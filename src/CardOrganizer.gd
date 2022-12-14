extends Node2D

var cards_in_hand = {}
var logic_container

func _ready():
	logic_container = get_parent()

func add_card(c,state,pos):
#	print("================")
#	print("====add_card====")
#	print(c)
#	print(cards_in_hand)
	for card_exist in cards_in_hand.values():
		if card_exist == c:
			return 
	self.add_child(c)
	c.position = pos
	var index = cards_in_hand.size()
	cards_in_hand[index] = c
	c.card_index = index
	c.card_state_machine.switch_to_state(state)
#	yield(get_tree(),"idle_frame")
#	print("================")
#	print("====add_card====")
#	print(cards_in_hand)
	reorganize()

func clear():
	for ca in cards_in_hand.values():
		ca.queue_free()
	cards_in_hand.clear()

func remove_card(c):
#	print("================")
#	print("====remove_card====")
#	print(c)
#	print(cards_in_hand)
	var target_id
	for ca in cards_in_hand.keys():
		if cards_in_hand[ca] == c:
			target_id = ca
	var new_dic = {}
	for ca in cards_in_hand.keys():
		if ca > target_id:
			new_dic[ca-1] = cards_in_hand[ca]
			cards_in_hand[ca].card_index = ca - 1
		elif ca == target_id:
			continue
		else:
			new_dic[ca] = cards_in_hand[ca]
			cards_in_hand[ca].card_index = ca
	cards_in_hand = new_dic
	self.remove_child(c)
#	yield(get_tree(),"idle_frame")
#	print("================")
#	print("====remove_card====")
#	print(cards_in_hand)
	reorganize()
		
func reorganize():
	for c in cards_in_hand.values():
		logic_container.re_position_card(c)
	
func get_card(index):
	if cards_in_hand.has(index):
		return cards_in_hand[index]

func swap_card(card1,card2):
#	print("swap_happen!!!!")
	var new_d = cards_in_hand.duplicate(false)
	var temp_id = card2.card_index
	new_d[card1.card_index] = card2
	new_d[card2.card_index] = card1
	card2.card_index = card1.card_index
	card1.card_index = temp_id
	cards_in_hand = new_d

func get_card_count():
	var count = 0
	for c in get_children():
		if c is CollisionShape2D:
			continue
		else:
			count += 1
	return count
