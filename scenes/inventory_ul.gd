extends Control

var is_open = false

# Dùng @onready để đảm bảo các node đã được load xong
@onready var grid_container = $MarginContainer/GridContainer
# Đường dẫn scene ô Slot (Bạn hãy kiểm tra lại đường dẫn này xem có chuẩn 100% chưa nhé)
var slot_scene = preload("res://scenes/ui/InventorySlot.tscn") 

func _ready():
	# Cài đặt chế độ xử lý để node này luôn chạy kể cả khi game pause
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	visible = false # Ẩn khi bắt đầu
	
	# Kiểm tra an toàn trước khi tạo ô
	if grid_container:
		create_slots(19) 
	else:
		print("Cảnh báo: Không tìm thấy GridContainer. Hãy kiểm tra lại đường dẫn trong script!")

func toggle():
	is_open = !is_open
	visible = is_open
	
	# Dừng thế giới game nhưng UI này vẫn chạy (vì đã để Mode Always)
	get_tree().paused = is_open
	
	if is_open:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	else:
		# Nếu game của bạn không dùng chuột để xoay camera thì có thể dùng MODE_VISIBLE luôn cũng được
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func create_slots(amount: int):
	# Kiểm tra nếu file slot_scene load thành công
	if not slot_scene:
		print("Lỗi: Không tìm thấy file InventorySlot.tscn!")
		return
		
	for i in range(amount):
		var new_slot = slot_scene.instantiate()
		grid_container.add_child(new_slot)
