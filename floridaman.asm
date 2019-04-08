//////////////////////////////////////////////////////////////////////////////////////
// Florida Man by Seth Parson aka Deadline
//////////////////////////////////////////////////////////////////////////////////////
//
// NOTES:
//	EACH LEVEL HAS A DIFFERENT GOAL
//		THE OBJECT IS TO COMPLETE THE LEVEL AND THEN GET CAUGHT BY POLICE AND
//		HAVE A CRAZY HEADLINE. THE MORE POINTS YOU SCORE DURING THE LEVEL
//		INCREASES THE YEARS IN PRISON YOU GET.
//
//////////////////////////////////////////////////////////////////////////////////////
.const C_ROUTINE_MEM     = $080E
.const C_LEVEL_ROUTINE   = $5000 // Load level into this area
#import "../ddl_asm_c64/Deadline_Library.asm"
#import "floridamanfont-charset.asm"
#import "floridaman_vars.asm"
.var mem_deadline_sprites = $A000
*=mem_deadline_sprites "DeadlineSprites"
#import "../ddl_asm_c64/Deadline_Sprites_Data.asm"
.var mem_floridaman_sprites = $A1C0
*=mem_floridaman_sprites "floridamansprites";
.import binary "floridamansprites2000.2.prg"
*=$CE00 "Data Tables"
#import "floridaman_data.asm"
//////////////////////////////////////////////////////////////////////////////////////
// File stuff
.file [name="prg_files/floridaman.prg", segments="Main,DDL,DefaultLevel"]
.file [name="prg_files/0.prg", segments="DefaultLevel"]
.file [name="prg_files/1.prg", segments="Level1"]
.file [name="prg_files/2.prg", segments="Level2"]
.disk [filename="floridaman.d64", name="FLORIDAMAN", id="2019!" ] {
	[name="FLORIDAMAN", type="prg",  segments="Main,DDL,DefaultLevel"],
	[name="----------------", type="rel"],
	[name="0", type="prg", segments="DefaultLevel"],
	[name="1", type="prg", segments="Level1"],
	[name="2", type="prg", segments="Level2"],
}
//////////////////////////////////////////////////////////////////////////////////////
.segment Main [allowOverlap]
*=$0801 "BASIC"
BasicUpstart(C_ROUTINE_MEM)
*=C_ROUTINE_MEM "Main ROUTINE"
program_start:
	sei
	DDL_Load_StringName("0",$50,$00)
  	jsr sub_initialize
  	jsr sub_title_screen
	jsr sub_initialize_vars
  	jmp GAME_ON

//////////////////////////////////////////////////////////////////////////////////////
// Subroutine: Setup initialize
//////////////////////////////////////////////////////////////////////////////////////	
sub_initialize:
	lda #54; sta $01
    lda #$93; jsr KERNAL_CHROUT // Clear Screen
	lda #$00; sta BORDER_COLOR; sta BACKGROUND_COLOR
	// Change the charset
	lda VIC_MEM_POINTERS;  ora #$0e; sta VIC_MEM_POINTERS
	lda VIC_CONTROL_REG_2; and #$ef; sta VIC_CONTROL_REG_2
	rts

//////////////////////////////////////////////////////////////////////////////////////
// Subroutine: Setup initialize
//////////////////////////////////////////////////////////////////////////////////////	
sub_initialize_vars:
	jsr sub_copy_floridaman_sprites

	// Fill in some default var values
 	lda #C_STARTING_LIVES; sta var_lives // starting lives
	lda #C_STARTING_LEVEL; sta var_level // starting level (add +1 for displaying on screen)

	// This routines will be set up inside the level routine that loads
	// Setup player location on screen
	lda #$80; sta var_player_x
	lda #$80; sta var_player_y

	// Turn off game sprites
    lda #$00; sta SPRITE_ENABLE
	rts

//////////////////////////////////////////////////////////////////////////////////////
// Subroutine: Title Screen
//////////////////////////////////////////////////////////////////////////////////////	
sub_title_screen:
    lda #$93
    jsr KERNAL_CHROUT
	jsr sub_copy_floridaman_font
	jsr sub_copy_deadline_sprites
	
	PrintAtColor(15,7,titlemsg1,WHITE)
	PrintAtColor(9,15,titlemsg2,YELLOW)

	// PUT THE FLORIDA MAN TITLE ON THE SCREEN
	ldx #$00
