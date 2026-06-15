class_name Projectile extends Area2D

@export var damage := 10
@export var max_distance := 100
@export var speed := 200
@export var explo_scale := 1

var _distance_traveled := 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if explo_scale == 1:
		add_to_group("bullets")
	elif explo_scale == 4:
		add_to_group("bombs")
	#print("bullet added to group")

func _physics_process(delta: float) -> void:
	position += transform.x * speed * delta
	_distance_traveled += speed * delta
	if _distance_traveled  > max_distance:
		_explode() 
		
func _explode() -> void:
	poof(global_position)
	queue_free()

func poof(projectile_position: Vector2):
	
	var particles = CPUParticles2D.new()
	get_tree().current_scene.add_child(particles)
	particles.global_position = projectile_position
	# Create a particle cloud (a "poof" of particles from the center)
	particles.z_index = 100
	particles.z_as_relative = false 
	particles.amount = 10*explo_scale
	particles.lifetime = 0.5
	particles.explosiveness = 1.0 
	particles.one_shot = true
	particles.scale_amount_min = 2.0*explo_scale
	particles.scale_amount_max = 5.0*explo_scale
	particles.spread = 180.0
	particles.gravity = Vector2(0, 0)
	particles.initial_velocity_min = 80.0
	particles.initial_velocity_max = 150.0
	particles.damping_min = 50.0 
	# Design the shape of the cloud (the "poof")
	var curve = Curve.new()
	curve.add_point(Vector2(0, 1.0)) 
	curve.add_point(Vector2(1, 0.0))
	particles.scale_amount_curve = curve

	if is_in_group("bullets"):
		# Design the colours of the cloud
		var gradient = Gradient.new()
		gradient.add_point(0.0, Color(1.0, 0.835, 0.01, 1.0)) 
		gradient.add_point(1.0, Color(1.0, 0.505, 0.01, 1.0)) 
		gradient.add_point(1.0, Color(1.0, 0.01, 0.01, 1.0)) 

		particles.color_ramp = gradient


	if is_in_group("bombs"):
		# Design the colours of the cloud
		var gradient = Gradient.new()
		gradient.add_point(0.0, Color(1.0, 0.01, 0.01, 1.0)) 
		gradient.add_point(1.0, Color(1.0, 0.505, 0.01, 1.0)) 
		gradient.add_point(1.0, Color(1.0, 0.01, 0.01, 1.0)) 

		particles.color_ramp = gradient
	
	particles.emitting = true
	var timer = get_tree().create_timer(particles.lifetime + 0.5)
	timer.timeout.connect(particles.queue_free)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass





func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("mobs"):
		body.mob_take_damage(damage)
		_explode()
	else:
		_explode()
	pass # Replace with function body.
