extends StaticBody2D
@onready var motion: AnimatedSprite2D = $Motion

func destroy():
	motion.play("destroy")
	await motion.animation_finished
	queue_free()
