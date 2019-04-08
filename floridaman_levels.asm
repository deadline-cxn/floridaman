
*=C_LEVEL_ROUTINE "DEFAULT LEVEL ROUTINE" // THIS IS A DUMMY FILLER LEVEL IN CASE LEVEL LOADING FAILS
default_game_loop:
	jsr sub_read_joystick_2
	jsr sub_update_hud
	jsr sub_move_player
	jmp default_game_loop

#import "floridaman_level0.asm"

