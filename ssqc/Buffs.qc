void () BuffThink = {
    float h;
    h = self.health - 1;

    if (h > 0)
    {
        self.health = h;
        self.nextthink = time + self.nextthinkinterval;

        return;
    }

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

void (entity targ, float cat, float id, float lifetime, float tickrate) T_ApplyBuff = {
	entity newbuff;
	newbuff = spawn();
    newbuff.owner = targ;
    newbuff.classname = "buff";
    newbuff.buffcategory = cat;
	newbuff.buffid = id;
    
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