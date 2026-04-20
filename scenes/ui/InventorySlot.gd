extends PanelContainer

signal slot_selected(slot: Control)

@onready var selector_frame: TextureRect = $PanelContainer/SelectorFrame
@onready var slot_panel: Control = $PanelContainer

var is_selected: bool = false
var is_hovering: bool = false
const HOVER_SCALE: Vector2 = Vector2(1.08, 1.08)

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_STOP
	_mouse_filter_children(self)
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	resized.connect(_sync_selector_to_slot)
	call_deferred("_center_pivot_offset")
	call_deferred("_sync_selector_to_slot")
	if selector_frame:
		selector_frame.visible = false
		selector_frame.mouse_filter = Control.MOUSE_FILTER_IGNORE
		selector_frame.z_index = 10
		selector_frame.texture_repeat = CanvasItem.TEXTURE_REPEAT_DISABLED
		selector_frame.stretch_mode = TextureRect.STRETCH_SCALE
	if slot_panel:
		slot_panel.set_anchors_preset(Control.PRESET_FULL_RECT)
		slot_panel.offset_left = 0.0
		slot_panel.offset_top = 0.0
		slot_panel.offset_right = 0.0
		slot_panel.offset_bottom = 0.0

func _mouse_filter_children(node: Node) -> void:
	for child in node.get_children():
		if child is Control:
			var child_control: Control = child as Control
			child_control.mouse_filter = Control.MOUSE_FILTER_IGNORE
			child_control.z_index = 0
		_mouse_filter_children(child)

func _on_mouse_entered() -> void:
	is_hovering = true
	scale = HOVER_SCALE
	if selector_frame:
		selector_frame.visible = true
	print("Mouse entered inventory slot: ", name)

func _on_mouse_exited() -> void:
	is_hovering = false
	scale = Vector2.ONE
	if selector_frame:
		selector_frame.visible = is_selected

func _center_pivot_offset() -> void:
	pivot_offset = size / 2.0

func _sync_selector_to_slot() -> void:
	if not selector_frame:
		return
	selector_frame.set_anchors_preset(Control.PRESET_FULL_RECT)
	selector_frame.offset_left = 0.0
	selector_frame.offset_top = 0.0
	selector_frame.offset_right = 0.0
	selector_frame.offset_bottom = 0.0
	selector_frame.size = size

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		var mouse_event := event as InputEventMouseButton
		if mouse_event.button_index == MOUSE_BUTTON_LEFT and mouse_event.pressed:
			slot_selected.emit(self)
			accept_event()

func set_selected(is_selected: bool) -> void:
	self.is_selected = is_selected
	if selector_frame:
		selector_frame.visible = is_selected or is_hovering
		selector_frame.z_index = 10 if is_selected else 10
