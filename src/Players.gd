extends Node2D
onready var player = $Player
onready var cam = $Player/Camera2D

var speed = 300
var current_speed = Vector2.ZERO

const sprite_region_size = 32

export var world_size := Rect2(0,0,0,0) setget set_world_size

func set_world_size(val):
	world_size = val
	if is_instance_valid(cam) and world_size.size != Vector2.ZERO:
		cam.limit_left = world_size.position.x
		cam.limit_right = world_size.end.x
		cam.limit_top = world_size.position.y
		cam.limit_bottom = world_size.end.y
	
func bound_in_edge():
	if world_size != Rect2(0,0,0,0):
		player.position.x = clamp(player.position.x, world_size.position.x + sprite_region_size, world_size.end.x - sprite_region_size)
		player.position.y = clamp(player.position.y, world_size.position.y + sprite_region_size, world_size.end.y - sprite_region_size)

func _process(delta):
	var dir = Vector2.ZERO
	if Input.is_action_pressed("ui_up"):
		dir.y = -1
	if Input.is_action_pressed("ui_down"):
		dir.y = 1
	if Input.is_action_pressed("ui_left"):
		dir.x = -1
	if Input.is_action_pressed("ui_right"):
		dir.x = 1
	current_speed = dir * speed
	bound_in_edge()
	
func _physics_process(delta):
	if current_speed.distance_squared_to(Vector2.ZERO) > 1e-3:
		player.move_and_collide(current_speed * delta)
