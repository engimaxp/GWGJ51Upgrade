extends Node2D

onready var collision_detector = $CollisionDetector
onready var mouse_listener = $MouseListener

var state = Constants.CardState.INITIALIZE
var state_finalized = false
var state_instance = null
var card


func _ready():
	card = get_parent()
	mouse_listener.connect("mouse_entered",self,"_mouse_enter_leave",[true])
	mouse_listener.connect("mouse_exited",self,"_mouse_enter_leave",[false])
	mouse_listener.connect("gui_input",self,"_gui_input")
	collision_detector.connect("area_entered",self,"area_entered")
	collision_detector.connect("area_exited",self,"area_exited")
	set_monitoring(false)
	set_mouse_listener(true)
	state_instance = load(Constants.card_state_script_map[state]).new()\
		.init_param(card,self)
	yield(get_tree(),"idle_frame")
	var aw = state_instance.entered()
	if aw is GDScriptFunctionState:
		yield(aw,"completed")
	

func switch_to_state(new_state):
#	print(str(card.card_index) + " " + str(new_state))
	var old_state = state
	var aw_exited = state_instance.exited()
	if aw_exited is GDScriptFunctionState:
		yield(aw_exited,"completed")
	state = new_state
	state_instance = load(Constants.card_state_script_map[new_state]).new()\
		.init_param(card,self,old_state)
	var aw_enter = state_instance.entered()
	if aw_enter is GDScriptFunctionState:
		yield(aw_enter,"completed")
	
func set_monitoring(is_monitor):
	collision_detector.monitorable = is_monitor
	collision_detector.monitoring = is_monitor
	
func set_mouse_listener(is_listen):
	if is_listen:
		mouse_listener.mouse_filter = Control.MOUSE_FILTER_STOP
	else:
		mouse_listener.mouse_filter = Control.MOUSE_FILTER_IGNORE

func _mouse_enter_leave(is_enter):
#	print(str(card.card_index) + " " + ("_mouse_enter" if is_enter else "_mouse_leave"))
	state_instance.mouse_enter_leave(is_enter)
	
func _gui_input(event):
	if "pressed" in event and "position" in event:
#		print("_gui_input",var2str(event))
		state_instance.click(event)
	elif event is InputEventMouseMotion or event is InputEventScreenDrag:
		state_instance.click_move(event)

func area_entered(area):
	state_instance.area_entered_exited(area,true)
	
func area_exited(area):
	state_instance.area_entered_exited(area,false)
