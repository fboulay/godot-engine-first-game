extends Area2D

signal hit

export var speed = 400    # how fast the player will move (pixel/second)
var screen_size           # size of the game window
var is_mouse_pressed = false
var is_mouse_dragging = false
var last_position: Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	hide()
	screen_size = get_viewport_rect().size

func _input(event: InputEvent):
	if (event is InputEventMouseButton || event is InputEventScreenTouch):
		is_mouse_pressed = event.is_pressed()	
	is_mouse_dragging = (event is InputEventMouseMotion || event is InputEventScreenDrag) && is_mouse_pressed
	if event is InputEventMouseMotion:
		last_position = get_viewport().get_mouse_position()
	if event is InputEventScreenDrag:
		last_position = event.position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity =_compute_keyboard_input()
	velocity += _compute_mouse_input()
	
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite.play()
	else:
		$AnimatedSprite.stop()
	
	position += velocity * delta
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)
	
	if velocity.x != 0:
		$AnimatedSprite.animation = "right"
		$AnimatedSprite.flip_h = velocity.x < 0
		$AnimatedSprite.flip_v = false
	elif velocity.y != 0:
		$AnimatedSprite.animation = "up"
		$AnimatedSprite.flip_v = velocity.y > 0

# Returns the velocity using the keyboard input
func _compute_keyboard_input() -> Vector2: 
	var velocity: Vector2
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1
	return velocity

# Returns the velocity using the mouse (or touch) input
func _compute_mouse_input() -> Vector2:
	if is_mouse_dragging || is_mouse_pressed:
		return last_position - position
	return Vector2()
	
func _on_Player_body_entered(body):
	hide()  # player disappear when hit
	emit_signal("hit")
	$CollisionShape2D.set_deferred("disabled", true)
	
func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
