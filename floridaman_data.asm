//////////////////////////////////////////////////////////////////////////////////////
// DATA TABLES & STUFF
//////////////////////////////////////////////////////////////////////////////////////
titlefloridaman:
.byte 64,65,68,69,72,73,76,77,80,81,84,85,88,89
.byte 66,67,70,71,74,75,78,79,82,83,86,87,90,91
.byte 32,32,32,32,92,93,88,89,96,97,32,32,32,32
.byte 32,32,32,32,94,95,90,91,98,99,32,32,32,32
titlefloridamancolor:
.byte DARK_GRAY,GRAY,LIGHT_GRAY,WHITE,LIGHT_GRAY,GRAY,DARK_GRAY,GRAY,LIGHT_GRAY,WHITE,LIGHT_GRAY,GRAY,DARK_GRAY,GRAY
.byte GRAY,LIGHT_GRAY,WHITE,LIGHT_GRAY,GRAY,DARK_GRAY,GRAY,LIGHT_GRAY,WHITE,LIGHT_GRAY,GRAY,DARK_GRAY,GRAY,DARK_GRAY
.byte LIGHT_GRAY,WHITE,LIGHT_GRAY,GRAY,DARK_GRAY,GRAY,LIGHT_GRAY,WHITE,LIGHT_GRAY,GRAY,DARK_GRAY,GRAY,DARK_GRAY,GRAY
.byte WHITE,LIGHT_GRAY,GRAY,DARK_GRAY,GRAY,LIGHT_GRAY,WHITE,LIGHT_GRAY,GRAY,DARK_GRAY,GRAY,DARK_GRAY,GRAY,LIGHT_GRAY

upmsg:
.text "SCORE:"
.byte 0
SCREEN_LIVES_STRING:
.text "LIVES:"
.byte 0
message:
.text "qqqqqqq           bFLORIDA MANe.qq"
.byte 0

*=$A000 "DeadlineSprites"
#import "../ddl_asm_c64/Deadline_Sprites_Data.asm"
