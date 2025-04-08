-----------------------------------------------------------------------
-- Script: OniX TLC Tokens Farm (Con Sistema de Key Integrado)
-- Autor: [Tu Nombre]
-- Descripción: Script para teletransportar al jugador al balón y luego
--              a la portería (Home) bloqueando su posición durante 10 seg.
--              Solo se habilita si se ingresa la Key correcta.
-----------------------------------------------------------------------

-- Servicios principales
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

-----------------------------------------------------------------------
-- SISTEMA DE KEY - Verificación de acceso
-----------------------------------------------------------------------

local keyCorrecta = "OniX-KeyBaldwinGoat1928" -- Cambia este valor por la clave deseada
local accesoConcedido = false

-- Creamos la interfaz para la verificación de la Key
local KeyGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
KeyGui.Name = "KeySystem"

local KeyFrame = Instance.new("Frame", KeyGui)
KeyFrame.Name = "KeyFrame"
KeyFrame.Size = UDim2.new(0, 300, 0, 200)
KeyFrame.Position = UDim2.new(0.35, 0, 0.35, 0)
KeyFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
KeyFrame.BackgroundTransparency = 0.2

local KeyBox = Instance.new("TextBox", KeyFrame)
KeyBox.Name = "KeyBox"
KeyBox.Size = UDim2.new(0.8, 0, 0.3, 0)
KeyBox.Position = UDim2.new(0.1, 0, 0.2, 0)
KeyBox.PlaceholderText = "Introduce la Key..."
KeyBox.Font = Enum.Font.Gotham
KeyBox.TextSize = 20
KeyBox.Text = ""
KeyBox.TextColor3 = Color3.new(1, 1, 1)
KeyBox.BackgroundColor3 = Color3.fromRGB(40, 40, 50)

local SubmitBtn = Instance.new("TextButton", KeyFrame)
SubmitBtn.Name = "SubmitBtn"
SubmitBtn.Size = UDim2.new(0.5, 0, 0.25, 0)
SubmitBtn.Position = UDim2.new(0.25, 0, 0.6, 0)
SubmitBtn.Text = "Verificar Key"
SubmitBtn.Font = Enum.Font.GothamBold
SubmitBtn.TextSize = 22
SubmitBtn.TextColor3 = Color3.new(1, 1, 1)
SubmitBtn.BackgroundColor3 = Color3.fromRGB(100, 150, 255)

local ErrorLabel = Instance.new("TextLabel", KeyFrame)
ErrorLabel.Name = "ErrorLabel"
ErrorLabel.Size = UDim2.new(1, 0, 0.2, 0)
ErrorLabel.Position = UDim2.new(0, 0, 0.85, 0)
ErrorLabel.Text = ""
ErrorLabel.Font = Enum.Font.Gotham
ErrorLabel.TextSize = 16
ErrorLabel.TextColor3 = Color3.new(1, 0, 0)
ErrorLabel.BackgroundTransparency = 1

-- Función de verificación de la Key
SubmitBtn.MouseButton1Click:Connect(function()
    if KeyBox.Text == keyCorrecta then
        accesoConcedido = true
        KeyGui:Destroy() -- Se elimina la interfaz de verificación
        MainGUI.Enabled = true  -- Se activa la GUI principal
    else
        ErrorLabel.Text = "Key incorrecta. Inténtalo de nuevo."
    end
end)

-----------------------------------------------------------------------
-- CREACIÓN DE LA INTERFAZ PRINCIPAL (Main GUI)
-----------------------------------------------------------------------

-- Creamos la GUI principal pero la mantenemos desactivada hasta verificar la Key
local MainGUI = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
MainGUI.Name = "GoalUI"
MainGUI.ResetOnSpawn = false
MainGUI.Enabled = false  -- Se activa luego de la verificación de la Key

local Colors = {
    Primary = Color3.fromRGB(35, 35, 50),
    Accent = Color3.fromRGB(100, 150, 255),
    Text = Color3.fromRGB(230, 230, 250),
    Background = Color3.fromRGB(25, 25, 35)
}

-- Panel principal
local MainFrame = Instance.new("Frame", MainGUI)
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 300, 0, 400)
MainFrame.Position = UDim2.new(0.05, 0, 0.3, 0)
MainFrame.BackgroundColor3 = Colors.Primary
MainFrame.BackgroundTransparency = 0.2

