extends Node

var current_hand
var current_player
var current_tilemap
var current_camera
var draw_pile

var current_wave = 1

signal NextWave
signal OilChange(oil,max_oil)
signal AmmoChange(ammo,max_ammo)

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
		"num":2,
		"type":Constants.EnemyType.SMALL_BLUE
	},{
		"num":1,
		"type":Constants.EnemyType.SMALL_RED
	}],
	3: [{
		"num":2,
		"type":Constants.EnemyType.SMALL_BLUE
	},{
		"num":2,
		"type":Constants.EnemyType.SMALL_RED
	}],
	4: [{
		"num":2,
		"type":Constants.EnemyType.SMALL_BLUE
	},{
		"num":3,
		"type":Constants.EnemyType.SMALL_RED
	}],
	5: [{
		"num":4,
		"type":Constants.EnemyType.SMALL_RED
	}],
	6: [{
		"num":2,
		"type":Constants.EnemyType.SMALL_BLUE
	},{
		"num":1,
		"type":Constants.EnemyType.SMALL_GREEN
	}],
	7: [{
		"num":2,
		"type":Constants.EnemyType.SMALL_GREEN
	},{
		"num":3,
		"type":Constants.EnemyType.SMALL_RED
	}],
	8: [{
		"num":4,
		"type":Constants.EnemyType.SMALL_GREEN
	}],
	9: [{
		"num":2,
		"type":Constants.EnemyType.SMALL_GREEN
	},{
		"num":3,
		"type":Constants.EnemyType.SMALL_RED
	}],
	10: [{
		"num":2,
		"type":Constants.EnemyType.SAND
	},{
		"num":3,
		"type":Constants.EnemyType.SMALL_RED
	}],
	11: [{
		"num":2,
		"type":Constants.EnemyType.SAND
	},{
		"num":3,
		"type":Constants.EnemyType.SMALL_RED
	},{
		"num":1,
		"type":Constants.EnemyType.SMALL_DARK
	}],
	12: [{
		"num":2,
		"type":Constants.EnemyType.SMALL_DARK
	},{
		"num":3,
		"type":Constants.EnemyType.BIG_RED
	}],
	13: [{
		"num":4,
		"type":Constants.EnemyType.BIG_RED
	}],
	14: [{
		"num":3,
		"type":Constants.EnemyType.BIG_RED
	},{
		"num":3,
		"type":Constants.EnemyType.SMALL_RED
	}],
	15: [{
		"num":2,
		"type":Constants.EnemyType.SMALL_BLUE
	},{
		"num":3,
		"type":Constants.EnemyType.BIG_RED
	},{
		"num":2,
		"type":Constants.EnemyType.DARK_LARGE
	}],
}
