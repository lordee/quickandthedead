/*
==============================================================================

SHAMBLER

==============================================================================
*/

$cd id1/models/shams
$origin 0 0 24
$base base		
$skin base

$frame stand1 stand2 stand3 stand4 stand5 stand6 stand7 stand8 stand9
$frame stand10 stand11 stand12 stand13 stand14 stand15 stand16 stand17

$frame walk1 walk2 walk3 walk4 walk5 walk6 walk7 
$frame walk8 walk9 walk10 walk11 walk12

$frame	run1 run2 run3 run4 run5 run6

$frame smash1 smash2 smash3 smash4 smash5 smash6 smash7 
$frame smash8 smash9 smash10 smash11 smash12

$frame swingr1 swingr2 swingr3 swingr4 swingr5 
$frame swingr6 swingr7 swingr8 swingr9

$frame swingl1 swingl2 swingl3 swingl4 swingl5 
$frame swingl6 swingl7 swingl8 swingl9

$frame magic1 magic2 magic3 magic4 magic5 
$frame magic6 magic7 magic8 magic9 magic10 magic11 magic12

$frame pain1 pain2 pain3 pain4 pain5 pain6

$frame death1 death2 death3 death4 death5 death6 
$frame death7 death8 death9 death10 death11

void() classsham_run;
void() classsham_stand	=[	$stand1,		classsham_stand	] {
	if (!ClassStandFunc(classsham_run, 17))
	{
		return;
	}

	self.frame = $stand1 + self.walkframe;
	self.walkframe = self.walkframe + 1;
};

void() classsham_run	=[	$run1,		classsham_run	] {
	if (!ClassRunFunc(classsham_stand, 6))
	{
		return;
	}

	self.frame = self.frame + self.walkframe;
	self.walkframe = self.walkframe + 1;
};

void classsham_CastSkillOne();
void() classsham_smash     =[      $smash1,       classsham_smash    ] {
	if (self.walkframe >= 12)
	{
		self.walkframe = 0;
		classsham_run();
		return;
	}

	self.frame = $smash1 + self.walkframe;
	if (self.walkframe == 10)
	{
		classsham_CastSkillOne();
	}
	self.walkframe = self.walkframe + 1;
};

