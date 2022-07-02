module main

import gg
import gx

const (
	window_title           = 'V Spaceship Game'
	default_window_width   = 1920
	default_window_height  = 1080
	default_background     = gx.rgb(0, 0, 0)
	default_asteroid_count = 20
	default_text_config    = gx.TextCfg{
		color: gx.white
		size: 20
		align: .center
		vertical_align: .middle
	}
)


fn (mut app App)  on_event(e &gg.Event) {
    match e.typ {
		.resized, .restored, .resumed {
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