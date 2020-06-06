enum {
    CLASS_NONE,  // don't bother for now
    CLASS_FIEND,
    CLASS_SHAMBLER,
    CLASS_UNDEADKING,
    CLASS_LEASH,
};

enum {
    SKILLONE_FIEND,
    SKILLTWO_FIEND,
    SKILLONE_SHAMBLER,
    SKILLTWO_SHAMBLER,
    SKILLONE_UNDEADKING,
    SKILLTWO_UNDEADKING,
    SKILLONE_LEASH,
    SKILLTWO_LEASH,
};

typedef struct {
    float classtype;
    string classstring;
    string model;
    vector model_min;
    vector model_max;
    vector model_viewoffset;
    string model_head;
    f_void standfunc;
    string sound_pain;
    string sound_death;
    string sound_aashoot;
    string sound_aahit;
    string sound_aahitwall;
    string sound_skillone_cast;
    string sound_skilltwo_cast;
    float basead;
    float basehealth;
    float basespeed;
    float baseattackfinish;
    float skill_one;
    float skill_one_cooldown;
    float skill_one_damage;
    float skill_one_range;
    float skill_one_value;
    float skill_two;
    float skill_two_cooldown;
    float skill_two_damage;
    float skill_two_range;
    float skill_two_value;
} Class_t;

void()	demon1_stand1;
void()	sham_stand1;
void()	zombie_stand1;

Class_t Classes[4] = {
    {
        CLASS_FIEND,
        STRING_FIEND,
        MODEL_FIEND,
        MODEL_MIN_FIEND,
        MODEL_MAX_FIEND,
        MODEL_VIEWOFFSET_FIEND,
        MODEL_HEAD_FIEND,
        demon1_stand1,
        SOUND_PAIN_FIEND,
        SOUND_DEATH_FIEND,
        SOUND_AASHOOT_FIEND,
        SOUND_AAHIT_FIEND,
        SOUND_AAHITWALL_FIEND,
        SOUND_SKILLONE_CAST_FIEND,
        SOUND_SKILLTWO_CAST_FIEND,
        BASEAD_FIEND,
        BASEHEALTH_FIEND,
        BASESPEED_FIEND,
        BASEATTACKFINISH_FIEND,
        SKILLONE_FIEND,
        SKILLONE_COOLDOWN_FIEND,
        SKILLONE_DAMAGE_FIEND,
        SKILLONE_RANGE_FIEND,
        0,
        SKILLTWO_FIEND,
        SKILLTWO_COOLDOWN_FIEND,
        SKILLTWO_DAMAGE_FIEND,
        SKILLTWO_RANGE_FIEND,
        0
    },
    {
        CLASS_SHAMBLER,
        STRING_SHAMBLER,
        MODEL_SHAMBLER,
        MODEL_MIN_SHAMBLER,
        MODEL_MAX_SHAMBLER,
        MODEL_VIEWOFFSET_SHAMBLER,
        MODEL_HEAD_SHAMBLER,
        sham_stand1,
        SOUND_PAIN_SHAMBLER,
        SOUND_DEATH_SHAMBLER,
        SOUND_AASHOOT_SHAMBLER,
        SOUND_AAHIT_SHAMBLER,
        SOUND_AAHITWALL_SHAMBLER,
        SOUND_SKILLONE_CAST_SHAMBLER,
        SOUND_SKILLTWO_CAST_SHAMBLER,
        BASEAD_SHAMBLER,
        BASEHEALTH_SHAMBLER,
        BASESPEED_SHAMBLER,
        BASEATTACKFINISH_SHAMBLER,
        SKILLONE_SHAMBLER,
        SKILLONE_COOLDOWN_SHAMBLER,
        SKILLONE_DAMAGE_SHAMBLER,
        SKILLONE_RANGE_SHAMBLER,
        0,
        SKILLTWO_SHAMBLER,
        SKILLTWO_COOLDOWN_SHAMBLER,
        SKILLTWO_DAMAGE_SHAMBLER,
        SKILLTWO_RANGE_SHAMBLER,
        0
    },
    {
        CLASS_UNDEADKING,
        STRING_UNDEADKING,
        MODEL_UNDEADKING,
        MODEL_MIN_UNDEADKING,
        MODEL_MAX_UNDEADKING,
        MODEL_VIEWOFFSET_UNDEADKING,
        MODEL_HEAD_UNDEADKING,
        zombie_stand1,
        SOUND_PAIN_UNDEADKING,
        SOUND_DEATH_UNDEADKING,
        SOUND_AASHOOT_UNDEADKING,
        SOUND_AAHIT_UNDEADKING,
        SOUND_AAHITWALL_UNDEADKING,
        SOUND_SKILLONE_CAST_UNDEADKING,
        SOUND_SKILLTWO_CAST_UNDEADKING,
        BASEAD_UNDEADKING,
        BASEHEALTH_UNDEADKING,
        BASESPEED_UNDEADKING,
        BASEATTACKFINISH_UNDEADKING,
        SKILLONE_UNDEADKING,
        SKILLONE_COOLDOWN_UNDEADKING,
        SKILLONE_DAMAGE_UNDEADKING,
        SKILLONE_RANGE_UNDEADKING,
        0,
        SKILLTWO_UNDEADKING,
        SKILLTWO_COOLDOWN_UNDEADKING,
        SKILLTWO_DAMAGE_UNDEADKING,
        SKILLTWO_RANGE_UNDEADKING,
        0
    },
    {
        CLASS_LEASH,
        STRING_LEASH,
        MODEL_LEASH,
        MODEL_MIN_LEASH,
        MODEL_MAX_LEASH,
        MODEL_VIEWOFFSET_LEASH,
        MODEL_HEAD_LEASH,
        zombie_stand1,
        SOUND_PAIN_LEASH,
        SOUND_DEATH_LEASH,
        SOUND_AASHOOT_LEASH,
        SOUND_AAHIT_LEASH,
        SOUND_AAHITWALL_LEASH,
        SOUND_SKILLONE_CAST_LEASH,
        SOUND_SKILLTWO_CAST_LEASH,
        BASEAD_LEASH,
        BASEHEALTH_LEASH,
        BASESPEED_LEASH,
        BASEATTACKFINISH_LEASH,
        SKILLONE_LEASH,
        SKILLONE_COOLDOWN_LEASH,
        SKILLONE_DAMAGE_LEASH,
        SKILLONE_RANGE_LEASH,
        0,
        SKILLTWO_LEASH,
        SKILLTWO_COOLDOWN_LEASH,
        SKILLTWO_DAMAGE_LEASH,
        SKILLTWO_RANGE_LEASH,
        0
    }
};

Class_t selfclass;
void GetClass(float id)
{
    for (float i = 0; i < Classes.length; i++)
    {
        if (Classes[i].classtype == id)
        {
            selfclass = Classes[i];
            return;
        }
    }
    //selfchamp = Classes[0];
}