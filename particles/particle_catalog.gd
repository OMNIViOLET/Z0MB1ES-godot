class_name ParticleCatalog

enum ParticleType {
	BLOOD,
	DYING,
	EXPLODE,
	FACE_DIE,
	FACE_TRAIL,
	FLAME,
	GEOBIT,
	GOO,
	LASER,
	MUZZLE_FLASH,
	NEUCHUNK,
	NEUTRON,
	PIXEL,
	POWERUP,
	ROCKET,
	SCORE,
	SHOT
}

var catalog = {
	ParticleType.EXPLODE: load("res://particles/explode.tres"),
	ParticleType.MUZZLE_FLASH: load("res://particles/muzzle_flash.tres")
}


func get_particle_def(particle_type: int) -> ParticleDef:
	return catalog[particle_type] as ParticleDef
