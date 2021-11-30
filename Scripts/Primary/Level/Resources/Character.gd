tool
extends Resource
class_name Character, "res://Assets/Editor Icons/Character.png"
## Art assets for a given unit

export var name : String

export var level_texture : Texture
export var level_offset : Vector2
export var level_scale : Vector2 = Vector2.ONE

export var animations : SpriteFrames
export var animations_offset : Vector2
export var animations_scale : Vector2 = Vector2.ONE

func _init():
	animations = SpriteFrames.new()
	animations.remove_animation("default")
	animations.add_animation("Walk")
	animations.add_animation("Idle")
	animations.add_animation("Attack")
	animations.add_animation("Hurt")
