Rails.application.routes.draw do
  # get 'tags/index'
  # get 'tag/index'
  # get 'profiles/index'
  # get 'current_user/index'
  get 'private/test'
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

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  namespace :api do
    namespace :v1 do
      resources :profiles
      resources :tags
      resources :posts do
        resources :comments, shallow: true
      end
    end
  end
end 