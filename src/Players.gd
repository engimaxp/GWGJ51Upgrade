extends Node2D
onready var player = $Player
onready var cam = $Player/Camera2D
onready var movement = $Movement
onready var oil_proxy = $OilProxy
onready var fire_proxy = $Player/Base/Turrent/FireProxy
onready var health_proxy = $HealthProxy
onready var animation = $AnimationTree.get("parameters/playback")
onready var collision_shape_2d = $Player/CollisionShape2D
onready var boost_collector = $BoostCollector

onready var turrent = $Player/Base/Turrent
var is_dead = false
export(Array,NodePath) var tiles_paths

const sprite_region_size = 180

export var world_size := Rect2(0,0,0,0) setget set_world_size

func _ready():
	Game.current_camera = cam
	Game.current_player = self
	movement.connect("oil_spend",oil_proxy,"oil_spend")
	fire_proxy.can_fire = false

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
	health_proxy.position = player.position
	boost_collector.position = player.position
	bound_in_edge()
	movement.move(movement.motion)
	
	if Game.pause:
		return
	turrent.global_rotation = (get_global_mouse_position() - turrent.global_position).angle() + PI/2.0
	if Input.is_mouse_button_pressed(BUTTON_LEFT):
		fire_proxy.fire_bullet()
	
	if movement.motion.distance_squared_to(Vector2.ZERO) > 1e-3:
		for t in tiles_paths:
			var tile = get_node(t)
			tile.material.set("shader_param/moving",true)
	else:
		for t in tiles_paths:
			var tile = get_node(t)
			tile.material.set("shader_param/moving",false)
	
func _physics_process(delta):
	if Game.pause:
		return
	if is_dead:
		return
	if movement.motion.distance_squared_to(Vector2.ZERO) > 1e-3:
		player.move_and_collide(movement.motion)

func hit(damage):
	print("player hit %s" % damage)
	health_proxy.hurt(damage)

func die():
	if is_dead:
		return
	health_proxy.chain_explode(sprite_region_size)
#	print("die")
	is_dead = true
	collision_shape_2d.set_deferred("disabled",true)
	fire_proxy.fire_lock = true
	_on_AnimationPlayer_animation_finished("die")

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "die":
		print("die")
		health_proxy.final_big_explode(get_parent())
		yield(get_tree().create_timer(3.0),"timeout")
		get_tree().reload_current_scene()
#		self.queue_free()

func resupply(op_dic):
	oil_proxy.resupply(op_dic)

func repair(op_dic):
	health_proxy.repair(op_dic)
	
func reload(op_dic):
	fire_proxy.damage = op_dic
	fire_proxy.can_fire = true
	
