$.fn.scrollView = ->
  @each ->
    $("html, body").animate
      scrollTop: $(this).offset().top
    , 0


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
  rack = $('#tiles-bar')
  tiles = []
  tiles.push($(tile).text()) for tile in rack.children()  
  rack.empty()
  rack.append("<span class='tile'>" + tile + "<span>") for tile in shuffle(tiles)


guessFeedbackAnimtaion = (guess, isCorrectGuess) ->
  if (isCorrectGuess)
    $('#challenge-feedback').addClass("text-success").removeClass("text-error")
    $('#challenge-results').slideUp('fast')
    $('#challenge-results').slideDown('1000')
  else
    $('#challenge-feedback').addClass("text-error").removeClass("text-success")

  $('#challenge-feedback').text(guess)
  $('#challenge-feedback').animate({display: "show"}, 1)
  $('#challenge-feedback').animate({top: "-200", opacity: "toggle"}, 1500)
  $('#challenge-feedback').css('top', '-80px')


updateScore = (found, solved) ->
  $('#challenge-solutions-found').text(solved)
  #$('input#found').val(found.join(" "))



nextLevelAnimation = ->
  $('#challenge-loading').slideDown('slow')
  $('#challenge-form').slideUp('slow')

advanceToNextLevel = ->
  $('#challenge-loading-pretext').text("Advancing to")
  $('#challenge-results').addClass("text-success")
  nextLevelAnimation()
  $('form').submit()


delaySubmitWhileShowingMissedBingos = (missed) ->
  $('#challenge-loading-missed').html("Missed: <br/>" + missed.join(" "))
  $('#challenge-loading-missed').addClass("text-error")
  $('#challenge-results').addClass("text-warning")
  setTimeout ( -> $('form').submit()), 500 * missed.length

skipToNextLevel = (missed) ->
  $('#challenge-loading-pretext').text("Skipping to")
  $('input#failed').val("skip")
  delaySubmitWhileShowingMissedBingos(missed)
  nextLevelAnimation()
  
returnToFirstLevel = (missed) ->  
  $('#challenge-loading-pretext').text("Conceding")
  $('#challenge-loading-level').text("")
  $('input#failed').val("concede")
  delaySubmitWhileShowingMissedBingos(missed)
  nextLevelAnimation()
  


processGuess = () ->
  guess = $('#tiles-bar').text().trim()
  $('#s-'+guess).show('500')

  solved = 0
  remaining = 0
  found = []
  for solution in $('#challenge-solutions').children()
    do (solution) ->
      if $(solution).is(":visible")
        found.push($(solution).text())
        solved++
      else remaining++

  isCorrectGuess = solved - $('#challenge-solutions-found').text() > 0
  updateScore(found, solved)
  guessFeedbackAnimtaion(guess, isCorrectGuess)
  if remaining == 0 then advanceToNextLevel()



getMissedBingos = () ->
  missed = []
  for solution in $('#challenge-solutions').children()
    do (solution) ->
      if $(solution).is(":hidden") then missed.push($(solution).text())
  missed


processSkip = () ->
  skipToNextLevel(getMissedBingos())

processConcede = () ->
  returnToFirstLevel(getMissedBingos())


ready = ->

  # Random challenge

  if $('h2').text().indexOf "Random" > -1
    $('#bingo-challenge-box').scrollView()
    $('#tiles-bar').sortable({ containment: "parent", axis: "x", cursor: "move", appendTo: "parent" })
    $('#tiles-bar').disableSelection()
    if $('input#lives').val() < 1
      $('input.btn.btn-danger').prop("disabled", true)
    $('#shuffle').click (e) ->
      shuffleTiles(e)
    $('#submit-guess').click (e) ->
      e.preventDefault()
      processGuess()
    $('#skip-challenge').click (e) ->
      e.preventDefault()
      processSkip()
    $('#concede-challenge').click (e) ->
      e.preventDefault()
      processConcede()




# Setup

$(document).ready(ready)
$(document).on('page:load', ready)