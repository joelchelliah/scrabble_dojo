# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

ready = ->

	# Navbar

	lis = $('.nav').children()
	$(li).removeClass('active') for li in lis
	if $('h1').text() == "Memo"
		$(li).addClass('active') for li in lis when $(li).text().indexOf("Memo") >= 0
	else if $('h1').text() == "Scrabble Dojo"
		$(li).addClass('active') for li in lis when $(li).text().indexOf("Home") >= 0


#	$('.nav li').click ->
		
#		$(this).siblings().removeClass('active')
#		$(this).addClass('active')


# Setup

$(document).ready(ready)
$(document).on('page:load', ready)