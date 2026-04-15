extends Node2D

func _ready():
	if Global.coming_from_farm:
		# Nếu vừa từ Map 2 về, đặt Player ở vị trí gần cổng
	# Dùng owner (là Node Game) để tìm player
		owner.get_node("player").global_position = $SpawnFromFarm.global_position
		Global.coming_from_farm = false # Reset lại biến để lần sau vào game không bị nhảy tới đây
	else:
		# Nếu mới vào game lần đầu, để ở vị trí mặc định (giữa map)
		# Hoặc dùng một Marker2D khác cho vị trí bắt đầu
		pass
