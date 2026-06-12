extends Node2D

var mob_types := [
preload("res://entities/mobs/standard_mob.tscn"),
preload("res://entities/mobs/fast_mob.tscn"),
preload("res://entities/mobs/tank_mob.tscn")
]
var mob_cap : int = 0
var phase = 0
var probability: Array[int] = [0,0,0,0,1,1,2]
var num_mobs = len(GameManager.get_active_mobs())
var wavenum = 1
var wavecap = 3
var count = 10 

@onready var spawntimer = $SpawnTimer
@onready var wavetimer = $WaveTimer
@onready var timer1 = $Timer

func _ready() -> void:
	pass

func _on_timer_timeout() -> void:
	phase = 0
	count = 10

	if mob_cap == 0:
		print("Wave ", wavenum, " Has Begun!")

	while num_mobs < 5 and phase == 0:
		var pick = probability.pick_random()
		print(pick)
		var random_mob : PackedScene = mob_types[pick]
		var mob_instance := random_mob.instantiate()
		add_child(mob_instance)
		GameManager.set_active_mobs(mob_instance)

		#var viewport_size := Vector2()

		#var random_position := Vector2(0.0, 0.0)
		#random_position.x = randf_range(0.0, viewport_size.x)
		#random_position.y = randf_range(0.0, viewport_size.y)

		var temp_pos = Vector2(0.0,0.0)

		mob_instance.position = temp_pos

		mob_cap += 1
		phase = 1

	#if mob_cap >= 5:
		#wavenum += 1
		#wavetimer.start()


#func _on_wave_timer_timeout() -> void:
	#timer1.start()
	#if wavenum < wavecap :
		#mob_cap = 0
		#phase = 0
		#spawntimer.start()
