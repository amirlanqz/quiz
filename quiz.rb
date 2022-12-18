require 'yaml'

puts "Сіздің атыңыз: "
name = gets.strip.capitalize

current_time = Time.now.strftime('%Y-%m-%d_%H-%M-%S')

filename = "QUIZ_#{name}_#{current_time}.txt"

File.write(
	filename,
	"results for users #{name}\n\n#{current_time}",
	mode: 'a'
	)
a_code = 'A'.ord

correct_answers = 0
incorrect_answers = 0

all_questions = YAML.safe_load_file('questions.yaml', symbolize_names: true)

all_questions.shuffle.each do |question_data|
	formatted_quiestion = "\n\n=== #{question_data[:question]} ===\n\n"
	puts formatted_quiestion

	File.write(
	filename,
	formatted_quiestion,
	mode: 'a'
	)

	correct_answer = question_data[:answers].first

	answers = question_data[:answers].shuffle.each_with_index.inject({}) do |result, (answer, i)|
		answers_char = (a_code + i).chr
		result[answers_char] = answer

		puts "#{answers_char} #{answer}"

		result
	end

	user_answer_char = nil

	loop do
		puts "your answer: "
		user_answer_char = gets.strip.capitalize[0]

		if user_answer_char.between?('A', 'D')
			break
		else
			puts "Answer chooce A to D"
		end
	end

	File.write(
	filename,
	"Answer user #{answers[user_answer_char]}",
	mode: 'a'
	)

	if answers[user_answer_char] == correct_answer
		puts "Correct"
		correct_answers = correct_answers + 1
		File.write(
			filename,
			"Correct answer",
			mode: 'a'
		)
	else
		puts "Incorrect. Correct answer is #{correct_answer}"
		incorrect_answers = incorrect_answers + 1 
	end


	
end

correct_answers_percentage = (correct_answers / all_questions.length.to_f) * 100

File.write(
	filename,
	"\n\ncorrect answers percentage: #{correct_answers_percentage.floor(2)}\n\n",
	mode: 'a'
	)