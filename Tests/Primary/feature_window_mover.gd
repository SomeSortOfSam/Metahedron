extends "res://addons/gut/test.gd"

func test_out_of_bounds_clamp():
	var parent_rect := Rect2(Vector2.ONE*3,Vector2.ONE*3)
	for x in range(-1,4):
		for y in range(-1,4):
			var child_rect := Rect2(x+3,y+3,1,1)
			child_rect.position += WindowMover.clamp_delta(Vector2.ZERO,child_rect,parent_rect)
			assert_true(parent_rect.encloses(child_rect),"Clamp works for (" + str(x) + "," + str(y) + ")")

func populate_mover(parent : Control) -> WindowMover:
	var child := Control.new()
	parent.add_child(child)
	child.rect_size = Vector2(1,1.5)
	
	var container = Control.new()
	child.add_child(container)
	container.rect_position = Vector2(0,1)
	
	var sub_container = Node2D.new()
	container.add_child(sub_container)
	
	var tilemap = TileMap.new()
	sub_container.add_child(tilemap)
	tilemap.cell_size = Vector2.ONE
	
	var mover := Control.new()
	child.add_child(mover) 
	mover.set_script(WindowMover) #lest window mover call onready before put in context
	mover.rect_size = Vector2(1,.5)
	mover.window = child
	mover.viewport_window = parent
	mover.tilemap = tilemap
	mover.tilemap_container = container
	
	return mover as WindowMover

func test_quantization():
	#Arrange
	var parent : Control = add_child_autofree(Control.new())
	parent.rect_size = Vector2(5,5.5)
	
	var mover := populate_mover(parent)
	var moverx := populate_mover(parent)
	var movery := populate_mover(parent)
	
	moverx.window.rect_position += Vector2(32,.2)
	movery.window.rect_position += Vector2(.2,32)
	#Act
	mover.window.rect_position += mover.quatizize()
	moverx.window.rect_position += moverx.quatizize()
	movery.window.rect_position += movery.quatizize()
	#Assert
	var pos := mover.tilemap.to_global(mover.tilemap.map_to_world(Vector2.ZERO))
	var xpos := moverx.tilemap.to_global(moverx.tilemap.map_to_world(Vector2.ZERO))
	var ypos := movery.tilemap.to_global(movery.tilemap.map_to_world(Vector2.ZERO))
	
	assert_almost_eq(pos.y,xpos.y, .001)
	assert_almost_eq(pos.x,ypos.x, .001)
