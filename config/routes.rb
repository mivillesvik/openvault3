Rails.application.routes.draw do
  root to: 'home#index'
  blacklight_for :catalog # If I change this we get errors from the other pages.

  get 'collections', to: 'collections#index'
  get 'collections/:id(/:tab)', to: 'collections#show'

  get 'exhibits', to: 'exhibits#index'
  get 'exhibits/:id(/:tab)', to: 'exhibits#show'

  resources :series,
            only: [:index]

  resources :about,
            only: [:show]

  resources :transcripts,
            only: [:show]

  resources :embed,
            only: [:show]

  resources :sitemap,
            only: [:index]

  resources :oai,
            only: [:index]

  get 'robots', to: 'robots#show'

  override_constraints = lambda do |req|
    !req.params['path'].to_s.match(/^rails/)
  end

  get '/plain/*path', to: 'plain_override#show', constraints: override_constraints
  get '/*path', to: 'override#show', constraints: override_constraints
end
