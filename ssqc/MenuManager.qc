enum {
    MENU_NONE,
    MENU_TEAM,
};



void MM_Constructor()
{
    MenuManager.CheckMenu = MM_CheckMenu;
	MenuManager.SetMenu = MM_SetMenu;
	MenuManager.RefreshScreen = MM_RefreshScreen;
	MenuManager.MenuInput = MM_MenuInput;
	MenuManager.ClearScreen = MM_ClearScreen;
	MenuManager.FrameThink = MM_FrameThink;
    MenuManager.CenterPrint = MM_CenterPrint;

    MenuManager.TeamMenu = MM_TeamMenu;
    MenuManager.MenuTeamInput = MM_TeamMenu_Input;
}

void MM_CenterPrint(entity player, string... count)
{
    float i, len, lineCount = 0;
    string s;
    s = "";

    for (i = 0; i < count; i++)
    {
        s = strcat(s, ...(i, string));
    }
    len = strlen(s);

    for (i = 0; i < len; i++)
    {
        if (substring(s, i, 1) == "\n")
        {
            lineCount++;
        }
    }

    if (len > 0 && lineCount == 0)
        lineCount = 1;

    player.status_string = s;
    player.status_string_time = time + 1.5;
    player.status_string_refresh_time = time;
    player.status_string_lines = lineCount;
}

void MM_FrameThink(entity player)
{
    if (player.menu != MENU_NONE)
	{
		MenuManager.MenuInput(player);
	}

    // check menus
	MenuManager.CheckMenu(player);

	MenuManager.RefreshScreen(player);
}

void MM_ClearScreen(entity player)
{
    player.status_string = "";
    player.status_string_lines = 0;
}

void MM_RefreshScreen(entity player)
{
    if (player.status_string_refresh_time > time)
    {
        return;
    }

    if (player.status_string_lines > 0 && player.status_string_time <= time && player.menu == MENU_NONE)
    {
        MenuManager.ClearScreen(player);
        //return;
    }

    centerprint(player, player.status_string);
}

void MM_CheckMenu(entity player)
{
    if (player.classname == "observer")
    {
        return;
    }

    // if no team set
    if (player.team_no == 0)
    { 
        MenuManager.TeamMenu(player);
        return;
    }
}

void MM_SetMenu(entity player, float menuType, string... count)
{
    // no printing while menu open
    if (player.menu != MENU_NONE)
    {
        return;
    }
    float i, len, lineCount = 0;
    string s;
    s = "";

    for (i = 0; i < count; i++)
    {
        s = strcat(s, ...(i, string));
    }
    len = strlen(s);

    for (i = 0; i < len; i++)
    {
        if (substring(s, i, 1) == "\n")
        {
            lineCount++;
        }
    }
    if (len > 0 && lineCount == 0)
        lineCount = 1;

    player.status_string = s;
    player.status_string_lines = lineCount;
    player.status_string_time = time + 1.5;
    player.status_string_refresh_time = time;

    player.menu = menuType;
    player.impulse = 0;
}

void MM_MenuInput(entity player) 
{
    switch (player.menu)
    {
        case MENU_NONE:
            return;
        case MENU_TEAM:
            MenuManager.MenuTeamInput(player);
            break;
    }

    player.impulse = 0;

    //MenuManager.ClearScreen(player);
}

void MM_TeamMenu_Input(entity player)
{
    if (player.classname == "observer")
    {
        return;
    }

    switch (player.impulse)
    {
        case 0:
            return;
        case 1:
            SetTeam(player, player.impulse);
            player.menu = MENU_NONE;
            break;
        case 2:
            player.state = player.state | PSTATE_SPAWNALLOWED;
            SetTeam(player, player.impulse);
            player.menu = MENU_NONE;
            break;
        case 5:
            float one = GetPlayersInTeam(1);
            float two = GetPlayersInTeam(2);
            if (one <= two)
            {
                SetTeam(player, TEAM_SURVIVOR);
            }
            else
            {
                player.state = player.state | PSTATE_SPAWNALLOWED;
                SetTeam(player, TEAM_MONSTER);
            }
            player.menu = MENU_NONE;
            break;
    }
}

void MM_TeamMenu(entity player)
{
    string select = "Select team:\n\n";
    string one = Q"\s[1]\s Survivors\n";
    string two = Q"\s[2]\s Monsters\n";
    
    // don't show auto team if already assigned a team
    string autoteam = (player.team_no) ? "" : Q"\s[5]\s Auto-assign team";

    MenuManager.SetMenu(player, MENU_TEAM, select, one, two, autoteam);
}