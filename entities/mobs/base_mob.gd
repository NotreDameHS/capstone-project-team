class_name Mob extends Area2D

@export var max_health = 100
@export var health = max_health
@export var speed := 100.0
@export var damage = 10
@export var search_radius := 100.0
@export var turning_speed := 4.0

var target: Mob = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	health = max_health
	add_to_group("mobs")

func _process(delta: float) -> void:
	if target == null or not is_instance_valid(target):
		find_player()

	if target != null:
		var direction = (target.global_position - global_position).normalized()
		var target_angle = direction.angle()
		rotation = lerp_angle(rotation, target_angle, turning_speed * delta)
		position += direction * speed * delta  # move TOWARD target directly

func find_player() -> void:
	var closest_player = null
	var shortest_dist = search_radius
	
	print("searching... nodes in Player group: ", get_tree().get_nodes_in_group("Player").size())
	
	for node in get_tree().get_nodes_in_group("Player"):

		var dist = global_position.distance_to(node.global_position)

		if dist < shortest_dist:
			shortest_dist = dist
			closest_player = node

	target = closest_player
	
	
func take_damage(amount: float):
	health -= amount
	print(health)
	if health <= 0:
		queue_free()	
		print("mob dead")
func deal_damage(amount: float):
	pass
	
	
