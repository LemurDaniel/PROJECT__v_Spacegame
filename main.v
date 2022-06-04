module main

import gg

fn main() {

	mut canvas := &Canvas{}

	canvas.gg = gg.new_context(
		bg_color: default_background
		width: default_window_width
		height: default_window_height
		sample_count: 1
		create_window: true
		window_title: window_title
		frame_fn: frame
		//event_fn: on_event
		//init_fn: init
	)

	canvas.gg.run()

}