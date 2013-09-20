ready = ->

	# Signup page

	if $('h2').text() == "Sign up"
		$('#user_name').focus()


	# Login page

	if $('h2').text() == "Log in"
		$('#session_email').focus()


	# Edit page

	if $('h2').text() == "Edit profile"
		$('#user_name').focus()


# Setup

$(document).ready(ready)
$(document).on('page:load', ready)