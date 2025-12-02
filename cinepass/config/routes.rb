Rails.application.routes.draw do
  root 'movies#index'
  resources :movies
  get 'movies/:id/export', to: 'movies#export', as: 'export_movie'
  get 'movies/export/all', to: 'movies#export_all', as: 'export_all_movies'
end

