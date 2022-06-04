module main

import gg
import gx


struct Canvas {
mut:
	gg         &gg.Context = 0
}






fn frame(mut ctx gg.Context) {
    mut vector := &Vector{20,20}
	mut vector2 := &Vector{30,30}
	
	str := "Sub: " + vector.sub(vector2).str()
    str2 := "Dist: " + vector.dist(vector2).str()
    str3 := "Mag: " + vector.mag().str()

    ctx.begin()
    ctx.draw_text(20, 20, str)
    ctx.draw_text(20, 50, str2)
    ctx.draw_text(20, 70, str3)
    ctx.end()
}


fn (mut canvas Canvas) draw_rect() {



}