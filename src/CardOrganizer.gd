extends Node2D

var cards_in_hand = {}
var logic_container

func _ready():
	logic_container = get_parent()

func add_card(c):
	self.add_child(c)
	cards_in_hand[cards_in_hand.size()] = c
	c.card_index = cards_in_hand.size() - 1
	c.card_state_machine.switch_to_state(Constants.CardState.IN_HAND)
	yield(get_tree(),"idle_frame")
	reorganize()

func remove_card(c):
	var target_id
	for ca in cards_in_hand.keys():
		if cards_in_hand[ca] == c:
			cards_in_hand.erase(ca)
			target_id = c.card_index
	var new_dic = {}
	for ca in cards_in_hand.keys():
		if ca > target_id:
			new_dic[ca-1] = cards_in_hand[ca]
			cards_in_hand[ca].card_index = ca - 1
		else:
			new_dic[ca] = cards_in_hand[ca]
			cards_in_hand[ca].card_index = ca
	cards_in_hand = new_dic
	yield(get_tree(),"idle_frame")
	reorganize()
		
func reorganize():
	for c in cards_in_hand.values():
		logic_container.re_position_card(c)
	
func get_card(index):
	if cards_in_hand.has(index):
		return cards_in_hand[index]

func swap_card(card1,card2):
	var new_d = cards_in_hand.duplicate(false)
	new_d[card1.card_index] = card2
	new_d[card2.card_index] = card1
	cards_in_hand = new_d

func get_card_count():
	var count = 0
	for c in get_children():
		if c is CollisionShape2D:
			continue
		else:
			count += 1
	return count
