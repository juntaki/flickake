Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'movies#list'
  get '/static/:id', to: 'movies#static'
  get '/movies/:id', to: 'movies#show'
  get '/movies/:id/thumb', to: 'movies#thumb'
end
