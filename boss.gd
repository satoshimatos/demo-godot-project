extends Area2D

var WALK_SPEED = .5
const JUMP_SPEED = -300
const DECELERATION = 25
const KNOCKBACK = 300
const MAX_SPEED = 120
const dead = preload("res://Dead.tscn")
const drop = preload("res://heart.tscn")
const boss_win = preload("res://boss_defeated.tscn")
const STAGE_CENTER = Vector2(150,-20)

var once = true
var charge = 500
var velocity = Vector2()
var hero
var play_once = true
var hp = 1
var boss_hit = false
var hp_hud
var patterns
var shot = preload ("res://musical_notes.tscn")
var shot_gravity = preload ("res://test_explosion.tscn")
var normalize = 0
var shooting = false
var teleporting = false
var attacking = false
var timer = false
var initial_pos
var tping = false
var last_pattern
var explo = preload ("res://explosion.tscn")
var explo_count = 0
var x = 0
var y = 1
var boss_hp
var boss_spawned = true
var pitch
var single_explosion_final = true
var global
var canstarttimer = false
var can_shoot = false
var charging_attacking = true
var chasing = true
var damaged = true

signal bosshit
signal boss_dead

func _ready():
	add_to_group("boss")
	global = $"/root/Global"
	randomize()
	var _unused = self.connect("body_entered", self, "_body_entered")
	hero = get_tree().get_nodes_in_group("heroes")[0]
	hp_hud = get_tree().get_nodes_in_group("hp")[0]
	boss_hp = get_tree().get_nodes_in_group("boss_hp")[0]
	
	_unused = self.connect("bosshit", hero, "_on_boss_bosshit")
	_unused = self.connect("bosshit", hp_hud, "_on_boss_bosshit")
	_unused = self.connect("boss_dead", hero, "_on_boss_dead")

	boss_hp.get_node("hpbar").visible = false
func _process(delta):
	if canstarttimer == false:
		global.get_node("timer").paused = true
		global.get_node("Pause").pause_enabled = false
	boss_hp.get_node("hpbar").value = hp
	normalize += delta
	if normalize >= 2:
		modulate = Color (1,1,1,1)
		normalize = 0

	#if Input.is_action_just_pressed("shoot"):
	#	patterns = randi() % 4
	#	hp = 0
	if hp > 40 and hp < 81 and boss_spawned == false:
		WALK_SPEED = 0.7
		
	if hp > 0 and hp < 41 and boss_spawned == false:
		WALK_SPEED = 0.9
		if damaged:
			damaged = false
			$explosion.play()
			$robot_damage.play()
		$damage.emitting = true
	if hp > 0:
		if boss_spawned == true:
			velocity.y = 30
			boss_hp.visible = true
			if global_position.y >= 30:
				if once:
					once = false
					$guitar.play("electric_pose")
					$pylons.play()
					yield($guitar,"animation_finished")
					$shock.play()
					$electricity.play()
					$guitar.play("electric_attack")
					$guitar/electricity.visible = true
				get_parent().get_node("blackscreen/anim").stop()
				get_parent().get_node("blackscreen/anim").play("fadein")

				velocity.y = 0
				if play_once:
					play_once = false
					$hp_charge_up.play()
					boss_hp.get_node("hpbar").visible = true
				hp += 1
				if hp >= 119:
					$hp_charge_up.stop()
					get_parent().get_node("music").play()
					hero.z_index = 0
					hp = 120
					hero.controls = true
					hero.start = true
					boss_spawned = false
					canstarttimer = true
					global.get_node("timer").paused = false
					global.get_node("Pause").pause_enabled = true

		if patterns == 0: #shaker
			attacking = false
			if tping == false:
				tping = true
				velocity.x = 0
				velocity.y = 0
				$anim.play("fadeout")
				yield($anim, "animation_finished")
				if patterns != 0:
					return
				global_position = STAGE_CENTER
				$anim.play("fadein")
				yield($anim, "animation_finished")
				$guitar.play("shaker_pose")
				yield($guitar,"animation_finished")
				$guitar.play("shaker_attack")
				if patterns != 0:
					return
				if get_tree().get_nodes_in_group("projectiles").size() <= 0:
					var music_spawn = shot_gravity.instance()
					add_child(music_spawn)
					music_spawn.global_position = global_position
			global_position = STAGE_CENTER
			global_position.x = randi() % 10 + 148

		if patterns == 1: #chaser

			attacking = false
			shooting = false
			teleporting = false
			if tping == false:
				tping = true
				velocity.x = 0
				velocity.y = 0
				$anim.play("fadeout")
				yield($anim, "animation_finished")
				if patterns != 1:
					return
				global_position = STAGE_CENTER
				$anim.play("fadein")
				yield($anim, "animation_finished")
				$guitar.play("electric_pose")
				$pylons.play()
				yield($guitar,"animation_finished")
				$shock.play()
				$collision.scale = Vector2(1.5, 1.5)
				$electricity.play()
				$guitar.play("electric_attack")
				$guitar/electricity.visible = true
				chasing = false
				if patterns != 1:
					return
		if chasing == false:
			follow()

		if patterns == 2: #charger
			$guitar.play("charger")
			tping = false
			if attacking:
				if charging_attacking:
					charging_attacking = false
					$charge_attack.play()
				if hp > 40:
					velocity.x = -charge*0.9
				else:
					velocity.x = -charge*1.3
				
				if position.x - initial_pos < -500:
					charging_attacking = true
					attacking = false
					timer = false
					velocity.x = 0
					velocity.y = 0
					$anim.play("fadeout")
					yield($anim, "animation_finished")
					if patterns != 2:
						return
					position.y = hero.position.y + 20
					position.x = hero.position.x + 120
					$anim.play("fadein")
			else:
				if timer == false:
					timer = true
					velocity.x = 0
					velocity.y = 0
					$anim.play("fadeout")
					yield($anim, "animation_finished")
					if patterns != 2:
						return
					position.y = hero.position.y + 20
					position.x = hero.position.x + 120
					$anim.play("fadein")
					yield($anim, "animation_finished")
					if patterns != 2:
						return
					
					if hp > 40:
						$anim.play("windup")
						$windup_timer.start()
						$charge_power_up.play()
					else:
						$anim.playback_speed = 1.2
						$anim.play("windup")
						$windup_timer_faster.start()
						$charge_power_up.pitch_scale = 0.6
						$charge_power_up.play()

		if patterns == 3: #shooter

			tping = false
			attacking = false
			teleporting = false
			if shooting == false:
				shooting = true
				velocity.x = 0
				velocity.y = 0
				$anim.play("fadeout")
				yield($anim, "animation_finished")
				if patterns != 3:
					return
				global_position = STAGE_CENTER
				$anim.play("fadein")
				yield($anim, "animation_finished")
				$guitar.play("turret_pose")
				yield($guitar,"animation_finished")
				$guitar/turret.visible = true
				$guitar.play("turret_attack")
				can_shoot = true
				if patterns != 3:
					return
			if can_shoot:
				music_shot()
			


		translate(velocity * delta)

	else:
		global.get_node("timer").paused = true
		global.get_node("Pause").pause_enabled = false
		if get_tree().get_nodes_in_group("projectiles").size() >= 0:
			for notes in get_tree().get_nodes_in_group("projectiles"):
				notes.queue_free()
		hero.set_collision_mask_bit(0, false)
		$guitar/turret.visible = false
		$damage_sound.stop()
		$pylons.stop()
		$charge_power_up.stop()
		$charge_attack.stop()
		$aim.stop()
		$anim.stop()
		$electricity.stop()
		$guitar/electricity.visible = false
		$guitar.rotation_degrees = 0
		$collision.disabled = true

		$guitar.play("dying")
		tping = false
		attacking = false
		teleporting = false
		shooting = false
		$windup_timer.stop()
		$pattern_change.stop()
		emit_signal("boss_dead")
		velocity.x = 0
		velocity.y = 0
		if explo_count == 0:
			$explosions.start()
			get_parent().get_node("music").stop()
			explo_count = 1
		elif explo_count >= 20 and explo_count < 26:
			if single_explosion_final:
				single_explosion_final = false
				$explosion_final.play()
			x += delta * 9
			$light.scale = Vector2(x, x)
			$explo.emitting = true
		elif explo_count >= 26 and explo_count < 30:
			$guitar.visible = false
			y -= delta*2
			$light.modulate = Color (1,1,1,y)
			$light2.visible = false
		elif explo_count >= 30:
			if single_explosion_final == false:
				single_explosion_final = true
				$explo/Timer.start()
				yield($explo/Timer,"timeout")
				get_parent().get_node("victory").play()
				yield(get_parent().get_node("victory"), "finished")
				var victory = boss_win.instance()
				global.add_child(victory)
				victory.global_position = hero.global_position
				queue_free()
			


