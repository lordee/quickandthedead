$cd id1/models/demon3
$scale	0.8
$origin 0 0 24
$base base
$skin base

$frame stand1 stand2 stand3 stand4 stand5 stand6 stand7 stand8 stand9
$frame stand10 stand11 stand12 stand13

$frame walk1 walk2 walk3 walk4 walk5 walk6 walk7 walk8

$frame run1 run2 run3 run4 run5 run6

$frame leap1 leap2 leap3 leap4 leap5 leap6 leap7 leap8 leap9 leap10
$frame leap11 leap12

$frame pain1 pain2 pain3 pain4 pain5 pain6

$frame death1 death2 death3 death4 death5 death6 death7 death8 death9

$frame attacka1 attacka2 attacka3 attacka4 attacka5 attacka6 attacka7 attacka8
$frame attacka9 attacka10 attacka11 attacka12 attacka13 attacka14 attacka15

void() classfiend_run;
void()	classfiend_JumpTouch;
void()	classfiend_stand1	=[	$stand1,	classfiend_stand1	] {
	self.weaponframe=0;
	if (self.velocity_x || self.velocity_y)
	{
		self.walkframe=0;
		classfiend_run();
		return;
	}

	if (self.walkframe >= 5)
			self.walkframe = 0;
	self.frame = $stand1 + self.walkframe;
	self.walkframe = self.walkframe + 1;
};

void() classfiend_run=[   $run1,      classfiend_run      ]
{
	self.weaponframe=0;
	if (!self.velocity_x && !self.velocity_y)
	{
		self.walkframe=0;
		classfiend_stand1();
		return;
	}

	if (self.walkframe == 6)
		self.walkframe = 0;
	self.frame = self.frame + self.walkframe;
	self.walkframe = self.walkframe + 1;
};

void()	classfiend_jump1	=[	$leap1,		classfiend_jump2	] 
{
	self.touch = classfiend_JumpTouch;
	makevectors (self.angles);
	self.origin_z = self.origin_z + 1;
	self.velocity = v_forward * 600 + '0 0 250';
	if (self.flags & FL_ONGROUND)
		self.flags = self.flags - FL_ONGROUND;
};
void()	classfiend_jump2	=[	$leap2,		classfiend_jump3	] {};
void()	classfiend_jump3	=[	$leap3,		classfiend_jump4	] {};
void()	classfiend_jump4	=[	$leap4,		classfiend_jump5	] {};
void()	classfiend_jump5	=[	$leap5,		classfiend_jump6	] {};
void()	classfiend_jump6	=[	$leap6,		classfiend_jump7	] {};
void()	classfiend_jump7	=[	$leap7,		classfiend_jump8	] {};
void()	classfiend_jump8	=[ 	$leap8,		classfiend_jump9	] {};
void()	classfiend_jump9	=[ 	$leap9,		classfiend_jump10	] {};
void()	classfiend_jump10	=[ 	$leap10,	classfiend_jump11	] {};
void()	classfiend_jump11	=[ 	$leap11,	classfiend_jump12	] {};
void()	classfiend_jump12	=[ 	$leap12,	classfiend_run	] {};


