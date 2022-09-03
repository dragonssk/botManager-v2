repeat task.wait(); until game:IsLoaded();

local userInputService  = game:GetService('UserInputService');
local runService        = game:GetService('RunService');
local replicatedStorage = game:GetService('ReplicatedStorage');
local coreGui           = game:GetService('CoreGui');
local httpService       = game:GetService('HttpService');
local lightingService   = game:GetService('Lighting');
local teamService       = game:GetService('Team');
local playerService     = game:GetService('Players');

local localPlayer       = playerService.LocalPlayer;
local currentCamera     = workspace.CurrentCamera;
local playerMouse       = localPlayer:GetMouse();
local random            = Random.new();

local config = {
    hostAccount = 'decom_piler';
    bots = {
        botPrefix = 'dragonssk_';
        botFpsCap = 15;
        botRendering = false;
    };
    commandPrefix = '>';
};

if (localPlayer.Name == config.hostAccount) then
    error('Host Account Detected, Script Disabled, Not A Bug');
end;

local hostPlayer = playerService:FindFirstChild(config.hostAccount);
if (not hostPlayer) then
    game:Shutdown();
end;

setfpscap(config.bots.botFpsCap);
runService:Set3dRenderingEnabled(config.bots.botRendering);

local function charFunction(player, callback)
    if (player.Character) then
        if (player.Character:FindFirstChild('HumanoidRootPart')) then
            callback(player.Character);
        end;
    end;
end;

local function newThread(func)
    task.spawn(func);
end;

local function hostCommand(cmds, callback)
    replicatedStorage.DefaultChatSystemChatEvents.OnMessageDoneFiltering.OnClientEvent:Connect(function(messageData)
        if (messageData.FromSpeaker == config.hostAccount) then
            for _, command in pairs(cmds) do
                if (messageData.Message:split(' ')[1] == config.commandPrefix..command) then
                    callback(messageData.Message, messageData.Message:split(' '));
                    break;
                end;
            end;
        end;
    end);
end;

local spamData = {
    spamMsg = '!';
    spamEnabled = false;
};

newThread(function()
    while true do task.wait(random:NextInteger(290, 320)/100);
        if (spamData.spamEnabled) then
            replicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(spamData.spamMsg, 'All');
        end;    
    end;
end);

hostCommand({'s', 'spam', 'm', 'msg'}, function(message, messageSplit)
    table.remove(messageSplit, 1);
    spamData.spamMsg = table.concat(messageSplit, ' ');
    spamData.spamEnabled = true;
end);

hostCommand({'us', 'unmsg', 'um', 'unmsg'}, function()
    spamData.spamEnabled = false;
end)

local orbitData = {
    orbitEnabled = false;
    orbitDistanceXZ = 5;
    orbitDistanceY = 1;
    orbitDelay = 0.5;
    orbitPlayer = hostPlayer;
    orbitOffset = Vector3.new(0, 0, 0);
}

newThread(function()
    while true do task.wait(orbitDelay)
        if (orbitData.orbitEnabled) then
            charFunction(localPlayer, function(localCharacter)
                charFunction(orbitData.orbitPlayer, function(hostCharacter)
                    local randomX = random:NextInteger(-orbitData.orbitDistanceXZ*100, orbitData.orbitDistanceXZ*100)/100;
                    local randomY = random:NextInteger(-orbitData.orbitDistanceY*100, orbitData.orbitDistanceY*100)/100;
                    local randomZ = random:NextInteger(-orbitData.orbitDistanceXZ*100, orbitData.orbitDistanceXZ*100)/100;
                    localCharacter.HumanoidRootPart.Position = hostCharacter.HumanoidRootPart.Position + Vector3.new(randomX, randomY, randomZ) + orbitData.orbitOffset;
                end);
            end);
        end;
    end;
end);

hostCommand({'o', 'orbit'}, function()
    orbitData.orbitEnabled = true;
end);
hostCommand({'uo', 'unorbit'}, function()
    orbitData.orbitEnabled = false;
end);
hostCommand({'ow', 'orbitwidth'}, function(_, messageSplit)
    orbitData.orbitDistanceXZ = tonumber(messageSplit[2]);
end);
hostCommand({'oh', 'orbitheight'}, function(_, messageSplit)
    orbitData.orbitDistanceY = tonumber(messageSplit[2]);
end);
hostCommand({'leave', 'l'}, function() game:Shutdown() end);
hostCommand({'ord', 'orbitdelay'}, function(_, messageSplit)
    orbitData.orbitDelay = tonumber(messageSplit[2]);
end);
hostCommand({'op', 'orbitplayer'}, function(_, messageSplit)
    local f;
    for _, player in pairs(playerService:GetPlayers()) do
        if (player.DisplayName:lower() == messageSplit[2]:lower()) then
            orbitData.orbitPlayer = player;
            f = true;
            break;
        end;
    end;
    if (not f) then
        for _, player in pairs(playerService:GetPlayers()) do
            if (player.DisplayName:lower():match(messageSplit[2]:lower())) then
                orbitData.orbitPlayer = player;
                break;
            end;
        end;
    end;
end);
hostCommand({'oo', 'orbitoffset'}, function(message, messageSplit)
    table.remove(messageSplit, 1);
    local newVector3 = Vector3.new(tonumber(messageSplit[1]), tonumber(messageSplit[2]), tonumber(messageSplit[3]));
    orbitData.orbitOffset = newVector3;
end);
local sitEnabled = false;
newThread(function()
    while true do task.wait();
        charFunction(localPlayer, function(localCharacter)
            localCharacter.Humanoid.Sit = sitEnabled;
        end);
    end;
end);
hostCommand({'sit'}, function()
    sitEnabled = true;
end);
hostCommand({'unsit'}, function()
    sitEnabled = false;
end);
hostCommand({'ng', 'nograv', 'nogravity'}, function()
    workspace.Gravity = 0;
end);
hostCommand({'g', 'grav', 'gravity'}, function()
    workspace.Gravity = 196.2;
end);
