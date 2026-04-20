extends CharacterBody2D

# --- CÀI ĐẶT THÔNG SỐ (Chỉnh được ở Inspector) ---
@export_group("Movement")
@export var speed: float = 130.0
@export var sprint_speed: float = 190.0
@export var acceleration: float = 1200.0 # Độ nhạy khi bắt đầu chạy
@export var friction: float = 1000.0     # Độ trượt khi dừng lại

@export_group("Stamina")
@export var stamina_drain_per_second: float = 25.0
@export var stamina_recovery_per_second: float = 18.0
@export var stamina_recovery_delay: float = 0.6

# --- BIẾN NỘI BỘ ---
var last_direction: Vector2 = Vector2.DOWN
var stamina_recovery_timer: float = 0.0
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

func _physics_process(delta: float) -> void:
	# 1. Lấy hướng từ phím bấm (WASD hoặc 4 phím mũi tên)
	var input_vector: Vector2 = Input.get_vector("left", "right", "up", "down")
	var has_sprint_action: bool = InputMap.has_action("sprint")
	var is_trying_to_sprint: bool = (has_sprint_action and Input.is_action_pressed("sprint")) or Input.is_key_pressed(KEY_SHIFT)
	var is_moving: bool = input_vector != Vector2.ZERO
	var can_sprint: bool = is_moving and is_trying_to_sprint and GameManager.current_stamina > 0.0
	var current_speed: float = sprint_speed if can_sprint else speed
	
	# 2. Xử lý di chuyển với gia tốc (mượt hơn)
	if is_moving:
		velocity = velocity.move_toward(input_vector * current_speed, acceleration * delta)
		last_direction = input_vector
	else:
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)

	_update_stamina(delta, is_moving, can_sprint)
	
	move_and_slide()
	
	# 3. Cập nhật Animation dựa trên trạng thái
	update_animations(input_vector)

func _update_stamina(delta: float, is_moving: bool, is_sprinting: bool) -> void:
	if is_sprinting:
		GameManager.consume_stamina(stamina_drain_per_second * delta)
		stamina_recovery_timer = stamina_recovery_delay
		return

	if stamina_recovery_timer > 0.0:
		stamina_recovery_timer = maxf(stamina_recovery_timer - delta, 0.0)
		return

	if not is_moving:
		GameManager.recover_stamina(stamina_recovery_per_second * delta)

func update_animations(input_vector: Vector2) -> void:
	if input_vector != Vector2.ZERO:
		# Xử lý lật hình khi đi sang trái/phải
		if input_vector.x != 0:
			animated_sprite.flip_h = (input_vector.x < 0)
		
		# Ưu tiên animation theo hướng di chuyển mạnh nhất
		if abs(input_vector.x) > abs(input_vector.y):
			animated_sprite.play("walk_side")
		else:
			if input_vector.y > 0:
				animated_sprite.play("walk_down")
			else:
				animated_sprite.play("walk_up")
	else:
		# Khi đứng yên (Idle)
		play_idle_animation()

func play_idle_animation() -> void:
	if abs(last_direction.x) > abs(last_direction.y):
		animated_sprite.play("idle_side")
	else:
		if last_direction.y > 0:
			animated_sprite.play("idle_down")
		else:
			animated_sprite.play("idle_up")
