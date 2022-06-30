module main

import gg


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

fn (mut app App) game_loop(ctx gg.Context) {

	app.asteroids.move(app.bounds)
    app.spaceship.move(app.bounds)

	app.asteroids.draw(ctx)
    app.spaceship.draw(ctx)
	
	ctx.draw_text(20, 100, app.spaceship.base.pos.str())
}


fn (mut app App) collision_check() {




}
