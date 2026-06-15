extends Node

#This script is used to stash world variables to be used between nodes
var active_mobs := []
var killed_mobs = 0
var count := 0
var all_mobs_dead := false
var currently_spawn := false

func get_active_mobs():
	return active_mobs
	#pass
	
func set_active_mobs(mob) -> void:
	active_mobs.append(mob)
	
func remove_active_mobs(mob) -> void:
	active_mobs.erase(mob)

func inc_killed_mobs():
	killed_mobs += 1
	
func check():
	if len(active_mobs) == 0 and currently_spawn == true:
		all_mobs_dead = false
	elif len(active_mobs) == 0 and currently_spawn == false:
		all_mobs_dead = true
