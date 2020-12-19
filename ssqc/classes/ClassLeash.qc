$cd id1/models/soldier3
$origin 0 -6 24
$base base		
$skin skin

$frame stand1 stand2 stand3 stand4 stand5 stand6 stand7 stand8

$frame death1 death2 death3 death4 death5 death6 death7 death8
$frame death9 death10

$frame deathc1 deathc2 deathc3 deathc4 deathc5 deathc6 deathc7 deathc8
$frame deathc9 deathc10 deathc11

$frame load1 load2 load3 load4 load5 load6 load7 load8 load9 load10 load11

$frame pain1 pain2 pain3 pain4 pain5 pain6

$frame painb1 painb2 painb3 painb4 painb5 painb6 painb7 painb8 painb9 painb10
$frame painb11 painb12 painb13 painb14

$frame painc1 painc2 painc3 painc4 painc5 painc6 painc7 painc8 painc9 painc10
$frame painc11 painc12 painc13

$frame run1 run2 run3 run4 run5 run6 run7 run8

$frame shoot1 shoot2 shoot3 shoot4 shoot5 shoot6 shoot7 shoot8 shoot9

$frame prowl_1 prowl_2 prowl_3 prowl_4 prowl_5 prowl_6 prowl_7 prowl_8
$frame prowl_9 prowl_10 prowl_11 prowl_12 prowl_13 prowl_14 prowl_15 prowl_16
$frame prowl_17 prowl_18 prowl_19 prowl_20 prowl_21 prowl_22 prowl_23 prowl_24

void() classleash_run;
void() classleash_stand	=[	$stand1,	classleash_stand	] {
	if (!ClassStandFunc(classleash_run, 8))
	{
		return;
	}

	self.frame = self.frame + self.walkframe;
	self.walkframe = self.walkframe + 1;
};

void() classleash_run	=[	$run1,		classleash_run	] {
	if (!ClassRunFunc(classleash_stand, 8))
	{
		return;
	}

	self.frame = self.frame + self.walkframe;
	self.walkframe = self.walkframe + 1;
};

void classleash_shoot()
{
    // modified w_fireaxe
    GetClass(self.class);
    vector  source, org;

	makevectors (self.v_angle);
	source = self.origin + '0 0 16';
	traceline (source, source + v_forward*64, FALSE, self);
	if (trace_fraction == 1.0)
		return;
	
	org = trace_endpos - v_forward*4;

	if (trace_ent.takedamage)
	{
		trace_ent.axhitme = 1;
		SpawnBlood (org, 20);
        sound (self, CHAN_WEAPON, selfclass.sound_aahit, 1, ATTN_NORM);
        T_Damage (trace_ent, self, self, selfclass.basead);
	}
	else
	{       // hit wall
		sound (self, CHAN_WEAPON, selfclass.sound_aahitwall, 1, ATTN_NORM);

		WriteByte (MSG_MULTICAST, SVC_TEMPENTITY);
		WriteByte (MSG_MULTICAST, TE_GUNSHOT);
		WriteByte (MSG_MULTICAST, 3);
		WriteCoord (MSG_MULTICAST, org_x);
		WriteCoord (MSG_MULTICAST, org_y);
		WriteCoord (MSG_MULTICAST, org_z);
		multicast (org, MULTICAST_PVS);
	}
}

void()	classleash_attack	=[	$shoot1,	classleash_attack	] {
    if (self.walkframe >= 9)
    {
        self.walkframe = 0;
        classleash_run();
        return;
    }

    if (self.walkframe == 5)
    {
        classleash_shoot();
    }

    self.frame = self.frame + self.walkframe;
	self.walkframe = self.walkframe + 1;
};

void()	classleash_paina	=[	$pain1,		classleash_paina	] {
    if (self.walkframe >= 6)
    {
        self.walkframe = 0;
        classleash_run();
        return;
    }

    self.frame = self.frame + self.walkframe;
    self.walkframe = self.walkframe + 1;
};

void()	classleash_painb	=[	$painb1,		classleash_painb	] {
    if (self.walkframe >= 14)
    {
        self.walkframe = 0;
        classleash_run();
        return;
    }

    self.frame = self.frame + self.walkframe;
    self.walkframe = self.walkframe + 1;
};

void()	classleash_painc	=[	$painc1,		classleash_painc	] {
    if (self.walkframe >= 13)
    {
        self.walkframe = 0;
        classleash_run();
        return;
    }

    self.frame = self.frame + self.walkframe;
    self.walkframe = self.walkframe + 1;
};

