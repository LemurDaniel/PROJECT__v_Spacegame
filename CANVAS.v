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

fn (mut component DrawComponent) draw(ctx gg.Context, rot f32, x f32, y f32) {

	points := component.transform(rot, x, y)

	if component.kind == Kind.empty {
        ctx.draw_poly_empty(points, component.color)
    }
	else if component.kind == Kind.filled {
		ctx.draw_convex_poly(points, component.color)
	}
	
}

fn (mut component DrawComponent) transform(rad f32, x f32, y f32) []f32 {

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

		rot_x := point[0] * cos - point[1] * sin
		rot_y := point[0] * sin + point[1] * cos
		
		points[index]   = f32(rot_x) + x
		points[index+1] = f32(rot_y) + y
		index += 2
	}

	// Close shape by appending first vertice as last.
	points[points.len-2] = points[0]
	points[points.len-1] = points[1]

	return points
}



