extends Node2D

export var oil = 20
export var max_oil = 64

func oil_spend(amount):
	oil -= amount
	oil = clamp(oil,0,max_oil)
	if "cam" in get_parent():
		Game.emit_signal("OilChange",oil,max_oil)

func add_oil(number):
	if number + oil > max_oil:
		number = max_oil - oil
	self.oil += number
	Game.emit_signal("OilChange",oil,max_oil)

func resupply(var hurt_dictionary)->bool:
	var damage = 1
	if hurt_dictionary.has("damage"):
		damage = hurt_dictionary["damage"]
	match hurt_dictionary["opt"]:
		Constants.OperatorState.PLUS:
			add_oil(hurt_dictionary["damage"])
			return true
		Constants.OperatorState.MINUS:
			self.oil -= damage
		Constants.OperatorState.MULTIPLY:
			add_oil(oil * damage - oil)
		Constants.OperatorState.DIVIDE:
			self.oil -= int(oil / damage)
	Game.emit_signal("OilChange",oil,max_oil)
	return true
