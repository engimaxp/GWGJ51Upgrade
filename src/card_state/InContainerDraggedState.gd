extends CardStateBase

var started_pos = Vector2.ZERO
var start_drag_position = Vector2.ZERO
var in_hand_area = false
var lock_swap_state = false

var current_over_containers = []
var current_container

func entered():
	started_pos = card.global_position
	state_machine.set_monitoring(true)
	state_machine.set_mouse_listener(true)
	var aw = card.adapt_to_container()
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
				Constants.CardState.FOCUSED_IN_HAND,Constants.CardState.IN_HAND,_:
					var original_postion = card.global_position
					card.get_parent().remove_card(card)
					Game.current_hand.card_organizer.add_card(card,\
						Constants.CardState.IN_HAND,Game.current_hand.to_local(original_postion))
		elif is_instance_valid(current_container) and \
					current_container != card.get_parent().logic_container:
			var original_postion = card.global_position
			card.get_parent().remove_card(card)
			current_container.card_organizer.add_card(card,Constants.CardState.IN_CONTAINER\
				,current_container.to_local(original_postion))
		else:
			state_machine.switch_to_state(Constants.CardState.IN_CONTAINER)

func click_move(event):
	if start_drag_position == Vector2.ZERO:
		start_drag_position = event.position
	card.translate(event.position - start_drag_position)
	if current_container == card.get_parent().logic_container and not lock_swap_state:
		var n_position = card.global_position
#		var n_position = started_pos + event.position - start_drag_position
		var lcard = card.get_neighbour(-1)
		var rcard = card.get_neighbour(1)
		var ci = card.card_index
		if is_instance_valid(lcard):
			var l_neighbour_pos = lcard.global_position
			if n_position.x < l_neighbour_pos.x:
				lock_swap_state = true
				card.get_parent().swap_card(lcard,card)
				card.change_index(lcard.card_index,false)
				var aw = lcard.change_index(ci,true)
				if aw is GDScriptFunctionState:
					yield(aw,"completed")
				lock_swap_state = false
		if is_instance_valid(rcard):
			var r_neighbour_pos = rcard.global_position
			if n_position.x > r_neighbour_pos.x:
				lock_swap_state = true
				card.get_parent().swap_card(rcard,card)
				card.change_index(rcard.card_index,false)
				var aw = rcard.change_index(ci,true)
				if aw is GDScriptFunctionState:
					yield(aw,"completed")
				lock_swap_state = false
		
func mouse_enter_leave(is_enter):
	if is_enter:
		state_machine.switch_to_state(Constants.CardState.FOCUSED_IN_CONTAINER)
	
func area_entered_exited(area,is_enter):
	if "is_hand" in area:
		in_hand_area = is_enter
		print("area_entered_exited " + str(in_hand_area))
	
	if area.has_method("glow"):
		if is_enter:
			if is_instance_valid(current_container) and current_container != area:
				current_container.glow(false)
			current_container = area
			current_over_containers.append(current_container)
			current_container.glow(true)
		else:
			current_container.glow(false)
			if not current_over_containers.empty():
				for a in range(current_over_containers.size() - 1,-1,-1):
					if current_over_containers[a] == area:
						current_over_containers[a].glow(false)
						current_over_containers.remove(a)
				if not current_over_containers.empty():
					current_container = current_over_containers[current_over_containers.size() - 1]
					current_container.glow(true)
#		print(current_over_containers)
#		print(current_container)
