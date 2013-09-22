ready = ->

	# Words

	if $('h2').text() == "Two letter words"
		$('#btn-two-letters').attr('disabled', true)
	else if $('h2').text() == "Three letter words"
		$('#btn-three-letters').attr('disabled', true)
	else if $('h2').text() == "Four letter words"
		$('#btn-four-letters').attr('disabled', true)
	else if $('h2').text() == "Short words with C"
		$('#btn-c-words').attr('disabled', true)
	else if $('h2').text() == "Short words with W"
		$('#btn-w-words').attr('disabled', true)




# Setup

$(document).ready(ready)
$(document).on('page:load', ready)