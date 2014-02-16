XmotoIo::Application.routes.draw do
  root 'levels#index'

  resources :levels
end
