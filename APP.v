module main

import gg
import gx


struct App {
mut:
    gg         &gg.Context = 0
	bounds	   &Vector 	   = 0
    spaceship  GameObject  = &GameObject{}
}

fn (mut app App) init() {
    app.spaceship.init()
	app.resize()
}

fn (mut app App)  on_event(e &gg.Event) {
    match e.typ {
		.resized {
			app.resize()
		}
        .key_down  {
			match e.key_code {
				.w {
					app.spaceship.thrust()
				}
				.a {
					app.spaceship.turn(-5.0)
				}
                .d {
					app.spaceship.turn(5.0)
				}
                .s {
					//app.handle_click_mode()
				}
				else {}
			}
		}
        else {}
    }

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

    app.spaceship.draw(ctx, app.bounds)
}
