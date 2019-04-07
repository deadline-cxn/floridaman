//////////////////////////////////////////////////////////////////////////////////////
// Florida Man by Seth Parson aka Deadline
//////////////////////////////////////////////////////////////////////////////////////
/* NOTES:
EACH LEVEL HAS A DIFFERENT GOAL
THE OBJECT IS TO COMPLETE THE LEVEL AND THEN GET CAUGHT BY POLICE AND HAVE A CRAZY
HEADLINE. THE MORE POINTS YOU SCORE DURING THE LEVEL INCREASES THE YEARS IN PRISON
YOU GET. */
#import "../ddl_asm_c64/Deadline_Library.asm"
#import "floridamanfont-charset.asm"
#import "floridamanvars.asm"
.pc = $A1C0 "floridamansprites"
.import binary "floridamansprites2000.2.prg"
//////////////////////////////////////////////////////////////////////////////////////
.pc=$0801 "BASIC"
BasicUpstart(var_routine_mem)
.pc=var_routine_mem "ROUTINE"
program_start:
	sei
  	jsr sub_initialize
  	jsr sub_title_screen
	jsr sub_initialize_vars
  	jmp sub_start

//////////////////////////////////////////////////////////////////////////////////////
// Subroutine: Setup initialize
//////////////////////////////////////////////////////////////////////////////////////	
sub_initialize:
	lda #54
	sta $01
    lda #$93
    jsr KERNAL_CHROUT
	lda #$00
 	sta BORDER_COLOR
 	sta BACKGROUND_COLOR

	// Change the charset
	lda VIC_MEM_POINTERS
	ora #$0e
	sta VIC_MEM_POINTERS
	lda VIC_CONTROL_REG_2
	and #$ef
	sta VIC_CONTROL_REG_2
	rts

//////////////////////////////////////////////////////////////////////////////////////
// Subroutine: Setup initialize
//////////////////////////////////////////////////////////////////////////////////////	
sub_initialize_vars:
	jsr sub_copy_floridaman_sprites
	// Fill in some default var values
 	lda #$04
 	sta var_lives

	lda #$80
	sta var_player_x
	lda #$80
	sta var_player_y

	// Setup game sprites
    lda #$01
	sta SPRITE_ENABLE
	lda #$00
	sta SPRITE_MULTICOLOR
    lda #$00
	sta SPRITE_MSB_X
    
	lda BLUE
    sta SPRITE_0_COLOR
    
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
// Subroutine: Copy Florida Man FONT into VIC mem
//////////////////////////////////////////////////////////////////////////////////////
sub_copy_floridaman_font:
	// copy the Florida Man font to the showing area from $4000 to $3800
	ldx #$00
copy_fmf_loopz1:
	lda $4000,x
	sta $3800,x
	lda $4100,x
	sta $3900,x	
	lda $4200,x
	sta $3A00,x
	lda $4300,x
	sta $3B00,x
	lda $4400,x
	sta $3C00,x
	lda $4500,x
	sta $3D00,x
	lda $4600,x
	sta $3E00,x
	lda $4700,x
	sta $3F00,x
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
	lda $A000,x
	sta $2000,x
	inx
	bne copyloopz1
copyloopz2:
	lda $A100,x
	sta $2100,x
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
	lda $A1C0,x
	sta $2000,x
	lda $A2C0,x
	sta $2100,x
	lda $A3C0,x
	sta $2200,x
	lda $A4C0,x
	sta $2300,x
	lda $A5C0,x
	sta $2400,x
	lda $A6C0,x
	sta $2500,x
	lda $A7C0,x
	sta $2600,x
	lda $A8C0,x
	sta $2700,x	
	lda $A9C0,x
	sta $2800,x
	lda $AAC0,x
	sta $2900,x
	lda $ABC0,x
	sta $2A00,x
	lda $ACC0,x
	sta $2B00,x
	lda $ADC0,x
	sta $2C00,x
	lda $AEC0,x
	sta $2D00,x
	lda $AFC0,x
	sta $2E00,x
	lda $B0C0,x
	sta $2F00,x
	lda $B1C0,x
	sta $3000,x
	lda $B2C0,x
	sta $3100,x
	lda $B3C0,x
	sta $3200,x
	lda $B4C0,x
	sta $3300,x
	lda $B5C0,x
	sta $3400,x
	lda $B6C0,x
	sta $3500,x
	inx
	bne copy_flm_loopz2
	rts
