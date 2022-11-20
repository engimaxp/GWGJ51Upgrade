extends Node

var current_hand
var current_player
var current_tilemap
var current_camera
var draw_pile

var current_wave = 1

signal NextWave
signal OilChange(oil,max_oil)

var pause = false

func _ready():
	randomize()

func _unhandled_input(event):
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().paused = !get_tree().paused

func reset_game():
	current_wave = 1
	pause = false
	
var wave_data = {
	1: [{
		"num":2,
		"type":Constants.EnemyType.SMALL_BLUE
	}],
	2: [{
		"num":3,
		"type":Constants.EnemyType.SMALL_BLUE
	}],
}
