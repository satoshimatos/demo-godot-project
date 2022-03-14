extends Area2D

const GRAVITY = 600.0
const WALK_SPEED = 70
const JUMP_SPEED = -250

export var y_corr = -200 #syringe bounces so that it doesn't get underground
const drop = preload("res://heart.tscn")
const dead = preload("res://Dead.tscn")

var velocity = Vector2()
var hero
var hp = 4
var hit = false
var initial_pos
var screenx
var screeny
var dx
var dy
var start = 0
var lighting: float
signal enemy_hit

func _ready():

	initial_pos = global_position
	add_to_group("enemies")
	var _unused = self.connect("enemy_hit", get_tree().get_nodes_in_group("hp")[0], "_on_enemy_hit")
	_unused = self.connect("enemy_hit", get_tree().get_nodes_in_group("heroes")[0], "_on_enemy_hit")
	_unused = self.connect("body_entered", self, "_hit")
	hero = get_tree().get_nodes_in_group("heroes")[0]
	var screen = hero.get_node("camera").get_viewport_rect()
	screenx = screen.size.x
	screeny = screen.size.y
	
	
func _process(delta):
	if $spark.playing == false:
		$spark.play()
	
	randomize()
	lighting = randi() % 11
	$lightning/lighting.energy = .5 + (lighting/10)
	velocity.y += delta * GRAVITY

	if hp > 0:
		
		dx = global_position.x - hero.global_position.x
		dy = global_position.y - hero.global_position.y
		
		if $collision_ray.is_colliding() and $timer2.is_stopped() and start == 0:
			velocity.x = 0
			if velocity.y > 0 and !$collision_ray_up.is_colliding():
				velocity.y = y_corr
			if $timertojump.is_stopped():
				$animation.play("readytojump")
				$timertojump.start()
				
		if $collision_ray_right.is_colliding():
			velocity.x = -WALK_SPEED
		if $collision_ray_left.is_colliding():
			velocity.x = WALK_SPEED
		if $collision_ray_up.is_colliding() and velocity.y < 0:
			velocity.y = 1


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
	
	translate(velocity * delta)

func _on_Timer_timeout():
	$timer2.start()
	$animation.play("jumping")
	if dx < screenx/1.8 and dy < screeny and dx > -screenx/1.8 and dy > -screeny:
		if hero.global_position.x > global_position.x:
			velocity.x = WALK_SPEED
		else:
			velocity.x = -WALK_SPEED

	velocity.y = JUMP_SPEED

func _on_timer2_timeout():
	$timer2.stop()

func _hit(body):
	if body.is_in_group("heroes"):
		hit = true
		emit_signal("enemy_hit")
