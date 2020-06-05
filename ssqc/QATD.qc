float GetPlayersInTeam(float team)
{
    float val = 0;
    string searchString = (team == 0) ? "observer" : "player";
    entity p = find(world, classname, searchString);
    while (p)
    {
        if (p.team_no == team)
        {
            val++;
        }
        p = find(p, classname, searchString);
    }

    return val;
}

string GetTeamName(float team)
{
    string teamName = "";
    switch (team)
    {
        case 1:
            teamName = "survivors";
            break;
        case 2:
            teamName = "monsters";
            break;
        default:
            teamName = "error";
            break;
    }
    return teamName;
}

void SetTeamName(entity player)
{
    string t = "";
    switch (player.team_no)
    {
        case 1:
            t = "surv";
            break;
        case 2:
            t = "mons";
            break;
    }
    //forceinfokey(player, "team", t);
    stuffcmd(player, strcat("team ", t, "\n"));
}

void SetTeam(entity player, float team)
{
    string teamName = GetTeamName(team);
    
    if (team == player.team_no)
    {
        sprint(player, PRINT_HIGH, "You are already on the ", teamName, "!\n");
        return;
    }

    player.team_no = team;
    ClientKill();

    bprint(PRINT_HIGH, player.netname, " has joined the ", teamName, "!\n");

    SetTeamName(player);
}