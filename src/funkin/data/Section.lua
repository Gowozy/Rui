SwagSection = {
    sectionNotes = {};
	lengthInSteps = 16;
	typeOfSection = 0;
	mustHitSection = true;
	bpm = 100;
	changeBPM = false;
	altAnim = false;
}

Section = {
    sectionNotes = {};
    lengthInSteps = 16;
    typeOfSection = 0;
    mustHitSection = true;

    COPYCAT = 0;
    
    new = function(lengthInSteps)
        if lengthInSteps == nil or lengthInSteps == "" then
            lengthInSteps = 16
        end

        self.lengthInSteps = lengthInSteps
    end
}