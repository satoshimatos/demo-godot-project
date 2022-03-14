extends Node2D

var shot = preload ("res://selectionshot.tscn")

export var choices = 4
var selection = 3
var animation = true
var credits = false

func _ready():
	$"/root/Global/StageZERO".stop()
	$"/root/Global/StageONE".stop()
	get_node("/root/Global").set_stage(-1)
	$"/root/Global/Pause".pause_enabled = false
	$screen_darkener/anim.play("fadein")

func _process(_delta):
	if credits == false:
		if selection > choices:
			selection = 1
		if selection <= 0:
			selection = 4
		
		if Input.is_action_just_pressed("ui_up") and animation == true:
			selection += 1
	
		elif Input.is_action_just_pressed("ui_down") and animation == true:
			selection -= 1
	
		if selection == 1:
			$start/anim.play("normal")
			$tutorial/anim.play("normal")
			$quit/anim.play("selected")
			$credits/anim.play("normal")
			$selector.position = $quit.get_position()
			$selector.position.x -= 40
		if selection == 2:
			$start/anim.play("normal")
			$quit/anim.play("normal")
			$tutorial/anim.play("selected")
			$credits/anim.play("normal")
			$selector.position = $tutorial.get_position()
			$selector.position.x -= 40
		if selection == 3:
			$tutorial/anim.play("normal")
			$quit/anim.play("normal")
			$start/anim.play("selected")
			$credits/anim.play("normal")
			$selector.position = $start.get_position()
			$selector.position.x -= 40
		if selection == 4:
			$tutorial/anim.play("normal")
			$quit/anim.play("normal")
			$start/anim.play("normal")
			$credits/anim.play("selected")
			$selector.position = $credits.get_position()
			$selector.position.x -= 40
	
		if Input.is_action_just_pressed("ui_accept") or Input.is_action_just_pressed("shoot"):
			if selection == 1:
				shot_instance()
			elif selection == 2:
				shot_instance()
			elif selection == 3:
				shot_instance()
			elif selection == 4:
				credits_show()
				credits = true
				
	elif credits == true:
		if Input.is_action_just_pressed("left_click") or Input.is_action_just_pressed("shoot") or Input.is_action_just_pressed("ui_accept"):
			$credits2.visible = false
			credits = false
			
func play_stage_one():
	if animation == false:
		var _unused = get_tree().change_scene("res://stageONE.tscn")

func play_tutorial():
	if animation == false:
		var _unused = get_tree().change_scene("res://Node2DTest.tscn")
		
func shot_instance():
	if animation == true:
		animation = false
		$shot.play()
		$selector.play("selected")
		$canvas/flash/anim.play("fadeout")
		$timer_tutorial.start()
		var accept = shot.instance()
		add_child(accept)
		accept.position = $selector.position
		accept.position.x += 7

func credits_show():
	$credits2.visible = true

func _on_timer_tutorial_timeout():
	$screen_darkener/anim.play("fadeout")


func _on_anim_animation_finished(_fadeout):
	if selection == 3:
		play_stage_one()
	if selection == 2:
		play_tutorial()
	if selection == 1:
		get_tree().quit()

func _on_start_mouse_entered():
	if animation:
		selection = 3
		$tutorial/anim.play("normal")
		$quit/anim.play("normal")
		$start/anim.play("selected")
		$credits/anim.play("normal")
		$selector.position = $start.get_position()
		$selector.position.x -= 40

func _on_tutorial_mouse_entered():
	if animation:
		selection = 2
		$start/anim.play("normal")
		$quit/anim.play("normal")
		$tutorial/anim.play("selected")
		$credits/anim.play("normal")
		$selector.position = $tutorial.get_position()
		$selector.position.x -= 40

func _on_quit_mouse_entered():
	if animation:
		selection = 1
		$start/anim.play("normal")
		$tutorial/anim.play("normal")
		$quit/anim.play("selected")
		$credits/anim.play("normal")
		$selector.position = $quit.get_position()
		$selector.position.x -= 40

func _on_credits_mouse_entered():
	if animation:
		selection = 4
		$start/anim.play("normal")
		$tutorial/anim.play("normal")
		$quit/anim.play("selected")
		$credits/anim.play("selected")
		$selector.position = $quit.get_position()
		$selector.position.x -= 40