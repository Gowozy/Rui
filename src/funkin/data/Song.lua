require "json"

SwagSong = {
    song = "";
    notes = {};
    bpm = 0;
    needsVoices = true;
    speed = 1;
    
    player1 = "";
    player2 = "";
    gfVersion = "";
    stage = "";

    composer = "";

    arrowSkin = "";
    splashSkin = "";
    validScore = true;
}

Song = {
    song = "";
    notes = {};
    bpm = 100;
    needsVoices = true;
    arrowSkin = "";
    splashSkin = "";
    speed = 1;
    stage = "";
    
    composer = "";

    player1 = "bf";
    player2 = "dad";
    gfVersion = "gf";


    -- // i know there is another way to write functions
    -- // but i perfer this way
    new = function(song, notes, bpm)
        self.song = Song.song
        self.notes = Song.notes
        self.bpm = Song.bpm
    end;

    onLoadJson = function(songJson)
        if songJson.gfVersion == nil or songJson.gfVersion == "" then
            songJson.gfVersion = songJson.player3
            songJson.player3 = nil
        end

    end;

    loadFromJson = function(jsonInput, folder)
        local jsonfile = io.open(string.lower(folder)..string.lower(jsonInput),"r")
        local rawJson = tostring(jsonfile:read("a"))

        jsonfile:close() -- \\ closes an open file to save memory

        while string.sub(rawJson,#rawJson) == "}" do
        rawJson = string.sub(rawJson,0,string.len(rawJson) - 1)

        end

        return song:parseJSONshit(rawJson)
    end;

    parseJSONshit = function(rawJson)
        local swagShit = json:decode(rawJson).song
        swagShit.validScore = true
        return swagShit
    end
}