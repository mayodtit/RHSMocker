RHSMocker::Application.routes.draw do
  root to: 'home#index'

  namespace :api do
    namespace :v1 do
      resources :allergies, :only => :index
      resources :association_types, :only => :index
      resources :contents, :only => [:index, :show] do
        post :status, :on => :member
        post :like
        post :dislike
        post :remove_like
      end
      resources :diets, :only => :index
      resources :cards, :only => [:show, :update]
      resources :conditions, :only => :index
      resources :consults, :only => [:index, :show, :create] do
        resources :messages, :only => [:index, :show, :create]
        resources :scheduled_phone_calls, :except => [:new, :edit]
        resources :phone_calls, :only => [:index, :show, :create]
        resources :users, only: :index, controller: 'consult_users'
      end
      resources :diseases, :only => :index, :controller => :conditions
      resources :encounters, :only => [:index, :show, :create], :controller => 'consults' do
        resources :messages, :only => [:index, :show, :create]
      end
      resources :ethnic_groups, :only => :index
      resources :locations, :only => :create
      resources :messages, :only => :show do
        post :mark_read, :on => :collection
        post :save, :on => :collection
        post :dismiss, :on => :collection
      end
      resources :offerings, :only => :index
      post :password_resets, :controller => :users, :action => :reset_password # TODO - deprecated!
      resources :phone_call_summaries, :only => :show
      resources :ping, :only => :index
      resources :plans, :only => [:index, :show]
      resources :remote_events, :only => :create
      resources :side_effects, :only => :index
      resources :symptoms, :only => :index
      resources :treatments, :only => :index
      resources :users, :only => [:index, :update] do
        resources :allergies, :except => [:new, :edit, :update], :controller => 'user_allergies'
        resources :associations, :except => [:new, :edit]
        resources :blood_pressures, only: [:index, :create, :destroy]
        resources :credit_cards, :only => :create
        resources :credits, :only => [:index, :show, :create] do
          get 'available', :on => :collection
        end
        resources :conditions, except: [:new, :edit], controller: 'user_conditions' do
          resources :treatments, only: :destroy, controller: 'user_condition_user_treatments' do
            post ':id', to: 'user_condition_user_treatments#create', on: :collection
          end
        end
        resources :diseases, except: [:new, :edit], controller: 'user_conditions' do
          resources :treatments, only: :destroy, controller: 'user_condition_user_treatments' do
            post ':id', to: 'user_condition_user_treatments#create', on: :collection
          end
        end
        post 'invite', :on => :member
        resources :cards, :only => [:show, :update] do
          get :inbox, :on => :collection
          get :timeline, :on => :collection
        end
        post :reset_password, :on => :collection
        resources :subscriptions, :except => [:new, :edit]
        resources :treatments, :except => [:new, :edit], :controller => 'user_treatments' do
          resources :conditions, only: :destroy, controller: 'user_condition_user_treatments' do
            post ':id', to: 'user_condition_user_treatments#create', on: :collection
          end
          resources :diseases, only: :destroy, controller: 'user_condition_user_treatments' do
            post ':id', to: 'user_condition_user_treatments#create', on: :collection
          end
        end
        resources :weights, :only => [:index, :create, :destroy]
      end

      #account management
      post "signup" => "users#create", :as=>"signup"
      post "login" => "sessions#create", :as=>"login"
      delete "logout" => "sessions#destroy", :as=>"logout"
      put "user" => "users#update"
      put "user/:id" => "users#update"
      post "user/update_password" => "users#update_password", :as=>"update_password"
      post "user/update_email" => "users#update_email", :as=>"update_email"

      get "factors/:id" => "factors#index"
      post "symptoms/check" => "factors#check"
    end
  end

  resources :cards, :only => :show # TODO: used for debugging - remove route and controller before app becomes public
  resources :contents, :only => [:index, :show] do
    get ":user_reading_id", :to => :show, :on => :member
  end
  resources :invites, :only => [:update, :show] do
    get :complete, :on => :collection
    get :signup, :on => :collection
  end
  resources :nurseline_records, :only => :create
  resources :questions, :only => :show
  resources :users, :only => [] do
    get 'reset_password/:token', :to => 'users#reset_password', :on => :collection, :as => 'reset_password'
    put 'reset_password', :to => 'users#reset_password_update', :on => :collection, :as => 'reset_password_update'
  end

  get "/messages" => "messages#index", :as=>"messages_index"
  get "/logout" => "sessions#destroy", :as=>"logout"
  get '/login' => "sessions#new", :as=>"login"
  resources :sessions
  get "faq" =>"home#faq"

  %w(403 404 412 500).each do |status_code|
    match status_code => 'errors#exception'
  end

  match '/docs' => Raddocs::App, :anchor => false
end
