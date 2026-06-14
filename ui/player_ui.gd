extends CanvasLayer

@onready var health_label = $MarginContainer/HBoxContainer/HealthPanel/HealthLabel
@onready var ammo_label =  $MarginContainer/HBoxContainer/AmmoPanel/AmmoCount

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var player = get_tree().get_first_node_in_group("Player")
	player.health_changed.connect(update_health)
	player.ammo_changed.connect(update_ammo)
	
	update_health(player.health)
	update_ammo(player.current_ammo)
	pass # Replace with function body.

func update_health(updated_value):
	health_label.text = str(updated_value, "HP / 100HP")
	
func update_ammo(updated_value):
	if updated_value == 0:
		ammo_label.text = str("RELOADING...")
	else:
		ammo_label.text = str("AMMO: ", updated_value, " / 20")
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
