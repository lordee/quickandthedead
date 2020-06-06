#include "defs.h"

float skill;
float coop;



//typedef void (float n) f_void_float;
typedef void () f_void;

// status bar stuff
.string status_string;           // current centerprint text
.float status_string_lines;       // how many lines the centerprint is
.float status_string_time;        // when text will time out
.float status_string_refresh_time;       // when sbar is next printed

.float team_no;
//.f_void_float menu_input;
.float menu;
.float class;


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
.float skill_one_value;
.float skill_two_damage;
.float skill_two_cooldown;
.float skill_two_cooldown_time;
.float skill_two_range;
.float skill_two_value;