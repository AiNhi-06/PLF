extends Control

var is_open = false

func _ready():
	visible = false # Lúc đầu vào game thì ẩn túi đồ đi

func toggle():
	is_open = !is_open
	visible = is_open
	
	# Dừng game hoặc chạy tiếp khi mở/đóng túi đồ
	get_tree().paused = is_open
	
	# Hiện/Ẩn chuột để tương tác với vật phẩm
	if is_open:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	else:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		
		
