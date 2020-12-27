$cd id1/models/zombie

$origin	0 0 24

$base base
$skin skin

$frame stand1 stand2 stand3 stand4 stand5 stand6 stand7 stand8
$frame stand9 stand10 stand11 stand12 stand13 stand14 stand15

$frame walk1 walk2 walk3 walk4 walk5 walk6 walk7 walk8 walk9 walk10 walk11
$frame walk12 walk13 walk14 walk15 walk16 walk17 walk18 walk19

$frame run1 run2 run3 run4 run5 run6 run7 run8 run9 run10 run11 run12
$frame run13 run14 run15 run16 run17 run18

$frame atta1 atta2 atta3 atta4 atta5 atta6 atta7 atta8 atta9 atta10 atta11
$frame atta12 atta13

$frame attb1 attb2 attb3 attb4 attb5 attb6 attb7 attb8 attb9 attb10 attb11
$frame attb12 attb13 attb14

$frame attc1 attc2 attc3 attc4 attc5 attc6 attc7 attc8 attc9 attc10 attc11
$frame attc12

$frame paina1 paina2 paina3 paina4 paina5 paina6 paina7 paina8 paina9 paina10
$frame paina11 paina12

$frame painb1 painb2 painb3 painb4 painb5 painb6 painb7 painb8 painb9 painb10
$frame painb11 painb12 painb13 painb14 painb15 painb16 painb17 painb18 painb19
$frame painb20 painb21 painb22 painb23 painb24 painb25 painb26 painb27 painb28

$frame painc1 painc2 painc3 painc4 painc5 painc6 painc7 painc8 painc9 painc10
$frame painc11 painc12 painc13 painc14 painc15 painc16 painc17 painc18

$frame paind1 paind2 paind3 paind4 paind5 paind6 paind7 paind8 paind9 paind10
$frame paind11 paind12 paind13

$frame paine1 paine2 paine3 paine4 paine5 paine6 paine7 paine8 paine9 paine10
$frame paine11 paine12 paine13 paine14 paine15 paine16 paine17 paine18 paine19
$frame paine20 paine21 paine22 paine23 paine24 paine25 paine26 paine27 paine28
$frame paine29 paine30

$frame cruc_1 cruc_2 cruc_3 cruc_4 cruc_5 cruc_6

float ClassStandFunc(f_void runfunc, float wframemax);
float ClassRunFunc(f_void standfunc, float wframemax);
void() classundeadking_run;

void() classundeadking_stand	=[	$stand1,		classundeadking_stand	] {
	if (!ClassStandFunc(classundeadking_run, 15))
	{
		return;
	}

	self.frame = $stand1 + self.walkframe;
	self.walkframe = self.walkframe + 1;
};

void() classundeadking_run	=[	$run1,		classundeadking_run	] {
	if (!ClassRunFunc(classundeadking_stand, 18))
	{
		return;
	}

	self.frame = self.frame + self.walkframe;
	self.walkframe = self.walkframe + 1;
};

void() classundeadking_walk		=[	$walk1,		classundeadking_walk	] {
	if (self.walkframe >= 19)
		self.walkframe = 0;
	
	self.frame = $walk1 + self.walkframe;
	self.walkframe = self.walkframe + 1;
};

void() ClassUndeadKingGrenadeTouch =
{
	if (other == self.owner)
		return;		// don't explode on owner
	GetClass(self.owner.class);
	if (other.takedamage)
	{
		T_Damage (other, self, self.owner, 10 );
		sound (self, CHAN_WEAPON, selfclass.sound_aahit, 1, ATTN_NORM);
		remove (self);
		return;
	}
	sound (self, CHAN_WEAPON, selfclass.sound_aahitwall, 1, ATTN_NORM);	// bounce sound
	self.velocity = '0 0 0';
	self.avelocity = '0 0 0';
	self.touch = SUB_Remove;
};

