extends Control

var is_open = false

# 1. Khai báo đường dẫn chuẩn đến file bạn vừa lưu
@onready var grid_container = $MarginContainer/GridContainer
var slot_scene = preload("res://scenes/ui/InventorySlot.tscn") 

func _ready():
	visible = false
	# 2. Gọi hàm tạo sẵn 20 ô khi game vừa load
	create_slots(20) 

func toggle():
	is_open = !is_open
	visible = is_open
	get_tree().paused = is_open
	
	if is_open:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	else:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

# 3. Thêm hàm tạo ô này vào cuối script
func create_slots(amount: int):
	for i in range(amount):
		var new_slot = slot_scene.instantiate()
		grid_container.add_child(new_slot)
