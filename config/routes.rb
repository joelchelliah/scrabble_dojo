ScrabbleDojo::Application.routes.draw do
  
  resources :sessions, only: [:new, :create, :destroy]
  resources :users
  resources :word_entries, only: [:new, :create, :destroy, :index, :show]
  resources :memos do
    collection do
      get 'by_health'
      get 'by_word_count'
      get 'revise_weakest'
    end
    member do
      get 'results_of'
      patch 'practice'
    end
  end

  root 'dojo#home'

  match '/signup',  to: 'users#new',  via: 'get'
  match '/login',  to: 'sessions#new',  via: 'get'
  match '/logout',  to: 'sessions#destroy',  via: 'delete'

  get '/bingos'                   => 'word_entries#bingos',           as: 'bingos'
  get '/short_words_with/:letter' => 'word_entries#short_words_with', as: 'short_words_with'
  get '/word_length/:len'         => 'word_entries#word_length',      as: 'word_length'

  get '/look_up'                  => 'word_entries#look_up',          as: 'look_up'
  get '/search'                  => 'word_entries#search',          as: 'search'

end