void(vector st) ClassUndeadKingFireGrenade =
{
	GetClass(self.class);
	entity missile;
	vector	org;

	missile = spawn ();
	missile.owner = self;
	missile.movetype = MOVETYPE_BOUNCE;
	missile.solid = SOLID_BBOX;

	makevectors(self.v_angle);
	org = self.origin + st_x * v_forward + st_y * v_right + (st_z - 24) * v_up;

	missile.velocity = aim(self, 1000);
	missile.velocity = missile.velocity * 600;
	missile.velocity_z = 200;

	missile.avelocity = '3000 1000 2000';

	missile.touch = ClassUndeadKingGrenadeTouch;
	missile.nextthink = time + 2.5;
	missile.think = SUB_Remove;

	setmodel (missile, "progs/zom_gib.mdl");
	setsize (missile, '0 0 0', '0 0 0');		
	setorigin (missile, org);
};


void() classundeadking_attacka		=[	$atta1,		classundeadking_attacka	] {
	if (self.walkframe >= 13)
		{
			ClassUndeadKingFireGrenade('-10 -22 30');
			self.walkframe = 0;
			classundeadking_run();
			return;
		}
	
	self.frame = $atta1 + self.walkframe;
	self.walkframe = self.walkframe + 1;
};

void() classundeadking_attackb		=[	$attb1,		classundeadking_attackb	] {
	if (self.walkframe >= 14)
		{
			ClassUndeadKingFireGrenade('-10 -24 29');
			self.walkframe = 0;
			classundeadking_run();
			return;
		}
	
	self.frame = $attb1 + self.walkframe;
	self.walkframe = self.walkframe + 1;
};

void() classundeadking_attackc		=[	$attc1,		classundeadking_attackc	] {
	if (self.walkframe >= 12)
		{
			ClassUndeadKingFireGrenade('-12 -19 29');
			self.walkframe = 0;
			classundeadking_run();
			return;
		}
	
	self.frame = $attc1 + self.walkframe;
	self.walkframe = self.walkframe + 1;
};

void classundeadking_attack()
{
	GetClass(self.class);
	sound(self, CHAN_WEAPON, selfclass.sound_aashoot, 1, ATTN_NORM);

	float r;	
	r = random();
	
	if (r < 0.3)
		classundeadking_attacka();
	else if (r < 0.6)
		classundeadking_attackb();
	else
		classundeadking_attackc();
}

void() classundeadking_paina1	=[	$paina1,	classundeadking_paina1	] {
	if (self.walkframe >= 12)
		{
			self.walkframe = 0;
			classundeadking_run();
			return;
		}
	
	self.frame = $paina1 + self.walkframe;
	self.walkframe = self.walkframe + 1;
};

void() classundeadking_painc1	=[	$painc1,	classundeadking_painc1	] {
	if (self.walkframe >= 18)
		{
			self.walkframe = 0;
			classundeadking_run();
			return;
		}
	
	self.frame = $painc1 + self.walkframe;
	self.walkframe = self.walkframe + 1;
};

void() classundeadking_paind1	=[	$paind1,	classundeadking_paind1	] {
	if (self.walkframe >= 13)
		{
			self.walkframe = 0;
			classundeadking_run();
			return;
		}
	
	self.frame = $paind1 + self.walkframe;
	self.walkframe = self.walkframe + 1;
};

void() classundeadking_die =
{
	GetClass(self.class);
	sound (self, CHAN_VOICE, "zombie/z_gib.wav", 1, ATTN_NORM);
	ThrowHead (selfclass.model_head, 100);
	for (float i = 0; i < 3; i++)
	{
		ThrowGib ("progs/gib1.mdl", self.health);
		ThrowGib ("progs/gib2.mdl", self.health);
		ThrowGib ("progs/gib3.mdl", self.health);
	}
};

void(entity attacker, float take) classundeadking_pain =
{
	GetClass(self.class);
	sound (self, CHAN_VOICE, selfclass.sound_pain, 1, ATTN_NORM);

	self.walkframe = 0;
	float r = random();
	if (r < 0.33)
		classundeadking_paina1();
	else if (r <  0.66)
		classundeadking_painc1();
	else
		classundeadking_paind1();
};

