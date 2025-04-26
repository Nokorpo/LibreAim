class_name TargetMovementBehaviorLinearmovement
extends TargetMovementBehavior
## A target movement behavior that moves linearly in a straight line

## Max velocity of the target
@export var max_velocity: Vector3 = Vector3.ZERO

var min_position: Vector3
var max_position: Vector3

func init(new_min_position: Vector3, new_max_position: Vector3) -> void:
	_current_velocity = Vector3(randf_range(-max_velocity.x, max_velocity.x),\
		 randf_range(-max_velocity.y, max_velocity.y), 0)
	min_position = new_min_position
	max_position = new_max_position

func move_process(delta: float, position: Vector3) -> Vector3:
	if _current_velocity != Vector3.ZERO:
		## TODO: Refactor this ugly code
		if position.x > max_position.x:
			_current_velocity = _current_velocity.bounce(Vector3(1, 0, 0))
		if position.y > max_position.y:
			_current_velocity = _current_velocity.bounce(Vector3(0, 1, 0))
		if position.z > max_position.z:
			_current_velocity = _current_velocity.bounce(Vector3(0, 0, 1))
		if position.x < min_position.x:
			_current_velocity = _current_velocity.bounce(Vector3(-1, 0, 0))
		if position.y < min_position.y:
			_current_velocity = _current_velocity.bounce(Vector3(0, -1, 0))
		if position.z < min_position.z:
			_current_velocity = _current_velocity.bounce(Vector3(0, 0, -1))
	return _current_velocity * delta
