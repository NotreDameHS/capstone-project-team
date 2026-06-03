extends Area2D  
class_name Player

var max_speed := 800
var velocity = Vector2(0,0)
var steering_factor := 10.0
var max_health := 100
var health := 100
var dmg := 0
var current_mob = null
var a = null
var queue_num = 0
var timed = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_health(max_health)
	add_to_group("Player")
	print("Player layers: ", collision_layer)
	print("Player mask: ", collision_mask)
	print("Player instance: ", get_instance_id())

	pass # Replace with function body.

func _physics_process(delta: float) -> void:
	if queue_num == 1:
		timed += (1/60)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:

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
	print("Original health: ", health)
	health = new_health
	print("New health: ", health)
	get_node("UI/HealthBar").value = health
	
func player_take_damage(damage: int) -> void:
	if current_mob != null and timed <3 and queue_num == 1:
		set_health(health - damage)
	

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("HealthPack"):
		print("Players current health: ", health)
		print("Max hp allowed: ", max_health)
		if health >= max_health:
			return
		else:
			set_health(health + 10)
			#area.queue_free()
			print("Healing")

	while area.is_in_group("mobs"):
		current_mob = area
		print("player took ", area.damage, " damage from ", area)
		dmg = area.damage
		player_take_damage(dmg)
		queue_num =+ 1
		print("damage queued ", queue_num)
		#a = false
		get_node("Timer").start(0.5)

		
#func _on_area_exited(area: Area2D)-> void:
	#if area == current_mob:
		#a = false
		#queue_num = 0
		#current_mob = null
		#get_node("Timer").stop()

func _on_timer_timeout() -> void:
	#a = true
	if current_mob != null and timed <3 and queue_num == 1:
		player_take_damage(dmg)
		queue_num = 0
		timed = 0
	
	else:
		current_mob = null
		get_node("Timer").stop()
