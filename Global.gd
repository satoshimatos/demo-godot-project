extends Node

var hero_hp = 100
var collectibles = {-1:0}
var stage = -1
var regen
var seconds = 600

func _ready():
	
	$timer.paused = true
	hero_hp = 0
	$Pause.pause_enabled = false
func set_stage(level):
	stage = level
	collectibles[stage] = 0

func set_timer(level):
	if level == -1:
		$timer.stop()
	if level == 0:
		$timer.start()
		seconds = 600
	if level == 1:
		$timer.start()
		seconds = 600
		
func _process(_delta):
	if collectibles[stage] == 10:
		if regen == false:
			regen = true
			$regen.start()
	else:
		regen = false
		$regen.stop()

func _on_regen_timeout():
	if hero_hp < 100 and hero_hp > 0:
		hero_hp += 1


func _on_timer_timeout():
	seconds -= 1