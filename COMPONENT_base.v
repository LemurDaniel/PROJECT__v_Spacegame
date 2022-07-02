module main


import gg
import gx
import math


enum Kind {
	filled // needs vertices clockwise and start and end vertice the same.
    empty
}


struct DrawComponent {
mut:
	name     string
	kind     Kind 
	color    gx.Color   
	points    [][]int
	pointsf32 [][]f32
}

fn (mut component DrawComponent) draw_layers(ctx gg.Context, layers int, rot f32, scale f32, x f32, y f32){

	for layer in 0..layers {
		component.draw(ctx, rot, scale - (0.02 * layer), x, y)
	}
}

fn (mut component DrawComponent) draw(ctx gg.Context, rot f32, scale f32, x f32, y f32) {

	points := component.transform(rot, scale, x, y)

	if component.kind == Kind.empty {
        ctx.draw_poly_empty(points, component.color)
    }
	else if component.kind == Kind.filled {
		ctx.draw_convex_poly(points, component.color)
	}
	
}

fn (mut component DrawComponent) transform(rad f32, scale f32, x f32, y f32) []f32 {

	if component.pointsf32.len == 0 {

		component.pointsf32 = [][]f32{
			len: component.points.len,
			init: [f32(0),0]
		}
		for index, point in component.points {
			component.pointsf32[index] = [
				f32(point[0]), f32(point[1])
			]
		}
	}
	

	mut points := []f32{
		len: component.pointsf32.len * 2 +2, 
		init: 0
	}

	mut index := 0
	for point in component.pointsf32 {
        sin := math.sin(rad)
        cos := math.cos(rad)

		rot_x := (point[0] * cos - point[1] * sin) * scale
		rot_y := (point[0] * sin + point[1] * cos) * scale
		
		// apply offset to rotation
		points[index]   = f32(rot_x) + x
		points[index+1] = f32(rot_y) + y
		index += 2
	}

	// Close shape by appending first vertice as last.
	points[points.len-2] = points[0]
	points[points.len-1] = points[1]

	return points
}


// ###########################################


struct GameObject {
mut:
	layers      int	 = 5
	size 		int
	limit		int
	rot			f32
	damp 		f32
	trsh		f32
	speed_ang   f32
	scale    	f32  = f32(1.0)
	active		bool = true
	pos			&Vector  = &Vector{0, 0}
	speed		&Vector  = &Vector{0, 0}
	components 	[]&DrawComponent
	
	on_wrap_bound fn (obj &GameObject)  
	 = fn(obj &GameObject) { }

	on_collision fn (mut self &GameObject, mut obj &GameObject) = 
		fn (mut self &GameObject, mut obj &GameObject) {
			self.active = false
		}
}


fn (mut obj GameObject) bounds(bound_x int, bound_y int) {
	mut wrapped_bound := false

	if obj.pos.x > bound_x + obj.size {
		obj.pos.x = 0 - obj.size + 5
		wrapped_bound = true
	}
	if obj.pos.y > bound_y + obj.size {
		obj.pos.y = 0 - obj.size + 5
		wrapped_bound = true
	}
	if obj.pos.x < 0 - obj.size {
		obj.pos.x = bound_x + obj.size - 5
		wrapped_bound = true
	}
	if obj.pos.y < 0 - obj.size {
		obj.pos.y = bound_y + obj.size - 5
		wrapped_bound = true
	}

	if wrapped_bound {
		obj.on_wrap_bound(obj)
	}
}

fn (mut obj GameObject) move(bounds &Vector) {
	obj.pos.add(obj.speed)
	obj.rot += obj.speed_ang
	obj.bounds(
		int(bounds.x), 
		int(bounds.y)
		)

	if obj.speed.x > obj.trsh {
		obj.speed.x -= obj.damp
	} 
	else if obj.speed.x < -obj.trsh {
		obj.speed.x += obj.damp
	}
	else {
		obj.speed.x = 0
	}

	if obj.speed.y > obj.trsh {
		obj.speed.y -= obj.damp
	}
	else if obj.speed.y < -obj.trsh {
		obj.speed.y += obj.damp
	}
	else {
		obj.speed.y = 0
	}
}

fn (mut obj GameObject) draw(ctx gg.Context) {

	for mut component in obj.components {
		component.draw_layers(ctx, obj.layers, obj.rot, obj.scale, obj.pos.x, obj.pos.y)
	}

	// ctx.draw_circle_empty(obj.pos.x, obj.pos.y, obj.size, gx.white)

}