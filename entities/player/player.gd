extends Area2D  
class_name Player

var max_speed := 800
var velocity = Vector2(0,0)
var steering_factor := 10.0
var max_health := 100
var health := 100

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_health(max_health)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	add_to_group("Player")
	var direction := Vector2(0,0)
	direction.x = Input.get_axis("move_left", "move_right")
	direction.y = Input.get_axis("move_up", "move_down")
	
	if direction.length() > 1.0:
		direction = direction.normalized()
		
	var desired_velocity := direction * max_speed
	var steering_vector = desired_velocity - velocity
	velocity += steering_factor * steering_vector * delta
	
	position += velocity * delta
	pass
	
func set_health(new_health: int) -> void:
	health = new_health
	get_node("UI/HealthBar").value = health
	
func player_take_damage(damage: int) -> void:
	set_health(health - damage)


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("HealthPack"):
		if health >= max_health:
			return
		else:
			set_health(health + 10)
			area.queue_free()
			print("Healing")
			
	if area.is_in_group("mobs"):
		player_take_damage(10)
	pass # Replace with function body.
