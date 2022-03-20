// Giana Sisters 2D Retro autosplitter
// Made by apel

state("Giana") 
{
    int lives : "mono.dll", 0x1F30AC, 0xE8, 0x28, 0x8, 0x2C;
    string255 levelName : "mono.dll", 0x1F30AC, 0xE8, 0x28, 0x8, 0x14, 0xC;
    bool levelStarted : "mono.dll", 0x1F30AC, 0xE8, 0x14, 0x145;
    int timer : "mono.dll", 0x1F30AC, 0xE8, 0x14, 0x100;
}

start
{
    // this will start when Giana is able to move, the loading screen will still be up
    return current.lives == 5 && current.levelName == "classicmode01" && current.levelStarted && old.timer == 100 && current.timer == 99;
}

split
{
    int oldLevelId = 0;
    int newLevelId = 0;

    if (int.TryParse(old.levelName.Substring(11), out oldLevelId)) 
    {
        if (int.TryParse(current.levelName.Substring(11), out newLevelId))
        {
            return newLevelId > oldLevelId;
        }

        return old.levelName == "classicmode32" && current.levelName == "classicmode_boss";
    }

    // last split
    return (old.levelName == "classic_start" || old.levelName == "classicmode_boss") && string.IsNullOrWhiteSpace(current.levelName);
}