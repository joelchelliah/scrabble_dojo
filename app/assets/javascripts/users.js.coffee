ready = ->

	# Signup page

	if $('h2').text().indexOf "Sign up" > -1
		$('#user_name').focus()


	# Login page

	if $('h2').text().indexOf "Log in" > -1
		$('#session_email').focus()


	# Edit page

	if $('h2').text().indexOf "Edit profile" > -1
		$('#user_name').focus()


# Setup

$(document).ready(ready)
$(document).on('page:load', ready)