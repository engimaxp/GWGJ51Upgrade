extends Node2D

onready var glow = $Glow
onready var card = $Card
onready var card_state_machine = $CardStateMachine

signal focused(is_focus)

export var card_index = -1
var current_tween

func _ready():
	pass

func show_card(is_show):
	var time_elapsed = 0.2
	var tween = create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	if is_show:
		tween.tween_property(self,"modulate:a",1.0,time_elapsed)
		tween.tween_property(self,"scale",Vector2.ONE,time_elapsed)
	else:
		tween.tween_property(self,"modulate:a",0.0,time_elapsed)
		tween.tween_property(self,"scale",Vector2.ZERO,time_elapsed)
	yield(tween,"finished")
	
func flip_card(is_flip):
	var time_elapsed = 0.8
	var tween = create_tween()
	tween.tween_property(card.material,"shader_param/Angle",\
		0.0 if is_flip else 180.0,time_elapsed)\
		.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)

func get_neighbour(neighbour_dir):
	if not get_parent().has_method("get_card"):
		return null
	if neighbour_dir == 1:
		return get_parent().get_card(card_index + 1)
	else:
		return get_parent().get_card(card_index - 1)
		
func change_index(index,need_repos):
	card_index = index
	if need_repos and "logic_container" in get_parent():
		var time_elapsed = 0.2
		var logic_container = get_parent().logic_container
		self.z_index = 5 + card_index
		var tween = check_tween()
		self.z_index = 0
		tween.parallel().tween_property(self,"scale",Vector2(1.0,1.0),time_elapsed)
		tween.parallel().tween_property(self,"position",logic_container.recalculate_position_use_oval(self),time_elapsed)
		tween.parallel().tween_property(self,"rotation_degrees",logic_container.recalculate_rotation(self),time_elapsed)
		yield(tween,"finished")

# Changes card focus (highlighted and put on the focus viewport)
func set_focus(requestedFocus: bool, color := Constants.FOCUS_HOVER_COLOR) -> void:
	var time_elapsed = 0.2
	if requestedFocus:
		if glow.self_modulate.a == 1.0:
			return
		var tween = create_tween()
		glow.modulate = color
		tween.tween_property(glow,"self_modulate:a",1.0,time_elapsed)
		yield(tween,"finished")
	else:
		if glow.self_modulate.a == 0.0:
			return
		var tween = create_tween()
		glow.modulate = color
		tween.tween_property(glow,"self_modulate:a",0.0,time_elapsed)
		yield(tween,"finished")
	emit_signal("focused",requestedFocus)

func check_tween():
	if is_instance_valid(current_tween) and current_tween.is_running():
		current_tween.stop()
	current_tween = create_tween()
	return current_tween
	
func hover_up(is_hover,no_rotation = false):
	var time_elapsed = 0.2
	if is_hover:
		var tween = check_tween()
		self.z_index = 20
		tween.parallel().tween_property(self,"rotation_degrees",0.0,time_elapsed)
		tween.parallel().tween_property(self,"scale",Vector2(2.0,2.0),time_elapsed)
		tween.parallel().tween_property(self,"position",self.position + Vector2(0,-180),time_elapsed)
		yield(tween,"finished")
	else:
		self.z_index = 5 + card_index
		var tween = check_tween()
		tween.parallel().tween_property(self,"scale",Vector2(1.0,1.0),time_elapsed)
		if "logic_container" in get_parent():
			var logic_container = get_parent().logic_container
			tween.parallel().tween_property(self,"position", \
				logic_container.recalculate_position_use_oval(self),time_elapsed)
			if not no_rotation:
				tween.parallel().tween_property(self,"rotation_degrees",
					logic_container.recalculate_rotation(self),time_elapsed)
		else:
			tween.parallel().tween_property(self,"position", \
				Vector2.ZERO,time_elapsed)
			if not no_rotation:
				tween.parallel().tween_property(self,"rotation_degrees",
					0.0,time_elapsed)
		yield(tween,"finished")
			
		
