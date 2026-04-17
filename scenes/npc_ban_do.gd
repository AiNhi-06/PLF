extends StaticBody2D

var can_interact = false 

func _ready():
	# Kết nối tín hiệu
	$Area2D.body_entered.connect(_on_body_entered)
	$Area2D.body_exited.connect(_on_body_exited)

func _on_body_entered(body):
	if body.name == "player":
		can_interact = true
		if has_node("CanvasLayer/Label"):
			$CanvasLayer/Label.show()
		print("Nhấn E để nói chuyện")

func _on_body_exited(body):
	if body.name == "player":
		can_interact = false
		if has_node("CanvasLayer/Label"):
			$CanvasLayer/Label.hide()
		print("Tạm biệt!")

func _process(_delta):
	# Kiểm tra nếu nhấn phím tương tác
	# Lưu ý: "ui_accept" thường là Enter/Space. 
	# Nếu bạn đã tạo "interact" cho phím E thì đổi chữ "ui_accept" thành "interact"
	if can_interact and Input.is_action_just_pressed("interact"):
		mo_dialogue()

func mo_dialogue():
	print("Đang mở hội thoại...")
	# Trỏ đúng đến Node DialogueManager trong Scene của bạn
	# Nếu DialogueManager nằm cùng cấp với NPC trong Scene chính, dùng: get_parent().get_node("DialogueManager")
	# Nếu bạn đã cài Autoload thì bỏ dấu $ đi
	if has_node("../CanvasLayer"): # Ví dụ nó nằm ở CanvasLayer chung của map
		$"../CanvasLayer".start_story(["Chào Mây!", "Hôm nay bà có hạt giống mới nè.", "Cháu mua gì không?"], "Bà bán đồ")
	else:
		# Nếu DialogueManager đang nằm ngay trong NPC (như ảnh trước của bạn)
		$CanvasLayer.start_story(["Chào Mây!", "Hôm nay bà có hạt giống mới nè."], "Bà bán đồ")
