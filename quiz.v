module main

import net.html
import net.http
import x.json2 as js

const (
	address = 'https://quiz-geek.ru/randomquestions'
)

struct Quiz {
mut:
	quiz []Item = []Item{}
}

struct Item {
	question string
	answer   string
}

// It isn't used anywhere, I've implemented this just for fun
pub fn (mut q Quiz) from_json(f js.Any){
	arr := f.arr()
	for item in arr{
		mut question := ''
		mut answer := ''
		for k, v in item.as_map(){
			match k {
				'question' {question = v.str()}
				'answer' {answer = v.str()}
				else {}
			}
		}
		q.quiz << Item{question, answer}
	}
}

pub fn (q Quiz) to_json() string{
	mut arr := []js.Any{}
	for item in q.quiz {
		mut quiz_item := map[string]js.Any
		quiz_item['question'] = item.question.replace('\n', '')
		quiz_item['answer'] = item.answer.replace('\n', '')
		arr.insert_map(quiz_item)
	}
	return arr.str()
}

fn get_quiz() ?Quiz {
	resp := http.get(address) or {
		return error(err)
	}
	if resp.status_code != 200 {
		return error('Status is not 200, it\'s ${resp.status_code}')
	}

	mut quiz := Quiz{}
	mut parser := html.Parser{}
	parser.parse_html(resp.text, false)

	mut tbody := parser.get_dom().get_by_tag('table')[0]
	for tr in tbody.get_children() {
		mut td := tr.get_children()[0]

		question := td.get_children()[0].get_content()
		ans_holder := td.get_children()[1].get_children()[1].get_content()
		answer := ans_holder.split('content :')[1].split('\"')[1]

		quiz.quiz << Item{
			question: question.trim_space()
			answer: answer.trim_space()
		}

		question.free()
		ans_holder.free()
		answer.free()
	}

	return quiz
}