void(entity attacker, float damage)	classleash_pain =
{
	if (self.pain_finished > time)
		return;

    float r;
	r = random();
    GetClass(self.class);
    sound (self, CHAN_VOICE, selfclass.sound_pain, 1, ATTN_NORM);

	if (r < 0.2)
	{
		self.pain_finished = time + 0.6;
		classleash_paina();
	}
	else if (r < 0.6)
	{
		self.pain_finished = time + 1.1;
		classleash_painb();
	}
	else
	{
		self.pain_finished = time + 1.1;
		classleash_painc();
	}
};

void()	classleash_diea	=[	$death1,	classleash_diea	] {
    if (self.walkframe == 3)
    {
        self.solid = SOLID_NOT;
    }
    
    if (self.walkframe == 10)
    {
        self.walkframe = 0;
        PlayerDie();
    }
    self.frame = self.frame + self.walkframe;
    self.walkframe = self.walkframe + 1;
};

void()	classleash_dieb	=[	$deathc1,	classleash_dieb	] {
    if (self.walkframe == 3)
    {
        self.solid = SOLID_NOT;
    }
    
    if (self.walkframe == 11)
    {
        self.walkframe = 0;
        PlayerDie();
    }
    self.frame = self.frame + self.walkframe;
    self.walkframe = self.walkframe + 1;
};

void() classleash_die =
{
    GetClass(self.class);
    self.state = self.state - (self.state & PSTATE_LEASHING);
    self.movetype = MOVETYPE_WALK;
    entity p = self.enemy;
    if (p)
    {
        p.state = p.state - (p.state & PSTATE_LEASHED);
        p.movetype = MOVETYPE_WALK;
    }

    // check for gib
	if (self.health < -35)
	{
		sound (self, CHAN_VOICE, "player/udeath.wav", 1, ATTN_NORM);
		ThrowHead (selfclass.model_head, self.health);
		ThrowGib ("progs/gib1.mdl", self.health);
		ThrowGib ("progs/gib2.mdl", self.health);
		ThrowGib ("progs/gib3.mdl", self.health);
		return;
	}

    // regular death
	sound (self, CHAN_VOICE, selfclass.sound_death, 1, ATTN_NORM);
    
	if (random() < 0.5)
		classleash_diea();
	else
		classleash_dieb();
};

vector TestMove(vector travel, float maxTravel)
{
    float dist = vlen(travel);
    if (dist > maxTravel)
        dist = maxTravel;
    
    vector dir = normalize(travel);
    travel = dir * dist;
    tracebox(self.enemy.origin, VEC_HULL_MIN, VEC_HULL_MAX, (self.enemy.origin + travel), MOVE_NORMAL, self.enemy);
    return travel * trace_fraction;
}

void () MaintainLinks =
{
    self.nextthink = time + 0.01;
	local vector chainvec;		// vector of the chain 
	local vector chainunit; 	// vector of chain with distance of 1
	local float chainlen;		// length of chain
	local entity newlink;		// pointer to chain link being added
	local entity currlink;		// pointer to current link being traversed
	local entity nextlink;		// pointer to next link after current link
	local float currpos;		// numeric position of currlink
	local float linknum;		// number of links that should exist
	local float linkstart;		// length from hook at which currlink starts
	local vector p_self_origin;	// predicted future hook origin

	// predicts hook's future position since chain links fall behind
	currpos = vlen(self.velocity) / 22;   // currpos used here just as an intermediate value
	p_self_origin = self.origin + normalize(self.velocity) * currpos;

      // get info about chain
	chainvec = ((self.owner.origin + '0 0 16') - p_self_origin);
	chainunit = normalize(chainvec);
	chainvec = chainvec - chainunit * 18;
	chainlen = vlen(chainvec);

	currlink = self;
	currpos = 0;

	// generate and refresh links
	linknum = ceil(chainlen / CHAIN_LINK_LEN);    
	while (currpos < linknum)
	{
		// add entities if chain's length grows
		if (currlink.goalentity == world)
		{
			newlink = spawn();
			newlink.movetype = MOVETYPE_NOCLIP;
			newlink.solid = SOLID_NOT;
			setmodel (newlink, "progs/chain.mdl");
			setsize (newlink, '0 0 0', '0 0 0');
			newlink.goalentity = world;
			currlink.goalentity = newlink;
		}
		currlink = currlink.goalentity;
		currpos = currpos + 1;
		
		// set angles 
		currlink.angles = vectoangles(chainvec);

		// fixes vectoangles round off error
		if ((currlink.angles_y > 0) && (currlink.angles_y < 180))
			currlink.angles = currlink.angles + '0 1 0';

		// vibrates chain links on the z axis
		currlink.angles_z = currlink.angles_z + crandom() * 30;

		// set position and frames 
		linkstart = (currpos - 1) * CHAIN_LINK_LEN;
		if (currpos < linknum)
		{
			setorigin (currlink, p_self_origin + chainunit * (linkstart + CHAIN_LINK_LEN / 2 ));
			currlink.frame = 9;
		}
		else
		{
			setorigin (currlink, p_self_origin + chainunit * (linkstart + (chainlen - linkstart) / 2 ));
			currlink.frame = floor((chainlen - linkstart) / CHAIN_LINK_LEN * 10);
		}
	}
	
	// remove remaining entities if chain's length shrinks
	nextlink = currlink.goalentity;
	currlink.goalentity = world;
	currlink = nextlink;
	while (currlink != world)
	{
		nextlink = currlink.goalentity;
		remove (currlink);
		currlink = nextlink;
	}
};

