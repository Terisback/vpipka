module main

import net.html
import net.http

const(
	address = "https://quiz-geek.ru/randomquestions"
)

struct Item {
	question string
	answer string
}

fn get_quiz() ?[]Item {
	resp := http.get(address) or {
		return error(err)
	}

	if resp.status_code != 200 {
		return error("Status is not 200")
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

	return quiz
}