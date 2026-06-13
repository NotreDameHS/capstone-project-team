extends Node2D

var pack_cap := 10
var current_packs := 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var child_counts := get_child_count() - 1
	current_packs = child_counts
	pass


func _on_timer_timeout() -> void:
	if current_packs >= pack_cap:
		return
	var tilemap :=  get_tree().current_scene.find_child("World")
	var randpos := Vector2(0, 0)
	var map_rect = tilemap.get_used_rect()
	var tile_size = tilemap.tile_set.tile_size
	
	var min_x = map_rect.position.x * tile_size.x
	var max_x = map_rect.end.x * tile_size.x
	var min_y = map_rect.position.y * tile_size.y
	var max_y = map_rect.end.y * tile_size.y
	
	var health_pack := preload("res://entities/collectibles/health_pack.tscn")
	var health_instance := health_pack.instantiate()
	add_child(health_instance)
	

	randpos.x = randf_range(min_x, max_x)
	randpos.y = randf_range(min_y, max_y)
	
	health_instance.position = randpos
	
	print(current_packs)
	
	pass # Replace with function body.
