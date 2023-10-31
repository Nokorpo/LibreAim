extends Control

var global_color := Color(0, 255, 255, 1)
var global_outline_color := Color(0,0,0)

var enable_crosshair := true
var enable_outline := true
var crosshair_inner_enable := true
var dot_enable := false

var dot_size := 6.0
var global_outline_width := 2.0
var global_crosshair_height := 4.0
var global_crosshair_width := 12.0
var global_crosshair_space := 5.0

var current_crosshair = {
	"top": [],
	"right": [],
	"bottom": [],
	"left": [],
	"dot": []
}

func _draw():
	load_save()
	if not enable_crosshair:
		return
	if crosshair_inner_enable:
		draw_part(current_crosshair["top"], global_color, global_outline_width, global_outline_color)
		draw_part(current_crosshair["right"], global_color, global_outline_width, global_outline_color)
		draw_part(current_crosshair["bottom"], global_color, global_outline_width, global_outline_color)
		draw_part(current_crosshair["left"], global_color, global_outline_width, global_outline_color)
	if dot_enable:
		draw_part(current_crosshair["dot"], global_color, global_outline_width, global_outline_color)

func _on_options_refresh_crosshair():
	queue_redraw()

func load_save():
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
	if DataManager.get_data("CrosshairColor") != null:
		global_color = Global.string_to_color(DataManager.get_data("CrosshairColor"))
	if DataManager.get_data("OutlineColor") != null:
		global_outline_color = Global.string_to_color(DataManager.get_data("OutlineColor"))
	current_crosshair["dot"] = [
		Vector2(-dot_size,-dot_size), #top left
		Vector2(dot_size,-dot_size), #top right
		Vector2(dot_size,dot_size), #bottom right
		Vector2(-dot_size,dot_size) #bottom left
	]
	current_crosshair["left"] = [
		Vector2(-global_crosshair_width-global_crosshair_space,-global_crosshair_height),  #top left
		Vector2(-global_crosshair_space,-global_crosshair_height), #top right
		Vector2(-global_crosshair_space,global_crosshair_height), #bottom right
		Vector2(-global_crosshair_width-global_crosshair_space,global_crosshair_height) #bottom left
	]
	current_crosshair["top"] = [
		Vector2(-global_crosshair_height,-global_crosshair_width-global_crosshair_space), #top left
		Vector2(global_crosshair_height,-global_crosshair_width-global_crosshair_space), #top right
		Vector2(global_crosshair_height,-global_crosshair_space), #bottom right
		Vector2(-global_crosshair_height,-global_crosshair_space) #bottom left
	]
	current_crosshair["right"] = [
		Vector2(global_crosshair_space,-global_crosshair_height), #top left
		Vector2(global_crosshair_width+global_crosshair_space,-global_crosshair_height), #top right
		Vector2(global_crosshair_width+global_crosshair_space,global_crosshair_height), #bottom right
		Vector2(global_crosshair_space,global_crosshair_height) #bottom left
	]
	current_crosshair["bottom"] = [
		Vector2(-global_crosshair_height, global_crosshair_space), #top left
		Vector2(global_crosshair_height,global_crosshair_space), #top right
		Vector2(global_crosshair_height,global_crosshair_space+global_crosshair_width), #bottom right
		Vector2(-global_crosshair_height,global_crosshair_space+global_crosshair_width) #bottom left
	]

func draw_part(points: PackedVector2Array, color: Color, outline_width: float, outline_color: Color):
	draw_polygon(points, [color])
	var polygon := Polygon2D.new()
	polygon.set_polygon(points)
	if enable_outline:
		draw_outline(polygon, outline_width, outline_color)
	
func draw_outline(polygon: Polygon2D, outline_width: float, outline_color: Color):
	var poly = polygon.get_polygon()
	for i in range(1 , poly.size()):
		draw_line(poly[i-1] , poly[i], outline_color , outline_width)
	draw_line(poly[poly.size() - 1] , poly[0], outline_color , outline_width)
