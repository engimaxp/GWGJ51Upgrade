extends CardStateBase

func entered():
	var a1 = card.set_focus(true)
	if a1 is GDScriptFunctionState:
		yield(a1,"completed")

func card_hover(c):
	if card != c:
		state_machine.switch_to_state(Constants.CardState.IN_CONTAINER)

func exited():
	pass

func click(event):
	if event.pressed:
		state_machine.switch_to_state(Constants.CardState.DRAGGED_IN_CONTAINER)
	
func mouse_enter_leave(is_enter):
	if not is_enter:
		state_machine.switch_to_state(Constants.CardState.IN_CONTAINER)
	
func area_entered_exited(area,is_enter):
	pass
