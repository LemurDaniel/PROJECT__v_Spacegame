module main

import gg
import gx
import math


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