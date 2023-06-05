extends Node2D

func set_winner(c : String):
	visible = true
	$GPUParticles2D.emitting = true
	$GPUParticles2D2.emitting = true
	$GPUParticles2D3.emitting = true
	$AnimationPlayer.play("winning")
	$AnimatedSprite2D.play(c)
	
