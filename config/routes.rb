Rails.application.routes.draw do
  devise_for :members
  root 'home#index'

  resources :flashcard_categories do 
    get 'play', to: 'flashcard_categories#play', as: 'play'
  end
  resources :flashcards, only: [:new, :create, :edit, :update, :destroy, :show]
end
