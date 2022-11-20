extends Node
class_name CoolDownProxy,"res://asset/CoolDownProxy.svg"
export(float) var wait_time = 1.0 setget set_wait_time
export(NodePath) var timer_node_path
onready var timer = get_node_or_null(timer_node_path)
var is_cooldown = false

# triger_start
# cooldown_complete

signal cooldown_finish

func set_wait_time(var val):
	wait_time = val
	if is_instance_valid(get_owner()) and is_instance_valid(timer) and wait_time > 0:
		timer.wait_time = wait_time

func _ready():
	set_wait_time(wait_time)

func triger_start()->bool:
	if is_cooldown:
		return false
	is_cooldown = true
	timer.start()
	return true

func _on_Timer_timeout():
	var p = get_parent()
	if p.has_method("cooldown_complete"):
		p.cooldown_complete()
	is_cooldown = false
	emit_signal("cooldown_finish")
