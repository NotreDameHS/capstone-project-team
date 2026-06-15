extends CanvasLayer

@onready var title_label: Label = $ColorRect/CenterContainer/Label

# Called when the node enters the scene tree for the first time.
func set_title(text: String) -> void:
	title_label.text = text
	
func _ready() -> void:
	get_tree().paused = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
