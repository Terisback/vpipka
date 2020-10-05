module main

import net.html
import net.http
import json
import os

const(
	address = "https://quiz-geek.ru/randomquestions"
)

struct Item {
	question string
	answer string
}

fn main() {
	resp := http.get(address) or {
		println(err)
		return
	}

	if resp.status_code != 200 {
		println('Status code is ${resp.status_code}')
		println('Unavailable to continue...')
		return
	}

	mut quiz := []Item{}
	
	mut parser := html.Parser{}
	parser.parse_html(resp.text, false)
	mut tbody := parser.get_dom().get_by_tag("table")[0]
	for tr in tbody.get_children(){
		mut td := tr.get_children()[0]
		question := td.get_children()[0].get_content()
		ans_holder := td.get_children()[1].get_children()[1].get_content()
		answer := ans_holder.split("content :")[1].split("\"")[1]

		quiz << Item{question: question.trim_space(), answer: answer.trim_space()}
	}

	os.write_file("quiz.json", json.encode(quiz)) or {
		println('Can\'t json\'ify quiz cause ${err}')
		return
	}

	println("Success!")
}	