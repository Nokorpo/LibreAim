extends TargetMovementBehavior
class_name TargetMovementBehaviorStatic
## A target movement behavior that doesn't move

func init(_new_min_position: Vector3, _new_max_position: Vector3) -> void:
	pass

func move_process(_delta: float, _position: Vector3) -> Vector3:
	return Vector3.ZERO
