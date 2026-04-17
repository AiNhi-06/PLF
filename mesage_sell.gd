extends CanvasLayer

@onready var dialogue_control = $Control
@onready var message_label = $Control/MarginContainer/RichTextLabel
@onready var portrait = $Control/TextureRect2
@onready var name_label = $Control/Label


var dialogs = [] 
var current_step = 0

func _ready():
	dialogue_control.hide() # Lúc đầu ẩn đi

func start_story(list_chat: Array, npc_name: String):
	dialogs = list_chat
	current_step = 0
	name_label.text = npc_name
	show_text()
	dialogue_control.show()

func show_text():
	if current_step < dialogs.size():
		message_label.text = dialogs[current_step]
	else:
		# Hết câu thoại thì ẩn đi
		dialogue_control.hide()

func _input(event):
	# Nếu đang hiện khung và nhấn E (phím interact)
	if dialogue_control.visible and event.is_action_pressed("interact"):
		current_step += 1
		show_text()
		