void classfiend_Melee(float side)
{
	GetClass(self.class);
	vector  source;
	vector  org;

	makevectors (self.v_angle);
	source = self.origin + '0 0 16';
	traceline (source, source + v_forward*100, FALSE, self);
	if (trace_fraction == 1.0)
		return;
	
	org = trace_endpos - v_forward*4;

	if (trace_ent.takedamage)
	{
		trace_ent.axhitme = 1;
		SpawnBlood (org, 20);
		sound (self, CHAN_WEAPON, selfclass.sound_aahit, 1, ATTN_NORM);
		SpawnMeatSpray (self.origin + v_forward*16, side * v_right);
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

void()	classfiend_atta1	=[	$attacka1,		classfiend_atta2	] {};
void()	classfiend_atta2	=[	$attacka2,		classfiend_atta3	] {};
void()	classfiend_atta3	=[	$attacka3,		classfiend_atta4	] {};
void()	classfiend_atta4	=[	$attacka4,		classfiend_atta5	] {};
void()	classfiend_atta5	=[	$attacka5,		classfiend_atta6	] {classfiend_Melee(200);};
void()	classfiend_atta6	=[	$attacka6,		classfiend_atta7	] {};
void()	classfiend_atta7	=[	$attacka7,		classfiend_atta8	] {};
void()	classfiend_atta8	=[	$attacka8,		classfiend_atta9	] {};
void()	classfiend_atta9	=[	$attacka9,		classfiend_atta10] {};
void()	classfiend_atta10	=[	$attacka10,		classfiend_atta11] {};
void()	classfiend_atta11	=[	$attacka11,		classfiend_atta12] {classfiend_Melee(-200);};
void()	classfiend_atta12	=[	$attacka12,		classfiend_atta13] {};
void()	classfiend_atta13	=[	$attacka13,		classfiend_atta14] {};
void()	classfiend_atta14	=[	$attacka14,		classfiend_atta15] {};
void()	classfiend_atta15	=[	$attacka15,		classfiend_run] {};

void classfiend_attack()
{
	GetClass(self.class);

	self.attack_finished = time + selfclass.baseattackfinish;
	sound(self, CHAN_WEAPON, selfclass.sound_aashoot, 1, ATTN_NORM);
	classfiend_atta1();
}

void()	classfiend_pain1	=[	$pain1,		classfiend_pain2	] {};
void()	classfiend_pain2	=[	$pain2,		classfiend_pain3	] {};
void()	classfiend_pain3	=[	$pain3,		classfiend_pain4	] {};
void()	classfiend_pain4	=[	$pain4,		classfiend_pain5	] {};
void()	classfiend_pain5	=[	$pain5,		classfiend_pain6	] {};
void()	classfiend_pain6	=[	$pain6,		classfiend_run	] {};

void()	classfiend_die1		=[	$death1,		classfiend_die2	] {};
void()	classfiend_die2		=[	$death2,		classfiend_die3	] {};
void()	classfiend_die3		=[	$death3,		classfiend_die4	] {};
void()	classfiend_die4		=[	$death4,		classfiend_die5	] {};
void()	classfiend_die5		=[	$death5,		classfiend_die6	] {};
void()	classfiend_die6		=[	$death6,		classfiend_die7	]
{self.solid = SOLID_NOT;};
void()	classfiend_die7		=[	$death7,		classfiend_die8	] {};
void()	classfiend_die8		=[	$death8,		classfiend_die9	] {};
void()	classfiend_die9		=[	$death9,		classfiend_die9 ] {PlayerDead();};

void(entity attacker, float damage)	classfiend_pain =
{
	if (self.touch == classfiend_JumpTouch)
		return;

	if (self.pain_finished > time)
		return;
    GetClass(CLASS_FIEND);

	self.pain_finished = time + 1;
    sound (self, CHAN_VOICE, selfclass.sound_pain, 1, ATTN_NORM);

	if (random()*200 > damage)
		return;		// didn't flinch
		
	classfiend_pain1 ();
};

void classfiend_PinPlayer(entity pinner, entity pinned, float pin)
{
	entity oldself = self;
	if (pin)
	{
		// make them non solid, non move
		pinned.movetype = MOVETYPE_NONE;
		//pinnedPlayer.solid = SOLID_NOT;
		//pinnedPlayer.takedamage = DAMAGE_NO;
		pinned.weaponmodel = "";
		pinned.view_ofs = '0 0 -8';
		pinned.state = pinned.state | PSTATE_PINNED;
		player_setpinnedframe(pinned);

		pinner.state = pinner.state | PSTATE_PINNING;
		pinner.interactentity = pinned;
		droptofloor();
		pinner.movetype = MOVETYPE_NONE;
	}
	else
	{
		pinner.state = pinner.state - (pinner.state & PSTATE_PINNING);
		if (pinned)
		{
			pinned.state = pinned.state - (pinned.state & PSTATE_PINNED);
			pinned.movetype = MOVETYPE_SURVIVOR;
			self = pinned;
			W_SetCurrentAmmo();
			self = oldself;
			pinned.view_ofs = MODEL_VIEWOFFSET_SURVIVOR;
			pinner.interactentity = world;
		}
        
	}
}

void() classfiend_die =
{
	if (self.state & PSTATE_PINNING)
    {
        entity pinned = self.interactentity;
        classfiend_PinPlayer(self, pinned, FALSE);
    }

    GetClass(CLASS_FIEND);
    // check for gib
	if (self.health < -80)
	{
		sound (self, CHAN_VOICE, "player/udeath.wav", 1, ATTN_NORM);
		ThrowHead (selfclass.model_head, self.health);
		ThrowGib ("progs/gib1.mdl", self.health);
		ThrowGib ("progs/gib1.mdl", self.health);
		ThrowGib ("progs/gib1.mdl", self.health);
		return;
	}

    // regular death
    sound (self, CHAN_VOICE, selfclass.sound_death, 1, ATTN_NORM);
	classfiend_die1();
};

void()	classfiend_JumpTouch =
{
	if (self.health <= 0)
		return;
		
	if (other.team_no == TEAM_SURVIVOR)
	{
		classfiend_PinPlayer(self, other, TRUE);
	}

	self.touch = SUB_Null;
	self.think = classfiend_jump11;
	self.nextthink = time + 0.1;
};

void classfiend_skillone()
{
	classfiend_jump1();
}

void classfiend_skilltwo()
{
	switch (self.movetype)
	{
		case MOVETYPE_WALLWALK:
			self.movetype = MOVETYPE_FIEND;
			sprint(self, PRINT_HIGH, "Wall climbing off\n");
			break;
		case MOVETYPE_FIEND:
			self.movetype = MOVETYPE_WALLWALK;
			sprint(self, PRINT_HIGH, "Wall climbing on\n"); 
			break;
	}
}