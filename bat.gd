extends Area2D


const WALK_SPEED = 1
const JUMP_SPEED = -300
const DECELERATION = 25
const KNOCKBACK = 300
const dead = preload("res://Dead.tscn")
const drop = preload("res://heart.tscn")

var initial_pos
var velocity = Vector2()
var hero
var MAX_SPEED
var screenx
var screeny
var hp = 2
var hit = false
var hero_hp

signal enemy_hit

func _ready():
	initial_pos = position
	var _unused = self.connect("body_entered", self, "_body_entered")
	hero = get_tree().get_nodes_in_group("heroes")[0]
	hero_hp = get_tree().get_nodes_in_group("hp")[0]
	_unused = self.connect("enemy_hit", hero, "_on_enemy_hit")
	_unused = self.connect("enemy_hit", hero_hp, "_on_enemy_hit")
	add_to_group("enemies")

	var screen = hero.get_node("camera").get_viewport_rect()
	screenx = screen.size.x
	screeny = screen.size.y


func _process(delta):

	if hp > 0:
		
		var dx = position.x - hero.position.x
		var dy = position.y - hero.position.y
		
		randomize()
		MAX_SPEED = randi() % 81 + 40 #randomizes bat's speed

		if dx < screenx/1.8 and dy < screeny and dx > -screenx/1.8 and dy > -screeny:
			if hero.position.x < position.x:
				$animation.set_flip_h(false)
		
				if velocity.x >= 80:
					velocity.x -= 30
				velocity.x += -WALK_SPEED
				if velocity.x <= -MAX_SPEED:
					velocity.x = -MAX_SPEED
			
			elif hero.position.x > position.x:
				$animation.set_flip_h(true)
		
				if velocity.x <= -80:
					velocity.x += 30
				velocity.x += WALK_SPEED
				if velocity.x >= MAX_SPEED:
					velocity.x = MAX_SPEED
			
			else:
				if velocity.x > DECELERATION:
					velocity.x += -DECELERATION
			
				elif velocity.x < -DECELERATION:
					velocity.x += DECELERATION
						
				else:
					velocity.x = 0
					
			if hero.position.y < position.y:
		
				if velocity.y >= 80:
					velocity.y -= 30
				velocity.y += -WALK_SPEED
				if velocity.y <= -MAX_SPEED:
					velocity.y = -MAX_SPEED

			elif hero.position.y > position.y:

				if velocity.y <= -80:
					velocity.y += 30
				velocity.y += WALK_SPEED
				if velocity.y >= MAX_SPEED:
					velocity.y = MAX_SPEED

			else:
				if velocity.y > DECELERATION:
					velocity.y += -DECELERATION

				elif velocity.y < -DECELERATION:
					velocity.y += DECELERATION

				else:
					velocity.y = 0

			translate(velocity * delta)


	else:
		var heart = drop.instance()
		var enemydeath = dead.instance()
		enemydeath = dead.instance()
		enemydeath.position = position
		get_node("..").add_child(enemydeath)
		randomize()
		if randi() % 10 == 1:
			heart.position = position
			get_node("../../collectibles").add_child(heart)
		
		queue_free()

func _body_entered(body):
	if "heroes" in body.get_groups():
		hit = true
		emit_signal("enemy_hit")