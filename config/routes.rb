Rails.application.routes.draw do
  Healthcheck.routes(self)
  resources :partners, only: [:show, :create]

  get 'partners/nearst/:lat/:long', to: 'partners#nearst',
    :constraints => {:lat => /\-?\d+(.\d+)?/, :long => /\-?\d+(.\d+)?/}
end
