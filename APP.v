module main

import gg
import gx


struct App {
mut:
    gg         &gg.Context = 0
    spaceship  Spaceship = &Spaceship{}
}

fn (mut app App) init() {
    app.spaceship.init()
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

    app.spaceship.draw(ctx)
}
