extends Node2D

var direction = Vector2.ZERO
var speed = 0
export var acceleration = 260
export var decceleration = 200

var motion = Vector2.ZERO
var target_motion = Vector2.ZERO
var steering = Vector2.ZERO
export var MASS = 80

export var MAX_SPEED = 400

export(NodePath) var skin_path
export(NodePath) var oil_path

onready var oilProxy = get_node_or_null(oil_path)

export(bool) var is_ai = false

signal oil_spend(amount)

var Skin = null
var target_angle = 0

func _ready():
	Skin = get_node(skin_path)

func _process(delta):
	if Game.pause:
		return
	if get_parent().is_dead:
		return
	direction = Vector2.ZERO
	if is_ai:
		if is_instance_valid(Game.current_player):
			var target = Game.current_player.player
			direction = target.global_position - Skin.global_position
	else:
		if Input.is_action_pressed("ui_up"):
			direction.y = -1
		elif Input.is_action_pressed("ui_down"):
			direction.y = 1
		if Input.is_action_pressed("ui_left"):
			direction.x = -1
		elif Input.is_action_pressed("ui_right"):
			direction.x = 1
		if direction != Vector2.ZERO:
			emit_signal("oil_spend",delta / 2.0)
	
	if oilProxy.oil <= 0:
		direction = Vector2.ZERO
		
	if direction != Vector2():
		speed += acceleration * delta
	else:
		speed -= decceleration * delta

	speed = clamp(speed, 0, MAX_SPEED)
	
	target_motion = speed * direction.normalized() * delta
	steering = target_motion - motion

	if steering.length() > 1:
		steering = steering.normalized()
	
	motion += steering / MASS

	if speed == 0:
		motion = Vector2.ZERO

func move(_motion):
	if _motion != Vector2.ZERO:
		target_angle = _motion.angle() + PI / 2.0
		Skin.rotation = target_angle
