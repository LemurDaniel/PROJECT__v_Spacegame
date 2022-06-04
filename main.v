module main

import gg


fn frame(mut app App) {
	app.gg.begin()
	app.draw(app.gg)
	app.gg.end()
}

fn init(mut app App) {
	app.init()
}

fn main() {

	mut app := &App{}

	app.gg = gg.new_context(
		bg_color: default_background
		width: default_window_width
		height: default_window_height
		sample_count: 1
		create_window: true
		window_title: window_title
		frame_fn: frame
		user_data: app
		//event_fn: on_event
		init_fn: init
	)

	app.gg.run()

}