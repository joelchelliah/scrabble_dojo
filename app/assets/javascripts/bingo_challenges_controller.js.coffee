shuffle = (a) ->
  i = a.length
  while --i > 0
      j = ~~(Math.random() * (i + 1))
      t = a[j]
      a[j] = a[i]
      a[i] = t
  a

shuffleTiles = (e) ->
  e.preventDefault()
  tiles = $('#tiles-bar').text().split(' ')
  $('#tiles-bar').text(shuffle(tiles).join(" "))




guessFeedbackAnimtaion = (guess, solved) ->
  if solved - $('#challenge-solutions-found').text() > 0
    $('#challenge-feedback').addClass("text-success").removeClass("text-error")
  else
    $('#challenge-feedback').addClass("text-error").removeClass("text-success")

  $('#challenge-feedback').text(guess)
  $('#challenge-feedback').animate({display: "show"}, 1)
  $('#challenge-feedback').animate({top: "-100", opacity: "toggle"}, 1000)
  $('#challenge-feedback').css('top', '-5px')


updateScore = (found, solved) ->
  $('#challenge-solutions-found').text(solved)
  #$('input#found').val(found.join(" "))


loadNextLevel = ->
  $('#challenge-loading').addClass("text-success")
  $('#challenge-loading').slideDown('slow')
  $('#challenge-form').slideUp('fast')
  $('#challenge-results').addClass("text-success")
  $('form').submit()


processGuess = (e) ->
  e.preventDefault()
  guess = $('#guess').val().toUpperCase()
  if guess.length > 0
    $('#s-'+guess).show()
    $('#guess').val('')

    solved = 0
    remaining = 0
    found = []
    for solution in $('#challenge-solutions').children()
      do (solution) ->
        if $(solution).is(":visible")
          found.push($(solution).text())
          solved++
        else remaining++

    guessFeedbackAnimtaion(guess, solved)
    updateScore(found, solved)
    if remaining == 0 then loadNextLevel()


processSkip = (e) ->
  e.preventDefault()
  $('form').submit()  

ready = ->

  # Random challenge

  if $('h2').text().indexOf "Random" > -1
    $('#guess').focus()
    if $('input#lives').val() < 1
      $('input.btn.btn-danger').prop("disabled", true)
    $('#shuffle').click (e) ->
      shuffleTiles(e)
    $('#submit-guess').click (e) ->
      processGuess(e)
    #$('#skip-challenge').click (e) ->
    #  processSkip(e)








# Setup

$(document).ready(ready)
$(document).on('page:load', ready)