local TitleLabel = Instance.new("TextLabel", MainFrame)
TitleLabel.Name = "TitleLabel"
TitleLabel.Size = UDim2.new(1, 0, 0, 50)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "OniX TLC Tokens Farm"
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextSize = 28
TitleLabel.TextColor3 = Colors.Text
TitleLabel.TextYAlignment = Enum.TextYAlignment.Center

local TokensLabel = Instance.new("TextLabel", MainFrame)
TokensLabel.Name = "TokensLabel"
TokensLabel.Size = UDim2.new(1, 0, 0, 50)
TokensLabel.Position = UDim2.new(0, 0, 0.14, 0)
TokensLabel.BackgroundTransparency = 1
TokensLabel.Text = "Star Tokens: 0"
TokensLabel.Font = Enum.Font.GothamBold
TokensLabel.TextSize = 24
TokensLabel.TextColor3 = Colors.Text
TokensLabel.TextYAlignment = Enum.TextYAlignment.Center

local ClickGoalButton = Instance.new("TextButton", MainFrame)
ClickGoalButton.Name = "ClickGoalButton"
ClickGoalButton.Size = UDim2.new(0.8, 0, 0.2, 0)
ClickGoalButton.Position = UDim2.new(0.1, 0, 0.5, 0)
ClickGoalButton.BackgroundColor3 = Colors.Accent
ClickGoalButton.Text = "Click Goal"
ClickGoalButton.Font = Enum.Font.GothamBold
ClickGoalButton.TextSize = 24
ClickGoalButton.TextColor3 = Colors.Text

-----------------------------------------------------------------------
-- FUNCIONES PRINCIPALES DEL SCRIPT
-----------------------------------------------------------------------

-- Función para obtener la cantidad de StarTokens desde Players
local function getStarTokens()
    -- Se asume que en Players, bajo el nombre del jugador, está ProfileStats
    local profile = player:FindFirstChild(player.Name)
    if profile then
        local stats = profile:FindFirstChild("ProfileStats")
        if stats then
            local tokens = stats:FindFirstChild("StarTokens")
            if tokens then
                return tokens.Value
            end
        end
    end
    return 0
end

-- Función para obtener el objeto Football en Workspace
local function getFootball()
    return Workspace:FindFirstChild("Football")
end

-- Función para obtener el objeto Home (la portería) desde Workspace.Goals
local function getHome()
    local goalsFolder = Workspace:FindFirstChild("Goals")
    if goalsFolder then
        return goalsFolder:FindFirstChild("Home")
    end
    return nil
end

-- Función principal del ciclo "Click Goal"
local function goalCycle()
    -- Asegurarse que el personaje está cargado
    local character = player.Character or player.CharacterAdded:Wait()
    local hrp = character:WaitForChild("HumanoidRootPart")
    
    -- 1. Teletransportarse al balón (si existe)
    local football = getFootball()
    if football then
        hrp.CFrame = football.CFrame + Vector3.new(0, 3, 0)
        task.wait(1)  -- Espera 1 segundo para simular que recoge el balón
    else
        warn("Football no encontrado en Workspace.")
    end
    
    -- 2. Teletransportarse EXACTAMENTE al centro de Home
    local home = getHome()
    if not home then
        warn("Home no encontrado en Workspace.Goals.")
        return
    end
    hrp.CFrame = home.CFrame  -- Coloca al jugador en el centro exacto
    
    -- 3. Bloquear la posición: anclar el HumanoidRootPart
    hrp.Anchored = true
    print("Teletransportado a Home. Quedando bloqueado durante 10 segundos. Star Tokens: " .. tostring(getStarTokens()))
    
    -- 4. Esperar 10 segundos manteniendo la posición bloqueada
    task.wait(10)
    
    -- 5. Desbloquear la posición para que el jugador pueda moverse o disparar
    hrp.Anchored = false
    print("Posición desbloqueada; jugador puede disparar.")
end

-----------------------------------------------------------------------
-- ACTUALIZACIÓN CONTINUA DEL LABEL DE STAR TOKENS
-----------------------------------------------------------------------
spawn(function()
    while true do
        TokensLabel.Text = "Star Tokens: " .. tostring(getStarTokens())
        task.wait(0.5)
    end
end)

-----------------------------------------------------------------------
-- CONEXIÓN DEL BOTÓN "CLICK GOAL" AL CICLO PRINCIPAL
-----------------------------------------------------------------------
ClickGoalButton.MouseButton1Click:Connect(function()
    ClickGoalButton.Active = false
    goalCycle()
    ClickGoalButton.Active = true
end)
