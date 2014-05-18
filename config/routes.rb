ScrabbleDojo::Application.routes.draw do
  
  root 'dojo#home'

  resources :sessions, only: [:new, :create, :destroy]
  get    '/login'  => 'sessions#new'
  delete '/logout' => 'sessions#destroy'

  resources :users
  get '/signup'  => 'users#new'

  resources :word_entries, only: [:new, :create, :destroy, :index, :show]
  get '/bingos'                   => 'word_entries#bingos'
  get '/short_words_with/:letter' => 'word_entries#short_words_with', as: 'short_words_with'
  get '/word_length/:len'         => 'word_entries#word_length',      as: 'word_length'
  get '/look_up'                  => 'word_entries#look_up'
  get '/search'                   => 'word_entries#search'
  get '/stems'                    => 'word_entries#stems'

  resources :memos do
    collection do
      get 'by_health'
      get 'by_word_count'
      get 'revise_weakest'
    end
    member do
      patch 'practice'
    end
  end

  resources :bingo_challenges, only: [:index, :show, :new]
  get   '/random_bingo_challenge' => 'bingo_challenges#random'
  patch '/play_bingo_challenge'   => 'bingo_challenges#play'

end
