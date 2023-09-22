extends CanvasLayer

@onready var joystick: Control = $Joystick

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func get_joystick() -> Joystick:
	return joystick
