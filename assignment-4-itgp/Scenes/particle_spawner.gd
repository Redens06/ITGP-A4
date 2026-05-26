extends Node2D

func playParticle(type : String):
	match type:
		"explosion":
			$fireballExplosion.emitting = true
		_:
			$fireballExplosion.emitting = true

func _on_fireball_explosion_finished() -> void:
	queue_free()
