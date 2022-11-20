extends Node

onready var map = $TileMap
onready var player = $Players
onready var timer = $Timer
onready var draw_pile = $CanvasLayer/DrawPile
onready var wave = $CanvasLayer2/Wave

onready var move = $CanvasLayer/Control/Move
onready var attack = $CanvasLayer/Control/Attack
onready var defense = $CanvasLayer/Control/Defense
onready var enemies_spawner = $EnemiesSpawner

export(NodePath) var time_text_path
export(NodePath) var oil_text_path
export(NodePath) var confirm_button_path
export(NodePath) var error_text_path

onready var time_text = get_node(time_text_path)
onready var oil_text = get_node(oil_text_path)
onready var confirm_button = get_node(confirm_button_path)
onready var error_text = get_node(error_text_path)

func change_wave():
	wave.bbcode_text = "[center]WAVE %d[/center]" % Game.current_wave

func _ready():
	Game.connect("NextWave",self,"change_wave")
	Game.current_tilemap = map
	var map_limits = map.get_used_rect()
	var map_cellsize = map.cell_size * map.scale
	var final_limit = Rect2(map_limits.position.x * map_cellsize.x,map_limits.position.y * map_cellsize.y,\
		map_limits.size.x * map_cellsize.x,map_limits.size.y * map_cellsize.y)

	timer.connect("timeout",self,"round_timer_up")
	
	player.world_size = final_limit
	enemies_spawner.world_size = final_limit
	Game.emit_signal("NextWave")
	timer.start()
	plan_show(false)
	
	Game.connect("OilChange",self,"OilChange")

func OilChange(oil,max_oil):
	oil_text.bbcode_text = "[right]%d/%d[/right]" % [int(oil),int(max_oil)]

func round_timer_up():
	plan_show(true)
	draw_pile.draw_card(5)

func _process(delta):
	if is_instance_valid(timer):
		if timer.is_stopped():
			time_text.bbcode_text =  "[right]pause[/right]"
		else:
			time_text.bbcode_text =  "[right]%d[/right]" % int(timer.time_left)

func plan_show(is_show):
	if is_show:
		draw_pile.show()
		move.show()
		attack.show()
		defense.show()
		confirm_button.show()
		Game.pause = true
	else:
		draw_pile.hide()
		move.hide()
		attack.hide()
		defense.hide()
		confirm_button.hide()
		Game.pause = false

func _on_Confirm_pressed():
	var error_message = ""
	var move_dic = {}
	var attack_dic = {}
	var defense_dic = {}
	var blast = false
	if move.has_card():
		var e = move.is_valid_card()
		if not e.empty():
			error_message = e
		else:
			move_dic = move.get_damage_info()
			print("move----",move_dic)
	if error_message.empty() and attack.has_card():
		var e = attack.is_valid_card()
		if not e.empty():
			error_message = e
		else:
			attack_dic = attack.get_damage_info()
			print("attack----",attack_dic)
	if error_message.empty() and defense.has_card():
		var e = defense.is_valid_card()
		if not e.empty():
			error_message = e
		else:
			defense_dic = defense.get_damage_info()
			print("defense----",defense_dic)
	if error_message.empty():
		error_text.bbcode_text = ""
		if not move_dic.empty():
			player.resupply(move_dic)
			if move_dic["damage"] == 24:
				blast = true
			move.clear()
		if not attack_dic.empty():
			player.reload(attack_dic)
			if attack_dic["damage"] == 24:
				blast = true
			attack.clear()
		if not defense_dic.empty():
			player.repair(defense_dic)
			if defense_dic["damage"] == 24:
				blast = true
			defense.clear()
		if blast:
			SubPub.publish(SubPub.total_blast)
			player.reload({"damage":100,"opt":Constants.OperatorState.PLUS})
			player.repair({"damage":1000,"opt":Constants.OperatorState.PLUS})
			player.resupply({"damage":1000,"opt":Constants.OperatorState.PLUS})
		plan_show(false)
		timer.start()
	else:
		error_text.bbcode_text = "[right]%s[/right]" % error_message
