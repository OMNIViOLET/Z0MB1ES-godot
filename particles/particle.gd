extends Sprite
class_name Particle

var particle_type: int
var traj = Vector2.ZERO
var player = 0
var flags = 0
var size = 0.0
var lifetime = 0.0
var r = 0.0
var g = 0.0
var b = 0.0
var a = 0.0
var exists = false


func set_alpha(alpha: bool):
	if not alpha:
		var mat = material as CanvasItemMaterial
		mat.blend_mode = CanvasItemMaterial.BLEND_MODE_MIX
		z_index = 2
	else:
		var mat = material as CanvasItemMaterial
		mat.blend_mode = CanvasItemMaterial.BLEND_MODE_ADD
		z_index = 6
