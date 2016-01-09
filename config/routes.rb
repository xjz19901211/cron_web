Rails.application.routes.draw do
  resources :works do
    resources :tasks, only: [:index, :show, :create], shallow: true
  end


  root 'works#index'

end

