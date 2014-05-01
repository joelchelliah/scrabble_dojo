ready = ->

  # Random challenge

  if $('h2').text().indexOf "Random" > -1
    $('#guess').focus()
    if $('input#lives').val() < 1
      $('input.btn.btn-danger').prop("disabled", true)









# Setup

$(document).ready(ready)
$(document).on('page:load', ready)