putfloridamantitle:
	lda data_titlefloridaman,x;			sta SCREEN_MEMORY+12+360,x
	lda data_titlefloridamancolor,x;	sta COLOR_MEMORY+12+360,x
	lda data_titlefloridaman+14,x;		sta SCREEN_MEMORY+12+400,x
	lda data_titlefloridamancolor+14,x;	sta COLOR_MEMORY+12+400,x
	lda data_titlefloridaman+28,x;		sta SCREEN_MEMORY+12+440,x
	lda data_titlefloridamancolor+28,x; sta COLOR_MEMORY+12+440,x
	lda data_titlefloridaman+42,x;		sta SCREEN_MEMORY+12+480,x
	lda data_titlefloridamancolor+42,x; sta COLOR_MEMORY+12+480,x
	inx
	cpx #14
	bne putfloridamantitle
	// PUT THE DEADLINE SPRITES ON THE SCREEN
    lda #$FF; 		sta SPRITE_ENABLE; sta SPRITE_MULTICOLOR
    lda #DARK_GRAY; sta SPRITE_MULTICOLOR_0
    lda #GRAY; 		sta SPRITE_MULTICOLOR_1
    lda #$00;		sta SPRITE_MSB_X
	lda #$80; sta SPRITE_0_POINTER
    lda #$81; sta SPRITE_1_POINTER
              sta SPRITE_7_POINTER
    lda #$82; sta SPRITE_2_POINTER
    lda #$83; sta SPRITE_3_POINTER
    lda #$84; sta SPRITE_4_POINTER
    lda #$85; sta SPRITE_5_POINTER
    lda #$86; sta SPRITE_6_POINTER
    lda #$6C; sta SPRITE_0_X
    lda #$7C; sta SPRITE_1_X
    lda #$8C; sta SPRITE_2_X
    lda #$9C; sta SPRITE_3_X
    lda #$AE; sta SPRITE_4_X
    lda #$BA; sta SPRITE_5_X
    lda #$CC; sta SPRITE_6_X
    lda #$DC; sta SPRITE_7_X
    lda #$48; sta SPRITE_0_Y
              sta SPRITE_1_Y
              sta SPRITE_2_Y
              sta SPRITE_3_Y
              sta SPRITE_4_Y
              sta SPRITE_5_Y
              sta SPRITE_6_Y
              sta SPRITE_7_Y
	// TITLE SCREEN LOOP WAITING FOR FIRE BUTTON TO BE PRESSED
title_loop:
	lda VIC_RASTER_COUNTER; cmp #$49; bne title_loop // WAIT FOR RASTER $49
	// CHANGE SPRITE COLORS
    ldx var_sprite_color_reg
         stx SPRITE_0_COLOR
    inx; stx SPRITE_1_COLOR
    inx; stx SPRITE_2_COLOR
    inx; stx SPRITE_3_COLOR
    inx; stx SPRITE_4_COLOR
    inx; stx SPRITE_5_COLOR
    inx; stx SPRITE_6_COLOR
    inx; stx SPRITE_7_COLOR
    inc var_sprite_color_reg
	// READ JOYSTICK 2, CHECK FOR FIRE BUTTON PRESS
	jsr sub_read_joystick_2
	lda var_joy_2_fire
	beq title_loop
	rts

titlemsg1: .text "presents"; .byte 0
titlemsg2: .text "press fire joyport 2"; .byte 0

//////////////////////////////////////////////////////////////////////////////////////
// Subroutine: GAME ON
//////////////////////////////////////////////////////////////////////////////////////
GAME_ON:
    lda #$93; jsr KERNAL_CHROUT
	jsr sub_load_level
	jmp C_LEVEL_ROUTINE

//////////////////////////////////////////////////////////////////////////////////////
// Subroutine: Load Level
//////////////////////////////////////////////////////////////////////////////////////
sub_load_level:
	lda #$93; jsr KERNAL_CHROUT
	PrintAtColor(5,5,load_level_message,WHITE)
// SET FILENAME
	ldx #$00
	lda #$00
set_filename_loop1:
	sta var_filename,x
	inx
	cpx #$0F
	bne set_filename_loop1
	lda var_level
	clc
	adc #$30
	sta var_filename
	PrintAtColor(19,5,var_filename,RED)
	PrintAtColor(5,7,load_level_filename,WHITE)
	PrintAtColor(14,7,var_filename,RED)
	DDL_Load_MemName(var_filename,$50,$00)
	PrintAtRainbow(5,9,level_message) // show the loaded level message
	// READ JOYSTICK 2, CHECK FOR FIRE BUTTON PRESS
	PrintAtColor(5,11,load_level_press_fire,YELLOW)
load_level_temp_check_fire:
	jsr sub_read_joystick_2
	lda var_joy_2_fire
	beq load_level_temp_check_fire
	rts
load_level_message:   .text "loading level:"; .byte 0
load_level_filename:  .text "filename:"; .byte 0
load_level_press_fire: .text "press fire to start"; .byte 0

//////////////////////////////////////////////////////////////////////////////////////
// Subroutine: Move Player
//////////////////////////////////////////////////////////////////////////////////////
sub_move_player:
	lda #$01;
	cmp VIC_RASTER_COUNTER;
	bcs ok_move;
	rts
ok_move:
	lda var_joy_2_x
	beq move_y
	cmp #$ff
	beq left
right:
	inc var_player_x
	jmp move_y
left:
	dec var_player_x
move_y:
	lda var_joy_2_y
	beq check_boundry
	cmp #$ff
	beq up
