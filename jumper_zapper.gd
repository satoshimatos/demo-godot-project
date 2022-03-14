extends KinematicBody2D

const GRAVITY = 600.0
const WALK_SPEED = 70
const JUMP_SPEED = -300

const drop = preload("res://heart.tscn")
const dead = preload("res://Dead.tscn")

var velocity = Vector2()
var hero
var hp 
var initial_pos

var lighting: float
var start = false
var on_screen = false

export var jump_time = 1

func _ready():
	randomize()
	$start.wait_time = jump_time + randi() % 6
	initial_pos = global_position

	hero = get_tree().get_nodes_in_group("heroes")[0]
	
func _physics_process(delta):
	
	if start == true:
		
		hp = $area2d_for_collision.hp
		$"enemy_hp_bar/progress".value = hp*5
		if $spark.playing == false:
			$spark.play()
		
		randomize()
		lighting = randi() % 11
		$lightning/lighting.energy = .5 + (lighting/10)
		velocity.y += delta * GRAVITY
	
		if hp > 0:
			
			if is_on_floor() and $timer2.is_stopped() and on_screen:
				velocity.y = 0
				velocity.x = 0
				#if velocity.y > 0 and !$collision_ray_up.is_colliding():
				#	velocity.y = y_corr
				if $timertojump.is_stopped():
					$animation.play("readytojump")
					$timertojump.start()
					
			if is_on_wall() and velocity.x > 0:
				velocity.x = -WALK_SPEED
			if is_on_wall() and velocity.x < 0:
				velocity.x = WALK_SPEED
			if is_on_ceiling() and velocity.y < 0:
				velocity.y = 0
	
	
		else:
			var heart = drop.instance()
			var enemydeath = dead.instance()
			enemydeath.position = position
			get_node("..").add_child(enemydeath)
			enemydeath = dead.instance()
			enemydeath.position = position
			get_node("..").add_child(enemydeath)
			randomize()
			if randi() % 10 == 1:
				heart.position = position
				get_node("../../collectibles").add_child(heart)
			
			queue_free()
		
		var _unused = move_and_slide(velocity, Vector2(0,-1))

func _on_Timer_timeout():
	$timer2.start()
	$animation.play("jumping")
	if on_screen:
		if hero.global_position.x > global_position.x:
			velocity.x = WALK_SPEED
		else:
			velocity.x = -WALK_SPEED

	velocity.y = JUMP_SPEED

func _on_timer2_timeout():
	$timer2.stop()

func _on_start_timeout():
	start = true

func _on_visibility_screen_entered():
	on_screen = true


func _on_visibility_screen_exited():
	on_screen = false