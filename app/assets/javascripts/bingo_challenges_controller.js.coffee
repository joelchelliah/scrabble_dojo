shuffle = (a) ->
    i = a.length
    while --i > 0
        j = ~~(Math.random() * (i + 1))
        t = a[j]
        a[j] = a[i]
        a[i] = t
    a

ready = ->

  # Random challenge

  if $('h2').text().indexOf "Random" > -1
    $('#guess').focus()
    if $('input#lives').val() < 1
      $('input.btn.btn-danger').prop("disabled", true)
    $('#shuffle').click (e)->
      e.preventDefault()
      tiles = $('#tiles-bar').text().split(' ')
      shuffle(tiles)
      $('#tiles-bar').text(tiles.join(" "))









# Setup

$(document).ready(ready)
$(document).on('page:load', ready)