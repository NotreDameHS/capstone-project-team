extends Node

#This script is used to stash world variables to be used between nodes
var active_mobs := []
var killed_mobs = 0
var count := 0
var all_mobs_dead := false
var currently_spawn := false
var wavenum := 1
var playerHealth := 1
var waves = 0
const GAME_END = preload("res://ui/game_end.tscn")


func get_active_mobs():
	return active_mobs
	#pass
	
func set_active_mobs(mob) -> void:
	active_mobs.append(mob)
	
func remove_active_mobs(mob) -> void:
	active_mobs.erase(mob)

func inc_killed_mobs():
	killed_mobs += 1
	

func died() -> void:
	print(1)
	if playerHealth == 0:
		print(2)
		show_end_screen("Game Over!")

func win() -> void:
	if waves == 3:
		show_end_screen("You Won!")

func show_end_screen(message: String) -> void:
	print(3)
	var screen = GAME_END.instantiate()
	get_tree().current_scene.add_child(screen)
	print(4)
	screen.set_title(message)
	
	
func check():
	if len(active_mobs) == 0 and currently_spawn == true:
		all_mobs_dead = false
	elif len(active_mobs) == 0 and currently_spawn == false:
		all_mobs_dead = true
