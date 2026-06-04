class_name Projectile extends Area2D

@export var damage := 10
@export var max_distance := 2000
@export var speed := 900

var _distance_traveled := 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _physics_process(delta: float) -> void:
	position += transform.x * speed * delta
	_distance_traveled += speed * delta
	if _distance_traveled  > max_distance:
		_explode() 
		
func _explode() -> void:
	queue_free()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_entered(area: Area2D) -> void:
	_explode()
	pass # Replace with function body.
