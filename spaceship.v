module main

import gg
import gx
import math

struct Spaceship {
mut:
	base        &GameObject = 0
	thrust 		f32
}

fn (mut ship Spaceship) init() {
	ship.thrust		= 0.4

	ship.base           = &GameObject{}
	ship.base.speed     = &Vector{1, 1}
	ship.base.pos 		= &Vector{75, 175}
	ship.base.rot 		= 0
	ship.base.limit 		= 4
	ship.base.damp 		= 0.015
	ship.base.trsh		= 0.05

	ship.base.size 		= 50
	ship.base.components  = []&DrawComponent{}
	
	color := gx.black

	ship.base.components << &DrawComponent{
		name: "Shiphull"
		color: color
		kind:  Kind.empty
		points: [
			[20,0]
			[-20,20]
			[-20,-20]
		]
	}

	ship.base.components << &DrawComponent{
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

	ship.base.components << &DrawComponent{
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

	ship.base.components << &DrawComponent{
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

fn (mut ship Spaceship) turn(rad f32) {
	ship.base.rot += f32(math.radians(rad))
}

fn (mut ship Spaceship) thrust() {
	mut acc := &Vector{0,0}
	acc.set(ship.base.rot, ship.thrust)

	ship.base.speed.add(acc)
	ship.base.speed.limit(ship.base.limit)
}