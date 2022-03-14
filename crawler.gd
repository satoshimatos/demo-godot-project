extends KinematicBody2D

const SPEED = 100
const GRAVITY = 600
const MAX_SPEED = 300

var velocity = Vector2()
var hero
var action
var updown = false

func _ready():
	hero = get_tree().get_nodes_in_group("heroes")[0]
	pass

func _process(delta):
		
	#if action == 0:
	#	wait()
	if action == 1 or action == 0:
		chase()
	elif action == 2:
		upsidedown()

	move_and_slide(velocity, Vector2(0,-1))
	
func upsidedown():
	print("updown")
	if updown == false:
		updown = true
		if $raycast.is_colliding():
			print("is colliding")

			if scale == Vector2(.5,-.5):
				scale = Vector2(.5, .5)
				velocity.y = GRAVITY

			else:
				scale = Vector2(.5, -.5)
				velocity.y = -GRAVITY
			if is_on_floor() or is_on_ceiling():
				velocity.y = 0
		
func chase():
	print("chase")
	if global_position < hero.global_position:
		$animation.flip_h = false
		velocity.x = SPEED
	elif global_position > hero.global_position:
		$animation.flip_h = true
		velocity.x = -SPEED
		
func wait():
	print("wait")
	velocity.x = 0

func _on_Timer_timeout():
	updown = false
	action = randi() % 3
