extends KinematicBody2D

const GRAVITY = 730.0
const WALK_SPEED = 15
const JUMP_SPEED = -320
const MAX_SPEED = 180
const DECELERATION = 29
const KNOCKBACK = 50

var bullet = preload ("res://pencil.tscn")
var charge = preload ("res://chargedshot.tscn")
var charging = 0
var velocity = Vector2()
var jump
var start = false
var shots = 0
var controls = true
var idle = false
var charger = false
var charge_loop = false
var global

func _ready():
	
	add_to_group("heroes")
	global = $"/root/Global"

func _physics_process(delta):
	if controls and start:
		global.get_node("Pause").pause_enabled = true
	else:
		global.get_node("Pause").pause_enabled = false
	if global.regen:
		$regen.emitting = true
	else:
		$regen.emitting = false
	if !Input.is_action_pressed("shoot"):
		$charge_loop.stop()
	if is_on_ceiling() and velocity.y < 0:
		velocity.y = 0
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
		$animation/anim.play("charge")
		if charge_loop == false:
			charge_loop = true
			if $charge.playing:
				$charge.stop()
			$charge_loop.play()
		charging = 1.05
	else:
		if $animation.visible == true:
			$animation/anim.play("normal")
	if charging <= 0:
		charging = 0

	$animation/charging.energy = charging
	if start:
		$animation.visible = true
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
	
		if Input.is_action_pressed("shoot") and controls:
			if charger == false:
				charger = true
				$charge.play()
			charging += delta * 1.2
	
		if Input.is_action_just_pressed("shoot") and shots <= 2 and controls:
			_shot()
	
	
		if Input.is_action_just_released("shoot") and controls:
			charger = false
			charge_loop = false
			$charge.stop()
			$charge_loop.stop()
			_shot_release()
	
	
	
		if Input.is_action_pressed("ui_left") and controls:
	
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
		elif Input.is_action_pressed("ui_right") and controls:
	
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
				if idle == false:
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
	
		if Input.is_action_just_pressed("jump") and controls:
			if is_on_floor() and jump == 0:
				jump = 1
				velocity.y = JUMP_SPEED
		elif Input.is_action_just_released("jump") and controls:
			if velocity.y < 0:
				jump = 1
				velocity.y = 0
	
	var _unused = move_and_slide(velocity, Vector2(0,-1))


func _on_enemy_armor_hit():
	velocity.y = 0
	start = false
	$Timer.start()
	$animation.play("damage")
	set_collision_mask_bit(0, false)
	set_collision_mask_bit(10, false)
	var enemies = get_tree().get_nodes_in_group("enemies_armor")
	var enemybat

	for enemy in enemies:
		if enemy.hit:
			enemy.hit = false
			enemybat = enemy
			break

	if enemybat.global_position.x > global_position.x:
		velocity.x = 0
		velocity.x = -KNOCKBACK
	if enemybat.global_position.x < global_position.x:
		velocity.x = 0
		velocity.x = KNOCKBACK

	get_parent().get_node("invincibilityframes").start()

func _on_enemy_hit():
	velocity.y = 0
	start = false
	$Timer.start()
	$animation.play("damage")
	set_collision_mask_bit(0, false)
	set_collision_mask_bit(10, false)
	var enemies = get_tree().get_nodes_in_group("enemies")
	var enemybat

	for enemy in enemies:
		if enemy.hit:
			enemy.hit = false
			enemybat = enemy
			break

	if enemybat.global_position.x > global_position.x:
		velocity.x = 0
		velocity.x = -KNOCKBACK
	if enemybat.global_position.x < global_position.x:
		velocity.x = 0
		velocity.x = KNOCKBACK

	get_parent().get_node("invincibilityframes").start()

func _on_boss_bosshit():
	velocity.y = 0
	start = false
	$Timer.start()
	$animation.play("damage")
	set_collision_mask_bit(0, false)
	set_collision_mask_bit(10, false)
	var boss = get_tree().get_nodes_in_group("boss")
	var enemybat

	for enemy in boss:
		if enemy.boss_hit:
			enemy.boss_hit = false
			enemybat = enemy
			break

	if enemybat.global_position.x > global_position.x:
		velocity.x = 0
		velocity.x = -KNOCKBACK
	if enemybat.global_position.x < global_position.x:
		velocity.x = 0
		velocity.x = KNOCKBACK

	get_parent().get_node("invincibilityframes").start()

func _got_hit_by_projectile():
	velocity.y = 0
	start = false
	$Timer.start()
	$animation.play("damage")
	set_collision_mask_bit(0, false)
	set_collision_mask_bit(10, false)
	var enemies = get_tree().get_nodes_in_group("projectiles")
	var enemybat

	for enemy in enemies:
		if enemy.hit:
			enemy.hit = false
			enemybat = enemy
			break
	
	if enemybat.global_position.x > global_position.x:
		velocity.x = 0
		velocity.x = -KNOCKBACK
	if enemybat.global_position.x < global_position.x:
		velocity.x = 0
		velocity.x = KNOCKBACK


	get_parent().get_node("invincibilityframes").start()

func _nodamagetimeout():
	set_collision_mask_bit(0, true)
	set_collision_mask_bit(10, true)

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
			if (Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right")) and jump == 0 and controls:
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

		

func _ready_to_start():
	start = true
	global.get_node("timer").paused = false
	$animation.self_modulate = Color (1,1,1,1)
	
func _on_Timer_timeout():
	start = true
	
func _on_boss_dead():
	controls = false
	
func _stage_cleared():
	$animation.play("hat")