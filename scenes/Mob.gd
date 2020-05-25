extends RigidBody2D


var min_speed = 150
var max_speed = 250
var mob_types = ["walk", "swim", "fly"]


# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite.animation = mob_types[randi() % mob_types.size()]

func _on_start_game():
	queue_free()
	
func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
