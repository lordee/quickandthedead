typedef struct {
    void () Constructor;
    entity Timer;
    float RoundNum;
    float RoundCountdown;
    float RoundInProgress;
    float RoundStartTime;
    float NextSpawnTime;
    
    // reset round data
    float MapEntsNum;
    string *MapEntStrings;
    entity *MapEnts;

    // scores
    float team_one_distance;
    float team_one_survivors_escape;
    float team_one_time_taken;
    float team_two_distance;
    float team_two_survivors_escape;
    float team_two_time_taken;
} RoundManager_t;
RoundManager_t RoundManager;

void () RoundManagerThink;

void () RM_Constructor = {
    RoundManager.Timer = spawn();
    RoundManager.Timer.think = RoundManagerThink;
    RoundManager.Timer.nextthink = time + 1;
};

// prematch
void () RoundEndCheck;
void () RoundPreMatch;
void () RoundManagerThink = {
    self.nextthink = time + 1;
    entity p;
    if (RoundManager.NextSpawnTime == 0)
    {
        RoundManager.NextSpawnTime = MONSTER_SPAWN_DELAY;
        p = find(world, classname, "player");

        while (p)
        {
            if (p.team_no == TEAM_MONSTER)
            {
                if (!p.spawned)
                {
                    p.state = p.state | PSTATE_SPAWNALLOWED;
                }
            }
            p = find(p, classname, "player");
        }
    }
    else
    {
        RoundManager.NextSpawnTime = MONSTER_SPAWN_DELAY - 1;
        string mymsg = "";
        switch (RoundManager.NextSpawnTime)
        {
            case 1:
            case 2:
            case 3:
            case 4:
                mymsg = strcat("\s[\s", ftos(rint(RoundManager.NextSpawnTime)), "\s]\s\n");
                break;
            case 5:
            case 10:
            case 20:
                mymsg = strcat("Spawning in \s[\s", ftos(rint(RoundManager.NextSpawnTime)), "\s]\s seconds\n");
                break;
        }

        if (mymsg != "")
        {
            p = find(world, classname, "player");
            while (p)
            {
                if (p.team_no == TEAM_MONSTER)
                {
                    if (!p.spawned)
                    {
                        sprint(p, PRINT_HIGH, mymsg);
                    }
                }
                p = find(p, classname, "player");
            }
        }
    }

    if (RoundManager.RoundInProgress)
    {
        RoundEndCheck();
    }
    else
    {
        RoundPreMatch();
    }
}

void () RoundStart;

void () RoundPreMatch = {
    // if players aren't ready, centerprint list and prompt for ready
    lightstyle (0, "e");
    string readyMsg = "Not ready: ";
    float playersReady = TRUE, count = 0, totCount = 0;
    entity p = find(world, classname, "player");
    while (p)
    {
        if (p.team_no == TEAM_SURVIVOR || p.team_no == TEAM_MONSTER)
            totCount++;
        if (p.ready == FALSE)
        {
            count++;
            playersReady = FALSE;
            if (count == 1)
            {
                readyMsg = strcat(readyMsg, p.netname);
            }
            else if (count <= 5)
            {
                readyMsg = strcat(readyMsg, ", ", p.netname);
            }
            else
            {
                readyMsg = strcat(readyMsg, " and others...");
                break;
            }
        }
        p = find(p, classname, "player");
    }
    readyMsg = strcat(readyMsg, "\n", "Type \s/ready\s in the console to toggle your ready status\n");

    if (playersReady && totCount > 0)
    {
        // countdown
        // reset countdown if countdown prev never set or has finished (round 1 -> round 2)
        if (RoundManager.RoundCountdown == 0)
        {
            RoundManager.RoundCountdown = 10;
        }
        if (RoundManager.RoundCountdown == 10)
        {
            if (RoundManager.RoundNum == 2) // not incremented yet, so this is "start" of round 3
            {
                return;
            }
            p = find(world, classname, "player");
            while (p)
            {
                p.movetype = MOVETYPE_NONE;
                p = find(p, classname, "player");
            }
            readyMsg = strcat("Round ", ftos(RoundManager.RoundNum + 1), " begins in \s[\s10\s]\s seconds\n");
        }
        else
        {
            readyMsg = strcat("\s[\s", ftos(RoundManager.RoundCountdown), "\s]\s\n");
        }
        RoundManager.RoundCountdown = RoundManager.RoundCountdown - 1;

        bprint(PRINT_HIGH, readyMsg);
        // once countdown finished, start
        if (RoundManager.RoundCountdown == 0)
        {
            RoundStart();
        }
    }
    else
    {
        p = find(world, classname, "player");
        while (p)
        {
            if (p.team_no)
                MenuManager.CenterPrint(p, readyMsg);
            p = find(p, classname, "player");
        }
    }
};

