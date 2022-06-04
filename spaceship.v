module main

import gg
import gx
import math

enum Shape {
	tri
	rect
	poly
}


struct DrawComponent {
mut:
	name     string
	shape    Shape 
	color    gx.Color   
	points   []&Vector 
}

fn (mut component DrawComponent) draw(ctx gg.Context, rot int, x int, y int) {

	points := component.transform(rot, x, y)

	if component.shape == Shape.tri {
		ctx.draw_triangle_empty(
			points[0],
			points[1],
			points[2],
			points[3],
			points[4],
			points[5],
			component.color
		)
	}
	else if component.shape == Shape.poly {
		ctx.draw_poly_empty(points, component.color)
	}
	

}

fn (mut component DrawComponent) transform(angle int, x int, y int) []f32 {

	mut points := []f32{
		len: component.points.len * 2, 
		init: 0
	}

	rad := math.radians(angle)

	mut index := 0
	for point in component.points {
        sin := math.sin(rad)
        cos := math.cos(rad)

		rot_x := point.x * cos - point.y * sin
		rot_y := point.x * sin + point.y * cos
		
		points[index]   = int(rot_x) + x
		points[index+1] = int(rot_y) + y
		index += 2
	}

	return points
}





struct Spaceship {
mut:
	rot			int
	pos			&Vector  = 0
	speed		&Vector  = 0
	color   	gx.Color
	components 	[]&DrawComponent
}


fn (mut ship Spaceship) init() {
	ship.color 		= gx.black
	ship.pos 		= &Vector{75, 175}
	ship.rot 		= 32
	ship.components = []&DrawComponent

	ship.components << &DrawComponent{
		name: "Shiphull"
		color: ship.color
		shape: Shape.tri
		points: [
			&Vector{20,0}
			&Vector{-20,20}
			&Vector{-20,-20}
		]
	}

	ship.components << &DrawComponent{
		name: "Laser"
		color: ship.color
		shape: Shape.poly
		points: [
			&Vector{18,-1}
			&Vector{30,-1}
			&Vector{30,1}
			&Vector{18,1}
		]
	}

	ship.components << &DrawComponent{
		name: "Thruster left"
		color: ship.color
		shape: Shape.poly
		points: [
			&Vector{-20,-5}
			&Vector{-20,-14}
			&Vector{-30,-14}
			&Vector{-30,-5}
		]
	}

	ship.components << &DrawComponent{
		name: "Thruster right"
		color: ship.color
		shape: Shape.poly
		points: [
			&Vector{-20,5}
			&Vector{-20,14}
			&Vector{-30,14}
			&Vector{-30,5}
		]
	}
}

fn (mut ship Spaceship) draw(ctx gg.Context) {

	x := ship.pos.x
	y := ship.pos.y
	color := ship.color

	ctx.draw_text(40, 90, ship.components[1].str())

	ctx.draw_text(x -28, y, "Test2")

	for mut component in ship.components {
		component.draw(ctx, ship.rot, ship.pos.x, ship.pos.y)
	}


}