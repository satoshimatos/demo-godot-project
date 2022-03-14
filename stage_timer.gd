extends Timer

var global
var minutes
var seconds
var time
var hero
var hurry = true

func _ready():
	add_to_group("timer")
	global = $"/root/Global"

func _process(_delta):
	hero = get_tree().get_nodes_in_group("heroes")[0]
	time = global.seconds
	minutes = ceil(time / 60)
	seconds = ceil(time % 60)
	if minutes < 10 and seconds >= 10:
		$text.set_text(str("0", minutes, ":", seconds))
	elif minutes < 10 and seconds < 10:
		$text.set_text(str("0", minutes, ":", "0", seconds))
	elif minutes >= 10 and seconds < 10:
		$text.set_text(str(minutes, ":", "0", seconds))
	else:
		$text.set_text(str(minutes, ":", seconds))
	if time == 300:
		$text/anim.play("flash")
	
	if time == 240:
		$text/anim.play("flash")
	
	if time == 180:
		$text/anim.play("flash")

	if time == 120:
		$text/anim.play("flash")

	if time == 60 and hurry:
		hurry = false
		$time_up.play()
		$text/anim.play("flash")

	if time <= 30 and time > 0:
		
		$text/anim2.play("loop")

	if time <= 0:
		hero.velocity.x = 0
		hero.velocity.y = 0
		$"/root/Global".hero_hp = 0
