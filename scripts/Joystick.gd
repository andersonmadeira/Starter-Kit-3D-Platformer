extends Control

@onready var handle: TextureRect = $Handle
@onready var arrows: TextureRect = $Arrows

var handle_relative_touch_position := Vector2.ZERO
var original_handle_global_position := Vector2.ZERO
var handle_center_position := Vector2.ZERO
var handle_touch_radius := 0
var is_dragging_handle := false

func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		if event.pressed:
			_on_touch_press(event.position)
		else:
			_on_touch_release()
	
	if event is InputEventScreenDrag and is_dragging_handle:
		_on_handle_drag(event.position)

func _ready() -> void:
	original_handle_global_position = handle.global_position
	var handle_pivot := handle.get_pivot_offset()
	handle_touch_radius = handle_pivot.x
	handle_center_position.x = global_position.x + handle.position.x + handle_pivot.x
	handle_center_position.y = global_position.y + handle.position.y + handle_pivot.y
	print(handle_center_position)
	
func _on_touch_press(touch_position: Vector2) -> void:
	var touch_distance = touch_position.distance_to(handle_center_position)
	
	if touch_distance <= handle_touch_radius:
		is_dragging_handle = true
		handle_relative_touch_position = _get_relative_position(handle_center_position, touch_position)
		
func _on_touch_release() -> void:
	is_dragging_handle = false
	handle.global_position = original_handle_global_position
	
func _on_handle_drag(drag_position: Vector2) -> void:
	handle.global_position = drag_position - handle.get_pivot_offset() - handle_relative_touch_position
	
func _get_relative_position(center: Vector2, other: Vector2) -> Vector2:
	var pos := Vector2.ZERO
	pos.x = other.x - center.x
	pos.y = other.y - center.y
	return pos

func _process(delta: float) -> void:
	pass
