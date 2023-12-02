extends Control

var color := Color(0, 255, 255, 1)
var outline_color := Color(0,0,0)

var enable_outline := true
var dot_enable := false

var dot_size := 6.0
var outline_width := 1.0
var crosshair_thickness := 2.0
var crosshair_length := 12.0
var crosshair_gap := 5.0

var current_crosshair = {
	"top": [],
	"right": [],
	"bottom": [],
	"left": [],
	"dot": []
}

func _draw():
	load_save()
	
	draw_part(current_crosshair["top"], color, outline_width, outline_color)
	draw_part(current_crosshair["right"], color, outline_width, outline_color)
	draw_part(current_crosshair["bottom"], color, outline_width, outline_color)
	draw_part(current_crosshair["left"], color, outline_width, outline_color)
	if dot_enable:
		draw_part(current_crosshair["dot"], color, outline_width, outline_color)

func _on_options_refresh_crosshair():
	queue_redraw()

func load_save():
	var category = DataManager.categories.CROSSHAIR
	dot_enable = set_parameter_if_exists(dot_enable, "dot")
	dot_size = set_parameter_if_exists(dot_size, "dot_size")
	crosshair_length = set_parameter_if_exists(crosshair_length, "crosshair_length")
	crosshair_thickness = set_parameter_if_exists(crosshair_thickness, "crosshair_thickness")
	crosshair_gap = set_parameter_if_exists(crosshair_gap, "crosshair_gap")
	enable_outline = set_parameter_if_exists(enable_outline, "outline_enable")
	outline_width = set_parameter_if_exists(outline_width, "outline_width")
	color = set_color_if_exists(color, "color")
	outline_color = set_color_if_exists(outline_color, "outline_color")
	
	current_crosshair["dot"] = [
		Vector2(-dot_size,-dot_size), #top left
		Vector2(dot_size,-dot_size), #top right
		Vector2(dot_size,dot_size), #bottom right
		Vector2(-dot_size,dot_size) #bottom left
	]
	current_crosshair["left"] = [
		Vector2(-crosshair_length-crosshair_gap,-crosshair_thickness),  #top left
		Vector2(-crosshair_gap,-crosshair_thickness), #top right
		Vector2(-crosshair_gap,crosshair_thickness), #bottom right
		Vector2(-crosshair_length-crosshair_gap,crosshair_thickness) #bottom left
	]
	current_crosshair["top"] = [
		Vector2(-crosshair_thickness,-crosshair_length-crosshair_gap), #top left
		Vector2(crosshair_thickness,-crosshair_length-crosshair_gap), #top right
		Vector2(crosshair_thickness,-crosshair_gap), #bottom right
		Vector2(-crosshair_thickness,-crosshair_gap) #bottom left
	]
	current_crosshair["right"] = [
		Vector2(crosshair_gap,-crosshair_thickness), #top left
		Vector2(crosshair_length+crosshair_gap,-crosshair_thickness), #top right
		Vector2(crosshair_length+crosshair_gap,crosshair_thickness), #bottom right
		Vector2(crosshair_gap,crosshair_thickness) #bottom left
	]
	current_crosshair["bottom"] = [
		Vector2(-crosshair_thickness, crosshair_gap), #top left
		Vector2(crosshair_thickness,crosshair_gap), #top right
		Vector2(crosshair_thickness,crosshair_gap+crosshair_length), #bottom right
		Vector2(-crosshair_thickness,crosshair_gap+crosshair_length) #bottom left
	]

func set_parameter_if_exists(parameter, key: String):
	var category = DataManager.categories.CROSSHAIR
	var new_value = DataManager.get_data(category, key)
	if new_value != null:
		return new_value
	return parameter

func set_color_if_exists(parameter, key: String):
	var color = set_parameter_if_exists(parameter, key)
	if color != null and color is String:
		color = Global.string_to_color(color)
	return color

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
