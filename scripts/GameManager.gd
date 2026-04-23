extends Node

signal health_changed(current: float, maximum: float)
signal stamina_changed(current: float, maximum: float)
signal hunger_changed(current: float, maximum: float)

var target_spawn_name: String = ""
# Các biến toàn cục (Global) - Đi đâu cũng không mất
var max_health: float = 150.0
var current_health: float = 150.0
var player_health = 150.0

var max_stamina: float = 150.0
var current_stamina: float = 150.0

var max_hunger: float = 150.0
var current_hunger: float = 150.0

var gold = 0
var inventory_items = [] # Danh sách item Nhi đã nhặt

# Biến để lưu tham chiếu đến Scene Main (để gọi hàm đổi map)
var main_scene = null

var is_changing_scene = false

func _ready() -> void:
	# Đảm bảo chỉ số hợp lệ ngay khi game chạy.
	current_health = clampf(current_health, 0.0, max_health)
	player_health = current_health
	current_stamina = clampf(current_stamina, 0.0, max_stamina)
	current_hunger = clampf(current_hunger, 0.0, max_hunger)
	health_changed.emit(current_health, max_health)
	stamina_changed.emit(current_stamina, max_stamina)
	hunger_changed.emit(current_hunger, max_hunger)

func set_health(value: float) -> void:
	current_health = clampf(value, 0.0, max_health)
	player_health = current_health
	health_changed.emit(current_health, max_health)

func heal(amount: float) -> void:
	if amount <= 0.0:
		return
	set_health(current_health + amount)

func take_damage(amount: float) -> void:
	if amount <= 0.0:
		return
	set_health(current_health - amount)

func set_stamina(value: float) -> void:
	current_stamina = clampf(value, 0.0, max_stamina)
	stamina_changed.emit(current_stamina, max_stamina)

func consume_stamina(amount: float) -> bool:
	if amount <= 0.0:
		return true
	if current_stamina <= 0.0:
		return false

	set_stamina(current_stamina - amount)
	return current_stamina > 0.0

func recover_stamina(amount: float) -> void:
	if amount <= 0.0:
		return
	set_stamina(current_stamina + amount)

func set_hunger(value: float) -> void:
	current_hunger = clampf(value, 0.0, max_hunger)
	hunger_changed.emit(current_hunger, max_hunger)

func consume_hunger(amount: float) -> bool:
	if amount <= 0.0:
		return true
	if current_hunger <= 0.0:
		return false

	set_hunger(current_hunger - amount)
	return current_hunger > 0.0

func recover_hunger(amount: float) -> void:
	if amount <= 0.0:
		return
	set_hunger(current_hunger + amount)

func add_gold(amount):
	gold += amount
	print("Vàng hiện tại: ", gold)
	

	# Hàm này để các cổng dịch chuyển gọi tới
func change_map(map_path: String):
	if is_changing_scene: return # Nếu đang chuyển rồi thì thôi
	
	is_changing_scene = true
	
	# Sử dụng call_deferred để tránh lỗi "physics callback" (lỗi đỏ Nhi gặp)
	# Nó sẽ đợi các tính toán vật lý xong xuôi rồi mới đổi map
	call_deferred("_deferred_change_map", map_path)
	
	# Hàm phụ trợ để thực hiện việc đổi map an toàn
func _deferred_change_map(map_path: String):
	if main_scene:
		main_scene.change_map(map_path)
	
	# Đợi 1 chút rồi mới cho phép chuyển tiếp lần sau
	await get_tree().create_timer(0.5).timeout
	is_changing_scene = false
