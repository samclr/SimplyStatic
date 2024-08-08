extends Node2D

#REMEMBER, viewport_width == the x coordinate of the right side of the screen for the mouse (NOT FOR DREAWING)
#FOR MOUSE x=0 at left side and y = 0 at top with viewport_height being the y cord at bottom of screen
#_draw has different coordinate system because it is based off node2d so base everything off the orgin

@export var grid_seperation = 40.5 # make in multiples of 5 and ending in .5
@export var grid_hover_tolerance = 5 # amount of tolerance you want around each cordinate intersection for clicking
########################################################################
var mouse_pixel = grid_seperation*2 #based on a camera zoom of 2 in $Camera2D, does not scale linearly
var viewport_width
var viewport_height
var drawing_counter = 1
var point_counter = 1
var points_uncorrected = {}
@onready var polygon_node = $Shape


func _ready():
	var viewport_size = get_window().get_size()
	viewport_width = viewport_size.x
	viewport_height = viewport_size.y

func _process(_delta):
	if Input.is_action_just_pressed('ui_accept'):
		queue_redraw()


func _draw():
	print('drawing: ', drawing_counter)
	drawing_counter += 1
	
	convert_points()
	
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
	
	for key in points_uncorrected:
		var point_position = points_uncorrected[key]
		var x = int(point_position[0])
		var y = int(point_position[1])
		draw_circle(Vector2(x, y), 5, Color.TURQUOISE)
	
	print("Viewport Resolution is: ", get_viewport().get_visible_rect().size)

func _input(event):
	
	if event is InputEventMouseButton:
		if event.pressed:
			var x = event.position.x 
			var y = event.position.y
			var point_added = false
			print("Mouse Click/Unclick at: ", event.position)
			
			#FOR QUAD 1 & 4
			var i = viewport_width/2 
			while i <= viewport_width: #from orgin to right side of page
				####################################################################################
				if abs(x - i) <= grid_hover_tolerance: #checks if x position is within 5 pixels of a verical line
					print('by a vertical line')
					var j = viewport_height/2 # from orgin to bottom of screen
					while j <= viewport_height:
						if abs(y - j) <= grid_hover_tolerance: #checks if y position is within 5 pixels of a horizontal line
							print('by a horizontal line')
							points_uncorrected["point " + str(point_counter)] = [(i - (viewport_width/2))/2,(j-(viewport_height/2))/2] #adds points to a group
							point_counter += 1
							print(points_uncorrected)
							point_added = true 
							break
						j += mouse_pixel
						############################################################################
					if point_added == false: #prevents double point addition at x and y intercepts
						j = viewport_height/2 #from orgin to top of screen
						while j >= 0:
							if abs(y - j) <= grid_hover_tolerance: #checks if y position is within 5 pixels of a horizontal line
								print('by a horizontal line')
								points_uncorrected["point " + str(point_counter)] = [(i - (viewport_width/2))/2,(j-(viewport_height/2))/2] #adds points to a group
								point_counter += 1
								print(points_uncorrected)
								point_added = true 
								break
							j -= mouse_pixel
						break
				i += mouse_pixel
				
			if point_added == false : #prevents double point addition at x and y intercepts
				#FOR QUAD 2 & 3
				i = viewport_width/2 
				while i >= 0: #from orgin to left side of page
				####################################################################################
					if abs(x - i) <= grid_hover_tolerance: #checks if x position is within 5 pixels of a verical line
						print('by a vertical line')
						var j = viewport_height/2 #from orgin to bottom of screen
						while j <= viewport_height:
							if abs(y - j) <= grid_hover_tolerance: #checks if y position is within 5 pixels of a horizontal line
								print('by a horizontal line')
								points_uncorrected["point " + str(point_counter)] = [(i - (viewport_width/2))/2,(j-(viewport_height/2))/2] #adds points to a group
								point_counter += 1
								print(points_uncorrected)
								point_added = true
								break
							j += mouse_pixel
							############################################################################
						if point_added == false: #prevents double point addition at x and y intercepts
							j = viewport_height/2 #from orgin to top of screen
							while j >= 0:
								if abs(y - j) <= grid_hover_tolerance: #checks if y position is within 5 pixels of a horizontal line
									print('by a horizontal line')
									points_uncorrected["point " + str(point_counter)] = [(i - (viewport_width/2))/2,(j-(viewport_height/2))/2] #adds points to a group
									point_counter += 1
									print(points_uncorrected)
									point_added = true 
									break
								j -= mouse_pixel
							break
					i -= mouse_pixel
			queue_redraw()
			
func convert_points():
	var shape_points : Array = []
	for key in points_uncorrected.keys():
		var point = points_uncorrected[key]
		# Ensure that the point is a list or array with exactly 2 elements
		if point.size() == 2:
			shape_points.append(Vector2(point[0], point[1]))
	if polygon_node:
		# Update the polygon with the points from the list
		polygon_node.polygon = shape_points
		
