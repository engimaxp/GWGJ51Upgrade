extends Node

enum OperatorType {
	MOVE,
	ATTACK,
	DEFENSE,
}

enum OperatorState {
	PLUS,MINUS,MULTIPLY,DIVIDE
}

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
	INITIALIZE		#17
	DESTORY		#18
	IN_CONTAINER		#19
	FOCUSED_IN_CONTAINER		#20
	DRAGGED_IN_CONTAINER		#21
}
const FOCUS_HOVER_COLOR := Color.green * 1

const card_state_script_map = {
	CardState.IN_HAND:"res://src/card_state/InHandState.gd",
	CardState.FOCUSED_IN_HAND:"res://src/card_state/FocusedInHandState.gd",
	CardState.FOCUSED_IN_CONTAINER:"res://src/card_state/FocusedInContainerState.gd",
	CardState.DRAGGED:"res://src/card_state/InHandDraggedState.gd",
	CardState.DRAGGED_IN_CONTAINER:"res://src/card_state/InContainerDraggedState.gd",
	CardState.IN_PILE:"res://src/card_state/InPileState.gd",
	CardState.IN_CONTAINER:"res://src/card_state/InContainerState.gd",
	CardState.INITIALIZE:"res://src/card_state/InitializeState.gd",
	CardState.DESTORY:"res://src/card_state/DestoryState.gd",
}

enum CardNumber{ONE,TWO,THREE,FOUR,FIVE,SIX,SEVEN,\
	EIGHT,NINE,PLUS,MINUS,MULTIPLY,DIVIDE}
enum CardFace{CLUB,DIAMOND,HEART,SPADE,SPECIAL}

enum EnemyType {SMALL_BLUE}

var enemy_dic = {
	EnemyType.SMALL_BLUE:{
		"base":"res://asset/map/tankBody/blue/outline.tres",
		"turrent":"res://asset/map/tankBlue/barrel3/outline.tres",
		"damage_data":{"damage":5,"opt":OperatorState.PLUS},
		"health_data":{
			"max_health":5,
			"health":5
		}
	}
}

