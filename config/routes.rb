Rails.application.routes.draw do
  resources :playlist_items, only: [:create]
  resources :playlists, only: [:index, :show, :new, :create, :edit] do
    member do
      patch :update_title
      delete :remove_videos
    end
  end
  root 'home#index'
  get 'videos/:id', to: 'home#show', as: 'video'
end
