module main

import gg
import gx


struct App {
mut:
    gg         &gg.Context = 0
	bounds	   &Vector 	   = 0
    spaceship  &Spaceship   = &Spaceship{}
	asteroids  &Asteroidmanager = &Asteroidmanager{}
}

fn (mut app App) init() {
    app.spaceship.init()
	app.asteroids.init()
	app.resize()
}


fn (mut app App) resize() {
	window_size := app.gg.window_size()
	app.bounds = &Vector{
		window_size.width,
	    window_size.height
	}
}

fn (mut app App) draw(ctx gg.Context) {

    mut vector := &Vector{20,20}
	mut vector2 := &Vector{30,30}
	
	str := "Sub: " + vector.sub(vector2).str()
    str2 := "Dist: " + vector.dist(vector2).str()
    str3 := "Mag: " + vector.mag().str()

    ctx.draw_text(20, 20, str)
    ctx.draw_text(20, 50, str2)
    ctx.draw_text(20, 70, str3)

	app.asteroids.draw(ctx, app.bounds)
    app.spaceship.base.draw(ctx, app.bounds)

	ctx.draw_text(20, 170, app.asteroids.asteroids[0].base.components[0].pointsf32.str())
}
