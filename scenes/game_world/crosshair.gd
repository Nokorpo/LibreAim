extends Control
## Renders the user crosshair

var current_crosshair: Dictionary = {
	"top": [],
	"right": [],
	"bottom": [],
	"left": [],
	"dot": []
}

var _color: Color
var _outline_color: Color

var _enable_outline: bool
var _dot_enable: bool

var _dot_size: float
var _outline_width: float
var _thickness: float
var _length: float
var _gap: float

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
	var save_file: SaveManager.SaveFile = SaveManager.settings
	var setting := "crosshair"
	
	_dot_enable = save_file.get_data(setting, "dot_enable")
	_dot_size = save_file.get_data(setting, "dot_size")
	_length = save_file.get_data(setting, "length")
	_thickness = save_file.get_data(setting, "thickness")
	_gap = save_file.get_data(setting, "gap")
	_enable_outline = save_file.get_data(setting, "enable_outline")
	_outline_width = save_file.get_data(setting, "outline_width")
	_color = save_file.get_data(setting, "color")
	_outline_color = save_file.get_data(setting, "outline_color")

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
