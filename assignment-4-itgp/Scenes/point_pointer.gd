extends Node2D

@export var pointTarget : Node2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if global_position.distance_to(pointTarget.global_position) <= 200:
		hide()
	else:
		show()
	look_at(pointTarget.global_position)

func destroy():
	queue_free()
