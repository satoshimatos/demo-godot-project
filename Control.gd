extends Control

func _on_Button_pressed():
	var _unused = get_tree().change_scene("res://Node2DTest.tscn")


func _on_Button2_pressed():
	get_tree().quit()