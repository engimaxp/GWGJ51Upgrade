tool
extends Area2D

onready var sprite_2 = $Sprite2
onready var sprite = $Sprite2/Sprite
onready var glow_sprite = $BackGround/Glow
onready var card_organizer = $CardOrganizer

var card_size = Vector2( 74, 80 )
var card_rotation = 0

export(Color) var color = Color.white setget set_color
export(Texture) var texture setget set_texture
export(Constants.OperatorType) var operator_type = Constants.OperatorType.MOVE

func set_color(val):
	color = val
	if is_instance_valid(sprite_2):
		sprite_2.material.set("shader_param/ColorUniform",color)
		glow_sprite.self_modulate = color
		glow_sprite.self_modulate.s = glow_sprite.self_modulate.s - 0.2
		glow_sprite.self_modulate.v = glow_sprite.self_modulate.v + 0.2
	
func set_texture(val):
	texture = val
	if is_instance_valid(sprite) and texture != null:
		sprite.texture = texture

func get_card_scale():
	return Vector2(0.67,0.67)

func _ready():
	self.color = color
	self.texture = texture
	glow_sprite.modulate.a = 0

func glow(is_glow):
	var tween = create_tween()
	tween.tween_property(glow_sprite,"modulate:a",1.0 if is_glow else 0.0,0.2)

func recalculate_position_use_oval(c):
	return Vector2(90 + c.card_index * card_size.x,0)
	
func recalculate_rotation(c):
	return 0.0

func re_position_card(c):
	c.adapt_to_container()
