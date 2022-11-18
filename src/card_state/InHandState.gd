extends CardStateBase

var lock_state = false

func entered():
	if last_state == Constants.CardState.DRAGGED:
		lock_state = true
		var t = Timer.new()
		card.add_child(t)
		t.one_shot = true
		t.wait_time = 0.3
		t.start()
		t.connect("timeout",self,"unlock_state",[t])
		
	var a1 = card.set_focus(false)
	var a2 = card.hover_up(false)
	for a in [a1,a2]:
		if a is GDScriptFunctionState:
			yield(a,"completed")
	state_machine.set_monitoring(false)
	state_machine.set_mouse_listener(true)


func unlock_state(timer):
	lock_state = false
	timer.queue_free()

func exited():
	pass

func click(event):
	pass
	
func mouse_enter_leave(is_enter):
	if lock_state:
		return
	if is_enter:
		state_machine.switch_to_state(Constants.CardState.FOCUSED_IN_HAND)
	
func area_entered_exited(area,is_enter):
	pass
