extends Node2D
var mob_types := [
preload("res://entities/mobs/standard_mob.tscn"),
preload("res://entities/mobs/fast_mob.tscn"),
preload("res://entities/mobs/tank_mob.tscn")
]
var mob_cap : int = 0
var phase = 0
var probability: Array[int] = [0,0,0,0,1,1,2]
# Called when the node enters the scene tree for the first time.

func _ready() -> void:
	pass

func _on_timer_timeout() -> void:
	phase = 0
	while mob_cap < 5 and phase == 0:
		var pick = probability.pick_random()
		print(pick)
		var random_mob : PackedScene = mob_types[pick]
		var mob_instance := random_mob.instantiate()
		add_child(mob_instance)
		
		#var viewport_size := Vector2()
		
		#var random_position := Vector2(0.0, 0.0)
		#random_position.x = randf_range(0.0, viewport_size.x)
		#random_position.y = randf_range(0.0, viewport_size.y)
		
		var temp_pos = Vector2(0.0,0.0)
		
		mob_instance.position = temp_pos
		
		mob_cap += 1
		phase = 1
		break
