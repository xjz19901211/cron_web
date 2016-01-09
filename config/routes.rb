Rails.application.routes.draw do
  resources :works do

    resources :tasks, only: [:index, :show, :create], shallow: true do
      member do
        get :start_code
        get :run_code
      end
    end
  end


  root 'works#index'

end

