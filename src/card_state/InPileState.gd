extends CardStateBase

func entered():
	card.scale = Vector2.ZERO
	card.modulate.a = 0
	state_machine.set_monitoring(false)
	state_machine.set_mouse_listener(false)

func exited():
	var x = card.show_card(true)
	var y = card.flip_card(true)
	for xx in [x,y]:
		if xx is GDScriptFunctionState:
			yield(xx,"completed")

func click(event):
	pass
	
func mouse_enter_leave(is_enter):
	pass
	
func area_entered_exited(area,is_enter):
	pass
