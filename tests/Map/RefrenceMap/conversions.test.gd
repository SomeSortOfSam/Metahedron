extends WAT.Test

func test_conversions():
	parameters(generate_conversion_paramaters())
	describe(generate_conversion_description())
	var map := tests_map.initalize_full_map(tests_map.SIZE)
	var refrence_rect := Rect2(p.x,p.y,0,0)
	var refrence_map := RefrenceMap.new(map,refrence_rect)
	run_conversion_tests(refrence_map)

func generate_conversion_paramaters() -> Array:
	var out := [["x","y"]]
	for x in tests_map.SIZE.x:
		for y in tests_map.SIZE.y:
			out.append([x,y])
	return out

func generate_conversion_description() -> String:
	return "Refrence map convesions with a start tile of " + str(Vector2(p.x,p.y))

func run_conversion_tests(refrence_map : RefrenceMap):
	for x in tests_map.SIZE.x:
		for y in tests_map.SIZE.y:
			run_conversion_test(Vector2(x,y), refrence_map)

func run_conversion_test(cell : Vector2, refrence_map : RefrenceMap ):
	var refrenced_cell := cell - refrence_map.refrence_rect.position
	asserts.is_equal(refrenced_cell, refrence_map.map_to_internal_map(cell), "Refrence map to map correct at " + str(cell))
	asserts.is_equal(cell, refrence_map.internal_map_to_map(refrenced_cell), "Internal map to map correct at " + str(cell))
