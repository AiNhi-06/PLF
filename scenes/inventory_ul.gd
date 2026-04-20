extends Control

var is_open = false
const PANEL_PADDING := 20.0

# Dùng @onready để đảm bảo các node đã được load xong
@onready var nine_patch_rect: NinePatchRect = $NinePatchRect
@onready var margin_container: MarginContainer = $NinePatchRect/MarginContainer
@onready var grid_container = $NinePatchRect/MarginContainer/GridContainer
var selected_slot: Control = null
# Đường dẫn scene ô Slot (Bạn hãy kiểm tra lại đường dẫn này xem có chuẩn 100% chưa nhé)
var slot_scene = preload("res://scenes/ui/InventorySlot.tscn") 

func _ready():
	# Cài đặt chế độ xử lý để node này luôn chạy kể cả khi game pause
	process_mode = Node.PROCESS_MODE_ALWAYS

	# Chuẩn hóa anchor để tính vị trí không bị lệch do thiết lập trong scene.
	set_anchors_preset(Control.PRESET_FULL_RECT)
	offset_left = 0.0
	offset_top = 0.0
	offset_right = 0.0
	offset_bottom = 0.0

	nine_patch_rect.set_anchors_preset(Control.PRESET_TOP_LEFT)
	nine_patch_rect.offset_left = 0.0
	nine_patch_rect.offset_top = 0.0
	nine_patch_rect.offset_right = 0.0
	nine_patch_rect.offset_bottom = 0.0
	
	visible = false # Ẩn khi bắt đầu

	# 1) MarginContainer phủ kín NinePatchRect
	margin_container.set_anchors_preset(Control.PRESET_FULL_RECT)
	margin_container.offset_left = 0.0
	margin_container.offset_top = 0.0
	margin_container.offset_right = 0.0
	margin_container.offset_bottom = 0.0

	# 2) Lề đều 20px
	margin_container.add_theme_constant_override("margin_left", int(PANEL_PADDING))
	margin_container.add_theme_constant_override("margin_top", int(PANEL_PADDING))
	margin_container.add_theme_constant_override("margin_right", int(PANEL_PADDING))
	margin_container.add_theme_constant_override("margin_bottom", int(PANEL_PADDING))

	# 3) Căn giữa GridContainer trong MarginContainer
	grid_container.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	grid_container.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	
	
	# Kiểm tra an toàn trước khi tạo ô
	if grid_container:
		create_slots(23) 
		_connect_all_slot_signals()
		call_deferred("_update_inventory_layout")
	else:
		print("Cảnh báo: Không tìm thấy GridContainer. Hãy kiểm tra lại đường dẫn trong script!")

	resized.connect(_update_inventory_layout)

func _input(event):
	# Node này chạy ở chế độ ALWAYS nên vẫn nhận được phím khi game đang pause.
	if event.is_action_pressed("toggle_inventory") and not event.is_echo():
		toggle()
		accept_event()

func toggle():
	is_open = !is_open
	visible = is_open
	
	if is_open:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	else:
		# Nếu game của bạn không dùng chuột để xoay camera thì có thể dùng MODE_VISIBLE luôn cũng được
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func close_inventory():
	is_open = false
	visible = false
	# Đảm bảo game không còn bị pause bởi inventory.
	get_tree().paused = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func create_slots(amount: int):
	# Kiểm tra nếu file slot_scene load thành công
	if not slot_scene:
		print("Lỗi: Không tìm thấy file InventorySlot.tscn!")
		return
		
	for i in range(amount):
		var new_slot: Node = slot_scene.instantiate()
		grid_container.add_child(new_slot)
	_connect_all_slot_signals()

	call_deferred("_update_inventory_layout")
	call_deferred("_clear_selection")

func _on_slot_selected(slot: Control) -> void:
	selected_slot = slot
	for child in grid_container.get_children():
		if child.has_method("set_selected"):
			child.call("set_selected", child == selected_slot)

func _clear_selection() -> void:
	selected_slot = null
	for child in grid_container.get_children():
		if child.has_method("set_selected"):
			child.call("set_selected", false)

func _connect_all_slot_signals() -> void:
	for child in grid_container.get_children():
		if child.has_signal("slot_selected"):
			var callable = Callable(self, "_on_slot_selected")
			if not child.is_connected("slot_selected", callable):
				child.connect("slot_selected", callable)

func _update_inventory_layout():
	if not nine_patch_rect or not grid_container or not margin_container:
		return

	# Chờ UI tính toán layout xong rồi mới lấy size chính xác.
	await get_tree().process_frame

	var slot_count: int = int(grid_container.get_child_count())
	if slot_count <= 0:
		return

	var cols: int = int(max(1, int(grid_container.columns)))
	var rows: int = int(ceil(float(slot_count) / float(cols)))
	var h_sep: float = float(grid_container.get_theme_constant("h_separation"))
	var v_sep: float = float(grid_container.get_theme_constant("v_separation"))

	# Lấy kích thước ô lớn nhất để tránh bị cắt nếu có slot kích thước khác nhau.
	var cell_size: Vector2 = Vector2.ZERO
	for child: Node in grid_container.get_children():
		if child is Control:
			var child_control: Control = child as Control
			cell_size.x = max(cell_size.x, child_control.get_combined_minimum_size().x)
			cell_size.y = max(cell_size.y, child_control.get_combined_minimum_size().y)

	var grid_size: Vector2 = Vector2(
		float(cols) * cell_size.x + float(cols - 1) * h_sep,
		float(rows) * cell_size.y + float(rows - 1) * v_sep
	)

	var margin_left: float = float(margin_container.get_theme_constant("margin_left"))
	var margin_top: float = float(margin_container.get_theme_constant("margin_top"))
	var margin_right: float = float(margin_container.get_theme_constant("margin_right"))
	var margin_bottom: float = float(margin_container.get_theme_constant("margin_bottom"))
	var panel_size: Vector2 = grid_size + Vector2(margin_left + margin_right, margin_top + margin_bottom)
	var panel_pos: Vector2 = ((size - panel_size) * 0.5).round()

	nine_patch_rect.size = panel_size
	nine_patch_rect.position = panel_pos
