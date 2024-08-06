extends Node2D

#REMEMBER, viewport_width == the x coordinate of the right side of the screen for the mouse (NOT FOR DREAWING)
#FOR MOUSE x=0 at left side and y = 0 at top with viewport_height being the y cord at bottom of screen
#_draw has different coordinate system because it is based off node2d so base everything off the orgin.

const grid_seperation = 20.5 # make in multiples of 5 and ending in .5
@export var grid_hover_tolerance = 5 # amount of tolerance you want around each cordinate intersection for clicking
########################################################################
const mouse_pixel = grid_seperation*2
var viewport_width
var viewport_height
var drawing_counter = 0

func _ready(): # not really needed since we update it in _draw (saving just incase)
	var viewport_size = get_window().get_size()
	viewport_width = viewport_size.x
	viewport_height = viewport_size.y
	print("Viewport width: ", viewport_width)
	print("Viewport height: ", viewport_height)

func _process(_delta):
	if Input.is_action_just_pressed('ui_accept'):
		queue_redraw()


func _draw():
	print('drawing: ', drawing_counter)
	drawing_counter += 1
	
	var viewport_size = get_window().get_size()
	viewport_width = viewport_size.x
	viewport_height = viewport_size.y
	
	draw_line(Vector2(0, -viewport_height/2), Vector2(0, viewport_height/2), Color.BLACK, 2.0)
	draw_line(Vector2(-viewport_width, 0), Vector2(viewport_width, 0), Color.BLACK, 2.0)
	
	var i = grid_seperation
	while i <= viewport_width: # FOR VERTICAL LINES
		draw_line(Vector2(i, -viewport_height/2), Vector2(i, viewport_height/2), Color.BLACK, 1.0)
		draw_line(Vector2(-i, -viewport_height/2), Vector2(-i, viewport_height/2), Color.BLACK, 1.0)
		i += grid_seperation
		
	i = grid_seperation
	while i <= viewport_height: # FOR HORIZOTNAL LINES
		draw_line(Vector2(-viewport_width/2, -i), Vector2(viewport_width/2, -i), Color.BLACK, 1.0)
		draw_line(Vector2(-viewport_width/2, i), Vector2(viewport_width/2, i), Color.BLACK, 1.0)
		i += grid_seperation
	
	draw_circle(Vector2(2*grid_seperation, grid_seperation), 3, Color.RED)
	
	print("Viewport Resolution is: ", get_viewport().get_visible_rect().size)
	print(viewport_width, " ",  viewport_height)

func _input(event):
	
	if event is InputEventMouseButton:
		var x = event.position.x 
		var y = event.position.y
		print("Mouse Click/Unclick at: ", event.position)
		
		#FOR QUAD 1 & 4
		var i = viewport_width/2 
		while i <= viewport_width: #from orgin to right side of page
			####################################################################################
			if abs(x - i) <= grid_hover_tolerance: #checks if x position is within 5 pixels of a verical line
				print('by a vertical line')
				i = viewport_height/2 #from orgin to bottom of screen
				while i <= viewport_width:
					if abs(y - i) <= grid_hover_tolerance: #checks if y position is within 5 pixels of a horizontal line
						print('by a horizontal line')
						break
					i += mouse_pixel
					############################################################################
				i = viewport_height/2 #from orgin to top of screen
				while i >= 0:
					if abs(y - i) <= grid_hover_tolerance: #checks if y position is within 5 pixels of a horizontal line
						print('by a horizontal line')
						break
					i -= mouse_pixel
				break
			i += mouse_pixel
			
		#FOR QUAD 2 & 3
		i = viewport_width/2 
		while i >= 0: #from orgin to left side of page
			####################################################################################
			if abs(x - i) <= grid_hover_tolerance: #checks if x position is within 5 pixels of a verical line
				print('by a vertical line')
				i = viewport_height/2 #from orgin to bottom of screen
				while i <= viewport_width:
					if abs(y - i) <= grid_hover_tolerance: #checks if y position is within 5 pixels of a horizontal line
						print('by a horizontal line')
						break
					i += mouse_pixel
					############################################################################
				i = viewport_height/2 #from orgin to top of screen
				while i >= 0:
					if abs(y - i) <= grid_hover_tolerance: #checks if y position is within 5 pixels of a horizontal line
						print('by a horizontal line')
						break
					i -= mouse_pixel
				break
			i -= mouse_pixel
	
	elif event == InputEventMouseMotion: #CHANGE == to is for it to be active
		
		var x = event.position.x 
		var y = event.position.y
		if x == viewport_width/2 and y == viewport_height/2 :
				print("Mouse at orgin")
		
		var ii = viewport_width/2 
		while ii < viewport_width: #from orgin to right side of page
			if x == ii:
				print('at a vertical line')
			ii += mouse_pixel
		
		ii = viewport_width/2 
		while ii > -viewport_width: #from orgin to left side of page
			if x == ii:
				print('at a vertical line')
			ii -= mouse_pixel
			
			# a little worried about using for while loops inside the mouse motion event as this will probably be alot of 
			#work for the computer, maybe we try to find all intersection points and add them to a list each time the 
			# _draw function is run so that we dont have to constantly be checking mouse movement, or if we add a 
			#range of area around intersection points
			# to the mouse click then its only ran when they click so its not that deep.
	

