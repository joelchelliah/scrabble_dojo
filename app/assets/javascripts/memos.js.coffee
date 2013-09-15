# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

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

	# Index 

	#$('.bar').css("left", "-300px")
	#$('.bar').animate({ left: '0' }, 1500);


	# Show page

	$('#box-hints').hide()
	$('#box-practice').hide()
	#$('#box-words-solutions').hide()

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
		else
			$('#btn-practice').text("Practice").removeClass('btn-danger').addClass('btn-primary')
			show_hints()
			show_words()
			$('#btn-hints').attr('disabled', false)
			$('#btn-words').attr('disabled', false)
			$('#box-practice').hide('fast')


	# Results page

	prev_health = "-" + (527 - $('#prev-health').text() * 527 / 100) + "px"
	$('.health-update .progress .bar').css("left", prev_health)
	$('.health-update .progress .bar').animate({left: '0'}, 2000)


# Setup

$(document).ready(ready)
$(document).on('page:load', ready)