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
var wavenum = GameManager.wavenum
var wavecap = 3
var count = 5 
var stop_spawn = false
var reset_wave = false
var inactivity_counter = false
var inactivity_counter_count = 0
var previous_count := 0
var mob_max = 5
var lower = 4
var upper = 7

@onready var building_layer :=  get_tree().current_scene.find_child("World").get_node("ColliderTile")
@onready var spawntimer = $SpawnTimer
@onready var wavetimer = $WaveTimer
@onready var timer1 = $Timer

func _ready() -> void:
	pass

func _on_timer_timeout() -> void:
	phase = 0
	count = 10
	GameManager.wavenum = wavenum
	if mob_cap == 0:
		print("Wave ", wavenum, " Has Begun!")
		stop_spawn = false
		inactivity_counter = false
		inactivity_counter_count = 0
		mob_max = randi_range(lower,upper)
		print(mob_max,lower,upper)

	while mob_cap < mob_max and phase == 0 and stop_spawn == false:
		var pick = probability.pick_random()
		print(pick)
		var random_mob : PackedScene = mob_types[pick]
		var mob_instance := random_mob.instantiate()
		add_child(mob_instance)
		GameManager.set_active_mobs(mob_instance)

		var randpos := Vector2(0, 0)
		var tilemap :=  get_tree().current_scene.find_child("World")
		var map_rect = tilemap.get_used_rect()
		var tile_size = tilemap.tile_set.tile_size

		var min_x = map_rect.position.x * tile_size.x
		var max_x = map_rect.end.x * tile_size.x
		var min_y = map_rect.position.y * tile_size.y
		var max_y = map_rect.end.y * tile_size.y

		#var temp_pos = Vector2(0.0,0.0)
		var valid_position := false
		
		while valid_position == false:
			randpos.x = randf_range(min_x, max_x)
			randpos.y = randf_range(min_y, max_y)
			
			if is_in_building(randpos):
				print("Mob in building, rerandomizing")
			else:
				valid_position = true
			
		mob_instance.position = randpos
		print("Mob ", mob_cap, " Spawned")
		#mob_instance.position = temp_pos

		mob_cap += 1
		phase = 1
	
	if mob_cap >= mob_max and stop_spawn == false:
		stop_spawn = true
		print(mob_cap, stop_spawn)
		print("Wave spawning compelete")
		inactivity_counter = true
		
	if mob_cap >= mob_max and stop_spawn ==true:
		
		print(len(GameManager.active_mobs), wavenum)
		
		if len(GameManager.active_mobs) > 0 and inactivity_counter == true:
			if len(GameManager.active_mobs) > previous_count:
				inactivity_counter_count = 0
			inactivity_counter_count += 1
			previous_count = len(GameManager.active_mobs)
			
		if wavenum < wavecap and len(GameManager.active_mobs) == 0 or wavenum < wavecap and inactivity_counter_count == 30:
			print("All Mobs Dead!")
			wavenum+=1
			GameManager.active_mobs = []
			wavetimer.start()
			lower += 1
			upper += 2
			reset_wave = true
			
		elif wavenum == wavecap and len(GameManager.active_mobs) == 0 or inactivity_counter_count == 30 and wavenum == wavecap:
			print("All waves complete!")
			won()
	
	if mob_cap > mob_max:
		mob_cap = mob_max
	
	if reset_wave == false:
		spawntimer.start()	
	

func _on_wave_timer_timeout() -> void:
	GameManager.count = 5
	timer1.start()

func _on_count_timeout() -> void:
	counter()
	if GameManager.count > 0:
		timer1.start()
	elif GameManager.count <= 0:
		print("Beginning Next Round")
		mob_cap = 0
		reset_wave = false
		spawntimer.start()
		
func counter():
	print(GameManager.count, " Seconds left")
	GameManager.count -= 1

func won():
	spawntimer.stop()
	wavetimer.stop()
	timer1.stop()
	GameManager.waves = 3
	GameManager.win()

func is_in_building(position: Vector2) -> bool:
	var map_coords = building_layer.local_to_map(position)
	var source_id = building_layer.get_cell_source_id(map_coords)
	return source_id != -1
