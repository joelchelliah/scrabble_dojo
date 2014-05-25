class Timer
  constructor: (@target_id = "#timer") ->

  init: ->
    @reset()
    window.tick = =>
      @tick()
    setInterval(window.tick, 100)

  kill: ->
  	@target_id = "#dead"
  	@reset()

  reset: ->
    @seconds = 0
    @one_tenth = 0
    @updateTarget()

  tick: ->
    [one_tenth, seconds] = [@one_tenth, @seconds]
    if one_tenth is 9
      @seconds = seconds + 1
      @one_tenth = 0
    else
      @one_tenth = one_tenth + 1
    @updateTarget()

  updateTarget: ->
    $(@target_id).attr('value', (@seconds + "." + @one_tenth))


hide_hints = ->
	$('#btn-hints').text("Show hints")
	$('#box-words').removeClass('span3').addClass('span8')
	$('#box-hints').hide('fast')

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

	if $('h2').text().indexOf "Create" > -1
		$('#memo_name').focus()
		$('#advanced-options').hide()

		$('#advanced-options-link a').click (e)->
			e.preventDefault()
			$('#advanced-options-link').hide('fast')
			$('#advanced-options').slideDown('fast')
			$('#memo_accepted_words').focus()
			


	# Edit page
	if $('h2').text().indexOf "Update" > -1
    $('#advanced-options').show()
		$('#memo_word_list').focus()

		if $('#memo_accepted_words').text() == ""
			$('#advanced-options').hide()
		else
			$('#advanced-options-link').hide()

		$('#advanced-options-link a').click (e)->
			e.preventDefault()
			$('#advanced-options-link').hide('fast')
			$('#advanced-options').slideDown('fast')
			$('#memo_accepted_words').focus()


	# Index page
	#
	#

	# Show page
	timer = new Timer('#memo-timer')
	if $('h2').text().indexOf "Revise" > -1
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
				timer = new Timer('#memo-timer')
				timer.init()
			else
				timer.kill()
				$('#btn-practice').text("Practice").removeClass('btn-danger').addClass('btn-primary')
				show_hints()
				show_words()
				$('#btn-hints').attr('disabled', false)
				$('#btn-words').attr('disabled', false)
				$('#practice-text-area').val('')
				$('#box-practice').hide('fast')

			$('#practice-done').click (e)->
				$('#memo-timer').after("<span class='text-success'>Saving results...</span>")
				$('#memo-timer').after("<span>Time: " + $('#memo-timer').attr('value') + "seconds. &nbsp; </span>")
				$('#memo-timer').hide()
				


	# Results page

	if $('h2').text().indexOf "Results" > -1
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