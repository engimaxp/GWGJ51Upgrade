extends Node2D

onready var tween = $Tween

export var sprite_nodepath:NodePath
onready var sprite = get_node_or_null(sprite_nodepath)
onready var chargingParticle = $ChargingParticles
onready var ringSparkle = $RingSparkle

export var max_level = 3
var current_level = 0

func _ready():
	chargingParticle.visible = false
	ringSparkle.emitting = false
#	chargingParticle.charge()

func start_anim(var is_add):
	if is_add:
		if is_instance_valid(chargingParticle):
			chargingParticle.visible = true
			chargingParticle.charge()
	get_tree().create_timer(evolve_time,false).connect("timeout",self,"level_effect_fade",[is_add])
	if tween.is_active():
		tween.stop_all()
	if is_instance_valid(sprite):
		tween.interpolate_property(sprite,"self_modulate:r",1.0,evolve_modulate,evolve_time)
		tween.interpolate_property(sprite,"self_modulate:g",1.0,evolve_modulate,evolve_time)
		tween.interpolate_property(sprite,"self_modulate:b",1.0,evolve_modulate,evolve_time)
		tween.start()
		SoundManager.play_sound(load("res://asset/sfx/powerup.tres"))

const evolve_time = 2.0
const evolve_modulate = 3.0

func add_level()->bool:
	start_anim(true)
	return true

func level_effect_fade(var is_add):
	if is_add:
		ringSparkle.emitting = true
	chargingParticle.visible = false
	tween.interpolate_property(sprite,"self_modulate:r",evolve_modulate,1.0,evolve_time)
	tween.interpolate_property(sprite,"self_modulate:g",evolve_modulate,1.0,evolve_time)
	tween.interpolate_property(sprite,"self_modulate:b",evolve_modulate,1.0,evolve_time)
	tween.start()
