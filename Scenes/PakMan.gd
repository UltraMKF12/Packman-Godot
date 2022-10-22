extends KinematicBody2D

var direction: Vector2

func _process(delta):
	direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down");

func _physics_process(delta):
	move_and_slide(direction * 80)


func _on_Area2D_area_entered(area):
	area.queue_free()
