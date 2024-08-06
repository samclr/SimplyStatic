extends Node2D

var viewport_width
var viewport_height
var counter = 0

func _ready():
	var viewport_size = get_window().get_size()
	viewport_width = viewport_size.x
	viewport_height = viewport_size.y
	print("Viewport width: ", viewport_width)
	print("Viewport height: ", viewport_height)

func _process(delta):
	if Input.is_action_just_pressed('ui_accept'):
		queue_redraw()


func _draw():
	print('drawing: ', counter)
	counter += 1
	
	draw_line(Vector2(0, -viewport_height/2), Vector2(0, viewport_height/2), Color.BLACK, 2.0)
	draw_line(Vector2(-viewport_width, 0), Vector2(viewport_width, 0), Color.BLACK, 2.0)
	
	var i = 20.5 
	while i <= viewport_width: # FOR VARTICAL LINES
		draw_line(Vector2(i, -viewport_height/2), Vector2(i, viewport_height/2), Color.BLACK, 1.0)
		draw_line(Vector2(-i, -viewport_height/2), Vector2(-i, viewport_height/2), Color.BLACK, 1.0)
		i += 20.5
		
	i = 20.5
	while i <= viewport_height: # FOR HORIZOTNAL LINES
		draw_line(Vector2(-viewport_width/2, -i), Vector2(viewport_width/2, -i), Color.BLACK, 1.0)
		draw_line(Vector2(-viewport_width/2, i), Vector2(viewport_width/2, i), Color.BLACK, 1.0)
		i += 20.5
	
	

	print("Viewport Resolution is: ", get_viewport().get_visible_rect().size)
