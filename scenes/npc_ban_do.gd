extends StaticBody2D

var can_interact = false # Biến kiểm tra xem người chơi có đang đứng gần không

func _ready():
	# Kết nối tín hiệu khi người chơi đi vào/ra khỏi vùng Area2D
	$Area2D.body_entered.connect(_on_body_entered)
	$Area2D.body_exited.connect(_on_body_exited)
func _on_body_entered1(body):
	if body.name == "player":
		can_interact = true
		$CanvasLayer/Label.show() # Hiện dòng chữ lên

func _on_body_exited(body):
	if body.name == "player":
		can_interact = false
		$CanvasLayer/Label.hide() # Ẩn dòng chữ đi

func _on_body_entered(body):
	if body.name == "player": # Kiểm tra nếu đúng là Node người chơi
		can_interact = true
		print("Nhấn E để mua đồ")

func _on_body_exited2(body):
	if body.name == "player":
		can_interact = false
		print("Tạm biệt!")

func _process(_delta):
	# Nếu đang đứng gần và nhấn phím tương tác (mặc định là Space hoặc Enter)
	if can_interact and Input.is_action_just_pressed("ui_accept"):
		mo_cua_hang()

func mo_cua_hang():
	print("Đang mở menu bán đồ...")
	# Tại đây bạn sẽ viết lệnh hiện giao diện (UI) cửa hàng
