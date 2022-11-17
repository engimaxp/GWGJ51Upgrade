extends CardStateBase

func entered():
	card.scale = Vector2.ZERO
	card.modulate.a = 0
	state_machine.set_monitoring(false)
	state_machine.set_mouse_listener(false)

func exited():
	pass

func click(event):
	pass
	
func mouse_enter_leave(is_enter):
	pass
func area_entered_exited(area,is_enter):
	pass
