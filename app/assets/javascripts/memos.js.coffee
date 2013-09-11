# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


ready = ->

	# Index 

	#$('.bar').css("left", "-300px")
	#$('.bar').animate({ left: '0' }, 1500);


	# Show page

	$('#box-hints').hide()
	$('#btn-hints').click (e)->
		e.preventDefault()
		$('#box-hints').toggle('slow')

	$('#btn-words').click (e)->
		e.preventDefault()
		$('#box-words').toggle('slow')

	$('#btn-revise').click (e)->
		e.preventDefault()
		$('#box-hints').hide('slow')
		$('#box-words').hide('slow')


# Setup

$(document).ready(ready)
$(document).on('page:load', ready)