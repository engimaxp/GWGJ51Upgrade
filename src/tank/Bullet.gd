extends KinematicBody2D

var fire_to_layer = -1 setget set_fire_to_layer

const EXPLOSION = preload("res://src/tank/Explosion.tscn")
var explode = false
var speed = 1000
var damage = {}

func set_fire_to_layer(val):
	fire_to_layer = val
	if fire_to_layer >= 0 and is_inside_tree():
		self.set_collision_mask_bit(fire_to_layer,true)
		
func _ready():
	self.fire_to_layer = fire_to_layer

func _on_Timer_timeout():
	self.queue_free()
	pass # Replace with function body.

func _physics_process(delta):
	if Game.pause:
		return
	var c = move_and_collide(Vector2.RIGHT.rotated(self.rotation - PI/2.0) * speed * delta)
	if c:
		if explode:
			create_explosion(c.position)
			self.queue_free()
		else:
			damage["position"] = c.position
			c.collider.get_parent().hit(damage)
			self.queue_free()

func create_explosion(pos):
	var blast = EXPLOSION.instance()
	blast.global_position = pos
	blast.fire_to_layer = fire_to_layer
	blast.damage = damage
	blast.explode_area = 50
	get_tree().current_scene.add_child(blast)
