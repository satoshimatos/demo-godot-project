extends Node2D

var pause_enabled = true

func _ready():
	add_to_group("pause_global")
	pass

func _process(_delta):
	if get_tree().paused == true:
		for song in get_tree().get_nodes_in_group("music"):
			song.volume_db = -20
	if Input.is_action_just_pressed("pause") and pause_enabled:
		if get_tree().paused == false:
			for song in get_tree().get_nodes_in_group("music"):
				song.volume_db = -20
				$"../CanvasLayer/Pause_Menu".ready = true
			get_node("../CanvasLayer/pause_dark_screen").visible = true
			get_tree().paused = true
		else:
			unpause()
			
func unpause():
	$"../CanvasLayer/Pause_Menu".reset()
	for song in get_tree().get_nodes_in_group("music"):
		if pause_enabled == true:
			song.volume_db = -4
		$"../CanvasLayer/Pause_Menu".ready = false
	get_node("../CanvasLayer/pause_dark_screen").visible = false
	get_tree().paused = false