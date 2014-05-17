$.fn.scrollView = ->
  @each ->
    $("html, body").animate
      scrollTop: $(this).offset().top
    , 1


shuffle = (a) ->
  i = a.length
  while --i > 0
      j = ~~(Math.random() * (i + 1))
      t = a[j]
      a[j] = a[i]
      a[i] = t
  a

shuffleTiles = () ->
  rack = $('#tiles-bar')
  tiles = []
  tiles.push($(tile).text()) for tile in rack.children()
  rack.empty()
  rack.append("<span class='tile'>" + tile + "<span>") for tile in shuffle(tiles)


guessAnimtaion = (guess, isCorrectGuess) ->
  if (isCorrectGuess)
    $('#challenge-feedback').addClass("text-success").removeClass("text-error")
    $('#challenge-results').slideUp('fast')
    $('#challenge-results').slideDown('1000')
  else
    $('#challenge-feedback').addClass("text-error").removeClass("text-success")

  $('#challenge-feedback').text(guess)
  $('#challenge-feedback').animate({top: "10"}, 0)
                          .animate({display: "show"}, 0)
                          .animate({top: "-120", opacity: "toggle"}, 1000)  



numHearts = -> $('#lives-bar > #count').text()

loseHeart = ->
  count = $('#lives-bar > #count')
  count.text(count.text() - 1)

  for child in $('#lives-bar').children()
    if $(child).hasClass('heart-ph')
      $(child).removeClass('heart-ph')
      $(child).text("")
      $(child).addClass('icon-remove')
      break



nextLevelAnimation = ->
  $('#challenge-loading').slideDown('1200')
  $('#challenge-form').slideUp('1000')

processNextLevel = ->
  $('input#from_form').val("next")
  phrases = ["Excellent!", "Correct!", "Perfect!", "Not bad!", "Awesome!", "Yup!", "Great!", "Yeah!", "Nice!"]
  $('#challenge-loading').prepend("<p>" + shuffle(phrases)[0] + "</p>")
  $('#challenge-results').addClass("text-success")
  setTimeout ( -> $('form').submit()), 500
  nextLevelAnimation()

processYield = () ->
  $('input#from_form').val("yield")
  missed = []
  for solution in $('#challenge-solutions').children()
    if $(solution).is(":hidden") then missed.push($(solution).text()) 

  $('#challenge-loading').prepend("<p>Game over!</p>")
  $('#challenge-loading').append("<p id='challenge-loading-missed'>Missed: </br></p>")
  $('#challenge-loading-missed').append(missed.join(" "))
  $('#challenge-loading-missed').addClass("text-error")
  $('#challenge-results').addClass("text-warning")
  setTimeout ( -> $('form').submit()), 500 + 750 * missed.length
  nextLevelAnimation()

processCorrectGuess = () ->
  solved    = 0
  remaining = 0
  for solution in $('#challenge-solutions').children()
    if $(solution).is(":visible") then solved++      
    else remaining++

  $('#challenge-solutions-found').text(solved)  
  if remaining == 0 then processNextLevel()

processIncorrectGuess = () ->
  loseHeart()
  if numHearts() < 0 then processYield()

processGuess = () ->
  guess             = $('#tiles-bar').text().trim()
  potentialSolution = $('#s-'+guess)

  if potentialSolution.length > 0 && potentialSolution.is(":hidden")
    potentialSolution.show('600')
    guessAnimtaion(guess, true)
    processCorrectGuess()
  else
    guessAnimtaion(guess, false)
    processIncorrectGuess()
    


makeTilesSortable = () ->
  $('#tiles-bar').sortable({ containment: "#challenge-form", axis: "x", cursor: "move", appendTo: "parent" })
  $('#tiles-bar').disableSelection()

replaceSkipWithYield = () ->
  $('#skip-or-yield').removeClass("btn-danger")
  $('#skip-or-yield').addClass("btn-inverse")
  $('#skip-or-yield').val("Yield")


ready = ->

  # Random challenge
  if $('#bingo-challenge').length > 0
    $('h2').scrollView()
    makeTilesSortable()

    $('#shuffle').click (e) ->
      e.preventDefault()
      shuffleTiles()
    $('#submit-guess').click (e) ->
      e.preventDefault()
      processGuess()
    $('#yield').click (e) ->
      e.preventDefault()
      processYield()




# Setup

$(document).ready(ready)
$(document).on('page:load', ready)