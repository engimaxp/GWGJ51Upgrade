extends Node2D

class_name BoostBase

onready var animation = $AnimationTree.get("parameters/playback")
onready var cooldown_proxy = $CoolDownProxy
onready var tween = $Tween
onready var spark = $Sparkle
onready var ringSparkle = $RingSparkle
onready var sparkCircle = $SparkCircle

var life_time = 0 setget set_lifetime
var is_picked = false
var pickable_by_lr = 0 setget set_pickable_by_lr

export var is_pickable_by_side := false

func _ready():
	animation.travel("spawn")
	set_lifetime(life_time)
	if is_pickable_by_side:
		set_pickable_by_lr(pickable_by_lr)

func set_pickable_by_lr(var val):
	pickable_by_lr = val
	if is_pickable_by_side and is_inside_tree():
		var tint_color = Constants.color_side(pickable_by_lr)
		spark.process_material.color = tint_color
		ringSparkle.process_material.color = tint_color
		sparkCircle.process_material.color = tint_color
		pass

func set_lifetime(var val):
	life_time = val
	if is_instance_valid(cooldown_proxy):
		cooldown_proxy.wait_time = life_time
	else:
		return
	if life_time > 0:
		cooldown_proxy.triger_start()
		if !cooldown_proxy.is_connected("cooldown_finish",self,"life_time_end"):
			cooldown_proxy.connect("cooldown_finish",self,"life_time_end")
		if tween.is_active():
			tween.interpolate_property($SparkCircle,"amount",64,0,life_time)
			tween.start()
# override
func _picked_by(var who)->bool:
	# trigger who animate effect
	# trigger who effect
	return true

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "picked":
		self.queue_free()


func _on_PickableArea_area_entered(area):
	if is_picked:
		return
	if _picked_by(area):
		is_picked = true
		animation.travel("picked")

func life_time_end():
	if is_picked:
		return
	is_picked = true
	animation.travel("picked")
