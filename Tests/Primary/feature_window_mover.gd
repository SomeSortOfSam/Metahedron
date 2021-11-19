extends "res://addons/gut/test.gd"

func test_out_of_bounds_clamp():
	var parent_rect := Rect2(Vector2.ONE*3,Vector2.ONE*3)
	for x in range(-1,4):
		for y in range(-1,4):
			var child_rect := Rect2(x+3,y+3,1,1)
			child_rect.position += WindowMover.clamp_delta(Vector2.ZERO,child_rect,parent_rect)
			assert_true(parent_rect.encloses(child_rect),"Clamp works for (" + str(x) + "," + str(y) + ")")
