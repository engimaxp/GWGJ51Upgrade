extends Reference
class_name CardStateBase

var card = null
var state_machine = null
var last_state = null

func init_param(_card,_state_machine,_last_state = null):
	card = _card
	state_machine = _state_machine
	last_state = _last_state
	return self

func entered():
	pass
	
func exited():
	pass

func click(event):
	pass
	
func click_move(event):
	pass
	
func mouse_enter_leave(is_enter):
	pass
	
func area_entered_exited(area,is_enter):
	pass