func _body_entered(body):
	if "heroes" in body.get_groups():
		boss_hit = true
		emit_signal("bosshit")

func music_shot():
	if get_tree().get_nodes_in_group("projectiles").size() <= 0:
		$aim.play()
		$guitar/turret/anim.play("shot")
		var note = shot.instance()
		get_parent().add_child(note)
		note.global_position = $guitar/turret.global_position


func follow(): #chaser

	if hero.position.x < position.x:

		if velocity.x >= 80:
			velocity.x -= 30
		velocity.x += -WALK_SPEED
		if velocity.x <= -MAX_SPEED:
			velocity.x = -MAX_SPEED

	elif hero.position.x > position.x:

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

func _on_pattern_change_timeout():
	$aim.stop()
	$collision.scale = Vector2(1, 1)
	chasing = true
	modulate = Color(1,1,1,1)
	$electricity.stop()
	$guitar/electricity.visible = false
	can_shoot = false
	$guitar/turret.visible = false
	$guitar.play("normal")
	
	last_pattern = patterns
	patterns = randi() % 4

	while (last_pattern == patterns):
		patterns = randi() % 4
	if patterns == 2:
		timer = false
	else:
		timer = true

	$guitar.rotation_degrees = 0
	$collision.rotation_degrees = 0
	shooting = false
	tping = false

func _on_windup_timer_timeout():

	timer = false
	initial_pos = position.x
	attacking = true

func _on_windup_timer_faster_timeout():

	timer = false
	initial_pos = position.x
	attacking = true

func _on_explosions_timeout():
	
	explo_count += 1
	if explo_count <= 23:
		var explosion = explo.instance()
		$guitar/hit.play("hit")
		add_child(explosion)
		pitch = randi() % 11
		$explosion.pitch_scale = pitch/5 + 0.1
		$explosion.play()
		explosion.global_position.x = global_position.x + randi() % 81 - 40
		explosion.global_position.y = global_position.y + randi() % 81 - 40
