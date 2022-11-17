extends CardStateBase

func entered():
	SubPub.subscribe(SubPub.card_hover,self,funcref(self,"card_hover"))
	var a1 = card.set_focus(true)
	var a2 = card.hover_up(true)
	for a in [a1,a2]:
		if a is GDScriptFunctionState:
			yield(a,"completed")

func card_hover(c):
	if card != c:
		state_machine.switch_to_state(Constants.CardState.IN_HAND)

func exited():
	pass

func click(event):
	if event.pressed:
		state_machine.switch_to_state(Constants.CardState.DRAGGED)
	pass
	
func mouse_enter_leave(is_enter):
	if not is_enter:
		state_machine.switch_to_state(Constants.CardState.IN_HAND)
	
func area_entered_exited(area,is_enter):
	pass