copy_flm_loopz2:
	jmp copy_flm_loopz1

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
.text "qqqqqqqe              PRESENTS:mqqqqqq         PRESS FIRE JOYPORT 2";
.byte 0
endtitlemsg:
	ldx #$00
putfloridamantitle:
	lda titlefloridaman,x
	sta SCREEN_MEMORY+12+360,x
	lda titlefloridamancolor,x
	sta COLOR_MEMORY+12+360,x
	lda titlefloridaman+14,x
	sta SCREEN_MEMORY+12+400,x
	lda titlefloridamancolor+14,x
	sta COLOR_MEMORY+12+400,x
	lda titlefloridaman+28,x
	sta SCREEN_MEMORY+12+440,x
	lda titlefloridamancolor+28,x
	sta COLOR_MEMORY+12+440,x
	lda titlefloridaman+42,x
	sta SCREEN_MEMORY+12+480,x
	lda titlefloridamancolor+42,x
	sta COLOR_MEMORY+12+480,x
	inx
	cpx #14
	bne putfloridamantitle
    lda #$FF
	sta SPRITE_ENABLE
	sta SPRITE_MULTICOLOR
    lda #DARK_GRAY
	sta SPRITE_MULTICOLOR_0
    lda #GRAY
	sta SPRITE_MULTICOLOR_1
    lda #$00
	sta SPRITE_MSB_X
title_loop:
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
	jsr sub_read_joystick_2
	lda var_joy_2_fire
	beq title_loop2
	rts
title_loop2:
	jmp title_loop

//////////////////////////////////////////////////////////////////////////////////////
// Subroutine: Start
//////////////////////////////////////////////////////////////////////////////////////
sub_start:
    lda #$93
    jsr KERNAL_CHROUT
main_game_loop:
	jsr sub_read_joystick_2
	jsr sub_update_hud
	jsr sub_move_player
	jmp main_game_loop
	
//////////////////////////////////////////////////////////////////////////////////////
// Subroutine: Move Player
//////////////////////////////////////////////////////////////////////////////////////
sub_move_player:
	lda #$ff
	cmp VIC_RASTER_COUNTER
	beq ok_move
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
// DEBUG STUFF
	lda var_player_x
	sta 1064
	lda var_player_y
	sta 1065
	lda var_joy_2_fire
	sta 1066
	rts
// FFUTS GUBED

	lda var_score
    cmp #$3a
    bne toscreen
    lda #$30
    sta var_score
    inc var_score+1
    lda var_score+1
    cmp #$3a
    bne toscreen
    lda #$30
    sta var_score+1
    inc var_score+2
    lda var_score+2
    cmp #$3a
    bne toscreen
    lda #$30
    sta var_score+2
    inc var_score+3
    lda var_score+3
    cmp #$3a
    bne toscreen
    lda #$30
    sta var_score+3
    inc var_score+4
    lda var_score+4
    cmp #$3a
    bne toscreen
    lda #$30
    sta var_score+4
    inc var_score+5
    lda var_score+5
    cmp #$3a
    bne toscreen
    lda #$30
    sta var_score+5
    inc var_score+6
    lda var_score+6
    cmp #$3a
    bne toscreen
    lda #$00
    sta var_score+6
toscreen:
	ldx #$00
update_loop1:
	lda upmsg,x
    beq xitupmsg
    jsr KERNAL_CHROUT
    inx
    jmp update_loop1
xitupmsg:
	ldx #$07
update_loop2:
	lda var_score,x
    jsr KERNAL_CHROUT
    dex
    cpx #$ff
    bne update_loop2
    ldx #$00
update_loop3:
	lda upmsgb,x
    beq xtupmsg
    jsr KERNAL_CHROUT
    inx
    jmp update_loop3
xtupmsg:
	lda var_lives
    clc
    adc #$30
    jsr KERNAL_CHROUT
    rts	

