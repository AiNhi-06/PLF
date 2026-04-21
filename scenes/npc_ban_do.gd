extends StaticBody2D

var can_interact = false 

# Kéo thả ảnh chân dung của bà bán đồ vào ô này ở Inspector
@export var npc_portrait : Texture2D 

func _ready():
	$Area2D.body_entered.connect(_on_body_entered)
	$Area2D.body_exited.connect(_on_body_exited)

func _on_body_entered(body):
	if body.name == "player":
		can_interact = true
		print("Nhấn E để nói chuyện")

func _on_body_exited(body):
	if body.name == "player":
		can_interact = false
		print("Tạm biệt!")

func _process(_delta):
	if can_interact and Input.is_action_just_pressed("interact"):
		mo_dialogue()

func mo_dialogue():
	# Kiểm tra nếu DialogueManager (CanvasLayer) nằm ngay trong NPC
	if has_node("DialogueManager"):
		var dm = $DialogueManager
		if !dm.is_active:
			dm.start_story(["Chào Mây!", "Hôm nay bà có hạt giống mới nè."], npc_portrait)
	# Kiểm tra nếu nó nằm ở ngoài Map (cấp cha)
	elif has_node("../DialogueManager"):
		var dm = $"../DialogueManager"
		if !dm.is_active:
			dm.start_story(["Chào Mây!", "Hôm nay bà có hạt giống mới nè."], npc_portrait)
