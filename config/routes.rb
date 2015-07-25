XmotoIo::Application.routes.draw do
  root 'levels#index'

  resources :levels do
    member do
      post :capture
    end

    resources :scores
  end

  # OmniAuth (facebook)
  match '/auth/:provider/callback', :to => 'sessions#create', :via => [:get, :post]
  match '/auth/failure',            :to => redirect('/'),     :via => [:get, :post]
  get   '/signout',                 :to => 'sessions#destroy', :as => :signout
end
