ready = ->

	# Words

	if $('h2').text() == "Two letter words"
		$('#btn-two-letters').attr('disabled', true)
	else if $('h2').text() == "Three letter words"
		$('#btn-three-letters').attr('disabled', true)
	else if $('h2').text() == "Four letter words"
		$('#btn-four-letters').attr('disabled', true)
	else if $('h2').text() == "Five letter words"
		$('#btn-five-letters').attr('disabled', true)
	else if $('h2').text() == "Short words with C"
		$('#btn-c-words').attr('disabled', true)
	else if $('h2').text() == "Short words with W"
		$('#btn-w-words').attr('disabled', true)



	# Manage words

	if $('h2').text().indexOf "Manage" > -1
		$('#word').focus()


	# Remove word

	if $('h2').text().indexOf "Remove" > -1
		$('#btn-cancel').focus()


	# Add word

	if $('h2').text().indexOf "Add" > -1
		$('#btn-cancel').focus()


	# Search words

	if $('h2').text().indexOf "Search" > -1
		$('#word').focus()


	# Word stems

	if $('h2').text().indexOf "Stems" > -1
		$('#word').focus()



# Setup

$(document).ready(ready)
$(document).on('page:load', ready)
$(document).scroll ->
  $('#word-nav').toggle $(this).scrollTop() > 2000
  return