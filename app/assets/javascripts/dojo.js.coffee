ready = ->

	# Navbar

	lis = $('.nav').children()
	$(li).removeClass('active') for li in lis
	if $('h1').text() == "Memo"
		$(li).addClass('active') for li in lis when $(li).text().indexOf("Memo") >= 0
	else if $('h1').text() == "Scrabble Dojo"
		$(li).addClass('active') for li in lis when $(li).text().indexOf("Home") >= 0



# Setup

$(document).ready(ready)
$(document).on('page:load', ready)