// Giana Sisters 2D Retro autosplitter
// Made by apel

state("Giana") 
{
    int lives : "mono.dll", 0x1F30AC, 0xE8, 0x28, 0x8, 0x2C;
    string255 levelName : "mono.dll", 0x1F30AC, 0xE8, 0x28, 0x8, 0x14, 0xC;
    bool levelStarted : "mono.dll", 0x1F30AC, 0xE8, 0x14, 0x145;
    int timer : "mono.dll", 0x1F30AC, 0xE8, 0x14, 0x100;
}

startup
{
    settings.Add("reset_lives_and_diamonds", true, "Reset lives and diamonds when the timer resets");

    vars.gameProgressPointer = new DeepPointer("mono.dll", 0x1F30AC, 0xE8, 0x28, 0x8);
}

init
{
    vars.OnReset = (LiveSplit.Model.Input.EventHandlerT<TimerPhase>)((sender, e) => 
    {
        if (vars.ShouldResetMemory)
        {
            var address = vars.gameProgressPointer.Deref<int>(game);
            if (address != 0x0)
            {
                game.WriteValue<int>(new IntPtr(address + 0x2C), 5); // lives set to 5
                game.WriteValue<int>(new IntPtr(address + 0x34), 0); // diamonds set to 0
            }
        }
    });
    timer.OnReset += vars.OnReset;
}

exit
{
    timer.OnReset -= vars.OnReset;
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

update
{
    vars.ShouldResetMemory = settings["reset_lives_and_diamonds"];
    return true;
}