void () DropHook = {
    entity linkptr, nextptr;

	// removes hook and chain
	linkptr = self;
	while (linkptr != world)
	{
		nextptr = linkptr.goalentity;
		remove (linkptr);
		linkptr = nextptr;
	}
};

void LeashRemove()
{
    self.owner.state = self.owner.state - (self.owner.state & PSTATE_LEASHING);
    self.owner.movetype = MOVETYPE_WALK;

    DropHook();
}

void classleash_skillone_Think()
{
    MaintainLinks();
    self.nextthink = time + 0.01;
    if (self.enemy.deadflag == DEAD_DEAD)
    {
        LeashRemove();
        return;
    }

    setorigin(self, self.enemy.origin);
    if (self.cnt <= time)
    {
        self.cnt = time + SKILLONE_THINK_TICK_LEASH;
        self.health = self.health + SKILLONE_THINK_TICK_LEASH;
        // pull over 5 seconds, think tick is .1 seconds
        float maxTravel = (SKILLONE_RANGE_LEASH / 5) * (1 + self.health);// * SKILLONE_THINK_TICK_LEASH;
        // work out dist to go
        vector pos, dest, travelh, travelv, vel;

        dest = self.owner.origin;
        pos = self.enemy.origin;
        travelh = dest - pos;
        travelh = [travelh_x, travelh_y, 0];
        float dist_h = vlen(travelh);

        travelv = dest - pos;
        travelv = [0, 0, travelv_z];
        float dist_v = vlen(travelv);

        if (dist_h < 32 && dist_v < 32)
        {
            self.enemy.movetype = MOVETYPE_NONE;
            self.nextthink = -1;
            //remove(self); // TODO - don't remove once strangled etc stuff in? or put in post player think
            return;
        }

        if ((self.enemy.flags & FL_ONGROUND) && dist_h >= 32)
        {
            vel = TestMove(travelh, maxTravel);
            if (vlen(vel) == 0)
            {
                // can't go any further along horizontal plane, so try vertical if needed
                vel = TestMove(travelv, maxTravel);
            }
            self.enemy.velocity = vel;        
        }
        else if (dist_v >= 32)
        {
            // vertical test only
            vel = TestMove(travelv, maxTravel);
            self.enemy.velocity = vel;
        }
    }
}

void LeashTouch()
{
    if (other.team_no == TEAM_SURVIVOR)
    {
        sound (self, CHAN_AUTO, "shambler/smack.wav", 1, ATTN_NORM);
	    
        vector spray;
        // FIXME - change to diff mdl
		spray_x = 40 * crandom();
		spray_y = 40 * crandom();
		spray_z = 40 * crandom();
		SpawnMeatSpray (self.origin, spray);
		spray_x = 80 * crandom();
		spray_y = 80 * crandom();
		spray_z = 80 * crandom();
		SpawnMeatSpray (self.origin, spray);
		spray_x = 120 * crandom();
		spray_y = 120 * crandom();
		spray_z = 120 * crandom();
		SpawnMeatSpray (self.origin, spray);

        self.touch = SUB_Null;
        self.enemy = other;
        other.state = other.state | PSTATE_LEASHED;
        self.think = classleash_skillone_Think;
        self.nextthink = time + 0.01;
        return;
    }

    // otherwise, get rid of it
    // don't attach hook to sky
	if ((pointcontents(self.origin) == CONTENT_SKY) )
	{		
		LeashRemove();
		return;
	}
    sound (self, CHAN_AUTO, "player/axhit2.wav", 1, ATTN_NORM);
    LeashRemove();
}

