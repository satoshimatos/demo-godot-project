extends Node2D

var selection = 1

func _ready():
	$"/root/Global/StageONE".stop()
	get_node("/root/Global").set_stage(-1)

func _process(_delta):

	if selection == 0:
		$quit/anim.play("selected")
		$continue_game/anim.play("normal")

	if selection == 1:
		$quit/anim.play("normal")
		$continue_game/anim.play("selected")
	
	if Input.is_action_just_pressed("ui_accept") or Input.is_action_just_pressed("shoot"):
		if selection == 1:
			var _unused = get_tree().change_scene("res://MainMenu.tscn")
		elif selection == 0:
			get_tree().quit()
	
func _on_quit_mouse_entered():
	selection = 0
	$quit/anim.play("selected")
	$continue_game/anim.play("normal")


func _on_credits_mouse_entered():
	selection = 1
	$quit/anim.play("normal")
	$continue_game/anim.play("selected")
