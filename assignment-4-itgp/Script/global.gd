extends Node

var player_current_attack = false 

var current_scene = "world" #world Dungeon 
var transition_scene = false	 

var player_exit_dungeon_posx = 0
var player_exit_dungeon_posy = 0
var player_start_posx = 0
var player_start_posy = 0 
	
func finish_changescenes():
		if transition_scene == true:
			transition_scene = false
			if current_scene == "world":
				current_scene = "dungeon"
			else: current_scene = "world"
	
func process(delta):
	if $AudioStreamPlayer2D.playing == false:
		$AudioStreamPlayer2D.play() 
	pass
