extends KinematicBody2D

const GRAVITY = 730.0
const WALK_SPEED = 15
const JUMP_SPEED = -320
const MAX_SPEED = 180
const DECELERATION = 29
const KNOCKBACK = 300

var bullet = preload ("res://pencil.tscn")
var charge = preload ("res://chargedshot.tscn")
var charging = 0
var velocity = Vector2()
var jump


var shots = 0

func _ready():
	add_to_group("heroes")

func _physics_process(delta):
	if shots != 0:
		print(shots)
	shots -= delta * 1.4
	if shots < 0:
		shots = 0
	if shots >= 3:
		shots = 3
	$animation/charging/anim.play("flashing")
	$animation/charging/anim.playback_speed = charging * 3

	if $animation.flip_h:
		$animation/charging.scale = Vector2(-1.5, 1.3)
	else:
		$animation/charging.scale = Vector2(1.5, 1.3)

	if charging > 1:
		charging = 1.05
	if charging <= 0:
		charging = 0

	$animation/charging.energy = charging
	velocity.y += delta * GRAVITY
	charging -= delta/2

	if is_on_floor():
		$animation/charging.global_position.y = global_position.y - 3
		velocity.y = 10
		jump = 0
	else:
		$animation/charging.global_position.y = global_position.y - 10
		if charging < 0.2:
			$animation.play("jumping")
		else:
			$animation.play("jumping_charging")
	#gotta edit this---------------------------------------------------------------------------
	if Input.is_action_pressed("shoot"):

			charging += delta * 1.2

	if Input.is_action_just_pressed("shoot") and shots <= 2:
		_shot()


	if Input.is_action_just_released("shoot"):
		_shot_release()

 #look at var shot

	if Input.is_action_pressed("ui_left"):

		$animation.flip_h = true

		if velocity.x >= 250:
			velocity.x -= 200
		velocity.x += -WALK_SPEED
		if velocity.x <= -MAX_SPEED:
			velocity.x = -MAX_SPEED

		if is_on_floor():
			if charging < 0.2:
				$animation.play("running")
			else:
				$animation.play("running_charging")
	elif Input.is_action_pressed("ui_right"):

		$animation.flip_h = false

		if velocity.x <= -250:
			velocity.x += 200
		velocity.x += WALK_SPEED
		if velocity.x >= MAX_SPEED:
			velocity.x = MAX_SPEED

		if is_on_floor():
			if charging < 0.2:
				$animation.play("running")
			else:
				$animation.play("running_charging")

	else:
		if is_on_floor() and jump == 0:
			if charging < 0.2:
				$animation.play("idle")
			else:
				$animation.play("idle_charging")
			if velocity.x > DECELERATION:
				velocity.x += -DECELERATION

			elif velocity.x < -DECELERATION:
				velocity.x += DECELERATION

			else:
				velocity.x = 0

	if Input.is_action_just_pressed("jump"):
		if is_on_floor() and jump == 0:
			jump = 1
			velocity.y = JUMP_SPEED
	elif Input.is_action_just_released("jump"):
		if velocity.y < 0:
			jump = 1
			velocity.y = 0


    # We don't need to multiply velocity by delta because MoveAndSlide already takes delta time into account.

    # The second parameter of move_and_slide is the normal pointing up.
    # In the case of a 2d platformer, in Godot upward is negative y, which translates to -1 as a normal.
	#Study later > velocity = move_and_slide_with_snap(velocity, Vector2(0, -1), Vector2(0,32)) # Used to define floor or ceiling based on the coordinates.
	var _unused = move_and_slide(velocity, Vector2(0,-1))


func _on_enemy_armor_hit():
	set_collision_mask_bit(0, false)
	var armor = get_tree().get_nodes_in_group("enemies_armor")
	var enemybat

	for enemy in armor:
		if enemy.hit:
			enemy.hit = false
			enemybat = enemy
			break

	if enemybat.position.x > position.x:
		velocity.x = -KNOCKBACK
	if enemybat.position.x < position.x:
		velocity.x = KNOCKBACK
	if enemybat.position.y > position.y:
		velocity.y = -KNOCKBACK
	if enemybat.position.y < position.y:
		velocity.y = -KNOCKBACK

	get_parent().get_node("invincibilityframes").start()

func _on_enemy_hit():
	set_collision_mask_bit(0, false)
	var enemies = get_tree().get_nodes_in_group("enemies")
	var enemybat

	for enemy in enemies:
		if enemy.hit:
			enemy.hit = false
			enemybat = enemy
			break

	if enemybat.position.x > position.x:
		velocity.x = -KNOCKBACK
	if enemybat.position.x < position.x:
		velocity.x = KNOCKBACK
	if enemybat.position.y > position.y:
		velocity.y = -KNOCKBACK
	if enemybat.position.y < position.y:
		velocity.y = -KNOCKBACK

	get_parent().get_node("invincibilityframes").start()

func _on_boss_bosshit():
	set_collision_mask_bit(0, false)
	var boss = get_tree().get_nodes_in_group("boss")
	var enemybat

	for enemy in boss:
		if enemy.boss_hit:
			enemy.boss_hit = false
			enemybat = enemy
			break

	if enemybat.position.x > position.x:
		velocity.x = -KNOCKBACK
	if enemybat.position.x < position.x:
		velocity.x = KNOCKBACK
	if enemybat.position.y > position.y:
		velocity.y = -KNOCKBACK
	if enemybat.position.y < position.y:
		velocity.y = -KNOCKBACK

	get_parent().get_node("invincibilityframes").start()

func _got_hit():
	set_collision_mask_bit(0, false)
	var vaccine = get_tree().get_nodes_in_group("enemies")
	var syringe

	for enemy in vaccine:
		if enemy.hit:
			enemy.hit = false
			syringe = enemy
			break

	if syringe.position.x > position.x:
		velocity.x = 0
		velocity.x = -KNOCKBACK
	if syringe.position.x < position.x:
		velocity.x = 0
		velocity.x = KNOCKBACK


	get_parent().get_node("invincibilityframes").start()

func _nodamagetimeout():
	set_collision_mask_bit(0, true)

func _shot():
	charging = 0
	var shot = bullet.instance()
	if get_global_mouse_position().x > global_position.x:
		$animation.flip_h = false
		shot.get_node("pencilphysics").flipping = false
	else:
		shot.get_node("pencilphysics").flipping = true
		$animation.flip_h = true
	shot.position = position
	get_parent().add_child(shot)

	if jump == 1:
		shot.position.y += -5

func _shot_release():
	if charging > 1:

			var charged = charge.instance()
			charged.position = position
			if (Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right")) and jump == 0:
				charged.position.y += -10
			elif jump == 1:
				charged.position.y += -20
			else:
				charged.position.y += -10
			if get_global_mouse_position().x > global_position.x:
				$animation.flip_h = false
			else:
				$animation.flip_h = true
				charged.get_node("chargedshot").flipping = true

			get_parent().add_child(charged)
			charging = 0
