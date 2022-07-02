module main

import gg
import gx
import math
import rand

struct Asteroid {
mut:
	base 		&GameObject = 0
	size        int
	speed_min   f32  = 0.2
	speed_max   f32  = 3.0
}

fn (mut ast Asteroid) init(verts int, r f32, random f32) {

	mut mid := &Vector{
		int(default_window_width / 2), 
		int(default_window_height / 2)
	}

	mut vec := &Vector{0,0}
	rad := rand.f32() * (math.pi*2)
	vec.set(rad, math.max(default_window_height, default_window_width))
	mid.add(vec)

	speed := rand.f32_in_range(ast.speed_min, ast.speed_max) or {ast.speed_min}
	vec.mul(&Vector{-1, -1})
	vec.set_mag(speed)


	ast.base = &GameObject{
		speed      : vec
		pos 	   : mid
		rot 	   : 0
		limit 	   : 4
		damp 	   : 0
		trsh	   : 0.05

		size 		: int(r)
		components  : []&DrawComponent{}

	}
	


	color := gx.light_gray 

	mut points := [][]f32{
		len: verts,
		init: [f32(0),0]
	}
	for i := 0; i < verts; i++ {

		angle := i * ((math.pi*2) / f32(verts))

		max := 1.0+random
		min := 1.0-random
		modifier := rand.f32_in_range(min, max) or {1}
		
        x := math.sin(angle) * r * modifier
        y := math.cos(angle) * r * modifier
		
		points[i] = [f32(x), f32(y)]
	}

	ast.base.components << &DrawComponent{
		name:  "Asteroid"
		color:  color
		kind:   Kind.empty
		pointsf32: points
	}

}




struct Asteroidmanager {
mut:
	asteroids        []Asteroid    = []
	ast_ptr			 int

	vertice_count    int           = 12
	radius           f32           = 8
	random           f32           = 0.2

	size_max         int           = 4
	size_min         int           = 20
	cooldown         int
	cooldown_max     int           = 400
	cooldown_min     int           = 75
}


fn (mut mgm Asteroidmanager) init() {
	mgm.asteroids = []Asteroid{
		len: default_asteroid_count, 
		init: &Asteroid{
			size: 0
			base: &GameObject{
				active: false
			}
		}
	}
}


fn (mut mgm Asteroidmanager) generate() {

	if mgm.ast_ptr >= mgm.asteroids.len -1 {
		return
	} else if mgm.cooldown > 0 {
		mgm.cooldown--
		return
	} else {
		mgm.cooldown = int((rand.f32() * mgm.cooldown_max) + mgm.cooldown_min)
	}

	mut size := int((rand.f32() * mgm.size_min) + mgm.size_max)

	mut ast := &Asteroid{}
	ast.init(12, f32(size), mgm.random)

	mgm.asteroids[mgm.ast_ptr++] = ast

}

fn (mut mgm Asteroidmanager)  move(bounds &Vector) {

	for mut ast in mgm.asteroids {
		ast.base.move(bounds)
	}

	mut i := 0
	for i < mgm.ast_ptr {
		mgm.asteroids[i].base.move(bounds)

		if !mgm.asteroids[i].base.active {
			mgm.ast_ptr--
			mgm.asteroids[i] = mgm.asteroids[mgm.ast_ptr]
		} 
		else {
			i++
		}
	}
}

fn (mut mgm Asteroidmanager)  draw(ctx gg.Context) {

	for mut ast in mgm.asteroids {
		if ast.base.active {
			ast.base.draw(ctx)
		}
	}
}


fn (mut mgm Asteroidmanager) calculate_collision(obj &GameObject) int {

	if !obj.active {
		return -1
	}

	for mut ast in mgm.asteroids {

		if !ast.base.active {
			continue
		}

		dist := ast.base.pos.dist(obj.pos)
		if dist <= ast.base.size + obj.size {
			ast.base.on_collision(ast.base, obj)
			obj.on_collision(obj, ast.base)
			return math.min(1, ast.base.size) 
		}

	}

	return -1
}