void classleash_skillone()
{
    if (self.state & PSTATE_LEASHING)
        return;

    GetClass(self.class);
    // pull
    self.movetype = MOVETYPE_NONE;
    self.state = self.state | PSTATE_LEASHING;
    entity puller;
    puller = spawn();
    puller.owner = self;
    puller.movetype = MOVETYPE_FLY;
    puller.solid = SOLID_BBOX;
    setmodel(puller, "progs/hook.mdl");
    setsize(puller, '0 0 0', '0 0 0');
    makevectors(self.v_angle);
    puller.origin = self.origin;
    puller.velocity = v_forward * selfclass.skill_one_range;
    puller.angles = vectoangles(v_forward);
    puller.avelocity = '0 0 600';
    sound (self, CHAN_AUTO, "weapons/ax1.wav", 1, ATTN_NORM);
    // keeps track of how frequent chain noise should occur 
	puller.delay = time;   
    puller.classname = "classleash_skillone";

    puller.touch = LeashTouch;
	puller.nextthink = time + 0.01;     
	puller.think = MaintainLinks;
}

void () HookThink = {
    // shrink the length of the chain
 	if (self.armorvalue > LEASH_MIN_CHAIN_LEN)
	{
		if (time - self.ltime > 0.1) self.ltime = time - 0.1;
		float framestep = 10 * (time - self.ltime) * LEASH_CHAIN_SHRINK_RATE;
		self.armorvalue = self.armorvalue - framestep;
		if (self.armorvalue < LEASH_MIN_CHAIN_LEN) 
            self.armorvalue = LEASH_MIN_CHAIN_LEN;
		self.ltime = time;

		// trigger slide sound
		if (time - self.delay >= 0.1)		
		{
			sound (self.owner, CHAN_AUTO, "hook/chain2.wav", 0.8, ATTN_NORM);
			self.delay = time;
		}
	}
    else
    {
        DropHook();
        return;
    }

    // chain physics
    vector chainvec = self.origin - (self.owner.origin + '0 0 16');
	float chainlen = vlen (chainvec);
    float f1, f2;

	// if player's location is beyond the chain's reach
	if (chainlen > self.armorvalue)	
	{	 
		// determine player's velocity component of chain vector
		vector velpart = chainvec * ((self.owner.velocity * chainvec) / (chainvec * chainvec));
		
		// restrainment default force 
		f2 = (chainlen - self.armorvalue) * 5;

		// if player's velocity heading is away from the hook
		if ((self.owner.velocity * chainvec) < 0)
		{
			// if chain has streched for 25 units
			if (chainlen > self.armorvalue + 25)
				// remove player's velocity component moving away from hook
				self.owner.velocity = self.owner.velocity - velpart; 
			f1 = f2;
		}
		else  // if player's velocity heading is towards the hook
		{
			if (vlen(velpart) < f2)
				f1 = f2 - vlen(velpart);
			else		
				f1 = 0;
		}
	}
	else
		f1 = 0;
	
      // applys chain restrainment 
	self.owner.velocity = self.owner.velocity + normalize(chainvec) * f1;
	
	//prevents sticking on the ground caused by built in friction routines
	if (self.owner.velocity_z > (cvar("sv_gravity") / 20))
		self.owner.flags = self.owner.flags - (self.owner.flags & FL_ONGROUND);

	MaintainLinks ();

	self.nextthink = time + 0.01;
};

void() HookTouch = {
	// armorvalue is used to hold current length of chain
	self.armorvalue = vlen (self.origin - (self.owner.origin + '0 0 16'));	

	// don't attach hook to sky
	if ((pointcontents(self.origin) == CONTENT_SKY))
	{		
		DropHook();
		return;
	}

    sound (self, CHAN_AUTO, "player/axhit2.wav", 1, ATTN_NORM);
    self.avelocity = '0 0 0';

	self.velocity = other.velocity;
	self.enemy = other;
	self.think = HookThink;
	self.nextthink = time + 0.01;
	self.touch = SUB_Null;
};

void LaunchHook()
{
    entity hook = spawn();

    hook.owner = self;
    hook.movetype = MOVETYPE_FLY;
    hook.solid = SOLID_BBOX;
    setmodel(hook, "progs/hook.mdl");
    setsize(hook, '0 0 0', '0 0 0');
    makevectors(self.v_angle);
    hook.origin = self.origin;
    hook.velocity = v_forward * 1000;
    hook.angles = vectoangles(v_forward);
    hook.avelocity = '0 0 600';
    sound (self, CHAN_AUTO, "weapons/ax1.wav", 1, ATTN_NORM);
    // smooths climb and slide rates; tracks time between frames 
	hook.ltime = time;  

	// keeps track of how frequent chain noise should occur 
	hook.delay = time;   

    hook.touch = HookTouch;
	hook.nextthink = time + 0.01;     
	hook.think = MaintainLinks;
}

void classleash_skilltwo()
{
    // grapple
    LaunchHook();
}