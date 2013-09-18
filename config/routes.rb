ScrabbleDojo::Application.routes.draw do
  
  resources :users
  resources :sessions, only: [:new, :create, :destroy]
  resources :words
  resources :memos do
    collection do
      get 'by_health'
      get 'by_word_count'
      get 'revise_weakest'
    end
    member do
      get 'results'
      patch 'practice'
    end
  end

  root 'dojo#home'

  match '/home',    to: 'dojo#home',  via: 'get'
  match '/signup',  to: 'users#new',  via: 'get'
  match '/login',  to: 'sessions#new',  via: 'get'
  match '/logout',  to: 'sessions#destroy',  via: 'delete'

end
