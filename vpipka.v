module main

import os
import vweb
import x.json2 as js

const (
	port = 3000
)

struct App {
pub mut:
	vweb vweb.Context
	quiz string
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
	quiz := get_quiz() or {
		println("Can\'t get quiz from site, cause $err")
		return
	}
	app.quiz = js.encode<Quiz>(quiz)
}

pub fn (mut app App) init() {
}

pub fn (mut app App) index() vweb.Result {
	return app.vweb.json(app.quiz)
}

pub fn (mut app App) reset() vweb.Result {
	quiz := get_quiz() or {
		app.vweb.set_status(0, '') // 500 Internal Error
		return app.vweb.text("Can\'t get quiz from site, cause $err")
	}
	app.quiz = js.encode<Quiz>(quiz)
	return app.vweb.ok("Success")
}
