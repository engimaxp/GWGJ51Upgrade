extends Node2D

onready var base = $KinematicBody2D/Base
onready var barrel = $KinematicBody2D/Base/Turrent/Barrel1

onready var player = $"KinematicBody2D"
onready var movement = $Movement
onready var turrent = $KinematicBody2D/Base/Turrent
onready var fire_proxy = $KinematicBody2D/Base/Turrent/FireProxy
onready var health_proxy = $HealthProxy
onready var animation = $AnimationTree.get("parameters/playback")
onready var collision_shape_2d = $KinematicBody2D/CollisionShape2D
onready var off_screen_marker = $KinematicBody2D/OffScreenMarker

export var world_size := Rect2(0,0,0,0) setget set_world_size

const sprite_region_size = 80
export var health_data = {}
export var damage_data = {}

var is_dead = false

export(Texture) var base_img
export(Texture) var turrent_img

func _ready():
	health_proxy.max_health = health_data["max_health"]
	health_proxy.health = health_data["health"]
	base.texture = base_img
	barrel.texture = turrent_img
	fire_proxy.damage = damage_data if not damage_data.empty() else \
		{"damage":10,"opt":Constants.OperatorState.PLUS}
	SubPub.subscribe(SubPub.total_blast,self,funcref(self,"die"))
	
func set_world_size(val):
	world_size = val
	
func bound_in_edge():
	if world_size != Rect2(0,0,0,0):
		player.position.x = clamp(player.position.x, world_size.position.x + sprite_region_size, world_size.end.x - sprite_region_size)
		player.position.y = clamp(player.position.y, world_size.position.y + sprite_region_size, world_size.end.y - sprite_region_size)

func _process(delta):
	bound_in_edge()
	movement.move(movement.motion)
	health_proxy.position = player.position
	if Game.pause:
		return
	turrent.global_rotation = (Game.current_player.player.global_position - player.global_position).angle() + PI/2.0
	
func _physics_process(delta):
	if Game.pause:
		return
	if is_dead:
		return
	if movement.motion.distance_squared_to(Vector2.ZERO) > 1e-3:
		player.move_and_collide(movement.motion)

func hit(damage):
	print("enemy hit %s" % damage)
	health_proxy.hurt(damage)

func die():
	if is_dead:
		return
	health_proxy.chain_explode(sprite_region_size)
#	print("die")
	is_dead = true
	collision_shape_2d.set_deferred("disabled",true)
	off_screen_marker.modulate.a = 0
	fire_proxy.fire_lock = true
	animation.travel("die")
	yield(get_tree().create_timer(1.0),"timeout")
	_on_AnimationPlayer_animation_finished("die")

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "die":
		print("die")
		health_proxy.final_big_explode(get_parent())
		yield(get_tree().create_timer(3.0),"timeout")
		SubPub.publish(SubPub.enemy_down)
		self.queue_free()

func spawn_boost():
	var b = preload("res://src/tank/CardBoost.tscn").instance()
	b.life_time = 600
	b.global_position = player.global_position
	get_tree().current_scene.call_deferred("add_child",b)
