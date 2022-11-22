extends Node2D

onready var start_point = $StartPoint
export var fire_to_layer = 5
const BULLET = preload("res://src/tank/Bullet.tscn")
onready var timer = get_node_or_null("Timer")
var damage = {}
var can_fire = false setget set_can_fire
export var fire_lock = false
export (bool)var explode = false
export (int)var speed = 1000
var fire_amount = 0
export var current_fire_ammo_amount = 100
export var is_enemy = false

func set_can_fire(val):
	can_fire = val
	if can_fire:
		fire_amount = current_fire_ammo_amount
	if not is_enemy:
		if not can_fire:
			Game.emit_signal("AmmoChange",0,current_fire_ammo_amount)
		else:
			Game.emit_signal("AmmoChange",fire_amount,current_fire_ammo_amount)

func fire_bullet():
	if fire_lock:
		return
	if not can_fire:
		return
	if fire_amount <= 0:
		return
	if is_instance_valid(timer):
		can_fire = false
	var bullet = BULLET.instance()
	bullet.global_rotation = self.global_rotation
	bullet.global_position = start_point.global_position
	bullet.damage = damage
	bullet.speed = speed
	bullet.explode = explode
	bullet.fire_to_layer = fire_to_layer
	get_tree().current_scene.add_child(bullet)
	fire_amount -= 1
	if not is_enemy:
		Game.emit_signal("AmmoChange",fire_amount,current_fire_ammo_amount)
	if is_instance_valid(timer):
		if is_enemy:
			timer.wait_time = rand_range(6,20)
		timer.start()

func _ready():
	if is_instance_valid(timer) and is_enemy:
		timer.wait_time = rand_range(5,20)
		timer.start()
		fire_amount = current_fire_ammo_amount
	timer.connect("timeout",self,"reloaded")

func reloaded():
	can_fire = true
	if is_enemy:
		fire_bullet()
