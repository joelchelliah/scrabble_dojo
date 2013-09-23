module MemosHelper

	# general

	def health(memo)
		health = 100 - 3 * decay_diff(memo)
		health = 1 if health < 1
		health = 100 if health > 100
		health
	end

	def health_inc(memo, num_errors)
		(decay_diff(memo) / (1 + num_errors)).to_i
	end

	def health_bar(memo)
		h = health memo
		c = health_color memo
		"<div class='progress progress-#{c} progress-striped active'><div class='bar' style='width: #{h}%'></div></div>".html_safe
	end

	def show_word_list(list)
		h(list).gsub(/\r?\n/, '<br/>').html_safe
	end


	# Show page

	def show_health()
		h = health @memo
		c = health_text_color @memo
		"<span class='text-#{c}'>#{h}%</span>".html_safe
	end


	# Results page

	def show_regained_health()
		regained = health(@memo) - @prev_health

		show = "<div class='text'>"
		if @prev_health == 100
			show << "<strong> Your health is already at 100% </strong>"
		else
			show << "<span class='text-error'>" if regained.zero?
			show << "<span class='text-success'>" unless regained.zero?
			show << "<strong>Health replenished: #{regained}%</strong>"
			show << "<p><strong>You made too many mistakes.</strong></p>" if regained.zero?
			show << "</span>" if regained.zero?
		end
		show <<	"</div>"
		show.html_safe
	end


	# Index page

	def color_memo_row(memo)
		color = health_text_color memo
		return color unless color == "success"
		""
	end

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
		c = "success"
		c = "warning" if avg <= 75
		c = "error" if avg <= 25
		"<span class='text-#{c}'>#{avg}%</span>".html_safe
	end


	private

		def health_color(memo)
			health = health(memo)
			color = "success"
			color = "warning" if health <= 75
			color = "danger" if health <= 25
			color
		end

		def health_text_color(memo)
			health_color(memo).gsub("danger", "error")
		end

		def decay_diff(memo)
			((Time.now - memo.health_decay) / 1.day).to_i
		end
end
