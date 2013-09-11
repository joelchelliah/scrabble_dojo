module MemosHelper

	def show_health(memo)
		health = 100 - (3 * (Time.now - memo.health_decay) / 1.day).to_i
		health = 1 if health < 1
		color = "success"
		color = "warning" if health <= 75
		color = "danger" if health <= 25
		"<div class='progress progress-#{color} progress-striped active'><div class='bar' style='width: #{health}%'></div></div>".html_safe
	end

	def show_num_words(memo)
		"#{memo.word_list.split.count} words"
	end

	def show_hints
		h(@memo.hints).gsub(/\n/, '<br/>').html_safe
	end

	def show_word_list
		h(@memo.word_list).gsub(/\n/, '<br/>').html_safe
	end
end