//////////////////////////////////////////////////////////////////////////////////////
// Subroutine: Read joystick 1
//////////////////////////////////////////////////////////////////////////////////////
sub_read_joystick_1:
	lda JOYSTICK_PORT_1
	ldx #$00
	ldy #$00
	lsr
	bcs read_joystick_1_a
	dey
read_joystick_1_a:
	lsr
	bcs read_joystick_1_b
	iny
read_joystick_1_b:
	lsr
	bcs read_joystick_1_c
	dex
read_joystick_1_c:
	lsr
	bcs read_joystick_1_d
	inx
read_joystick_1_d:
	lsr
	stx var_joy_1_x
	sty var_joy_1_y
	bcc read_joystick_1_fire
	lda #$00
	sta var_joy_1_fire
	rts
read_joystick_1_fire:
	lda #$01
	sta var_joy_1_fire
	rts

//////////////////////////////////////////////////////////////////////////////////////
// Subroutine: Read joystick 2
//////////////////////////////////////////////////////////////////////////////////////
sub_read_joystick_2:
	lda JOYSTICK_PORT_2
	ldx #$00
	ldy #$00
	lsr
	bcs read_joystick_2_a
	dey
read_joystick_2_a:
	lsr
	bcs read_joystick_2_b
	iny
read_joystick_2_b:
	lsr
	bcs read_joystick_2_c
	dex
read_joystick_2_c:
	lsr
	bcs read_joystick_2_d
	inx
read_joystick_2_d:
	lsr
	stx var_joy_2_x
	sty var_joy_2_y
	bcc read_joystick_2_fire
	lda #$00
	sta var_joy_2_fire
	rts
read_joystick_2_fire:
	lda #$01
	sta var_joy_2_fire
	rts

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
upmsgb:
.text "LIVES:"
.byte 0
message:
.text "qqqqqqq           bFLORIDA MANe.qq"
.byte 0

*=$A000 "DeadlineSprites"
.byte 1,255,128,31,255,224,63,255,248,127,131,252,207,2,204,135,3,238,7,129,54,3,129,247,3,128,183,3,192,191,1,193
.byte 111,3,225,239,3,225,223,1,227,254,1,211,254,1,221,254,1,251,252,1,247,252,3,255,248,7,255,240,127,255,192,12
.byte 0,0,0,0,0,0,1,254,0,7,255,128,15,255,192,31,255,224,59,199,224,63,1,224,124,3,224,92,3,192,88,3
.byte 194,120,7,130,112,15,6,120,126,6,63,216,28,63,240,52,29,225,248,15,255,112,15,255,224,7,255,192,1,255,0,12
.byte 0,0,0,0,255,0,7,255,192,15,255,240,30,1,120,56,0,252,96,0,126,3,254,222,31,189,255,53,199,183,127,3
.byte 251,94,1,255,94,0,255,92,0,239,122,0,127,126,0,255,55,129,175,63,199,255,31,255,191,15,255,239,3,255,7,12
.byte 0,0,31,0,0,23,0,0,63,0,0,53,1,254,125,7,255,237,15,255,255,31,231,247,31,131,253,63,0,255,63,0
.byte 251,126,0,125,126,0,109,123,0,125,127,0,125,117,192,255,63,251,255,31,255,255,15,255,227,7,255,255,0,255,143,12
.byte 1,255,0,7,159,128,7,255,128,15,127,128,7,223,128,3,55,0,0,63,128,0,63,0,0,127,0,0,254,0,0,190
.byte 0,0,252,0,0,248,0,1,248,0,1,216,0,3,184,96,3,227,208,2,254,120,3,255,240,3,255,176,1,247,192,12
.byte 0,28,0,0,127,192,0,112,64,0,127,192,0,7,0,0,0,0,0,255,0,1,230,128,3,255,128,0,255,128,0,30
.byte 128,0,63,0,0,127,0,0,250,0,1,252,0,3,232,0,3,236,0,3,255,128,3,198,192,1,253,128,0,239,0,12
.byte 0,0,0,0,31,128,28,126,224,63,255,248,126,191,52,127,226,212,111,129,204,111,0,204,119,0,252,119,0,244,103,0
.byte 244,103,0,236,103,1,200,125,1,216,121,3,176,121,7,224,123,7,192,127,15,128,127,30,0,127,28,0,62,48,0,12
