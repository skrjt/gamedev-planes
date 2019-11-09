extends Area2D

var speed setget setSpeed

func _physics_process(delta):
	position += speed
	pass

func _on_Area2D_area_entered(other):
	if other.is_in_group("enemy"):
		other.health -= 1
		queue_free()
	pass

func _on_ProjectileVisibility_screen_exited():
	queue_free()
	pass
	
func setSpeed(pos):
	speed = pos
	pass