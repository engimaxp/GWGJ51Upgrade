extends CardStateBase

var started_pos = Vector2.ZERO
var start_drag_position = Vector2.ZERO
var in_hand_area = true
var lock_swap_state = false

func entered():
	started_pos = card.global_position
	state_machine.set_monitoring(true)
	state_machine.set_mouse_listener(true)
	var aw = card.hover_up(false,true)
	if aw is GDScriptFunctionState:
		yield(aw,"completed")
	
func exited():
	state_machine.set_monitoring(false)
	state_machine.set_mouse_listener(false)
	pass

func click(event):
	if not event.pressed:
		if in_hand_area:
			match last_state:
				Constants.CardState.FOCUSED_IN_HAND,Constants.CardState.IN_HAND:
					state_machine.switch_to_state(Constants.CardState.IN_HAND)
				_:
					state_machine.switch_to_state(Constants.CardState.IN_HAND)
		else:
			state_machine.switch_to_state(Constants.CardState.DESTORY)

func click_move(event):
	if start_drag_position == Vector2.ZERO:
		start_drag_position = event.position
	card.translate(event.position - start_drag_position)
	if in_hand_area and not lock_swap_state:
		var n_position = card.global_position
#		var n_position = started_pos + event.position - start_drag_position
		var lcard = card.get_neighbour(-1)
		var rcard = card.get_neighbour(1)
		var ci = card.card_index
		if is_instance_valid(lcard):
			var l_neighbour_pos = lcard.global_position
			if n_position.x < l_neighbour_pos.x:
				lock_swap_state = true
				Game.current_hand.card_organizer.swap_card(lcard,card)
				card.change_index(lcard.card_index,false)
				var aw = lcard.change_index(ci,true)
				if aw is GDScriptFunctionState:
					yield(aw,"completed")
				lock_swap_state = false
		if is_instance_valid(rcard):
			var r_neighbour_pos = rcard.global_position
			if n_position.x > r_neighbour_pos.x:
				lock_swap_state = true
				Game.current_hand.card_organizer.swap_card(rcard,card)
				card.change_index(rcard.card_index,false)
				var aw = rcard.change_index(ci,true)
				if aw is GDScriptFunctionState:
					yield(aw,"completed")
				lock_swap_state = false
		
func mouse_enter_leave(is_enter):
	if is_enter:
		state_machine.switch_to_state(Constants.CardState.FOCUSED_IN_HAND)
	
func area_entered_exited(area,is_enter):
	if "is_hand" in area:
		in_hand_area = is_enter
		print("area_entered_exited " + str(in_hand_area))
	pass
