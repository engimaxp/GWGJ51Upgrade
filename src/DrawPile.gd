extends MarginContainer

onready var rich_text_label = $PanelContainer/MarginContainer/PanelContainer/RichTextLabel
onready var y_sort = $PanelContainer/YSort
onready var draw_timer = $PanelContainer/Timer

var current_cards = []
const CARD = preload("res://src/Card.tscn")

const draw_text = "[center]%s[/center]"

var stack_cards = 0
var is_drawing = false

func _ready():
	Game.draw_pile = self
	initial_cards()

func draw_card(num):
	if is_drawing or stack_cards > 0:
		stack_cards += num
	elif current_cards.size() < num:
		stack_cards += num - current_cards.size()
		num = current_cards.size()
	else:
		for i in num:
			var c = current_cards.pop_front()
			var original_position = c.global_position
			y_sort.remove_child(c)
			Game.current_hand.card_organizer.add_card(c,Constants.CardState.IN_HAND,\
				Game.current_hand.to_local(original_position))
			rich_text_label.bbcode_text = draw_text % str(current_cards.size())
			draw_timer.start()
			yield(draw_timer,"timeout")
	
	if not is_drawing:
		if current_cards.size() <= 0:
			is_drawing = true
			var aw = initial_cards()
			if aw is GDScriptFunctionState:
				yield(aw,"completed")
			is_drawing = false
			if stack_cards > 0:
				var n = stack_cards
				stack_cards = 0
				draw_card(n)

#func _unhandled_input(event):
#	if Input.is_action_just_pressed("ui_accept"):
#		var a = draw_card(3)
#		if a is GDScriptFunctionState:
#			yield(a,"completed")
#		if current_cards.size() <= 0:
#			initial_cards()
		
func initial_cards():
	var cards = []
	for x in Constants.card_display_dic.keys():
		for y in Constants.card_display_dic[x].keys():
			if x == Constants.CardFace.SPECIAL and \
				Constants.card_display_dic[x][y].special != "upgrade":
				for i in 4:
					cards.append(Constants.card_display_dic[x][y])
			else:
				cards.append(Constants.card_display_dic[x][y])
	cards.shuffle()
	cards.insert(0,Constants.card_display_dic\
		[Constants.CardFace.SPECIAL][Constants.CardNumber.UPGRADE])
	var index = 0
	for x in cards:
		var card = CARD.instance()
		if x["special"]!="none":
			if x["special"] == "upgrade":
				x["color"] = Color.gold
			else:
				x["color"] = Color("#00C3F3")
		else:
			x["color"] = Color.white
		card.card_data = x
		y_sort.add_child(card)
		card.card_index = index
		card.card_state_machine.switch_to_state(Constants.CardState.IN_PILE)
		current_cards.append(card)
		rich_text_label.bbcode_text = draw_text % str(current_cards.size())
		draw_timer.start()
		index += 1
		yield(draw_timer,"timeout")
