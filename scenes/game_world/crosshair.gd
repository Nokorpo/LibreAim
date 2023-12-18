extends Control

var color := Color(0, 255, 255, 1)
var outline_color := Color(0,0,0)

var enable_outline := true
var dot_enable := false

var dot_size := 6.0
var outline_width := 1.0
var thickness := 2.0
var length := 12.0
var gap := 5.0

var current_crosshair = {
	"top": [],
	"right": [],
	"bottom": [],
	"left": [],
	"dot": []
}

func _draw():
	load_save()
	
	draw_part(current_crosshair["top"])
	draw_part(current_crosshair["right"])
	draw_part(current_crosshair["bottom"])
	draw_part(current_crosshair["left"])
	if dot_enable:
		draw_part(current_crosshair["dot"])

func _on_options_refresh_crosshair():
	queue_redraw()

func load_save():
	var category = DataManager.categories.CROSSHAIR
	dot_enable = DataManager.set_parameter_if_exists(category, dot_enable, "dot")
	dot_size = DataManager.set_parameter_if_exists(category, dot_size, "dot_size")
	length = DataManager.set_parameter_if_exists(category, length, "length")
	thickness = DataManager.set_parameter_if_exists(category, thickness, "thickness")
	gap = DataManager.set_parameter_if_exists(category, gap, "gap")
	enable_outline = DataManager.set_parameter_if_exists(category, enable_outline, "outline_enable")
	outline_width = DataManager.set_parameter_if_exists(category, outline_width, "outline_width")
	color = DataManager.set_color_if_exists(category, color, "color")
	outline_color = DataManager.set_color_if_exists(category, outline_color, "outline_color")
	
	current_crosshair["dot"] = [
		Vector2(-dot_size, -dot_size), #top left
		Vector2(dot_size, -dot_size), #top right
		Vector2(dot_size, dot_size), #bottom right
		Vector2(-dot_size, dot_size) #bottom left
	]
	current_crosshair["left"] = [
		Vector2(-length-gap, -thickness),  #top left
		Vector2(-gap, -thickness), #top right
		Vector2(-gap, thickness), #bottom right
		Vector2(-length-gap, thickness) #bottom left
	]
	current_crosshair["top"] = [
		Vector2(-thickness, -length-gap), #top left
		Vector2(thickness, -length-gap), #top right
		Vector2(thickness, -gap), #bottom right
		Vector2(-thickness, -gap) #bottom left
	]
	current_crosshair["right"] = [
		Vector2(gap,-thickness), #top left
		Vector2(length+gap,-thickness), #top right
		Vector2(length+gap,thickness), #bottom right
		Vector2(gap,thickness) #bottom left
	]
	current_crosshair["bottom"] = [
		Vector2(-thickness, gap), #top left
		Vector2(thickness,gap), #top right
		Vector2(thickness,gap+length), #bottom right
		Vector2(-thickness,gap+length) #bottom left
	]

func draw_part(points: PackedVector2Array):
	draw_polygon(points, [color])
	var polygon := Polygon2D.new()
	polygon.set_polygon(points)
	if enable_outline:
		draw_outline(polygon)
	
func draw_outline(polygon: Polygon2D):
	var poly = polygon.get_polygon()
	for i in range(1 , poly.size()):
		draw_line(poly[i-1] , poly[i], outline_color , outline_width)
	draw_line(poly[poly.size() - 1] , poly[0], outline_color , outline_width)
