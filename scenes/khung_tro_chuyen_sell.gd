extends CanvasLayer

@onready var dialogue_box = $DialogueBox
@onready var text_label = $DialogueBox/RichTextLabel
@onready var portrait_rect = $DialogueBox/Portrait # Đổi từ Label sang TextureRect

var dialogs = []
var current_dialog_idx = 0
var is_active = false

func _ready():
	dialogue_box.hide()
	is_active = false

func start_story(lines: Array, portrait_texture: Texture2D):
	if is_active: return
	
	dialogs = lines
	current_dialog_idx = 0
	
	if portrait_texture:
		portrait_rect.texture = portrait_texture
		portrait_rect.show()
	else:
		portrait_rect.hide()
		
	is_active = true
	show_dialog()
	dialogue_box.show()

func show_dialog():
	if current_dialog_idx < dialogs.size():
		text_label.text = dialogs[current_dialog_idx]
	else:
		ket_thuc_hoi_thoai()

func ket_thuc_hoi_thoai():
	is_active = false
	dialogue_box.hide()

func _input(event):
	if is_active and event.is_action_pressed("interact"):
		current_dialog_idx += 1
		show_dialog()
