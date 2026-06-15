extends Node2D

var pack_cap := 5
var current_packs := 0

@onready var building_layer :=  get_tree().current_scene.find_child("World").get_node("ColliderTile")
@onready var back_layer :=  get_tree().current_scene.find_child("World").get_node("BackgroundTiles")
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
	
	var valid_position := false
		
	while valid_position == false:
		randpos.x = randf_range(min_x, max_x)
		randpos.y = randf_range(min_y, max_y)
		
		if is_in_building(randpos):
			print("Item in building, rerandomizing")
		elif is_in_okspot(randpos):
			print("acceptable location, Item spawned")
			valid_position = true
	
	health_instance.position = randpos
	
	print(current_packs)
	
	pass # Replace with function body.
	
func is_in_building(position: Vector2) -> bool:
	var map_coords = building_layer.local_to_map(position)
	var source_id = building_layer.get_cell_source_id(map_coords)
	return source_id != -1
	
func is_in_okspot(position: Vector2) -> bool:
	var map_coords = back_layer.local_to_map(position)
	var source_id = back_layer.get_cell_source_id(map_coords)
	return source_id != 1
