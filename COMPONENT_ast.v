module main

import gg
import gx
import math
import rand

struct Asteroid {
mut:
	base 		&GameObject = 0
}

fn (mut ast Asteroid) init(verts int, r f32, random f32) {

	ast.base = &GameObject{
		speed      : &Vector{0.1, 0.1}
		pos 	   : &Vector{350, 350}
		rot 	   : 0
		limit 	   : 4
		damp 	   : 0
		trsh	   : 0.05

		size 		: 50
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
}


fn (mut mgm Asteroidmanager) init() {

	mut ast :=  &Asteroid{}
	ast.init(12, 48, 0)
	ast.base.pos.x = 280
	ast.base.pos.y = 320
	mgm.asteroids << ast

	ast =  &Asteroid{}
	ast.init(12, 58, 0.3)
	ast.base.pos.x = 173
	ast.base.pos.y = 240
	mgm.asteroids << ast

	mgm.ast_ptr = 2

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


fn (mut mgm Asteroidmanager) calculate_collision(obj &GameObject) bool {

	if !obj.active {
		return false
	}

	for mut ast in mgm.asteroids {

		if !ast.base.active {
			continue
		}

		dist := ast.base.pos.dist(obj.pos)
		if dist <= ast.base.size + obj.size {
			ast.base.on_collision(ast.base, obj)
			obj.on_collision(obj, ast.base)
			return true
		}

	}

	return false
}
