OneMoreRating::Engine.routes.draw do
  resources :ratings, :only => [:create]
end
