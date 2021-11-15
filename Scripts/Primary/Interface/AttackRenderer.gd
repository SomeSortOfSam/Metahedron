extends Node2D

var hovering := false

func _draw():
	if hovering:
		draw_line(Vector2.ZERO,Vector2.UP * 16 * 10,Color.red,8)
		draw_line(Vector2.ZERO,Vector2.DOWN * 16 * 10,Color.red,8)
		draw_line(Vector2.ZERO,Vector2.LEFT * 16 * 10,Color.red,8)
		draw_line(Vector2.ZERO,Vector2.RIGHT * 16 * 10,Color.red,8)

func _on_Body_position_selected(cell : Vector2):
	if cell == Vector2.ZERO && !hovering:
		hovering = true
		update()
	elif cell != Vector2.ZERO && hovering:
		hovering = false
		update()
