module main

import gg


struct App {
mut:       
    gg         &gg.Context  = 0
	bounds	   &Vector 	    = 0
    spaceship  &Spaceship   = &Spaceship{}
	asteroids  &Asteroidmanager = &Asteroidmanager{}
    score      int  
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

	mut spaceship := app.spaceship
	mut asteroids := app.asteroids

	asteroids.generate()

	asteroids.move(app.bounds)
    spaceship.move(app.bounds)


	if asteroids.calculate_collision(spaceship.base) > 0 {
		spaceship.on_collision()
	}

	for laser in spaceship.lasers {
		points := asteroids.calculate_collision(laser)
		if points > 0 {
			app.score += points
		}
	}


	asteroids.draw(ctx)
    spaceship.draw(ctx)

	ctx.draw_text(default_window_width-50, 20, "Score: " + app.score.str(), default_text_config)
	ctx.draw_text(default_window_width/2, 20, "Asteroids: " + asteroids.ast_ptr.str() + "/" + asteroids.asteroids.len.str(), default_text_config)
	ctx.draw_text(default_window_width/2, 40, "Next in: " + asteroids.cooldown.str(), default_text_config)
}
