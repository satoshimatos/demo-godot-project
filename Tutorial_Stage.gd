extends Node2D

var hero
var start = preload ("res://teleport_in.tscn")
var global

func _ready():

	global = get_node("/root/Global")
	global.set_stage(0)
	global.set_timer(0)
	global.hero_hp = 75

	var go = start.instance()
	add_child(go)
	hero = get_tree().get_nodes_in_group("heroes")[0]
	go.global_position = hero.global_position
	$Tutorials/Tutorials1.start = true
	$Tutorials/Tutorials2.start = false
	$Tutorials/Tutorials3.start = false
	$Tutorials/Tutorials4.start = false
	$Tutorials/Tutorials5.start = false
	$Tutorials/Tutorials6.start = false
	$Tutorials/Tutorials7.start = false
	$Tutorials/Tutorials8.start = false
	$Tutorials/Tutorials9.start = false
	$Tutorials/Tutorials10.start = false
	global.get_node("StageZERO/StageZERO_Intro").play()
	yield(global.get_node("StageZERO/StageZERO_Intro"),"finished")
	global.get_node("StageZERO/audio_controller").play("start")

func _process(_delta):
	if hero.position.x < 130 and $Tutorials/Tutorials1.start == true:
		$Tutorials/Tutorials2.start = true
		$Tutorials/Tutorials1.start = false
		$Tutorials/Tutorials3.start = true
		
	elif hero.position.x < -300 and $Tutorials/Tutorials3.start == true:
		$Tutorials/Tutorials2.start = false
		$Tutorials/Tutorials4.start = true
		$Tutorials/Tutorials5.start = true
		$Tutorials/Tutorials3.start = false
	
	elif hero.position.x > 300 and $Tutorials/Tutorials5.start == true:
		$Tutorials/Tutorials1.start = false
		$Tutorials/Tutorials2.start = false
		$Tutorials/Tutorials3.start = false
		$Tutorials/Tutorials4.start = false
		$Tutorials/Tutorials5.start = false
		$Tutorials/Tutorials6.start = true
		
	elif hero.position.x > 1350 and $Tutorials/Tutorials6.start == true:
		$Tutorials/Tutorials6.start = false
		$Tutorials/Tutorials7.start = true
		
	elif hero.position.x < 1000 and $Tutorials/Tutorials7.start == true:
		$Tutorials/Tutorials8.start = true
		$Tutorials/Tutorials7.start = false
	
	elif hero.position.x > 1950 and $Tutorials/Tutorials8.start == true:
		$Tutorials/Tutorials9.start = true
		$Tutorials/Tutorials8.start = false
		
	elif hero.position.x > 2250 and $Tutorials/Tutorials9.start == true:
		$Tutorials/Tutorials10.start = true
		$Tutorials/Tutorials9.start = false
		$Tutorials/Tutorials11.start = true