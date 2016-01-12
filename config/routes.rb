Rails.application.routes.draw do
  resources :schedules, only: [:index, :new]

  resources :works do
    resources :schedules, expect: [:new], shallow: true

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