const card_display_dic = {
	CardFace.CLUB:{
		CardNumber.ONE:{
			"image":"res://asset/cards/cardClubsA_1.png",
			"number":1,
			"special":"none",
		},
		CardNumber.TWO:{
			"image":"res://asset/cards/cardClubs2_1.png",
			"number":2,
			"special":"none",
		},
		CardNumber.THREE:{
			"image":"res://asset/cards/cardClubs3_1.png",
			"number":3,
			"special":"none",
		},
		CardNumber.FOUR:{
			"image":"res://asset/cards/cardClubs4_1.png",
			"number":4,
			"special":"none",
		},
		CardNumber.FIVE:{
			"image":"res://asset/cards/cardClubs5_1.png",
			"number":5,
			"special":"none",
		},
		CardNumber.SIX:{
			"image":"res://asset/cards/cardClubs6_1.png",
			"number":6,
			"special":"none",
		},
		CardNumber.SEVEN:{
			"image":"res://asset/cards/cardClubs7_1.png",
			"number":7,
			"special":"none",
		},
		CardNumber.EIGHT:{
			"image":"res://asset/cards/cardClubs8_1.png",
			"number":8,
			"special":"none",
		},
		CardNumber.NINE:{
			"image":"res://asset/cards/cardClubs9_1.png",
			"number":9,
			"special":"none",
		},
	},CardFace.DIAMOND:{
		CardNumber.ONE:{
			"image":"res://asset/cards/cardDiamondsA_1.png",
			"number":1,
			"special":"none",
		},
		CardNumber.TWO:{
			"image":"res://asset/cards/cardDiamonds2_1.png",
			"number":2,
			"special":"none",
		},
		CardNumber.THREE:{
			"image":"res://asset/cards/cardDiamonds3_1.png",
			"number":3,
			"special":"none",
		},
		CardNumber.FOUR:{
			"image":"res://asset/cards/cardDiamonds4_1.png",
			"number":4,
			"special":"none",
		},
		CardNumber.FIVE:{
			"image":"res://asset/cards/cardDiamonds5_1.png",
			"number":5,
			"special":"none",
		},
		CardNumber.SIX:{
			"image":"res://asset/cards/cardDiamonds6_1.png",
			"number":6,
			"special":"none",
		},
		CardNumber.SEVEN:{
			"image":"res://asset/cards/cardDiamonds7_1.png",
			"number":7,
			"special":"none",
		},
		CardNumber.EIGHT:{
			"image":"res://asset/cards/cardDiamonds8_1.png",
			"number":8,
			"special":"none",
		},
		CardNumber.NINE:{
			"image":"res://asset/cards/cardDiamonds9_1.png",
			"number":9,
			"special":"none",
		},
	},CardFace.HEART:{
		CardNumber.ONE:{
			"image":"res://asset/cards/cardHeartsA_1.png",
			"number":1,
			"special":"none",
		},
		CardNumber.TWO:{
			"image":"res://asset/cards/cardHearts2_1.png",
			"number":2,
			"special":"none",
		},
		CardNumber.THREE:{
			"image":"res://asset/cards/cardHearts3_1.png",
			"number":3,
			"special":"none",
		},
		CardNumber.FOUR:{
			"image":"res://asset/cards/cardHearts4_1.png",
			"number":4,
			"special":"none",
		},
		CardNumber.FIVE:{
			"image":"res://asset/cards/cardHearts5_1.png",
			"number":5,
			"special":"none",
		},
		CardNumber.SIX:{
			"image":"res://asset/cards/cardHearts6_1.png",
			"number":6,
			"special":"none",
		},
		CardNumber.SEVEN:{
			"image":"res://asset/cards/cardHearts7_1.png",
			"number":7,
			"special":"none",
		},
		CardNumber.EIGHT:{
			"image":"res://asset/cards/cardHearts8_1.png",
			"number":8,
			"special":"none",
		},
		CardNumber.NINE:{
			"image":"res://asset/cards/cardHearts9_1.png",
			"number":9,
			"special":"none",
		},
	},CardFace.SPADE:{
		CardNumber.ONE:{
			"image":"res://asset/cards/cardSpadesA_1.png",
			"number":1,
			"special":"none",
		},
		CardNumber.TWO:{
			"image":"res://asset/cards/cardSpades2_1.png",
			"number":2,
			"special":"none",
		},
		CardNumber.THREE:{
			"image":"res://asset/cards/cardSpades3_1.png",
			"number":3,
			"special":"none",
		},
		CardNumber.FOUR:{
			"image":"res://asset/cards/cardSpades4_1.png",
			"number":4,
			"special":"none",
		},
		CardNumber.FIVE:{
			"image":"res://asset/cards/cardSpades5_1.png",
			"number":5,
			"special":"none",
		},
		CardNumber.SIX:{
			"image":"res://asset/cards/cardSpades6_1.png",
			"number":6,
			"special":"none",
		},
		CardNumber.SEVEN:{
			"image":"res://asset/cards/cardSpades7_1.png",
			"number":7,
			"special":"none",
		},
		CardNumber.EIGHT:{
			"image":"res://asset/cards/cardSpades8_1.png",
			"number":8,
			"special":"none",
		},
		CardNumber.NINE:{
			"image":"res://asset/cards/cardSpades9_1.png",
			"number":9,
			"special":"none",
		},
	},CardFace.SPECIAL:{
		CardNumber.PLUS:{
			"image":"res://asset/cards/plus.png",
			"number":-1,
			"special":"plus",
		},
		CardNumber.MINUS:{
			"image":"res://asset/cards/minus.png",
			"number":-1,
			"special":"minus",
		},
		CardNumber.MULTIPLY:{
			"image":"res://asset/cards/multiply.png",
			"number":-1,
			"special":"multiply",
		},
		CardNumber.DIVIDE:{
			"image":"res://asset/cards/divide.png",
			"number":-1,
			"special":"divide",
		},
	}
}
