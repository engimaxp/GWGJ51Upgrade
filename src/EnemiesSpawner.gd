extends Node2D

var time_elapse = 0
var time_duration = 5

var current_enemies_count = 0
var current_enemies_destroy = 0

var current_enemies = []

var world_size = Rect2(0,0,0,0)

func _process(delta):
	if Game.pause:
		return
	if current_enemies.empty():
		return
	time_elapse += delta
	if time_elapse > time_duration:
		spawn_enemy_next()
		time_elapse = 0

func _ready():
	Game.connect("NextWave",self,"spawn_enemy")
	SubPub.subscribe(SubPub.enemy_down,self,funcref(self,"enemy_down"))
	pass

func enemy_down():
	current_enemies_destroy += 1
	if current_enemies_destroy >= current_enemies_count:
		Game.current_wave += 1
		yield(get_tree().create_timer(3.0),"timeout")
		current_enemies_destroy = 0
		Game.emit_signal("NextWave")

func spawn_enemy_next():
	var e = current_enemies.pop_front()
	var dic = Constants.enemy_dic[int(e)]
	var enemy = preload("res://src/Enemy.tscn").instance()
	enemy.damage_data = dic.damage_data
	enemy.health_data = dic.health_data
	enemy.base_img = load(dic.base)
	enemy.turrent_img = load(dic.turrent)
	var tl = world_size.position + Vector2.ONE * 100
	var rb = world_size.position + world_size.size - Vector2.ONE * 100
	enemy.global_position = Vector2(rand_range(tl.x,rb.x),rand_range(tl.y,rb.y))
	add_child(enemy)

func spawn_enemy():
	var array = Game.wave_data[Game.current_wave]
	for info in array:
		for i in info["num"]:
			current_enemies.append(info["type"])
	current_enemies_count = current_enemies.size()
	spawn_enemy_next()
