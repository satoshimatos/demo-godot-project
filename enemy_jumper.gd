extends Area2D

const GRAVITY = 650
const JUMP_SPEED = -600

var velocity = Vector2()
var initial_pos
var hp = 3
var drop = preload("res://heart.tscn")
var dead = preload("res://Dead.tscn")
var hero
var hit = false
export var delay = 0.01

signal enemy_hit

func _ready():
	$delay.wait_time = delay
	$delay.start()
	var _unused = self.connect("body_entered", self, "_body_entered")
	hero = get_tree().get_nodes_in_group("heroes")[0]
	_unused = self.connect("enemy_hit", hero, "_on_enemy_hit")
	_unused = self.connect("enemy_hit", get_node("../../hud/HP"), "_on_enemy_hit")
	add_to_group("enemies")

	initial_pos = position

func _process(delta):
	$"enemy_hp_bar/progress".value = hp*5
	if hp > 0:
		$spinning.play("spin")
		velocity.y += delta * GRAVITY
		translate(velocity * delta)
	else:
		var heart = drop.instance()
		var enemydeath = dead.instance()
		enemydeath.position = position
		get_node("..").add_child(enemydeath)
		randomize()
		if randi() % 10 == 1:
			heart.position = position
			get_node("../../collectibles").add_child(heart)
		
		queue_free()

func _on_jump_timer_timeout():
	velocity.y = 0
	position = initial_pos
	velocity.y = JUMP_SPEED

func _body_entered(body):
	if "heroes" in body.get_groups():
		hit = true
		emit_signal("enemy_hit")

func _on_delay_timeout():
	$jump_timer.start()
