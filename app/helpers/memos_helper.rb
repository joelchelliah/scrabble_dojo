module MemosHelper

	def health(memo)
		decay_diff = ((Time.now - memo.health_decay) / 1.day).to_i
		health = 100 - 3 * decay_diff
		health = 1 if health < 1
		health = 100 if health > 100
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
		regained = health(@memo) - @prev_health

		show = "<div class='text'>"
		if @prev_health == 100
			show << "<b> Your health is already at 100% </b>"
		else
			show << "<span class='text-danger'>" if regained.zero?
			show << "<b>Regained #{regained}% health!</b>"
			show << "<p><b>You made too many mistakes.</b></p>" if regained.zero?
			show << "</span>" if regained.zero?
		end
		show <<	"</div>"
		show.html_safe
	end
end
