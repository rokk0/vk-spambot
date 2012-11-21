VkSpambot::Application.routes.draw do

  root :to => 'posts#index'

  devise_for :users

  resources :posts
  resources :users do
    resources :accounts do
      resources :bots
    end

    resources :bots
  end

  devise_scope :user do
    get 'signin',  :to => 'devise/sessions#new'
  end

  match '/contact', :to => 'pages#contact'
  match '/about',   :to => 'pages#about'
  match '/help',    :to => 'pages#help'

  match '/run',               :to => 'bots#run'
  match '/stop',              :to => 'bots#stop'
  match '/run_account_all',   :to => 'bots#run_account_all'
  match '/stop_account_all',  :to => 'bots#stop_account_all'
  match '/run_all',           :to => 'bots#run_all'
  match '/stop_all',          :to => 'bots#stop_all'
  match '/check_status',      :to => 'bots#check_status'

  match '/users/:user_id/accounts/new'      => 'accounts#create',  :via => :post,    :as => 'create_account'
  match '/users/:user_id/accounts/:id/edit' => 'accounts#update',  :via => :put,     :as => 'update_account'
  match '/users/:user_id/accounts/:id'      => 'accounts#destroy', :via => :delete,  :as => 'destroy_account'

  match '/users/:user_id/bots/new'      => 'bots#create',  :via => :post,    :as => 'create_bot'
  match '/users/:user_id/bots/:id/edit' => 'bots#update',  :via => :put,     :as => 'update_bot'
  match '/users/:user_id/bots/:id'      => 'bots#destroy', :via => :delete,  :as => 'destroy_bot'

  match '/users/:user_id/accounts/:account_id/bots/new'      => 'bots#create',  :via => :post,    :as => 'create_user_account_bot'
  match '/users/:user_id/accounts/:account_id/bots/:id/edit' => 'bots#update',  :via => :put,     :as => 'update_user_account_bot'
  match '/users/:user_id/accounts/:account_id/bots/:id'      => 'bots#destroy', :via => :delete,  :as => 'account_destroy_bot'

end
