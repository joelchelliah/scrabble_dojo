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
  $('#challenge-feedback').animate({top: "-120", opacity: "toggle"}, 1500)
  $('#challenge-feedback').css('top', '-10px')


updateScore = (found, solved) ->
  $('#challenge-solutions-found').text(solved)
  #$('input#found').val(found.join(" "))



nextLevelAnimation = ->
  $('#challenge-loading').slideDown('slow')
  $('#challenge-form').slideUp('slow')

advanceToNextLevel = ->
  phrases = ["Excellent!", "Correct!", "Perfect!", "Not bad!", "Awesome!"]
  $('#challenge-loading').html("<p>" + shuffle(phrases)[0] + "</p>")
  $('#challenge-results').addClass("text-success")
  nextLevelAnimation()
  $('form').submit()


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



delaySubmitWhileShowingMissedBingos = () ->
  missed = []
  for solution in $('#challenge-solutions').children()
    do (solution) -> if $(solution).is(":hidden") then missed.push($(solution).text()) 

  $('#challenge-loading-missed').html("Missed: <br/>" + missed.join(" "))
  $('#challenge-loading-missed').addClass("text-error")
  $('#challenge-results').addClass("text-warning")
  setTimeout ( -> $('form').submit()), 500 * missed.length
  nextLevelAnimation()

processSkip = () ->
  $('input#failed').val("skip")
  delaySubmitWhileShowingMissedBingos()
  
processConcede = () ->
  $('input#failed').val("concede")
  delaySubmitWhileShowingMissedBingos()


ready = ->

  # Random challenge

  if $('h2').text().indexOf "Random" > -1
    $('h1').scrollView()
    $('#tiles-bar').sortable({ containment: "parent", axis: "x", cursor: "move", appendTo: "parent" })
    $('#tiles-bar').disableSelection()
    if $('input#lives').val() < 1
      $('#skip-or-yield').removeClass("btn-danger")
      $('#skip-or-yield').addClass("btn-inverse")
      $('#skip-or-yield').val("Yield")
    $('#shuffle').click (e) ->
      shuffleTiles(e)
    $('#submit-guess').click (e) ->
      e.preventDefault()
      processGuess()
    $('#skip-or-yield').click (e) ->
      e.preventDefault()
      if $('input#lives').val() < 1 then processConcede()
      else processSkip()




# Setup

$(document).ready(ready)
$(document).on('page:load', ready)