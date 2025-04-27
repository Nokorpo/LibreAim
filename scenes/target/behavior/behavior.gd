class_name TargetMovementBehavior
extends Resource
## Base class to define a target movement behavior

@warning_ignore("unused_private_class_variable")
var _current_velocity: Vector3 = Vector3.ZERO

func move_process(_delta: float, _position: Vector3) -> Vector3:
	push_warning("Target move process not defined")
	return Vector3.ZERO
