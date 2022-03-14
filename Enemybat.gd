extends Area2D


const WALK_SPEED = 1
const JUMP_SPEED = -300
const DECELERATION = 25
const KNOCKBACK = 300
const dead = preload("res://Dead.tscn")
const drop = preload("res://heart.tscn")

var velocity = Vector2()
var hero
var MAX_SPEED
var screenx
var screeny
var hp = 2
var hit = false


signal enemy_hit

func _ready():
	hero = get_tree().get_nodes_in_group("heroes")[0]
	self.connect("enemy_hit", hero, "_on_enemy_hit")
	self.connect("enemy_hit", get_node("../../hud/HP"), "_on_enemy_hit")
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

		if dx < screenx/1.8 && dy < screeny && dx > -screenx/1.8 && dy > -screeny:
			if hero.position.x < position.x:
				get_node("animation").set_flip_h(false)
		
				if velocity.x >= 80:
					velocity.x -= 30
				velocity.x += -WALK_SPEED
				if velocity.x <= -MAX_SPEED:
					velocity.x = -MAX_SPEED
			
			elif hero.position.x > position.x:
				get_node("animation").set_flip_h(true)
		
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

			var collide = translate(velocity * delta)


			if collide and collide.collider_id == hero.get_instance_id():
				hit = true
				emit_signal("enemy_hit")

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
