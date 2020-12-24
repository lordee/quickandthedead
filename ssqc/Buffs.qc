void () BuffThink = {
    float h;
    h = self.health - 1;

	// debuff tick applied
	switch (self.buffcategory)
    {
		case DEBUFF_DOWNEDHEALTHROT:
			// don't die whilst downed, clients go weird
			if (!self.downedflag)
				self.owner.health = self.owner.health - 1;
			break;
        default:
    }

    if (h > 0)
    {
        self.health = h;
        self.nextthink = time + self.nextthinkinterval;

        return;
    }

	// debuff ends
    switch (self.buffcategory)
    {
		case DEBUFF_STUN_MOVEALLOWED:
			self.owner.state = self.owner.state - (self.owner.state & PSTATE_STUNNED);
			break;
        case DEBUFF_STUN:
			self.owner.state = self.owner.state - (self.owner.state & PSTATE_STUNNED);
            self.owner.movetype = MOVETYPE_WALK;
			break;
        default:
    }

    remove(self);
}

/*
float BuffExists(entity player, float id)
{
	entity buff;
	buff = find(world, classname, "buff");
	while (buff)
	{
		if (buff.owner == player)
		{
			if (buff.buffid == id)
			{
				return TRUE;
			}
		}
		buff = find(buff, classname, "buff");
	}
	return FALSE;
}
*/
void (entity targ, float cat, float lifetime, float tickrate) T_ApplyBuff = {
	entity newbuff;
	newbuff = spawn();
    newbuff.owner = targ;
    newbuff.classname = "buff";
    newbuff.buffcategory = cat;
    
    newbuff.think = BuffThink;
	newbuff.max_health = lifetime;
	newbuff.health = lifetime;
	newbuff.nextthinkinterval = tickrate;
	newbuff.nextthink = time + tickrate;

    // instant debuff
    switch (cat)
    {
        case DEBUFF_STUN:
			targ.state = targ.state | PSTATE_STUNNED;
            targ.movetype = MOVETYPE_NONE;
			break;
		case DEBUFF_STUN_MOVEALLOWED:
			targ.state = targ.state | PSTATE_STUNNED;
			break;
        default:
    }
}