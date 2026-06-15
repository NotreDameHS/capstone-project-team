extends CanvasLayer

@onready var health_label = $MarginContainer/HBoxContainer/HealthPanel/HealthLabel
@onready var ammo_label =  $MarginContainer/HBoxContainer/AmmoPanel/AmmoCount
@onready var bomb_label = $MarginContainer/HBoxContainer/Bomb/Bombs
@onready var wave_label =  $MarginContainer/HBoxContainer/Wave/Wave
@onready var kill_label = $"MarginContainer/HBoxContainer/Zombie Kills/Kills"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var player = get_tree().get_first_node_in_group("Player")
	player.health_changed.connect(update_health)
	player.ammo_changed.connect(update_ammo)
	player.bomb_changed.connect(update_bomb)
	update_health(player.health)
	update_ammo(player.current_ammo)
	update_bomb(player.current_bomb)		
	update_wave(GameManager.wavenum)
	if GameManager.killed_mobs >0:
		update_kills(GameManager.killed_mobs)
	elif GameManager.killed_mobs == 0:
		kill_label.text = str("0 Kills")
	pass # Replace with function body.

func update_health(updated_value):
	health_label.text = str(updated_value, "HP / 100HP")
	
func update_ammo(updated_value):
	if updated_value == 0:
		ammo_label.text = str("RELOADING...")
	else:
		ammo_label.text = str("AMMO: ", updated_value, " / 20")
		
func update_bomb(updated_value):
	if updated_value == 0:
		bomb_label.text = str("RELOADING...")
	else:
		bomb_label.text = str("BOMBS: ", updated_value, " / 1")

func update_wave(updated_value):
	wave_label.text = str("WAVE ",updated_value," / 3")
	
func update_kills(updated_value):
	kill_label.text = str(updated_value, " KILLS")
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	update_wave(GameManager.wavenum)
	update_kills(GameManager.killed_mobs)
