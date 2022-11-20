extends BoostBase

func _picked_by(var who)->bool:
	var result = false
	if who.has_method("boost_collected"):
		result = who.boost_collected(1)
	else:
		who = who.get_parent()
		if who.has_method("boost_collected"):
			result = who.boost_collected(1)
	return result
