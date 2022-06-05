module main

import gg
import gx
import math

struct GameObject {
mut:
	rot			f32
	damp 		f32
	trsh		f32
	thrust 		f32
	size 		int
	limit		int
	pos			&Vector  = 0
	speed		&Vector  = 0
	components 	[]&DrawComponent
}

fn (mut obj GameObject) init() {
	obj.speed 		= &Vector{1, 1}
	obj.pos 		= &Vector{75, 175}
	obj.rot 		= 0
	obj.limit 		= 4
	obj.damp 		= 0.015
	obj.trsh		= 0.05
	obj.thrust		= 0.4
	obj.size 		= 50
	obj.components  = []&DrawComponent{}
	
	color := gx.black

	obj.components << &DrawComponent{
		name: "Shiphull"
		color: color
		kind:  Kind.empty
		points: [
			[20,0]
			[-20,20]
			[-20,-20]
		]
	}

	obj.components << &DrawComponent{
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

	obj.components << &DrawComponent{
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

	obj.components << &DrawComponent{
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

fn (mut obj GameObject) bounds(bound_x int, bound_y int) {
	if obj.pos.x > bound_x + obj.size {
		obj.pos.x = 0 - obj.size + 5
	}
	if obj.pos.y > bound_y + obj.size {
		obj.pos.y = 0 - obj.size + 5
	}
	if obj.pos.x < 0 - obj.size {
		obj.pos.x = 0 + obj.size - 5
	}
	if obj.pos.y < 0 - obj.size {
		obj.pos.y = 0 + obj.size - 5
	}
}

fn (mut obj GameObject) move(bounds &Vector) {
	obj.pos.add(obj.speed)
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

fn (mut obj GameObject) turn(rad f32) {
	obj.rot += f32(math.radians(rad))
}

fn (mut obj GameObject) thrust() {
	mut acc := &Vector{0,0}
	acc.set(obj.rot, obj.thrust)

	obj.speed.add(acc)
	obj.speed.limit(obj.limit)
}

fn (mut obj GameObject) draw(ctx gg.Context, bounds &Vector) {
	obj.move(bounds)

	x := obj.pos.x 
	y := obj.pos.y
	ctx.draw_text(20, 100, obj.damp.str())
	ctx.draw_text(20, 120, obj.speed.str())
	for mut component in obj.components {
		component.draw(ctx, obj.rot, obj.pos.x, obj.pos.y)
	}

	

}