extends Control





var global_color = Color(0, 255, 255, 1)
var global_outline_color = Color(0,0,0)

var enable_crosshair = true
var enable_outline = true
var crosshair_inner_enable = true
var dot_enable = false

#var global_crosshair_height = DataManager.get_options("heigh", "float")
#var global_crosshair_width = DataManager.get_options("width", "float")

var dot_size = 3

var global_outline_width = 0.5 * 2

var global_crosshair_height = 1 * 2
var global_crosshair_width = 4 * 2
var global_crosshair_space = 1.5 * 2



var dot_crosshair = []


var left_inner_crosshair = []
var top_inner_crosshair = []
var right_inner_crosshair = []
var bottom_inner_crosshair = []

func loadSave():
	if DataManager.get_data("Crosshair") != null:
		enable_crosshair = DataManager.get_data("Crosshair")
	if DataManager.get_data("Outline") != null:
		enable_outline = DataManager.get_data("Outline")
	if DataManager.get_data("CrosshairInner") != null:
		crosshair_inner_enable = DataManager.get_data("CrosshairInner")
	if DataManager.get_data("Dot") != null:
		dot_enable = DataManager.get_data("Dot")
	if DataManager.get_data("DotSize") != null:
		dot_size = DataManager.get_data("DotSize")
	if DataManager.get_data("OutlineSize") != null:
		global_outline_width = DataManager.get_data("OutlineSize")
	if DataManager.get_data("CrosshairHeight") != null:
		global_crosshair_height = DataManager.get_data("CrosshairHeight")
	if DataManager.get_data("CrosshairWidth") != null:
		global_crosshair_width = DataManager.get_data("CrosshairWidth")
	if DataManager.get_data("CrosshairSpace") != null:
		global_crosshair_space = DataManager.get_data("CrosshairSpace")
	dot_crosshair = [
		Vector2(-dot_size,-dot_size), #top left
		Vector2(dot_size,-dot_size), #top right
		Vector2(dot_size,dot_size), #bottom right
		Vector2(-dot_size,dot_size) #bottom left
	]
	left_inner_crosshair = [
		Vector2(-global_crosshair_width-global_crosshair_space,-global_crosshair_height),  #top left
		Vector2(0-global_crosshair_space,-global_crosshair_height),#top right
		Vector2(0-global_crosshair_space,global_crosshair_height), #bottom right
		Vector2(-global_crosshair_width-global_crosshair_space,global_crosshair_height) #bottom left
	]
	top_inner_crosshair = [
		Vector2(-global_crosshair_height,-global_crosshair_width-global_crosshair_space),  #top left
		Vector2(global_crosshair_height,-global_crosshair_width-global_crosshair_space),#top right
		Vector2(global_crosshair_height,-global_crosshair_space), #bottom right
		Vector2(-global_crosshair_height,-global_crosshair_space) #bottom left
	]
	right_inner_crosshair = [
		Vector2(0+global_crosshair_space,-global_crosshair_height),  #top left
		Vector2(global_crosshair_width+global_crosshair_space,-global_crosshair_height),#top right
		Vector2(global_crosshair_width+global_crosshair_space,global_crosshair_height),#bottom right
		Vector2(0+global_crosshair_space,global_crosshair_height) #bottom left
	]
	bottom_inner_crosshair = [
		Vector2(-global_crosshair_height, global_crosshair_space),  #top left
		Vector2(global_crosshair_height,global_crosshair_space),#top right
		Vector2(global_crosshair_height,global_crosshair_space+global_crosshair_width), #bottom right
		Vector2(-global_crosshair_height,global_crosshair_space+global_crosshair_width) #bottom left
	]


func redraw(_value):
	queue_redraw()

func _draw():
	loadSave()
	if dot_enable and enable_crosshair:
		polygonDrawer(dot_crosshair, global_color, global_outline_width, global_outline_color)
	
	if crosshair_inner_enable and enable_crosshair:
		polygonDrawer(left_inner_crosshair, global_color, global_outline_width, global_outline_color)
		polygonDrawer(top_inner_crosshair, global_color, global_outline_width, global_outline_color)
		polygonDrawer(right_inner_crosshair, global_color, global_outline_width, global_outline_color)
		polygonDrawer(bottom_inner_crosshair, global_color, global_outline_width, global_outline_color)

func polygonDrawer(polygon_points, color, outline_width, outline_color):
	var points = PackedVector2Array()
	var colour = PackedColorArray()
	points = polygon_points
	colour = [color]
	draw_polygon(points,colour)
	var polygon = Polygon2D.new()
	polygon.set_polygon(points)
	outlinePolygonDrawer(polygon, outline_width, outline_color)
	
func outlinePolygonDrawer(polygon, outline_width, outline_color):
	if enable_outline:
		var poly = polygon.get_polygon()
		for i in range(1 , poly.size()):
			draw_line(poly[i-1] , poly[i], outline_color , outline_width)
		draw_line(poly[poly.size() - 1] , poly[0], outline_color , outline_width)


func _on_options_refresh_crosshair():
	queue_redraw()
