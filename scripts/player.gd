extends CharacterBody2D

# --- CÀI ĐẶT THÔNG SỐ (Chỉnh được ở Inspector) ---
@export_group("Movement")
@export var speed: float = 150.0
@export var acceleration: float = 1200.0 # Độ nhạy khi bắt đầu chạy
@export var friction: float = 1000.0     # Độ trượt khi dừng lại

# --- BIẾN NỘI BỘ ---
var last_direction: Vector2 = Vector2.DOWN
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

func _physics_process(delta: float) -> void:
	# 1. Lấy hướng từ phím bấm (WASD hoặc 4 phím mũi tên)
	var input_vector = Input.get_vector("left", "right", "up", "down")
	
	# 2. Xử lý di chuyển với gia tốc (mượt hơn)
	if input_vector != Vector2.ZERO:
		velocity = velocity.move_toward(input_vector * speed, acceleration * delta)
		last_direction = input_vector
	else:
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
	
	move_and_slide()
	
	# 3. Cập nhật Animation dựa trên trạng thái
	update_animations(input_vector)

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
