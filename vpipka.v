module main

import json
import os
import vweb

const (
	port = 3000
)

struct App {
pub mut:
	vweb vweb.Context
}

fn main() {
	mut p := port
	env_port := os.getenv('PORT')
	if env_port != '' {
		p = env_port.int()
	}
	vweb.run<App>(port)
}

pub fn (mut app App) init_once() {
}

pub fn (mut app App) init() {
}

pub fn (mut app App) index() vweb.Result {
	if quiz := get_quiz() {
		text := json.encode(quiz)
		return app.vweb.json(text)
	} else {
		app.vweb.set_status(0, '') // 500 Internal Error
		return app.vweb.text("Can\'t get quiz from site, cause $err")
	}
}
