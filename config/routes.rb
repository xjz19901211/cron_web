Rails.application.routes.draw do
  resources :users
  resources :sessions, only: [:new, :create, :destroy]
  resources :schedules, only: [:index]

  resources :works do
    resources :schedules, except: [:index], shallow: true

    resources :tasks, only: [:index, :show, :create], shallow: true do
      member do
        get :start_code
        get :run_code
      end
    end
  end

  require 'sidekiq/web'
  require 'sidekiq/cron/web'
  mount Sidekiq::Web => '/sidekiq'

  root 'works#index'
end

