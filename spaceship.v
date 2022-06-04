module main

import term
import gg
import gx

struct Spaceship {
mut:
	rot			int
	pos			&Vector  = 0
	speed		&Vector  = 0
	components 	[]&DrawComponent
}

fn (mut ship Spaceship) init() {
	ship.speed 		= &Vector{1, 1}
	ship.pos 		= &Vector{75, 175}
	ship.rot 		= 0
	ship.components = []&DrawComponent{}
	
	color := gx.black

	ship.components << &DrawComponent{
		name: "Shiphull"
		color: color
		kind:  Kind.empty
		points: [
			[20,0]
			[-20,20]
			[-20,-20]
		]
	}

	ship.components << &DrawComponent{
		name: "Laser"
		color: gx.cyan
		kind:  Kind.filled
		points: [
			[18,-1]
			[18,1]
			[30,1]
			[30,-1]
		]
	
	}

	ship.components << &DrawComponent{
		name: "Thruster left"
		color: gx.dark_gray 
		kind:  Kind.filled
		points: [
			[-20,-14]
			[-20,-5]
			[-30,-5]
			[-30,-14]
		]
	}

	ship.components << &DrawComponent{
		name: "Thruster right"
		color: gx.dark_gray 
		kind:  Kind.filled
		points: [
			[-20,14]
			[-20,5]
			[-30,5]
			[-30,14]
		]
	}


}

fn (mut ship Spaceship) bounds(bound_x int, bound_y int, offset int) {
	if ship.pos.x > bound_x + offset {
		ship.pos.x = 0 - offset + 5
	}
	if ship.pos.y > bound_y + offset {
		ship.pos.y = 0 - offset + 5
	}
	if ship.pos.x < 0 - offset {
		ship.pos.x = 0 + offset - 5
	}
	if ship.pos.y < 0 - offset {
		ship.pos.y = 0 + offset - 5
	}
}

fn (mut ship Spaceship) move() {
	ship.pos.add(ship.speed)
}

fn (mut ship Spaceship) draw(ctx gg.Context) {
	ship.move()
	ship.bounds(544, 544, 50)

	rot := ship.speed.heading()
	x := ship.pos.x 
	y := ship.pos.y

	pos := term.get_cursor_position() or { term.Coord{-4,0} }
	ctx.draw_text(40, 90, pos.str())

	for mut component in ship.components {
		component.draw(ctx, rot, ship.pos.x, ship.pos.y)
	}



}