extends KinematicBody2D

signal gameover

export var speed = 130
const JUMPSPEED = 250
const GRAVITY = 200

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
var move_right = false
var move_left = false
var move_up = false

var touch_release_after_drag = false

func _input(event):
	if event is InputEventScreenTouch && !event.is_pressed():
		if !touch_release_after_drag:
			move_up = true
		touch_release_after_drag = false
	if event is InputEventScreenDrag:
		touch_release_after_drag = true
		move_up = false
		if event.relative.x > 0:
			move_right = true
		if event.relative.x < 0:
			move_left = true
		
	
var jumping = false
var velocity = Vector2()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):	
	if is_on_floor():
		velocity.y = 0
		jumping = false
	else:
		velocity += (Vector2.DOWN * GRAVITY * delta)
	velocity.x = 0
	if Input.is_action_pressed("ui_right") || move_right:
		velocity.x = speed
		move_right = false
	elif Input.is_action_pressed("ui_left") || move_left:
		velocity.x = -speed
		move_left = false
	elif (Input.is_action_pressed("ui_accept") || move_up) && is_on_floor():
		velocity = Vector2.UP * JUMPSPEED
		jumping = true
		move_up = false

	if !is_on_floor() || velocity.x != 0:
		$AnimatedSprite.play()
	else:
		$AnimatedSprite.stop()
		$AnimatedSprite.set_frame(0)
	move_and_slide(velocity, Vector2(0,-1))
	
	if velocity.x != 0:
		$AnimatedSprite.animation = "walk"
		$AnimatedSprite.flip_v = false
		$AnimatedSprite.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite.animation = "up"
		#$AnimatedSprite.flip_v = velocity.y > 0
	


func _on_Prize_body_entered(body):
	emit_signal("gameover")
	queue_free()
