hide_hints = ->
	$('#btn-hints').text("Show hints")
	$('#box-words').removeClass('span3').addClass('span8')
	$('#box-hints').hide()

show_hints = ->
	$('#btn-hints').text("Hide hints")
	$('#box-words').removeClass('span8').addClass('span3')
	$('#box-hints').show('fast')

hide_words = ->
	$('#btn-words').text("Show words")
	$('#box-words').hide('fast')

show_words = ->
	$('#btn-words').text("Hide words")
	$('#box-words').show('fast')


ready = ->

	# Create page

	if $('h2').text() == "Create"
		$('#memo_name').focus()


	# Edit page

	if $('h2').text() == "Edit"
		$('#memo_word_list').focus()


	# Index page
	#
	#

	# Show page

	if $('h2').text() == 'Revise'
		$('#box-hints').hide()
		$('#box-practice').hide()
		$('#btn-practice').focus()

		$('#btn-hints').click (e)->
			e.preventDefault()
			if !$('#btn-hints').attr('disabled')
				if $('#btn-hints').text() == "Show hints" then show_hints() else hide_hints()

		$('#btn-words').click (e)->
			e.preventDefault()
			if !$('#btn-words').attr('disabled')
				if $('#btn-words').text() == "Show words" then show_words() else hide_words()		

		$('#btn-practice').click (e)->
			e.preventDefault()
			if $('#btn-practice').text() == "Practice"
				$('#btn-practice').text("Cancel").removeClass('btn-primary').addClass('btn-danger')
				hide_hints()
				hide_words()
				$('#btn-hints').attr('disabled', true)
				$('#btn-words').attr('disabled', true)
				$('#box-practice').show('fast')
				$('#practice-text-area').focus()
			else
				$('#btn-practice').text("Practice").removeClass('btn-danger').addClass('btn-primary')
				show_hints()
				show_words()
				$('#btn-hints').attr('disabled', false)
				$('#btn-words').attr('disabled', false)
				$('#box-practice').hide('fast')


	# Results page

	if $('h2').text() == 'Results'
		$('#btn-overview').focus()

		max = 620
		prev_health = $('#prev-health').text() * max / 100
		current_health = $('.health-update .progress .bar').width()
		move_left = (prev_health - current_health) + "px"

		$('.health-update .progress .bar').css("left", move_left)
		$('.health-update .progress .bar').animate({left: '0'}, 2000)


# Setup

$(document).ready(ready)
$(document).on('page:load', ready)