// start round
void () RoundStart = {
    lightstyle (0, "m");
    RoundManager.RoundNum = RoundManager.RoundNum + 1;
    RoundManager.RoundInProgress = TRUE;
    RoundManager.RoundStartTime = time;
    bprint(PRINT_HIGH, strcat("Starting round ", ftos(RoundManager.RoundNum), "\n"));

    // reset entities
    for (float i = 0; i < RoundManager.MapEntsNum; i++)
    {
        entity e = spawn();
        float suc = parseentitydata(e, RoundManager.MapEntStrings[i]);
        //eprint(e);
        entity old = RoundManager.MapEnts[i];
        //eprint(old);
        switch(old.classname)
        {
            case "":
            case "player":
                break;
            default:
                remove(old);
                RoundManager.MapEnts[i] = e;
                break;
        }   
    }

    entity mon = find(world, classname, "monster_knight");

    while (mon)
    {
        if (mon.owner)
        {
            if (mon.owner.classname == "player")
            {
                entity temp = find(mon, classname, "monster_knight");
                remove(mon);
                mon = temp;
                continue;
            }
        }
        mon = find(mon, classname, "monster_knight");
    }

    // spawn players, survivors first so monsters can spawn on someone
    entity p = find(world, classname, "player");
    while (p)
    {
        if (p.team_no == TEAM_SURVIVOR)
        {
            self = p;
            PutClientInServer();
        }
        
        p = find(p, classname, "player");
    }

    entity p = find(world, classname, "player");
    while (p)
    {
        if (p.team_no == TEAM_MONSTER)
        {
            self = p;
            PutClientInServer();
        }
        
        p = find(p, classname, "player");
    }
};

// end Rounds
void (entity exit) NextMap;
void (float downedCount, float exitCount, float totCount) RoundEnd = {
    RoundManager.RoundInProgress = FALSE;
    string msg = "";
    if (downedCount >= totCount)
    {
        // monsters win
        msg = "No survivors escaped!\n";
    }
    else if (downedCount + exitCount >= totCount)
    {
        // survivors win
        msg = strcat(ftos(exitCount), "/", ftos(totCount), " survivors escaped!\n");
    }

    bprint(PRINT_HIGH, msg);

    float t = time - RoundManager.RoundStartTime;
    if (RoundManager.RoundNum == 1)
    {
        RoundManager.team_one_time_taken = t;
        RoundManager.team_one_survivors_escape = exitCount;
        // Swap teams, start again
        entity p = find(world, classname, "player");
        while (p)
        {
            if (p.team_no == TEAM_SURVIVOR)
            {
                p.team_no = TEAM_MONSTER;
                p.state = p.state | PSTATE_SPAWNALLOWED;

            }
            else if (p.team_no == TEAM_MONSTER)
            {
                p.team_no = TEAM_SURVIVOR;
            }
            p = find(p, classname, "player");
        }

        RoundPreMatch();
    }
    else
    {
        RoundManager.team_two_time_taken = t;
        RoundManager.team_two_survivors_escape = exitCount;
        // end map, calc scores
        float t1DistScore = RoundManager.team_one_distance * 1000;
        float t2DistScore = RoundManager.team_two_distance * 1000;
        float t1SurvScore = RoundManager.team_one_survivors_escape * 250;
        float t2SurvScore = RoundManager.team_two_survivors_escape * 250;
        float t1TimeScore = 0, t2TimeScore = 0;
        if (RoundManager.team_one_time_taken > RoundManager.team_two_time_taken)
        {
            t1TimeScore = 1000;
            t2TimeScore = 1000 * (RoundManager.team_one_time_taken / RoundManager.team_two_time_taken);
        }
        else
        {
            t2TimeScore = 1000;
            t1TimeScore = 1000 * (RoundManager.team_two_time_taken / RoundManager.team_one_time_taken);
        }

        bprint(PRINT_HIGH, strcat("Team 1 Distance: ", ftos(t1DistScore), "\n"));
        bprint(PRINT_HIGH, strcat("Team 1 Survivors: ", ftos(t1SurvScore), "\n"));
        bprint(PRINT_HIGH, strcat("Team 1 Time: ", ftos(t1TimeScore), "\n"));
        bprint(PRINT_HIGH, "\n");
        bprint(PRINT_HIGH, strcat("Team 2 Distance: ", ftos(t2DistScore), "\n"));
        bprint(PRINT_HIGH, strcat("Team 2 Survivors: ", ftos(t2SurvScore), "\n"));
        bprint(PRINT_HIGH, strcat("Team 2 Time: ", ftos(t2TimeScore), "\n"));

        string winner = ((t1DistScore + t1SurvScore + t1TimeScore) - (t2DistScore + t2SurvScore + t2TimeScore)) > 0 ? "Team 1" : "Team 2";
        bprint(PRINT_HIGH, strcat("\nWinners:", winner, "\n"));

        // change map code
        //entity exit = find(world, classname, "trigger_changelevel");
        //NextMap(exit);
    }
};

void () RoundEndCheck = {
    entity exit = find(world, classname, "trigger_changelevel");
    if (!exit)
    {
        // spam em
        bprint(PRINT_HIGH, "No changelevel found, level cannot be finished!\n");
        return;
    }

    entity p = find(world, classname, "player");
	float survCount = 0, survDownedCount = 0, survExitCount = 0;
	while (p)
	{
		if (p.team_no == TEAM_SURVIVOR)
		{
			survCount++;
			if (p.downedflag == TRUE)
				survDownedCount++;

            if (vlen(p.origin - exit.origin) <= 300)
                survExitCount++;
		}
		p = find(p, classname, "player");
	}

	if (survDownedCount + survExitCount >= survCount)
	{
		RoundEnd(survDownedCount, survExitCount, survCount);
	}
};