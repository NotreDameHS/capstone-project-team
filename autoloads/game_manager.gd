extends Node

#This script is used to stash world variables to be used between nodes
var active_mobs := []
var killed_mobs = 0

signal all_mobs_dead


func get_active_mobs():
	return active_mobs
	#pass
	
func set_active_mobs(mob) -> void:
	active_mobs.append(mob)
	
func remove_active_mobs(mob) -> void:
	active_mobs.erase(mob)

func inc_killed_mobs():
	killed_mobs += 1
