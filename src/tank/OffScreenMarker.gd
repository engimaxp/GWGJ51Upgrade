extends Node2D

onready var sprite = $Sprite
onready var icon = $Sprite/Icon
onready var label = $Sprite/Icon/Label

#func _ready():
#	self.modulate = Color(0,0,0)

var current_level_distance:= 0 setget set_current_level_distance

func set_current_level_distance(value):
	current_level_distance = value
	label.text = "%d" % current_level_distance

func _process(_delta):
	var canvas = get_canvas_transform()
	var top_left = -canvas.origin / canvas.get_scale()
	var size = get_viewport_rect().size / canvas.get_scale() - Vector2(0,108)
	
	set_marker_position(Rect2(top_left,size))
	set_marker_rotation()
	
	if Game.current_camera && Game.current_tilemap:
	
		var player_position =  Game.current_camera.get_camera_screen_center()
		var current_distance_to_center = Game.current_tilemap.world_to_map(player_position).distance_to(\
		Game.current_tilemap.world_to_map(get_parent().global_position))
		
		set_current_level_distance(current_distance_to_center)

func set_marker_position(bounds : Rect2):
	sprite.global_position.x = clamp(global_position.x,bounds.position.x,bounds.end.x)
	sprite.global_position.y = clamp(global_position.y,bounds.position.y,bounds.end.y)
	
	if bounds.has_point(global_position):
		hide()
	else:
		show()

func set_marker_rotation():
	var angle = (global_position - sprite.global_position).angle()
	sprite.global_rotation = angle
	icon.global_rotation = 0
