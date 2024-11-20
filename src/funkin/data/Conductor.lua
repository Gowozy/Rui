require "Song"

BPMChangeEvent = {
    stepTime = 0;
    songTime = 0;
    bpm = 0;
}

Conductor = {
    bpm = 100;
    crochet = ((60 / Conductor.bpm) / 1000); -- // beats in milliseconds
    stepCrochet = Conductor.crochet / 4; -- // steps in milliseconds
    songPosition = 0;
    lastSongPos = 0;
    offset = 0;

    safeFrames = 12;
    safeZoneOffset = (Conductor.safeFrames / 60) * 1000;

    bpmChangeMap = {};

    initialize = function()
        Conductor.bpm = 100;
        Conductor.crochet = ((60 / Conductor.bpm) / 1000); -- // beats in milliseconds
        Conductor.stepCrochet = Conductor.crochet / 4; -- // steps in milliseconds
        Conductor.songPosition = 0;
        Conductor.lastSongPos = 0;
        Conductor.offset = 0;

        Conductor.safeFrames = 12;
        Conductor.safeZoneOffset = (Conductor.safeFrames / 60) * 1000;

        Conductor.bpmChangeMap = {};
    end;

    mapBPMChanges = function(song)
        Conductor.bpmChangeMap = {}

        local curBPM = song.bpm
        local totalSteps = 0
        local totalPos = 0
        for i=0,#song.notes,1 do
            local currentSection = song.notes[i]
            if currentSection.changeBPM and currentSection.bpm ~= curBPM then
                curBPM = currentSection.bpm

                local BPMChangeEvent = {
                    stepTime = totalSteps;
                    songTime = totalPos;
                    bpm = curBPM;
                    stepCrochet = Conductor.calculateCrochet(curBPM) / 4
                }

                table.insert(Conductor.BPMChangeMap, BPMChangeEvent)
                ConductorEvents[#ConductorEvents+1] = newevnt
            end
            local deltaSteps = currentSection.lengthInSteps
            totalSteps = totalSteps + deltaSteps
            totalPos = totalPos + ((60 / curBPM) * 1000 / 4) * deltaSteps
        end
        print("new BPM map BUDDY ".. bpmChangeMap)
    end;

    calculateCrochet = function(bpm)
        return (60 / bpm) * 1000
    end;

    changeBPM = function(newBpm)
        Conductor.bpm = newBpm

        Conductor.crochet = ((60 / Conductor.bpm) * 1000)
        Conductor.stepCrochet = Conductor.crochet / 4
    end
}