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

	def show_word_list(list)
		h(list).gsub(/\r?\n/, '<br/>').html_safe
	end


	# Show page

	def show_health()
		h = health(@memo)
		color = "green"
		color = "yellow" if h <= 75
		color = "red" if h <= 25
		"<span class='text-#{color}'>#{h}%</span>".html_safe
	end


	# Results page

	def show_regained_health()
		regained = health(@memo) - @prev_health

		show = "<div class='text'>"
		if @prev_health == 100
			show << "<strong> Your health is already at 100% </strong>"
		else
			show << "<span class='text-danger'>" if regained.zero?
			show << "<strong>Health replenished: #{regained}%</strong>"
			show << "<p><strong>You made too many mistakes.</strong></p>" if regained.zero?
			show << "</span>" if regained.zero?
		end
		show <<	"</div>"
		show.html_safe
	end


	# Index page

	def show_word_count(memo)
		memo.word_list.split.count
	end

	# # memo-status (index page)

	def show_total_word_count()
		return 0 if @memos.blank?
		@memos.inject(0) { |acc, m| acc + m.word_list.split.count }
	end

	def show_total_practice_count()
		return 0 if @memos.blank?
		@memos.inject(0) { |acc, m| acc + m.num_practices }
	end

	def show_average_health()
		return 0 if @memos.blank?
		avg = @memos.inject(0) { |acc, m| acc + health(m) } / @memos.count
		color = "green"
		color = "yellow" if avg <= 75
		color = "red" if avg <= 25
		"<span class='text-#{color}'>#{avg}%</span>".html_safe
		
	end
end
