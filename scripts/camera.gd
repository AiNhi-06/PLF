extends Camera2D

# Kéo thả node TileMapLayer nền (ví dụ layer 'đất') vào đây
@export var tilemap: TileMapLayer 

func _ready():
 if tilemap:
  # Lấy vùng hình chữ nhật bao phủ toàn bộ các ô gạch đã vẽ
  var map_rect = tilemap.get_used_rect()
  # Lấy kích thước thực tế của mỗi ô gạch (thường là 16x16 hoặc 32x32)
  var tile_size = tilemap.tile_set.tile_size
  
  # Tính toán giới hạn bằng pixel
  limit_left = map_rect.position.x * tile_size.x
  limit_right = map_rect.end.x * tile_size.x
  limit_top = map_rect.position.y * tile_size.y
  limit_bottom = map_rect.end.y * tile_size.y