down:
 	inc var_player_y
 	jmp check_boundry
up:
	dec var_player_y
check_boundry:
	lda var_player_x
	cmp #$ff
	bne ckbnx2
	dec var_player_x
	jmp ckbny
ckbnx2:
	cmp #$20
	bne ckbny
	inc var_player_x
ckbny:
	lda var_player_y
	cmp #$d0
	bne ckbny2
	dec var_player_y
	jmp xitckbn
ckbny2:
	cmp #$40
	bne xitckbn
	inc var_player_y
xitckbn:
	lda var_player_x
	sta SPRITE_0_X
	lda var_player_y
	sta SPRITE_0_Y
	rts

//////////////////////////////////////////////////////////////////////////////////////
// Subroutine: Update HUD
//////////////////////////////////////////////////////////////////////////////////////
sub_update_hud:
	lda #$20
	cmp VIC_RASTER_COUNTER
	beq do_hud
	rts
do_hud:
	PrintAtColor(30,0,SCREEN_LIVES_STRING,WHITE)
	PrintAtColor(37,0,var_lives,WHITE)

	// DEBUG STUFF
	PrintDecAtColor(30,2,var_player_x,WHITE)
	PrintDecAtColor(30,3,var_player_y,WHITE)
	PrintDecAtColor(30,4,var_joy_2_fire,WHITE)
	
	// lda var_player_x; sta 1104
	// lda var_player_y; sta 1105
	// lda var_joy_2_fire; sta 1106



    rts	

SCREEN_LIVES_STRING: .text "lives:"; .byte 0

//////////////////////////////////////////////////////////////////////////////////////
// Subroutine: Copy Florida Man FONT into VIC mem
//////////////////////////////////////////////////////////////////////////////////////
sub_copy_floridaman_font:
	// copy the Florida Man font to the showing area from $4000 to $3800
	ldx #$00
copy_fmf_loopz1:
	lda $4000,x; sta $3800,x
	lda $4100,x; sta $3900,x	
	lda $4200,x; sta $3A00,x
	lda $4300,x; sta $3B00,x
	lda $4400,x; sta $3C00,x
	lda $4500,x; sta $3D00,x
	lda $4600,x; sta $3E00,x
	lda $4700,x; sta $3F00,x
	inx
	bne copy_fmf_loopz1
	rts

//////////////////////////////////////////////////////////////////////////////////////
// Subroutine: Copy Deadline Sprites into VIC mem
//////////////////////////////////////////////////////////////////////////////////////
sub_copy_deadline_sprites:
	// copy the deadline sprites
	ldx #$00
copyloopz1:
	lda mem_deadline_sprites,x; sta $2000,x
	inx
	bne copyloopz1
copyloopz2:
	lda mem_deadline_sprites+$100,x; sta $2100,x
	inx
	cpx #$C1
	bne copyloopz2
	rts

//////////////////////////////////////////////////////////////////////////////////////
// Subroutine: Copy Florida Man Sprites into VIC mem
//////////////////////////////////////////////////////////////////////////////////////
sub_copy_floridaman_sprites:
	// copy the floridaman sprites to the showing area from $A1C0-$B7C1 to $2000 
	ldx #$00
copy_flm_loopz1:
	lda mem_floridaman_sprites,x; sta $2000,x
	lda mem_floridaman_sprites+$100,x; sta $2100,x
	lda mem_floridaman_sprites+$200,x; sta $2200,x
	lda mem_floridaman_sprites+$300,x; sta $2300,x
	lda mem_floridaman_sprites+$400,x; sta $2400,x
	lda mem_floridaman_sprites+$500,x; sta $2500,x
	lda mem_floridaman_sprites+$600,x; sta $2600,x
	lda mem_floridaman_sprites+$700,x; sta $2700,x	
	lda mem_floridaman_sprites+$800,x; sta $2800,x
	lda mem_floridaman_sprites+$900,x; sta $2900,x
	lda mem_floridaman_sprites+$A00,x; sta $2A00,x
	lda mem_floridaman_sprites+$B00,x; sta $2B00,x
	lda mem_floridaman_sprites+$C00,x; sta $2C00,x
	lda mem_floridaman_sprites+$D00,x; sta $2D00,x
	lda mem_floridaman_sprites+$E00,x; sta $2E00,x
	lda mem_floridaman_sprites+$F00,x; sta $2F00,x
	lda mem_floridaman_sprites+$1000,x; sta $3000,x
	lda mem_floridaman_sprites+$1100,x; sta $3100,x
	lda mem_floridaman_sprites+$1200,x; sta $3200,x
	lda mem_floridaman_sprites+$1300,x; sta $3300,x
	lda mem_floridaman_sprites+$1400,x; sta $3400,x
	lda mem_floridaman_sprites+$1500,x; sta $3500,x
	inx
	bne copy_flm_loopz2
	rts
copy_flm_loopz2:
	jmp copy_flm_loopz1

#import "floridaman_levels.asm"
