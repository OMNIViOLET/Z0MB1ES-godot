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
	ParticleType.BLOOD: load("res://particles/blood.tres"),
	ParticleType.DYING: load("res://particles/dying.tres"),
	ParticleType.EXPLODE: load("res://particles/explode.tres"),
	ParticleType.FACE_DIE: load("res://particles/face_die.tres"),
	ParticleType.FACE_TRAIL: load("res://particles/face_trail.tres"),
	ParticleType.GEOBIT: load("res://particles/geobit.tres"),
	ParticleType.GOO: load("res://particles/goo.tres"),
	ParticleType.MUZZLE_FLASH: load("res://particles/muzzle_flash.tres"),
	ParticleType.NEUCHUNK: load("res://particles/neuchunk.tres"),
	ParticleType.PIXEL: load("res://particles/pixel.tres"),
	ParticleType.SCORE: load("res://particles/score.tres")
}


func get_particle_def(particle_type: int) -> ParticleDef:
	return catalog[particle_type] as ParticleDef
