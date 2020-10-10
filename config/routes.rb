Rails.application.routes.draw do
  resources :partners, only: [:show, :create] do
    get '/nearst/:lat/:long', to: 'partners#nearst'
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
