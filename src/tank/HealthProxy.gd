extends Node2D

onready var cooldown_proxy = $CoolDownProxy

export var animation_tree_nodepath:NodePath

onready var animation = get_node(animation_tree_nodepath).get("parameters/playback")
onready var explosion = $Explosion
onready var healthParticle = $HealingEffect

export var max_health = 24
export var health = 24 setget set_health
export(float) var hurt_cool_down_time = 6.0

onready var shield = $Shield
onready var health_left = $Shield/HealthLeft

export (Color)var shield_color = Color("3a88da")

func set_health(val):
	health = val
	if is_instance_valid(shield) and is_instance_valid(health_left):
		shield.material.set("shader_param/range",1.0 - (clamp(health,0,max_health) / float(max_health)))
		health_left.bbcode_text = "[center]%d[/center]" % health

func _ready():
	self.health = health
	healthParticle.emitting = false
	set_hurt_cool_down_time(hurt_cool_down_time)
	$Shield.self_modulate = shield_color
	var f = $Shield/HealthLeft.get("custom_fonts/normal_font")
	var n_color = shield_color
	n_color.s += 0.2
	n_color.v -= 0.2
	f.outline_color = n_color

#func _process(delta):
#	if is_instance_valid($Shield/HealthLeft):
#		$Shield/HealthLeft.rect_global_position = self.global_position - Vector2(50,0)

func set_hurt_cool_down_time(var val):
	hurt_cool_down_time = val
	if is_inside_tree():
		cooldown_proxy.wait_time = hurt_cool_down_time

func spawn_explode(var sprite_region_size):
	var p = Vector2(randf() * 2 - 1,randf() * 2 - 1)
	p *= sprite_region_size / 4.0
	var e = preload("res://src/tank/vfx/Explosion.tscn").instance()
	e.scale = Vector2(0.04,0.04)
	e.translate(p)
	add_child(e)
	e.explode_loop()

func chain_explode(var sprite_region_size):
	for i in range(5):
		var t = get_tree().create_timer((i+1) * rand_range(0.2,0.4),false)
		t.connect("timeout",self,"spawn_explode",[sprite_region_size])

func final_big_explode(var world):
	var e = preload("res://src/tank/vfx/Explosion.tscn").instance()
	e.scale = Vector2(0.8,0.8)
	e.global_position = self.global_position
	world.add_child(e)
	e.explode_queue_free()

#func _process(delta):
#	healthParticle.global_rotation = 0

func hurt(var hurt_dictionary)->bool:
	if !cooldown_proxy.triger_start():
		return false
	if hurt_dictionary.has("position"):
		explosion.position = to_local(hurt_dictionary["position"])
		explosion.explode()
	animation.travel("hurt")
	var damage = 1
	if hurt_dictionary.has("damage"):
		damage = hurt_dictionary["damage"]
	match hurt_dictionary["opt"]:
		Constants.OperatorState.MINUS:
			add_health(hurt_dictionary["damage"])
			return true
		Constants.OperatorState.PLUS:
			self.health -= damage
		Constants.OperatorState.MULTIPLY:
			add_health(health * damage - health)
		Constants.OperatorState.DIVIDE:
			self.health -= int(health / damage)
	if health <= 5:
		explosion.smoke(true)
	update_health_bar(hurt_dictionary)
	if health <= 0:
		if get_parent().has_method("spawn_boost"):
			get_parent().spawn_boost()
			print("spawn_boost")
			yield(get_tree(),"idle_frame")
			yield(get_tree(),"idle_frame")
			yield(get_tree(),"idle_frame")
		get_parent().die()
	return true

func update_health_bar(var hurt_dictionary):
	var h_dic = {"method":"health","param":{"health":health}}
	if hurt_dictionary.has("trauma"):
		h_dic["param"]["trauma"] = hurt_dictionary["trauma"]

func add_health(number):
	if number + health > max_health:
		number = max_health - health
	self.health += number
	if health > 5:
		explosion.smoke(false)
	healthParticle.emitting = true
	get_tree().create_timer(1.0).connect("timeout",self,"health_effect_fade")
	update_health_bar({})

func health_effect_fade():
	healthParticle.emitting = false

func cooldown_complete():
	animation.travel("RESET")

func repair(var hurt_dictionary)->bool:
	var damage = 1
	if hurt_dictionary.has("damage"):
		damage = hurt_dictionary["damage"]
	match hurt_dictionary["opt"]:
		Constants.OperatorState.PLUS:
			add_health(hurt_dictionary["damage"])
			return true
		Constants.OperatorState.MINUS:
			self.health -= damage
		Constants.OperatorState.MULTIPLY:
			add_health(health * damage - health)
		Constants.OperatorState.DIVIDE:
			self.health -= int(health / damage)
	if health <= 5:
		explosion.smoke(true)
	update_health_bar(hurt_dictionary)
	if health <= 0:
		get_parent().die()
	return true
