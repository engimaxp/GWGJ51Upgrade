extends MarginContainer

onready var rich_text_label = $PanelContainer/MarginContainer/PanelContainer/RichTextLabel
onready var y_sort = $PanelContainer/YSort
onready var draw_timer = $PanelContainer/Timer

var current_cards = []
const CARD = preload("res://src/Card.tscn")

const draw_text = "[center]%s[/center]"

func _ready():
	initial_cards()

func draw_card(num):
	for i in num:
		if current_cards.size() <= 0:
			return
		var c = current_cards.pop_front()
		var original_position = c.global_position
		y_sort.remove_child(c)
		Game.current_hand.card_organizer.add_card(c)
		c.global_position = original_position
		rich_text_label.bbcode_text = draw_text % str(current_cards.size())
		draw_timer.start()
		yield(draw_timer,"timeout")

func _unhandled_input(event):
	if Input.is_action_just_pressed("ui_accept"):
		var a = draw_card(3)
		if a is GDScriptFunctionState:
			yield(a,"completed")
		if current_cards.size() <= 0:
			initial_cards()
		
func initial_cards():
	for i in range(20):
		var card = CARD.instance()
		y_sort.add_child(card)
		card.card_index = i
		card.card_state_machine.switch_to_state(Constants.CardState.IN_PILE)
		current_cards.append(card)
		rich_text_label.bbcode_text = draw_text % str(current_cards.size())
		draw_timer.start()
		yield(draw_timer,"timeout")
