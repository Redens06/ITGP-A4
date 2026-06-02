extends Node2D

@export var pointType : String
var captureProgress = 0.0
var captureGoal = 15.0
var isCapturing = false
var isCaptured = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$TextureProgressBar.max_value = captureGoal

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if isCapturing == true and isCaptured == false:
		captureProgress += delta
		if captureProgress >= captureGoal:
			isCaptured = true
	elif captureProgress > 0 and isCaptured == false:
		captureProgress -= delta / 3
	
	$TextureProgressBar.value = captureProgress


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		isCapturing = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		isCapturing = false
