extends Node2D

onready var animation = $AnimationPlayer
onready var smokeParticle = $SmokeParticles2D
onready var hurtSound = $HurtSound

var is_smoking = false

func _ready():
	pass
	
func explode():
	animation.play("Explode")
	
func explode_loop():
	animation.play("Explode_loop")
	
func explode_queue_free():
	animation.play("Explode_queue_free")

func smoke(var fire_smoke):
	is_smoking = fire_smoke
	smokeParticle.emitting = fire_smoke

func _on_AnimationPlayer_animation_finished(anim_name):
	if is_smoking:
		smokeParticle.emitting = true
