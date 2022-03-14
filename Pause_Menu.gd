extends Node2D

const MAINMENU = preload("res://MainMenu.tscn")

var global_pause
var selection = 2
var select = true
var quit = false
var quit_selection = 2
var enter = true
var ready = false
var pause_global


func _ready():
	global_pause = $"/root/Global/Pause"
	global_pause.pause_enabled = true
	pause_global = get_tree().get_nodes_in_group("pause_global")[0]

func _process(_delta):
	if ready:
		visible = true
		if selection > 2:
			selection = 1
		if selection < 1:
			selection = 2
		if quit:
			if quit_selection > 2:
				quit_selection = 1
			if quit_selection < 1:
				quit_selection = 2
			if quit_selection == 1:
				$yes/anim.play("normal")
				$no/anim.play("selected")
				if Input.is_action_just_pressed("ui_accept") or Input.is_action_just_pressed("shoot"):
					enter = false
					$Timer.start()
					quit = false
					select = true
					selection = 2
					$quit_confirm.visible = false
					$yes.visible = false
					$no.visible = false
					
			if quit_selection == 2:
				$yes/anim.play("selected")
				$no/anim.play("normal")
				if Input.is_action_just_pressed("ui_accept") or Input.is_action_just_pressed("shoot"):
					var _unused = get_tree().change_scene("MainMenu.tscn")
					get_tree().paused = false
					select = true
					quit = false
					$quit_confirm.visible = false
					$yes.visible = false
					$no.visible = false
					pause_global.unpause()
					ready = false
					
		if selection == 2 and select:
			$resume/anim.play("selected")
			$quit/anim.play("normal")
			if Input.is_action_just_pressed("ui_accept") or Input.is_action_just_pressed("shoot"):
				get_tree().paused = false
				ready = false
				pause_global.unpause()
				
		elif selection == 1 and select:
			$resume/anim.play("normal")
			$quit/anim.play("selected")
			if (Input.is_action_just_pressed("ui_accept") or Input.is_action_just_pressed("shoot")) and enter:
				quit = true
				select = false
				quit_selection = 1
				$quit_confirm.visible = true
				$yes.visible = true
				$no.visible = true
	
		if Input.is_action_just_pressed("ui_up"):
			if select:
				selection += 1
		if Input.is_action_just_pressed("ui_down"):
			if select:
				selection -= 1
				
		if Input.is_action_just_pressed("ui_right"):
			if quit:
				quit_selection += 1
		if Input.is_action_just_pressed("ui_left"):
			if quit:
				quit_selection -= 1
	else:
		visible = false
		pause_global.unpause()
		
func _on_Timer_timeout():
	enter = true
	$Timer.stop()

func _on_no_mouse_entered():
	if quit and ready:
		quit_selection = 1

func _on_yes_mouse_entered():
	if quit and ready:
		quit_selection = 2

func _on_resume_mouse_entered():
	if ready:
		selection = 2

func _on_quit_mouse_entered():
	if ready and select:
		selection = 1

func reset():
	enter = false
	$Timer.start()
	quit = false
	select = true
	selection = 2
	$quit_confirm.visible = false
	$yes.visible = false
	$no.visible = false