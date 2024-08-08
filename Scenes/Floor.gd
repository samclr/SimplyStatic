extends Polygon2D

var toggled
################################################
func _ready():
	hide()
	toggled = false
################################################
func _on_check_button_pressed():
	if not toggled:
		show()
		toggled = true
	else:
		hide()
		toggled = false
