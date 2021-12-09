extends Projectile
class_name Flame

export(NodePath) var sprite_path

var _size = 0.0

onready var _sprite = get_node(sprite_path) as Sprite


func _init():
	_size = rand_range(0.0, 0.5)


func _process(delta):
	var a = int((0.5 - lifetime) * 2.0 * 9.0)
	_sprite.region_rect.position.y = a * 64.0
	_sprite.scale = Vector2(1.0, 0.9) * (1.2 - lifetime * 1.5 + _size)
