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



	# Manage words

	if $('h2').text() == "Manage"
		$('#word').focus()


	# Remove word

	if $('h2').text().indexOf "Remove" == 0
		$('#btn-cancel').focus()


	# Add word

	if $('h2').text().indexOf "Add" == 0
		$('#btn-cancel').focus()


# Setup

$(document).ready(ready)
$(document).on('page:load', ready)