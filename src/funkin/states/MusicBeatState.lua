require "ClientPrefs"
require "Conductor"

local lastBeat = 0
local lastStep = 0
local curStep = 0
local curBeat = 0

local controls = {} -- // nothing yet

local beatHitEvents = {}
local stepHitEvents = {}
--local sectionHitEvents = {}

local function updateBeat()
    curBeat = math.floor(curStep / 4)
end
local function updateCurStep()
    local lastChange = {
        stepTime = 0;
		songTime = 0;
		bpm = 0;
    }
    for i=0,#Conductor.bpmChangeMap,1 do
        if Conductor.songPosition >= Conductor.bpmChangeMap[i].songTime then
            lastChange = Conductor.bpmChangeMap[i]
            break
        end
    end

    curStep = lastChange.stepTime + math.floor(((Conductor.songPosition - ClientPrefs.noteOffset) - lastChange.songTime) / Conductor.stepCrochet)
end

MusicBeatState = {
    lastBeat = 0;
    lastStep = 0;

    curStep = 0;
    curBeat = 0;

    initialize = function()
        MusicBeatState.lastBeat = 0;
        MusicBeatState.lastStep = 0;

        MusicBeatState.curStep = 0;
        MusicBeatState.curBeat = 0;
    end;

    update = function(elapsed)
        -- // every step
        local oldStep = curStep

        updateBeat()
        updateCurStep()

        if oldStep ~= curStep and curStep > 0 then
            MusicBeatState.stepHit()
        end
    end;

    onStepHit = function()
        local newConnection = {}
	    setmetatable(newConnection,MusicBeatState)

	    newConnection.func = func --\\ function
	    newConnection.t = "step" --\\ name
	    newConnection.i = (#stepHitEvents + 1) --\\ index

	    table.insert(stepHitEvents,newConnection)

	    return newConnection
    end;

    onBeatHit = function()
        local newConnection = {}
	    setmetatable(newConnection,MusicBeatState)

	    newConnection.func = func --\\ function
	    newConnection.t = "beat" --\\ name
	    newConnection.i = (#beatHitEvents + 1) --\\ index

	    table.insert(beatHitEvents,newConnection)

	    return newConnection
    end;

    beatHit = function()
        if #beatHitEvents > 0 then
            for i = 1,#beatHitEvents do
                if beatHitEvents[i] then
                    beatHitEvents[i].func()
                end
            end
        end
    end;
    
    stepHit = function()
        if #stepHitEvents > 0 then
            for i = 1,#stepHitEvents do
                if stepHitEvents[i] then
                    stepHitEvents[i].func()
                end
            end
        end

        if MusicBeatState.curStep % 4 == 0 then
            mustHitSection.beatHit()
        end
    end;

    disconnect = function()
        if self.func then
            self.func = nil
        end
        
        if self.t == "beat" then
            table.remove(beatHitEvents, self.i)
        end
        if self.t == "step" then
            table.remove(stepHitEvents, self.i)
        end
    end;

    reset = function()
        for i = 1,#beatHitEvents do
            local event = beatHitEvents[i]
            if event then
                event:Destroy()
            end
        end
        for i = 1,#stepHitEvents do
            local event = stepHitEvents[i]
            if event then
                event:Destroy()
            end
        end
        beatHitEvents = {}
        stepHitEvents = {}
    end
}