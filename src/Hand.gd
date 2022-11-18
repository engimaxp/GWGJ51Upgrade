extends Area2D

var rect_size = Vector2(672,96)
var is_hand = true
onready var card_organizer = $CardOrganizer

var cards_in_hand = {}

var card_size = Vector2( 57.2, 80 )
var card_rotation = 0

func _ready():
	Game.current_hand = self

func re_position_card(c):
	c.hover_up(false)

# Calculate the position after the rotation has been calculated that use oval shape
func recalculate_position_use_oval(c,index_diff = null)-> Vector2:
	var card_position_x: float = 0.0
	var card_position_y: float = 0.0
	var parent_control = self
	# Oval hor rad, rect_size.x*0.5*1.5 it’s an empirical formula,
	# that's been tested to feel good.
	var hor_rad: float = parent_control.rect_size.x * 0.5 * 1.5
	# Oval ver rad, rect_size.y * 1.5 it’s an empirical formula,
	# that's been tested to feel good.
	var ver_rad: float = parent_control.rect_size.y * 1.5
	# Get the angle from the point on the oval to the center of the oval
	var angle = _get_angle_by_index(c,index_diff)
	var rad_angle = deg2rad(angle)
	# Get the direction vector of a point on the oval
	var oval_angle_vector = Vector2(hor_rad * cos(rad_angle),
			- ver_rad * sin(rad_angle))
	# Take the center point of the card as the starting point, the coordinates
	# of the top left corner of the card
	var left_top = Vector2(- card_size.x/2, - card_size.y/2)
	# Place the top center of the card on the oval point
	var center_top = Vector2(0, - card_size.y/2)
	# Get the angle of the card, which is different from the oval angle,
	# the card angle is the normal angle of a certain point
	var card_angle = _get_oval_angle_by_index(c,angle, null, hor_rad,ver_rad)
	# Displacement offset due to card rotation
	var delta_vector = left_top - center_top.rotated(deg2rad(90 - card_angle))
	# Oval center x
	var center_x = 28.6
#	var center_x = parent_control.rect_size.x / 2 \
#			+ parent_control.rect_position.x
	# Oval center y, - parent_control.rect_size.y * 0.25:This method ensures that the card is moved to the proper position
	var center_y = 192
#	var center_y = parent_control.rect_size.y * 1.5 \
#			+ parent_control.rect_position.y \
#			- parent_control.rect_size.y * 0.25
	card_position_x = (oval_angle_vector.x + center_x)
	card_position_y = (oval_angle_vector.y + center_y)
	return(Vector2(card_position_x, card_position_y) + delta_vector)
	
func recalculate_rotation(c,index_diff = null)-> float:
	var calculated_rotation := float(card_rotation)
	calculated_rotation = 90.0 - _get_oval_angle_by_index(c,null, index_diff)
	return(calculated_rotation)

# Get card angle in hand by index that use oval shape
# The angle of the normal on the ellipse
func _get_oval_angle_by_index(c,
		angle = null,
		index_diff = null,
		hor_rad = null,
		ver_rad = null) -> float:
	if not angle:
		# Get the angle from the point on the oval to the center of the oval
		angle = _get_angle_by_index(c,index_diff)
	var parent_control
	if not hor_rad:
		parent_control = self
		hor_rad = parent_control.rect_size.x * 0.5 * 1.5
	if not ver_rad:
		parent_control = self
		ver_rad = parent_control.rect_size.y * 1.5
	var card_angle
	if angle == 90:
		card_angle = 90
	# Convert oval angle to normal angle
	else:
		# To avoid div/0
		if hor_rad == 0:
			card_angle = 90
		else:
			card_angle = rad2deg(atan(- ver_rad / hor_rad / tan(deg2rad(angle))))
			card_angle = card_angle + 90
	return(card_angle)

# Get the angle on the ellipse
func _get_angle_by_index(c,index_diff = null) -> float:
	var index = c.card_index
	var hand_size = card_organizer.get_card_count()
	# This to prevent div/0 errors because the card will not be
	# reported when it's being dragged
	if hand_size == 0:
		hand_size = 1
	var half = (hand_size - 1) / 2.0
	var card_angle_max: float = 15
	var card_angle_min: float = 6.5
	# Angle between cards
	var card_angle = max(min(60 / hand_size, card_angle_max), card_angle_min)
	# When foucs hand, the card needs to be offset by a certain angle
	# The current practice is just to find a suitable expression function, if there is a better function, please replace this function: - sign(index_diff) * (1.95-0.3*index_diff*index_diff) * min(card_angle,5)
	if index_diff != null:
		return 90 + (half - index) * card_angle \
				- sign(index_diff) * (1.95 - 0.3 * index_diff * index_diff) \
				* min(card_angle, 5)
	else:
		return 90 + (half - index) * card_angle

func get_card_scale():
	return Vector2.ONE
