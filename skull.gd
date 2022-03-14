extends Area2D


const WALK_SPEED = 80
const KNOCKBACK = 300
const dead = preload("res://Dead.tscn")
const drop = preload("res://heart.tscn")

var velocity = Vector2()
var hero
var hp = 6
var hit = false

signal enemy_hit

func _ready():

	var _unused = self.connect("body_entered", self, "_body_entered")
	hero = get_tree().get_nodes_in_group("heroes")[0]
	_unused = self.connect("enemy_hit", hero, "_on_enemy_armor_hit")
	_unused = self.connect("enemy_hit", get_node("../../hud/HP"), "_on_enemy_armor_hit")
	add_to_group("enemies_armor")

func _process(delta):
	$"enemy_hp_bar/progress".value = hp*2.5
	if $eyes.energy >= 1.2:
		$eyes.energy -= delta
	if $eyes.energy <= 0.6:
		$eyes.energy += delta
	if scale == Vector2(-1, 1):
		velocity.x = WALK_SPEED
	else:
		velocity.x = -WALK_SPEED

	if hp > 0:
		if $ray_collision_left.is_colliding():
			if scale == Vector2(1,1):
				$enemy_hp_bar.scale.x = -1
				set_scale(Vector2(-1,1))
			else:
				$enemy_hp_bar.scale.x = 1
				set_scale(Vector2(1,1))

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

func _body_entered(body):
	if "heroes" in body.get_groups():
		hit = true
		emit_signal("enemy_hit")