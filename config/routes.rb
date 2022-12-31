Rails.application.routes.draw do
  # get 'current_user/index'
  get '/current_user', to: 'current_user#index'

  # route aliases to override default routes provided by devises
  devise_for :users, path: '', path_names: {
    sign_in: 'login',
    sign_out: 'logout',
    registration: 'signup'
  },
  controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }

  # resources :posts
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  namespace :api do
    namespace :v1 do
      resources :posts do
        resources :comments, shallow: true
      end
    end
  end
end
