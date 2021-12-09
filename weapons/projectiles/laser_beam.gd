extends Projectile
class_name LaserBeam

onready var _sprite := $Sprite


func _process(delta):
	_sprite.scale.x = 15.0 * (0.5 - lifetime)
	_sprite.modulate.a = min(1.0, lifetime * 10.0)
