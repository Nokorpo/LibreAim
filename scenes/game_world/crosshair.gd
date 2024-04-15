extends Control
## Renders the user crosshair

var _color := Color(0, 255, 255, 1)
var _outline_color := Color(0,0,0)

var _enable_outline := true
var _dot_enable := false

var _dot_size: float = 6.0
var _outline_width: float = 1.0
var _thickness: float = 2.0
var _length: float = 12.0
var _gap: float = 5.0

var current_crosshair: Dictionary = {
	"top": [],
	"right": [],
	"bottom": [],
	"left": [],
	"dot": []
}

func _draw() -> void:
	_load_save()
	_load_crosshair()
	
	_draw_part(current_crosshair["top"])
	_draw_part(current_crosshair["right"])
	_draw_part(current_crosshair["bottom"])
	_draw_part(current_crosshair["left"])
	if _dot_enable:
		_draw_part(current_crosshair["dot"])

func _on_options_refresh_crosshair() -> void:
	queue_redraw()

func _load_save() -> void:
	var category = DataManager.categories.CROSSHAIR
	_dot_enable = DataManager.set_parameter_if_exists(category, _dot_enable, "dot")
	_dot_size = DataManager.set_parameter_if_exists(category, _dot_size, "dot_size")
	_length = DataManager.set_parameter_if_exists(category, _length, "length")
	_thickness = DataManager.set_parameter_if_exists(category, _thickness, "thickness")
	_gap = DataManager.set_parameter_if_exists(category, _gap, "gap")
	_enable_outline = DataManager.set_parameter_if_exists(category, _enable_outline, "outline_enable")
	_outline_width = DataManager.set_parameter_if_exists(category, _outline_width, "outline_width")
	_color = DataManager.set_color_if_exists(category, _color, "color")
	_outline_color = DataManager.set_color_if_exists(category, _outline_color, "outline_color")

func _load_crosshair() -> void:
	current_crosshair["dot"] = [
		Vector2(-_dot_size, -_dot_size), # top left
		Vector2(_dot_size, -_dot_size), # top right
		Vector2(_dot_size, _dot_size), # bottom right
		Vector2(-_dot_size, _dot_size) # bottom left
	]
	current_crosshair["left"] = [
		Vector2(-_length -_gap, -_thickness), # top left
		Vector2(-_gap, -_thickness), # top right
		Vector2(-_gap, _thickness), # bottom right
		Vector2(-_length -_gap, _thickness) # bottom left
	]
	current_crosshair["top"] = [
		Vector2(-_thickness, -_length -_gap), # top left
		Vector2(_thickness, -_length -_gap), # top right
		Vector2(_thickness, -_gap), # bottom right
		Vector2(-_thickness, -_gap) # bottom left
	]
	current_crosshair["right"] = [
		Vector2(_gap, -_thickness), # top left
		Vector2(_length + _gap, -_thickness), # top right
		Vector2(_length +_gap, _thickness), # bottom right
		Vector2(_gap, _thickness) # bottom left
	]
	current_crosshair["bottom"] = [
		Vector2(-_thickness, _gap), # top left
		Vector2(_thickness, _gap), # top right
		Vector2(_thickness, _gap + _length), # bottom right
		Vector2(-_thickness, _gap + _length) # bottom left
	]

func _draw_part(points: PackedVector2Array) -> void:
	draw_polygon(points, [_color])
	var polygon := Polygon2D.new()
	polygon.set_polygon(points)
	if _enable_outline:
		_draw_outline(polygon)

func _draw_outline(polygon: Polygon2D) -> void:
	var poly = polygon.get_polygon()
	for i in range(1 , poly.size()):
		draw_line(poly[i-1] , poly[i], _outline_color , _outline_width)
	draw_line(poly[poly.size() - 1] , poly[0], _outline_color , _outline_width)
