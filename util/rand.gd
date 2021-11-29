extends Node


func _ready():
	randomize()


func rint(low: int, high: int) -> int:
	return low + (randi() % (high - low))


func coin_toss(success: float = 0.5) -> bool:
	return rand_range(0.0, 1.0) < success


func vec2(x_min: float, x_max: float, y_min: float, y_max: float) -> Vector2:
	return Vector2(rand_range(x_min, x_max), rand_range(y_min, y_max))
