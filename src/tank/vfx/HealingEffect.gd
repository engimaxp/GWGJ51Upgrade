tool
extends Node2D

var emitting = false setget set_emitting

onready var p1 = $Particles2D
onready var p2 = $Particles2D2
onready var p3 = $Particles2D3
onready var p4 = $Light2D


func set_emitting(var val):
	emitting = val
	p1.emitting = emitting
	p2.emitting = emitting
	p3.emitting = emitting
	p4.enabled = emitting

func _ready():
	if Engine.editor_hint:
		set_emitting(true)
	else:
		set_emitting(false)
