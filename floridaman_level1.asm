.segment Level1 [allowOverlap]
*=C_LEVEL_ROUTINE "LEVEL 1 ROUTINE"
    lda #$93; jsr KERNAL_CHROUT
	jmp over_level_1_message
level_1_message: .text level_list.get(1); .byte 0
over_level_1_message:
	PrintAtRainbow(10,24,level_1_message)

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


level_1_game_loop:
	jsr sub_read_joystick_2
	jsr sub_update_hud
	jsr sub_move_player
	jmp level_1_game_loop
