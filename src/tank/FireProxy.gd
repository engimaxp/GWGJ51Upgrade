extends Node2D

onready var start_point = $StartPoint
export var fire_to_layer = 5
const BULLET = preload("res://src/tank/Bullet.tscn")
onready var timer = get_node_or_null("Timer")
var damage = {}
var can_fire = false
export var fire_lock = false
export (bool)var explode = false

func fire_bullet():
	if fire_lock:
		return
	if not can_fire:
		return
	can_fire = false
	var bullet = BULLET.instance()
	bullet.global_rotation = self.global_rotation
	bullet.global_position = start_point.global_position
	bullet.damage = damage
	bullet.explode = explode
	bullet.fire_to_layer = fire_to_layer
	get_tree().current_scene.add_child(bullet)
	if is_instance_valid(timer):
		timer.start()
		timer.wait_time = rand_range(10,20)

func _ready():
	if is_instance_valid(timer):
		timer.start()
		timer.wait_time = rand_range(10,20)
		timer.connect("timeout",self,"reloaded")

func reloaded():
	can_fire = true
	fire_bullet()
