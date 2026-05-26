extends Node2D

func playParticle(type : String):
	match type:
		"explosion":
			$fireballExplosion.emitting = true
		"lightShatter":
			$lightShatter.emitting = true
		_:
			$fireballExplosion.emitting = true

func _on_fireball_explosion_finished() -> void:
	queue_free()

func _on_light_shatter_finished() -> void:
	queue_free()
