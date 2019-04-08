//////////////////////////////////////////////////////////////////////////////////////
// Florida Man by Seth Parson aka Deadline
//////////////////////////////////////////////////////////////////////////////////////
/* NOTES: EACH LEVEL HAS A DIFFERENT GOAL
THE OBJECT IS TO COMPLETE THE LEVEL AND THEN GET CAUGHT BY POLICE AND HAVE A CRAZY
HEADLINE. THE MORE POINTS YOU SCORE DURING THE LEVEL INCREASES THE YEARS IN PRISON
YOU GET. */
#import "../ddl_asm_c64/Deadline_Library.asm"
#import "floridamanfont-charset.asm"
#import "floridamanvars.asm"
*=$A1C0 "floridamansprites"
.import binary "floridamansprites2000.2.prg"
.file [name="prg_files/floridaman.prg", segments="Default"]
.file [name="prg_files/0.prg", segments="Level1"]
.disk [filename="floridaman.d64", name="FLORIDAMAN", id="2019!" ] {
	[name="FLORIDAMAN", type="prg",  segments="Default"],
	[name="----------------", type="rel"],
	[name="0", type="prg", segments="Level1"],
}

//////////////////////////////////////////////////////////////////////////////////////
*=$0801 "BASIC"
BasicUpstart(C_ROUTINE_MEM)
*=C_ROUTINE_MEM "ROUTINE"
program_start:
	sei
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

	// Setup player location on screen
	lda #$80; sta var_player_x
	lda #$80; sta var_player_y

	// Setup game sprites
    lda #$01; sta SPRITE_ENABLE
	lda #$00; sta SPRITE_MULTICOLOR
    lda #$00; sta SPRITE_MSB_X
	lda BLUE; sta SPRITE_0_COLOR
	lda #$80; sta SPRITE_0_POINTER
//    lda #$c9; sta SPRITE_1_POINTER
//              sta SPRITE_7_POINTER
//    lda #$ca; sta SPRITE_2_POINTER
//    lda #$cb; sta SPRITE_3_POINTER
//    lda #$cc; sta SPRITE_4_POINTER
//    lda #$cd; sta SPRITE_5_POINTER
//    lda #$ce; sta SPRITE_6_POINTER
	rts

//////////////////////////////////////////////////////////////////////////////////////
// Subroutine: Title Screen
//////////////////////////////////////////////////////////////////////////////////////	
sub_title_screen:
    lda #$93
    jsr KERNAL_CHROUT
	jsr sub_copy_floridaman_font
	jsr sub_copy_deadline_sprites
	ldx #$00
printtitlemsg:
	lda titlemsg,x
	beq endtitlemsg
	jsr KERNAL_CHROUT
	inx
	jmp printtitlemsg
titlemsg:
.text "qqqqqqqe              PRESENTS:mqqqqqq         PRESS FIRE JOYPORT 2"; .byte 0
endtitlemsg:
	// PUT THE FLORIDA MAN TITLE ON THE SCREEN
	ldx #$00
putfloridamantitle:
	lda titlefloridaman,x; 		   sta SCREEN_MEMORY+12+360,x
	lda titlefloridamancolor,x;    sta COLOR_MEMORY+12+360,x
	lda titlefloridaman+14,x;	   sta SCREEN_MEMORY+12+400,x
	lda titlefloridamancolor+14,x; sta COLOR_MEMORY+12+400,x
	lda titlefloridaman+28,x;	   sta SCREEN_MEMORY+12+440,x
	lda titlefloridamancolor+28,x; sta COLOR_MEMORY+12+440,x
	lda titlefloridaman+42,x;  	   sta SCREEN_MEMORY+12+480,x
	lda titlefloridamancolor+42,x; sta COLOR_MEMORY+12+480,x
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

//////////////////////////////////////////////////////////////////////////////////////
// Subroutine: GAME ON
//////////////////////////////////////////////////////////////////////////////////////
GAME_ON:
    lda #$93; jsr KERNAL_CHROUT
	jsr sub_load_level
	jsr sub_initialize_level
	jmp C_LEVEL_ROUTINE

//////////////////////////////////////////////////////////////////////////////////////
// Subroutine: Load Level
//////////////////////////////////////////////////////////////////////////////////////
sub_load_level:
	// TODO: SHOW LOAD SCREEN, INDICATE WHICH LEVEL, and the title of the level / goals

	// TODO: LOAD LEVEL FROM DISK

	// TODO: LOAD LEVEL GRAPHICS FROM DISK

	rts

//////////////////////////////////////////////////////////////////////////////////////
// Subroutine: Initialize Level
//////////////////////////////////////////////////////////////////////////////////////
sub_initialize_level:

	rts
	
//////////////////////////////////////////////////////////////////////////////////////
// Subroutine: Move Player
//////////////////////////////////////////////////////////////////////////////////////
sub_move_player:
	// lda #$ff; cmp VIC_RASTER_COUNTER; beq ok_move; rts
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
	cmp #$fd
	bne ckbnx2
	dec var_player_x
	jmp ckbny
ckbnx2:
	cmp #$20
	bne ckbny
	inc var_player_x
ckbny:
	lda var_player_y
	cmp #$b0
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
	// DEBUG STUFF
	lda var_player_x
	sta 1104
	lda var_player_y
	sta 1105
	lda var_joy_2_fire
	sta 1106

	lda #$00
	sta CURSOR_X_POS
	sta CURSOR_Y_POS

    ldx #$00
print_screen_lives:
	lda SCREEN_LIVES_STRING,x
	beq print_screen_lives_2
    jsr KERNAL_CHROUT
    inx
    jmp print_screen_lives
print_screen_lives_2:
	lda var_lives
    clc
    adc #$30
    jsr KERNAL_CHROUT
    rts	

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
	// copy the deadline sprites to the showing area from $A000 to $2000 (7x64 bytes)
	ldx #$00
copyloopz1:
	lda $A000,x; sta $2000,x
	inx
	bne copyloopz1
copyloopz2:
	lda $A100,x; sta $2100,x
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
	lda $A1C0,x; sta $2000,x
	lda $A2C0,x; sta $2100,x
	lda $A3C0,x; sta $2200,x
	lda $A4C0,x; sta $2300,x
	lda $A5C0,x; sta $2400,x
	lda $A6C0,x; sta $2500,x
	lda $A7C0,x; sta $2600,x
	lda $A8C0,x; sta $2700,x	
	lda $A9C0,x; sta $2800,x
	lda $AAC0,x; sta $2900,x
	lda $ABC0,x; sta $2A00,x
	lda $ACC0,x; sta $2B00,x
	lda $ADC0,x; sta $2C00,x
	lda $AEC0,x; sta $2D00,x
	lda $AFC0,x; sta $2E00,x
	lda $B0C0,x; sta $2F00,x
	lda $B1C0,x; sta $3000,x
	lda $B2C0,x; sta $3100,x
	lda $B3C0,x; sta $3200,x
	lda $B4C0,x; sta $3300,x
	lda $B5C0,x; sta $3400,x
	lda $B6C0,x; sta $3500,x
	inx
	bne copy_flm_loopz2
	rts
copy_flm_loopz2:
	jmp copy_flm_loopz1

#import "floridaman_data.asm"
#import "floridaman_levels.asm"
