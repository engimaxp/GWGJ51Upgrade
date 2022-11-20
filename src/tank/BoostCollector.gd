extends Node2D

var is_disable = false

func boost_collected(var type)->bool:
	if get_parent().is_dead || is_disable:
		return false
	if type == 1:
		Game.draw_pile.call_deferred("draw_card",1)
		SoundManager.play_sound(load("res://asset/sfx/pickup.tres"))
	return true
	
