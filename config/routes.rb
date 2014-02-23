XmotoIo::Application.routes.draw do
  root 'levels#index'

  resources :levels

  # OmniAuth (facebook)
  match '/auth/:provider/callback', :to => 'sessions#create', :via => [:get, :post]
  match '/auth/failure',            :to => redirect('/'),     :via => [:get, :post]
  get   '/signout',                 :to => 'sessions#destroy', :as => :signout
end
