module BingoChallengesHelper

  def challenge_lives()
    lives = @lives.to_i
    lives = 0 if lives < 0
    lives_text = ""
    (3-lives).times { lives_text << "<span class='icon icon-remove'></span> "  }
    lives.times { lives_text << "<span class='icon icon-heart'></span> "  }
    lives_text.html_safe
  end
end