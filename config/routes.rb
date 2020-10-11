Rails.application.routes.draw do
  resources :partners, only: [:show, :create]

  get 'partners/nearst/:lat/:long', to: 'partners#nearst',
    :constraints => {:lat => /\-?\d+(.\d+)?/, :long => /\-?\d+(.\d+)?/}
end
