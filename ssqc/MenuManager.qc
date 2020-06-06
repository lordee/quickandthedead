enum {
    MENU_NONE,
    MENU_TEAM,
    MENU_CLASS,
};

void MM_CheckMenu(entity player);
void MM_TeamMenu(entity player);
void MM_SetMenu(entity player, float menuType, string... count);
void MM_RefreshScreen(entity player);
void MM_MenuInput(entity player);
void MM_ClearScreen(entity player);
void MM_FrameThink(entity player);
void MM_TeamMenu_Input(entity player);

typedef struct {
    void (entity player) CheckMenu;
    void (entity player) TeamMenu;
    void (entity player, float menuType, string... count) SetMenu;
    void (entity player) RefreshScreen;
    void (entity player) ClearScreen;
    void (entity player) MenuInput;
    void (entity player) FrameThink;
    void (entity player) MenuTeamInput;
    void () Constructor;
} QATD_MenuManager;

QATD_MenuManager MenuManager;

void MM_Constructor()
{
    MenuManager.CheckMenu = MM_CheckMenu;
	MenuManager.TeamMenu = MM_TeamMenu;
	MenuManager.SetMenu = MM_SetMenu;
	MenuManager.RefreshScreen = MM_RefreshScreen;
	MenuManager.MenuInput = MM_MenuInput;
	MenuManager.ClearScreen = MM_ClearScreen;
	MenuManager.FrameThink = MM_FrameThink;
    MenuManager.MenuTeamInput = MM_TeamMenu_Input;
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
        case MENU_CLASS:

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
        case 2:
            SetTeam(player, player.impulse);
            player.menu = MENU_NONE;
            break;
        case 5:
            float one = GetPlayersInTeam(1);
            float two = GetPlayersInTeam(2);
            if (one <= two)
            {
                SetTeam(player, 1);
            }
            else
            {
                SetTeam(player, 2);
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