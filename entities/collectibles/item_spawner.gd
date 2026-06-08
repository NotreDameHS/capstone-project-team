extends Node2D

var pack_cap := 5
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
	
	var health_pack := preload("res://entities/collectibles/health_pack.tscn")
	var health_instance := health_pack.instantiate()
	add_child(health_instance)
	
	var viewport_size := get_viewport_rect().size
	print(viewport_size)
	var random_position := Vector2(0.0, 0.0)
	random_position.x = randf_range(0.0, viewport_size.x)
	random_position.y = randf_range(0.0, viewport_size.y)
	
	health_instance.position = random_position
	
	print(current_packs)
	
	pass # Replace with function body.
