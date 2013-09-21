ScrabbleDojo::Application.routes.draw do
  
  resources :sessions, only: [:new, :create, :destroy]
  resources :users
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
  resources :words

  root 'dojo#home'

  match '/home',    to: 'dojo#home',  via: 'get'
  match '/signup',  to: 'users#new',  via: 'get'
  match '/login',  to: 'sessions#new',  via: 'get'
  match '/logout',  to: 'sessions#destroy',  via: 'delete'

end
