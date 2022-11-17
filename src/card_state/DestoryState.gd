extends CardStateBase

func entered():
	match last_state:
		Constants.CardState.DRAGGED,_:
			Game.current_hand.card_organizer.remove_card(card)
	card.queue_free()

func exited():
	pass

func click(event):
	pass
	
func mouse_enter_leave(is_enter):
	pass
func area_entered_exited(area,is_enter):
	pass
