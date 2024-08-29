Rails.application.routes.draw do
  resources :playlist_items
  resources :playlists
  root 'home#index'
  get 'videos/:id', to: 'home#show', as: 'video'
end
