extends Area2D  
class_name Player
@export var bullet_scene: PackedScene
@export var fire_rate := 0.3
@onready var firetimer = $FireRate
@onready var reloadTimer = $ReloadTimer

var max_speed := 800
var velocity = Vector2(0,0)
var steering_factor := 10.0
var max_health := 100
var health := 100
var dmg := 0
var isinmob = false

#gun variables
var is_firing := false
var max_ammo := 20
var current_ammo := 20
var reload_time := 1.5
var current_reload := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_health(max_health)
	add_to_group("Player")
	firetimer.wait_time = fire_rate
	reloadTimer.wait_time = reload_time
	
	print("Player layers: ", collision_layer)
	print("Player mask: ", collision_mask)
	print("Player instance: ", get_instance_id())

	pass # Replace with function body.

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
	
func shoot_weapon():
	var bullet = bullet_scene.instantiate()
	bullet.global_position = global_position
	
	var mouse_pos = get_global_mouse_position()
	bullet.rotation = (mouse_pos - global_position).angle()
	get_tree().current_scene.add_child(bullet)
	
func reload():
	if current_reload:
		return
	
	is_firing = false
	print("Reloading...")
	current_reload = true
	reloadTimer.start()
	
func _unhandled_input(event: InputEvent) -> void:
#<<<<<<< Updated upstream
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			print("Weapon firing")
			is_firing = true
			if current_ammo > 0:
				shoot_weapon()
				firetimer.start()
		else:
			print("Weapon released")
			is_firing = false
			firetimer.stop()
		
func set_health(new_health: int) -> void:
	print("Original health: ", health)
	health = new_health
	print("New health: ", health)
	get_node("UI/HealthBar").value = health
	
func player_take_damage(damage: int) -> void:
	set_health(health - damage)
	get_node("Timer").start()



func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("HealthPack") and health < 100:
		print("Players current health: ", health)
		print("Max hp allowed: ", max_health)
		if health >= max_health:
			return
		else:
			set_health(health + 10)
			area.queue_free()
			print("Healing")

	if area.is_in_group("mobs"): #change to while for continuouse (needs fixing)
		isinmob = true
		print("player took ", area.damage, " damage from ", area)
		dmg = area.damage
		player_take_damage(dmg)
		
func _on_area_exited(area: Area2D) -> void:
	if area.is_in_group("mobs"):
		isinmob = false
		
func _on_timer_timeout() -> void: #continuous damage timer
	if isinmob == true:
		player_take_damage(dmg)
		get_node("Timer").start()
	else:
		pass


func _on_fire_rate_timeout() -> void:
	if current_ammo <= 0:
		reload()
		return
		
	if is_firing:
		shoot_weapon()
		current_ammo -= 1
		print(current_ammo)
		
		if current_ammo > 0:
			firetimer.start()
		else:
			reload()
			return
		pass # Replace with function body.


func _on_reload_timer_timeout() -> void: #reload timer
	if current_reload:
		current_ammo = max_ammo
		print("Reloaded")
		current_reload = false
		
		if is_firing:
			firetimer.start()
		
	pass # Replace with function body.
