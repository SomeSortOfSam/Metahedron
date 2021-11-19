extends TextureButton


export var attack_button : Texture
export var attack_button_disabled : Texture
export var back_button : Texture
export var back_button_disables : Texture

signal attack()
signal back()

var attack : bool = true

func set_buttons(a : bool):
	if (a):
		set_normal_texture(attack_button)
		set_disabled_texture(attack_button_disabled)
		emit_signal("back")
	else:
		set_normal_texture(back_button)
		set_disabled_texture(back_button_disables)
		emit_signal("attack")
	
	attack = a

func _ready():
	set_buttons(true)

func _on_Attack_pressed():
	set_buttons(!attack)

func _on_CombatMenu_requesting_close():
	set_buttons(true)
