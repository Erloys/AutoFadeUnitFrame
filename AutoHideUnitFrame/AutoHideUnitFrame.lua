local function log(msg)
    -- DEFAULT_CHAT_FRAME:AddMessage("AUTOFADE_UNITFRAME: " .. msg, 1, 1, 0.5);
end

-- the fadeout opacity between 0 and 1.
local transparancy = 0;
-- the fadein opacity between 0 and 1.
local opacity = 1;
-- delay in seconds before fade in/out.
local delay = 4;

function FadeOutFrame(frame)
    log("fade out ");
    UIFrameFadeOut(frame, opacity, transparancy);
end

function FadeInFrame(frame)
    log("fade in ");
    UIFrameFadeIn(frame, transparancy, opacity);
end

local hidden = false;
local TimeSinceLastUpdate = GetTime();
local TimeAfterFadeIn = 0;
local UpdateInterval = 1.0;
local InCombat = false;

function FadeOutUnitsFrames()
    hidden = true;
    FadeOutFrame(PlayerFrame);
    if (UnitExists("target")) then FadeOutFrame(TargetFrame); end
end

function FadeInUnitsFrames()
    hidden = false;
    TimeAfterFadeIn = 0;
    FadeInFrame(PlayerFrame);
    if (UnitExists("target")) then FadeInFrame(TargetFrame); end
end

local AutoFade_frame = CreateFrame("Frame");

AutoFade_frame:RegisterEvent("PLAYER_LEAVE_COMBAT");
AutoFade_frame:RegisterEvent("PLAYER_ENTER_COMBAT");
AutoFade_frame:RegisterEvent("PLAYER_TARGET_CHANGED");

AutoFade_frame:SetScript("OnEvent", function()
    if (event == "PLAYER_TARGET_CHANGED") then
        FadeInUnitsFrames();
    elseif (event == "PLAYER_ENTER_COMBAT") then
        InCombat = true;
        FadeInUnitsFrames();
    elseif (event == "PLAYER_LEAVE_COMBAT") then
        InCombat = false;
    end
end)

AutoFade_frame:SetScript("OnUpdate", function()
    if (GetTime() - TimeSinceLastUpdate > UpdateInterval) then
        TimeSinceLastUpdate = GetTime();
        if (hidden) then
            TimeAfterFadeIn = 0;
        elseif (not InCombat) then
            TimeAfterFadeIn = TimeAfterFadeIn + 1;
        end

        if (TimeAfterFadeIn > delay) then
            log("delay trigger fadeout")
            FadeOutUnitsFrames();
            TimeAfterFadeIn = 0;
        end
    end
end)
