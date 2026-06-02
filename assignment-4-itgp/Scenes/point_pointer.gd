extends Node2D

@export var pointTarget : Node2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	look_at(pointTarget.position)

func destroy():
	queue_free()
