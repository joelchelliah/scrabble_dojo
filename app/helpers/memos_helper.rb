module MemosHelper

	def health(memo)
		health = 100 - (3 * (Time.now - memo.health_decay) / 1.day).to_i
		health = 1 if health < 1
		health
	end

	def health_bar(memo)
		health = health memo
		color = "success"
		color = "warning" if health <= 75
		color = "danger" if health <= 25
		"<div class='progress progress-#{color} progress-striped active'><div class='bar' style='width: #{health}%'></div></div>".html_safe
	end

	def show_num_words(memo)
		"#{memo.word_list.split.count} words"
	end

	def show_word_list(list)
		h(list).gsub(/\r?\n/, '<br/>').html_safe
	end

	def show_regained_health()
		health(@memo) - @prev_health
	end
end
