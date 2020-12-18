#include "defs.h"

float skill;
float coop;


enum {
    CLASS_NONE,
    CLASS_SURVIVOR,
    CLASS_FIEND,
    CLASS_SHAMBLER,
    CLASS_UNDEADKING,
    CLASS_LEASH,
};

enum {
    SKILLONE_NONE,
    SKILLTWO_NONE,
    SKILLONE_SURVIVOR,
    SKILLTWO_SURVIVOR,
    SKILLONE_FIEND,
    SKILLTWO_FIEND,
    SKILLONE_SHAMBLER,
    SKILLTWO_SHAMBLER,
    SKILLONE_UNDEADKING,
    SKILLTWO_UNDEADKING,
    SKILLONE_LEASH,
    SKILLTWO_LEASH,
};

//typedef void (float n) f_void_float;
typedef void () f_void;
typedef void(entity, float) f_void_ef;

// status bar stuff
.string status_string;           // current centerprint text
.float status_string_lines;       // how many lines the centerprint is
.float status_string_time;        // when text will time out
.float status_string_refresh_time;       // when sbar is next printed
.float state; // bitfield to track states

.float team_no;
//.f_void_float menu_input;
.float menu;
.float class;
.entity interactentity;
// buffs
.float nextthinkinterval;
.float buffcategory;
.float buffid;
.float buffvalue;

// class fields
.float attackdamage;
.float attackfinish;
.float baseattackfinish;
.float skill_one;
.float skill_two;
.float skill_selected;
.float skill_one_damage;
.float skill_one_cooldown;
.float skill_one_cooldown_time;
.float skill_one_range;
.float skill_two_damage;
.float skill_two_cooldown;
.float skill_two_cooldown_time;
.float skill_two_range;

typedef struct {
    float classtype;
    string classstring;
    string model;
    vector model_min;
    vector model_max;
    vector model_viewoffset;
    string model_head;
    float modelindex;
    f_void standfunc;
    f_void runfunc;
    f_void_ef painfunc;
    f_void diefunc;
    f_void attackfunc;
    f_void skillonefunc;
    f_void skilltwofunc;
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
    float skill_one_buff_category;
    float skill_one_buff_lifetime;
    float skill_one_buff_tickrate;
    float skill_two;
    float skill_two_cooldown;
    float skill_two_damage;
    float skill_two_range;
    float skill_two_value;
    float skill_two_buff_category;
    float skill_two_buff_lifetime;
    float skill_two_buff_tickrate;

    float items;
    float ammo_rockets;
    float ammo_nails;
    float ammo_shells;
    float ammo_cells;
    float armortype;
    float armorvalue;
    float weapon;
    float flags;
    float waterlevel;
    float takedamage;
    float solid;
    float movetype;
    string weaponmodel;
} Class_t;
Class_t Classes[6];
Class_t selfclass;
void GetClass(float id);
