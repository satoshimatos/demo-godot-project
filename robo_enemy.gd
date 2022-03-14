extends Area2D

const MAX_SPEED = 150
const WALK_SPEED = 1
const JUMP_SPEED = -300
const DECELERATION = 1
const KNOCKBACK = 300
const dead = preload("res://Dead.tscn")
const drop = preload("res://heart.tscn")

var initial_pos
var velocity = Vector2()
var hero
var initial_hp = 3
var hp = initial_hp
var hit = false
var hero_hp
var speed_reset
var on_screen = false

signal enemy_hit

func _ready():
	initial_pos = global_position
	var _unused = self.connect("body_entered", self, "_body_entered")
	hero = get_tree().get_nodes_in_group("heroes")[0]
	hero_hp = get_tree().get_nodes_in_group("hp")[0]
	_unused = self.connect("enemy_hit", hero, "_on_enemy_hit")
	_unused = self.connect("enemy_hit", hero_hp, "_on_enemy_hit")
	add_to_group("enemies")

func _process(delta):
	$"enemy_hp_bar/progress".value = hp*5
	if hp > 0:
		
		randomize()

		if on_screen == true:
			if hero.global_position.x < global_position.x:
				if speed_reset == true:
					speed_reset = false
					velocity.x = 0
					velocity.y = 0
					
				if velocity.x >= 80:
					velocity.x -= 30
				velocity.x += -WALK_SPEED
				if velocity.x <= -MAX_SPEED:
					velocity.x = -MAX_SPEED
			
			elif hero.global_position.x > global_position.x:


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
					
			if hero.global_position.y < global_position.y:
		
				if velocity.y >= 80:
					velocity.y -= 30
				velocity.y += -WALK_SPEED
				if velocity.y <= -MAX_SPEED:
					velocity.y = -MAX_SPEED

			elif hero.global_position.y > global_position.y:

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
		else:
			hp = initial_hp
			speed_reset = true
			if global_position.x > initial_pos.x:
				velocity.x = -MAX_SPEED
			if global_position.x < initial_pos.x:
				velocity.x = MAX_SPEED
			if global_position.y > initial_pos.y:
				velocity.y = -MAX_SPEED
			if global_position.y < initial_pos.y:
				velocity.y = MAX_SPEED
			
		translate(velocity * delta)


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

func _body_entered(body):
	if "heroes" in body.get_groups():
		hit = true
		emit_signal("enemy_hit")

func _on_VisibilityNotifier2D_screen_exited():
	on_screen = false
func _on_visibility_screen_entered():
	on_screen = true