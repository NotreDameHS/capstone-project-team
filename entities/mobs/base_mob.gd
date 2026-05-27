class_name Mob extends Area2D

@export var max_health = 100
@export var health = max_health
@export var speed := 100.0
@export var damage = 10
@export var search_radius := 100.0

var target: Mob = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	health = max_health
	add_to_group("mobs")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if target == null or not is_instance_valid(target):
		find_player()
	
	position += transform.x * speed * delta
	

func find_player()-> void:
	var closest_Player = null
	var shortest_dist = search_radius
	
	for node in get_tree().get_nodes_in_group("Player"):
			if node is Player:
				var dist = global_position.distance_to(node.global_position)
				if dist < shortest_dist:
					shortest_dist = dist
					closest_Player = node
	target = closest_Player
	
func take_damage(amount: float):
	health -= amount
	print(health)
	if health <= 0:
		queue_free()	
		print("mob dead")
func deal_damage(amount: float):
	pass
	
	
