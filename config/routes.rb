RHSMocker::Application.routes.draw do

  namespace :api do
    namespace :v1 do
      resources :allergies, :only => :index
      resources :association_types, :only => :index
      resources :contents, :only => [:index, :show] do
        post :status, :on => :member
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
      post :password_resets, :controller => :users, :action => :reset_password # TODO - deprecated!
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
        resources :credits, :only => [:index, :show] do
          get 'summary', :on => :collection
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
        resources :cards, :only => [:index, :show, :update] do
          get :inbox, :on => :collection
          get :timeline, :on => :collection
        end
        get 'keywords', :on => :member
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

      #reading list
      get "user_readings" => "user_readings#index", :as=>"user_readings_index"
      get "inbox(/:page)(/:per_page)" => "user_readings#inbox", :as=>"inbox"
      post "contents/mark_read" => "user_readings#mark_read", :as=>"contents_mark_read"
      post "contents/dismiss" => "user_readings#dismiss", :as=>"contents_dismiss"
      post "contents/save" => "user_readings#save", :as=>"contents_read_later"
      post "contents/reset" => "user_readings#reset", :as=>"contents_reset"

      get "factors/:id" => "factors#index"
      post "symptoms/check" => "factors#check"
    end
  end

  resources :contents, :only => [:index, :show] do
    get ":user_reading_id", :to => :show, :on => :member
  end
  resources :invites, :only => [:update, :show] do
    get :complete, :on => :collection
    get :signup, :on => :collection
  end
  resources :nurseline_records, :only => :create
  resources :users, :only => [] do
    get 'reset_password/:token', :to => 'users#reset_password', :on => :collection, :as => 'reset_password'
    put 'reset_password', :to => 'users#reset_password_update', :on => :collection, :as => 'reset_password_update'
  end

  get "/messages" => "messages#index", :as=>"messages_index"
  root :to => "home#index"
  get "/logout" => "sessions#destroy", :as=>"logout"
  get '/login' => "sessions#new", :as=>"login"
  resources :sessions
  get "faq" =>"home#faq"

  %w(403 404 412 500).each do |status_code|
    get status_code => 'errors#exception'
  end

  get '/docs' => Raddocs::App, :anchor => false
end
