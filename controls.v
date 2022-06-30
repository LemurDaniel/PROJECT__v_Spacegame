module main

import gg
import gx

const (
	window_title          = 'V Spaceship Game'
	default_window_width  = 544
	default_window_height = 560
	default_background    = gx.rgb(0, 0, 0)
)


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
                .f {
					app.spaceship.shoot()
				}
				else {}
			}
		}
        else {}
    }

}