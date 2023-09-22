extends Control

class_name Joystick

@export var normalize := false

signal direction_changed(dir: Vector2)

# TODO: enable touching on the left side to place the joystick and then drag
# TODO: move arrows along with the handle
# TODO: create export options to make the joystick static or not
# TODO: create left_side_touch, right_side_touch events
# TODO: create options to assign one joystick to the left and another to the right
# TODO: create options to anchor buttons on the corners of the screen
# TODO: create options to assign sprites while configuring the joysticks and buttons

@onready var handle: TextureRect = $Handle
@onready var arrows: TextureRect = $Arrows

var handle_relative_touch_position := Vector2.ZERO
var original_handle_global_position := Vector2.ZERO
var handle_center_position := Vector2.ZERO
var handle_touch_radius := 0
var is_dragging_handle := false
var direction := Vector2.ZERO

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
	direction = Vector2.ZERO
	direction_changed.emit(Vector2.ZERO)
	
func _on_handle_drag(drag_position: Vector2) -> void:
	# where the control node will be positioned next
	var next_global_position = \
		drag_position - handle.get_pivot_offset() - handle_relative_touch_position
	# where the center will be next
	var next_center_position = \
		next_global_position + handle.get_pivot_offset()
	# vector that points to the touch position
	var distance_vector = \
		Vector2(next_center_position.x - handle_center_position.x, \
				next_center_position.y - handle_center_position.y)
	# get the radius of the joystick
	var max_joystick_length = size.y / 2
	# gets the vector clamped at the max length because the handle doesnt go past the border
	var direction_vector_clamped = distance_vector.limit_length(max_joystick_length)
	
	# position the handle according to the drag position but constrainted to the joystick's boundaries
	handle.global_position = \
		handle_center_position - handle.get_pivot_offset()\
		 - handle_relative_touch_position + direction_vector_clamped
	
	# calculate the proportional direction vector
	direction = Vector2(\
		direction_vector_clamped.x / max_joystick_length,
		direction_vector_clamped.y / max_joystick_length)
		
	if normalize:
		direction = direction.normalized()

	direction_changed.emit(direction)
	
func get_input() -> Vector2:
	return direction
	
func _get_relative_position(center: Vector2, other: Vector2) -> Vector2:
	var pos := Vector2.ZERO
	pos.x = other.x - center.x
	pos.y = other.y - center.y
	return pos

func _process(delta: float) -> void:
	pass
