extends CanvasLayer

@onready var hotbar_container: HBoxContainer = $HBoxContainer

var active_index: int = -1
var slots: Array[Control] = []

func _ready() -> void:
	slots.clear()
	for child in hotbar_container.get_children():
		if child is Control:
			slots.append(child)
			if child.has_signal("slot_selected"):
				child.slot_selected.connect(_on_slot_selected)

	# Mac dinh chon o so 1 khi vao game.
	_select_slot(0)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey:
		var key_event := event as InputEventKey
		if not key_event.pressed or key_event.echo:
			return

		var index := _keycode_to_slot_index(key_event.keycode)
		if index == -1:
			index = _keycode_to_slot_index(key_event.physical_keycode)

		if index >= 0 and index < slots.size():
			_select_slot(index)
			get_viewport().set_input_as_handled()

func _keycode_to_slot_index(keycode: Key) -> int:
	if keycode >= KEY_1 and keycode <= KEY_9:
		return int(keycode - KEY_1)
	if keycode >= KEY_KP_1 and keycode <= KEY_KP_9:
		return int(keycode - KEY_KP_1)
	return -1

func _select_slot(index: int) -> void:
	if index < 0 or index >= slots.size():
		return

	active_index = index

	for i in range(slots.size()):
		var slot := slots[i]
		if i == index:
			if slot.has_method("select"):
				slot.call("select")
			elif slot.has_method("set_selected"):
				slot.call("set_selected", true)
		else:
			if slot.has_method("deselect"):
				slot.call("deselect")
			elif slot.has_method("set_selected"):
				slot.call("set_selected", false)

func _on_slot_selected(slot: Control) -> void:
	var index := slots.find(slot)
	if index != -1:
		_select_slot(index)
