tool
extends Area2D

onready var sprite_2 = $Sprite2
onready var sprite = $Sprite2/Sprite
onready var glow_sprite = $BackGround/Glow
onready var card_organizer = $CardOrganizer

var card_size = Vector2( 74, 80 )
var card_rotation = 0

export(Color) var color = Color.white setget set_color
export(Texture) var texture setget set_texture
export(Constants.OperatorType) var operator_type = Constants.OperatorType.MOVE

func set_color(val):
	color = val
	if is_instance_valid(sprite_2):
		sprite_2.material.set("shader_param/ColorUniform",color)
		glow_sprite.self_modulate = color
		glow_sprite.self_modulate.s = glow_sprite.self_modulate.s - 0.2
		glow_sprite.self_modulate.v = glow_sprite.self_modulate.v + 0.2
	
func set_texture(val):
	texture = val
	if is_instance_valid(sprite) and texture != null:
		sprite.texture = texture

func get_card_scale():
	return Vector2(0.67,0.67)

func _ready():
	self.color = color
	self.texture = texture
	glow_sprite.modulate.a = 0

func glow(is_glow):
	var tween = create_tween()
	tween.tween_property(glow_sprite,"modulate:a",1.0 if is_glow else 0.0,0.2)

func recalculate_position_use_oval(c):
	return Vector2(90 + c.card_index * card_size.x,0)
	
func recalculate_rotation(c):
	return 0.0

func re_position_card(c):
	c.adapt_to_container()

func has_card():
	return not card_organizer.cards_in_hand.empty()

func is_valid_card()->String:
	if card_organizer.cards_in_hand.size() > 1:
		for index in range(card_organizer.cards_in_hand.size() - 1):
			var c = card_organizer.cards_in_hand[index]
			var c_next = card_organizer.cards_in_hand[index + 1]
			if c.card_data["special"] != "none" and \
				c_next.card_data["special"] != "none":
					return "Error! Operators can't be neighbour"
	return ""

func clear():
	card_organizer.clear()

func get_damage_info():
	var dmg_dic = {}
	var command = ""
	var opt = Constants.OperatorState.PLUS
	for index in range(card_organizer.cards_in_hand.size()):
		var c = card_organizer.cards_in_hand[index]
		if index == 0:
			match c.card_data["special"]:
				"none","plus","minus":
					opt = Constants.OperatorState.PLUS
				"multiply":
					opt = Constants.OperatorState.MULTIPLY
				"divide":
					opt = Constants.OperatorState.DIVIDE
			dmg_dic["opt"] = opt
		match c.card_data["special"]:
			"none":
				command += "(%d)" % c.card_data["number"]
			"plus":
				command += "+"
			"minus":
				command += "-"
			"multiply":
				command += "*"
			"divide":
				command += "/"
	if command.ends_with("+") or command.ends_with("-"):
		command += "0"
	elif command.ends_with("*") or command.ends_with("/"):
		command += "1"
	if command.begins_with("+") or command.begins_with("-"):
		command.substr(1,command.length() - 1)
	elif command.begins_with("*") or command.begins_with("/"):
		command.substr(1,command.length() - 1)
	print("command--",command)
	var expression = Expression.new()
	var error = expression.parse(command, [])
	if error != OK:
		print(expression.get_error_text())
		return dmg_dic
	var result = expression.execute([], null, true)
	if not expression.has_execute_failed():
		var dmg = int(result)
		if dmg < 0 and opt == "plus":
			opt = Constants.OperatorState.MINUS
			dmg = -dmg
		dmg_dic["damage"] = dmg
	print("dmg_dic--",dmg_dic)
	return dmg_dic
