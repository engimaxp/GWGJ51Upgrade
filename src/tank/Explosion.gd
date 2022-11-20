extends Node2D
onready var collision_shape_2d = $Area2D/CollisionShape2D
onready var area_2d = $Area2D

var explode_area = 10 setget set_explode_area
var damage = {}
var fire_to_layer = -1 setget set_fire_to_layer

func set_explode_area(val):
	explode_area = val
	if is_instance_valid(collision_shape_2d):
		collision_shape_2d.shape.radius = explode_area

func set_fire_to_layer(val):
	fire_to_layer = val
	if fire_to_layer >= 0 and is_inside_tree():
		area_2d.set_collision_mask_bit(fire_to_layer,true)
		
func _ready():
	self.explode_area = explode_area
	self.fire_to_layer = fire_to_layer

func _on_Area2D_body_entered(body):
	var bodies = area_2d.get_overlapping_bodies()
	if bodies:
		for b in bodies:
			damage["position"] = b.global_position
			b.get_parent().hit(damage)
	self.queue_free()

