extends TileMapLayer
var world_bounds: Rect2
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var map = get_used_rect()
	var tile_size = tile_set.tile_size
	
	world_bounds = Rect2(map.position * tile_size, map.size * tile_size)
	print(world_bounds)
	await get_tree().process_frame
	var player =  get_tree().get_first_node_in_group("Player")
	print("player found")
	if player:
		var cam = player.get_node_or_null("Camera2D")
		print("found cam")
		if cam:
			cam.limit_left = world_bounds.position.x
			cam.limit_top = world_bounds.position.y
			cam.limit_right = world_bounds.end.x
			cam.limit_bottom = world_bounds.end.y
			print("This works")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
