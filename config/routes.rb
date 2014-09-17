P45Rails::Application.routes.draw do
  resources :games
  root  'games#index'
end
