extends Node

enum CardState {
	IN_HAND					#0
	FOCUSED_IN_HAND			#1
	MOVING_TO_CONTAINER		#2
	REORGANIZING			#3
	PUSHED_ASIDE			#4
	DRAGGED					#5
	DROPPING_TO_BOARD		#6
	ON_PLAY_BOARD			#7
	FOCUSED_ON_BOARD		#8
	IN_PILE					#9
	VIEWED_IN_PILE			#10
	IN_POPUP				#11
	FOCUSED_IN_POPUP		#12
	VIEWPORT_FOCUS			#13
	PREVIEW					#14
	DECKBUILDER_GRID		#15
	MOVING_TO_SPAWN_DESTINATION		#16
	INITIALIZE
	DESTORY
}
const FOCUS_HOVER_COLOR := Color.green * 1

const card_state_script_map = {
	CardState.IN_HAND:"res://src/card_state/InHandState.gd",
	CardState.FOCUSED_IN_HAND:"res://src/card_state/FocusedInHandState.gd",
	CardState.DRAGGED:"res://src/card_state/InHandDraggedState.gd",
	CardState.IN_PILE:"res://src/card_state/InPileState.gd",
	CardState.MOVING_TO_CONTAINER:"res://src/card_state/MoveToContainerState.gd",
	CardState.INITIALIZE:"res://src/card_state/InitializeState.gd",
	CardState.DESTORY:"res://src/card_state/DestoryState.gd",
}