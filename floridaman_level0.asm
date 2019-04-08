.segment Level1 [allowOverlap] // outPrg="c64_files/0.prg", 
*=C_LEVEL_ROUTINE "LEVEL 0 ROUTINE" // THIS IS A DUMMY FILLER
level_0_game_loop:
	jsr sub_read_joystick_2
	jsr sub_update_hud
	jsr sub_move_player
	jmp level_0_game_loop