void ClassUndeadKingSkillOneTouch()
{
	GetClass(self.owner.class);
	if (other.classname != "player")
	{
		sound (self, CHAN_WEAPON, selfclass.sound_aahitwall, 1, ATTN_NORM);
		return;
	}
	entity p = self.owner;
	if (other.team_no != self.owner.team_no)
	{
		sound (self, CHAN_WEAPON, selfclass.sound_aahit, 1, ATTN_NORM);

		vector dest;
		float spawned = 0;
		for (int i = 0; i <= 100; i = i + 1)
		{
			if (spawned >= 10)
				break;

			entity z;
			z = spawn();
			
			dest = other.origin;

			// tracebox from enemy
			float r = random();
			dest_x = dest_x + ((300 * random()) * ((random() <= 0.5) ? 1 : -1));
			dest_y = dest_y + ((300 * random()) * ((random() <= 0.5) ? 1 : -1));
			tracebox(other.origin, VEC_ZOMBIE_MIN, VEC_ZOMBIE_MAX, dest, 0, self);

			if (trace_fraction == 0)
				continue;

			dest_x *= trace_fraction;
			dest_z *= trace_fraction;

			z.origin = dest;
			// set enemy
			self = z;
			monster_zombie();
			z.classname = "monster_zombie";
			z.owner = p;
			z.enemy = other;
			z.takedamage = TRUE;
			z.th_run();
			// if spawn place found
			spawned++;
		}
	}
}

void classundeadking_skillone_Think()
{
	GetClass(self.owner.class);
	float h = self.health; 
	if (h <= 0)
	{
		self.owner.movetype = selfclass.movetype;
		remove(self);
		return;
	}
	self.health = h - 1;

	// stream of gibs
	newmis = spawn();
	newmis.owner = self.owner;
	newmis.movetype = MOVETYPE_FLYMISSILE;
	newmis.solid = SOLID_BBOX;
		
	makevectors (self.owner.v_angle);
	// FIXME - use skill one range
	newmis.velocity = aim(self.owner, 1000);
	newmis.velocity = newmis.velocity * 1000;
	newmis.angles = vectoangles(newmis.velocity);
	
	newmis.touch = ClassUndeadKingSkillOneTouch;
	newmis.voided = 0;
	
	newmis.nextthink = time + 5;
	newmis.think = SUB_Remove;
	newmis.classname = "classundeadking_skillone";

	float r = random();
	string m = ""; // TODO - finally understand fteqcc pointers between fields/vars
	if (r <= 0.3)
	{
		m = "progs/gib1.mdl";
	}
	else if (r <= 0.6)
	{
		m = "progs/gib2.mdl";
	}
	else
	{
		m = "progs/gib3.mdl";
	}
	setmodel (newmis, m);
	setsize (newmis, '0 0 0', '0 0 0');             
	setorigin (newmis, self.owner.origin + v_forward*8 + '0 0 16');
	self.nextthink = time + 0.1;
}

void classundeadking_skillone()
{
	if (!self.spawned)
	{
		sprint(self, PRINT_HIGH, "You cannot use this skill as a ghost\n");
		return;
	}
	entity timer;
	timer = spawn();

	timer.owner = self;
	timer.think = classundeadking_skillone_Think;
	timer.nextthink = time + .1;
	timer.health = 10;
	self.movetype = MOVETYPE_NONE;
}

void classundeadking_skilltwo()
{
	if (!self.spawned)
	{
		sprint(self, PRINT_HIGH, "You cannot use this skill as a ghost\n");
		return;
	}
	// shoot zombie, if touch teleport to them
	makevectors(self.v_angle);
	traceline(self.origin, self.origin + v_forward * 1000, FALSE, self);

	if (trace_ent.classname == "monster_zombie")
	{
		vector org;
		org = trace_ent.origin;
		spawn_tfog(self.origin);
		spawn_tfog(org);
		spawn_tdeath(org, self);
		self.origin = org;
	}
}