void classsham_Melee(float side)
{
	GetClass(self.class);
	vector  source, org;

	makevectors (self.v_angle);
	source = self.origin + selfclass.model_viewoffset;
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
void() classsham_swingl	=[      $swingl1,      classsham_swingl   ] {
	
	if (self.walkframe == 7)
	{
		classsham_Melee(250);
	}
	else if (self.walkframe == 9)
	{
		self.walkframe = 0;
		classsham_run();
		return;
	}

	self.frame = self.frame + self.walkframe;
	self.walkframe = self.walkframe + 1;
};

void() classsham_swingr	=[      $swingr1,      classsham_swingr   ] {
	
	if (self.walkframe == 7)
	{
		classsham_Melee(250);
	}
	else if (self.walkframe == 9)
	{
		self.walkframe = 0;
		classsham_run();
		return;
	}

	self.frame = self.frame + self.walkframe;
	self.walkframe = self.walkframe + 1;
};

void() classsham_magic1     =[      $magic1,       classsham_magic2    ] {};
void() classsham_magic2     =[      $magic2,       classsham_magic3    ] {};
void() classsham_magic3     =[      $magic3,       classsham_magic4    ] {};
void() classsham_magic4     =[      $magic4,       classsham_magic5    ] {};
void() classsham_magic5     =[      $magic5,       classsham_magic6    ] {};
void() classsham_magic6     =[      $magic6,       classsham_magic9    ] {};
void() classsham_magic9     =[      $magic9,       classsham_magic10   ] {};
void() classsham_magic10    =[      $magic10,      classsham_magic11   ] {};
void() classsham_magic11    =[      $magic11,      classsham_magic12   ] {};
void() classsham_magic12    =[      $magic12,      classsham_run	   ] {};

void() classsham_pain1       =[      $pain1, classsham_pain2      ] {};
void() classsham_pain2       =[      $pain2, classsham_pain3      ] {};
void() classsham_pain3       =[      $pain3, classsham_pain4      ] {};
void() classsham_pain4       =[      $pain4, classsham_pain5      ] {};
void() classsham_pain5       =[      $pain5, classsham_pain6      ] {};
void() classsham_pain6       =[      $pain6, classsham_run      ] {};

void(entity attacker, float damage)	classsham_pain =
{
	if (self.health <= 0)
		return;		// already dying, don't go into pain frame

	GetClass(self.class);
	sound (self, CHAN_VOICE, selfclass.sound_pain, 1, ATTN_NORM);

	if (random()*400 > damage)
		return;		// didn't flinch

	if (self.pain_finished > time)
		return;
	self.pain_finished = time + 2;
		
	classsham_pain1 ();
};


//============================================================================

void() classsham_death1      =[      $death1,       classsham_death2     ] {};
void() classsham_death2      =[      $death2,       classsham_death3     ] {};
void() classsham_death3      =[      $death3,       classsham_death4     ] {self.solid = SOLID_NOT;};
void() classsham_death4      =[      $death4,       classsham_death5     ] {};
void() classsham_death5      =[      $death5,       classsham_death6     ] {};
void() classsham_death6      =[      $death6,       classsham_death7     ] {};
void() classsham_death7      =[      $death7,       classsham_death8     ] {};
void() classsham_death8      =[      $death8,       classsham_death9     ] {};
void() classsham_death9      =[      $death9,       classsham_death10    ] {};
void() classsham_death10     =[      $death10,      classsham_death11    ] {};
void() classsham_death11     =[      $death11,      classsham_death11    ] {PlayerDead();};

void() classsham_die =
{
	// check for gib
	GetClass(self.class);
	if (self.health < -60)
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
	classsham_death1 ();
};

void classsham_attack()
{
    GetClass(self.class);
	sound(self, CHAN_WEAPON, selfclass.sound_aashoot, 1, ATTN_NORM);

    if (random() <= 0.5)
        classsham_swingr();
    else 
        classsham_swingl();
}

void classsham_CastSkillOne()
{
	GetClass(self.class);

	// pop up all units in radius around champ
	entity affected = findradius(self.origin, selfclass.skill_one_range);

	while (affected)
	{
		if (affected.team_no != self.team_no)
		{
			if (affected.classname == "player")
			{
				GetClass(self.class);
				// pop up
				affected.velocity = '0 0 0';
				affected.velocity_z = 500;

				// stun 
				//T_ApplyBuff(affected, selfclass.skill_one_buff_category, selfclass.skill_one, selfclass.skill_one_buff_lifetime, selfclass.skill_one_buff_tickrate);
				T_Damage(affected, self, self, selfclass.skill_one_damage);
			}
		}
		affected = affected.chain;
	}
}

void classsham_skillone()
{
	if (!self.spawned)
	{
		sprint(self, PRINT_HIGH, "You cannot use this skill as a ghost\n");
		return;
	}
	self.walkframe = 0;
	classsham_smash();
}

void classsham_skilltwo_Touch()
{
	if (!self.spawned)
	{
		return;
	}
    // push back unit hit, stunning them for duration and .1 secs after hitting ground?
    if (other)
    {
        if (other.team_no != self.team_no)
        {
            if (other.classname == "player")
            {
				GetClass(self.class);
				float r;
				r = selfclass.skill_two_range;
                makevectors(self.angles);
                T_Damage(other, self, self, selfclass.skill_two_damage);
                other.velocity = v_forward * r;
                other.velocity_z = 181;
                //T_ApplyBuff(other, selfclass.skill_two_buff_category, selfclass.skill_two, selfclass.skill_two_buff_lifetime, selfclass.skill_two_buff_tickrate);
            }
        }
    }
    self.touch = SUB_Null;
}

void classsham_skilltwo()
{
	GetClass(self.class);
	// move shambler forward a bunch
	makevectors(self.angles);
	self.velocity = v_forward * selfclass.skill_two_range;
	if (self.flags & FL_ONGROUND)
	{
		self.velocity_z = 181;
	}

	// if he hits a unit
	self.touch = classsham_skilltwo_Touch;
}