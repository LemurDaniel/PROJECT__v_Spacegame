module main

import gg
import gx
import math

struct Spaceship {
mut:
	base        &GameObject = 0
	lives       []GameObject
	thrust 		f32 = 0.4
	init_lives  int = 3


	lasers     []GameObject
	laser_ptr  int
	cooldown   int
	laser_thrust 	   int = 10
	max_laser_parallel int = 50
	min_laser_cooldown int = 15

}

fn (mut ship Spaceship) on_collision() {
	if ship.lives.len > 0 {
		ship.lives.pop()
	}
}

fn (mut ship Spaceship) move(bounds &Vector) {
	ship.base.move(bounds)

	if ship.cooldown > 0 {
		ship.cooldown--
	}

	mut i := 0
	for i < ship.laser_ptr {
		ship.lasers[i].move(bounds)

		if !ship.lasers[i].active {
			ship.laser_ptr--
			ship.lasers[i] = ship.lasers[ship.laser_ptr]
		} 
		else {
			i++
		}
	}

}

fn (mut ship Spaceship) draw(ctx gg.Context) {

	for mut live in ship.lives {
		live.draw(ctx)
	}

	for mut laser in ship.lasers {
		if laser.active {
			laser.draw(ctx)
		}
	}

	ship.base.draw(ctx)
}



fn (mut ship Spaceship) shoot() {

	if ship.cooldown > 0 {
		return
	} else {
		ship.cooldown = ship.min_laser_cooldown
	}

	if ship.laser_ptr >= ship.lasers.len-1 {
		
		for idx in 0..(ship.lasers.len-1) {
			ship.lasers[idx] = ship.lasers[idx+1]
		}
		ship.laser_ptr--
	}

	ship.lasers[ship.laser_ptr++] = &GameObject{

		on_collision: fn (mut self &GameObject, mut obj &GameObject) {
			self.active = false
			self.pos.x = -1000
			self.pos.y = -1000
		}

		on_wrap_bound: fn (mut obj &GameObject) {
			obj.active = false
			obj.pos.x = -1000
			obj.pos.y = -1000
		}

		pos: &Vector{
			ship.base.pos.x + f32(math.cos(ship.base.rot) * 10 * ship.base.scale), 
			ship.base.pos.y + f32(math.sin(ship.base.rot) * 10 * ship.base.scale)
		}
		rot: ship.base.rot
		speed:  &Vector{
			f32(math.cos(ship.base.rot) * ship.laser_thrust),
			f32(math.sin(ship.base.rot) * ship.laser_thrust)
		}
		components: [
			&DrawComponent{
				name: "laser"
				kind: Kind.filled
				color: gx.red
				points: [
					[-5,-1]
					[-5,1]
					[5,1]
					[5,-1]
				]

			}
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

fn (mut ship Spaceship) init() {

	ship.lasers        = []GameObject{len: ship.max_laser_parallel, init: &GameObject{active: false}}

	ship.base           = &GameObject{}
	ship.base.speed     = &Vector{1, 1}
	ship.base.pos 		= &Vector{75, 175}
	ship.base.rot 		= 0
	ship.base.limit 	= 4
	ship.base.damp 		= 0.015
	ship.base.trsh		= 0.05
	ship.base.size 		   = 25

	ship.base.on_collision = 
	fn (mut self &GameObject, mut obj &GameObject) {}


	ship.base.components  = []&DrawComponent{}
	color := gx.white

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


	ship.lives = []GameObject{len: 3}
	for idx in 0..ship.init_lives {

		ship.lives[idx] = &GameObject{
			pos: &Vector{25 + (35*idx), 20}
			rot: -math.pi / 4
			scale: 0.5
			components: ship.base.components
		}
	}

}