RHSMocker::Application.routes.draw do
  root to: 'home#index'

  namespace :api do
    namespace :v1 do
      resources :agreements, only: [:index, :show] do
        get :current, on: :collection
      end
      resources :allergies, :only => :index
      resources :association_types, :only => :index
      resources :contents, :only => [:index, :show] do
        resources :references, only: [:index, :create, :destroy], controller: 'content_references'
        post :status, :on => :member
        post :like
        post :dislike
        post :remove_like
        get :tos, on: :collection
      end
      resources :diets, :only => :index
      resources :cards, :only => [:show, :update]
      resources :conditions, :only => :index
      resources :consults, :only => [:index, :show, :create] do
        resources :messages, only: [:index, :create]
      end
      resources :custom_cards, only: [:index, :show, :create, :update]
      resources :custom_contents, only: [:index, :show, :create, :update]
      resources :phone_calls, only: [:index, :show, :update] do
        post 'connect/origin', on: :member, to: 'phone_calls#connect_origin'
        post 'connect/destination', on: :member, to: 'phone_calls#connect_destination'
        post 'connect', on: :collection, to: 'phone_calls#connect'
        get 'connect/nurse', on: :collection, to: 'phone_calls#connect_nurse'
        get 'off_duty/menu', on: :collection, to: 'phone_calls#off_duty_menu'
        post 'off_duty/select', on: :collection, to: 'phone_calls#off_duty_select'
        post 'status/origin', on: :member, to: 'phone_calls#status_origin'
        post 'status/destination', on: :member, to: 'phone_calls#status_destination'
        post 'status', on: :collection, to: 'phone_calls#status'
      end
      resources :dashboard, only: :index
      resources :diseases, :only => :index, :controller => :conditions
      resources :ethnic_groups, :only => :index
      get 'factors/:symptom_id', to: 'factor_groups#index' # TODO - deprecated!
      resources :locations, :only => :create
      resources :members, only: [:index, :show, :update]
      resources :offerings, :only => :index
      post :password_resets, to: 'reset_password#create' # TODO - deprecated!
      resources :phone_call_summaries, :only => :show
      resources :ping, :only => :index
      resources :plans, :only => [:index, :show]
      resources :programs, only: [:index, :show, :create, :update] do
        resources :resources, only: [:index, :create, :update, :destroy], controller: 'program_resources'
      end
      resources :remote_events, :only => :create
      resources :reset_password, only: [:create, :show, :update]
      resources :scheduled_phone_calls, except: [:new, :edit] do
        get :available_times, on: :collection
      end
      resources :provider_call_logs, only: :create
      resources :side_effects, :only => :index
      resources :symptoms, only: :index do
        resources :factor_groups, only: :index
        resources :contents, only: :index, controller: :symptom_contents
        post :check, on: :collection, to: 'symptom_contents#index'
      end
      resources :treatments, :only => :index
      get :user, to: 'users#current' # TODO - this should be deprecated in favor of users#current
      put :user, to: 'users#update_current' # TODO - this should be deprecated in general, client should know the ID
      put 'user/:id', to: 'users#update' # TODO - deprecated, use users#update
      resources :users, only: [:index, :show, :create, :update] do
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
        get :current, on: :collection
        resources :diseases, except: [:new, :edit], controller: 'user_conditions' do
          resources :treatments, only: :destroy, controller: 'user_condition_user_treatments' do
            post ':id', to: 'user_condition_user_treatments#create', on: :collection
          end
        end
        post 'invite', :on => :member
        resources :cards, :only => [:create, :show, :update] do
          get :inbox, :on => :collection
          get :timeline, :on => :collection
        end
        put :secure_update, on: :member
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
      resources :waitlist_entries, only: [:index, :create, :destroy]
      resources :invitations, :only => [:create, :show, :update]
      get 'roles/:role_name/members' => 'roles#members', as: 'members_with_role'

      #account management - DEPRECATED
      post "signup" => "users#create", :as=>"signup"
      post "login" => "sessions#create", :as=>"login"
      delete "logout" => "sessions#destroy", :as=>"logout"
      post "user/update_password" => "users#secure_update", :as=>"update_password"
      post "user/update_email" => "users#secure_update", :as=>"update_email"
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
  resources :mayo_vocabularies, only: :index
  resources :nurseline_records, :only => :create
  resources :questions, :only => :show
  resources :users, :only => [] do
    get 'reset_password/:token', :to => 'users#reset_password', :on => :collection, :as => 'reset_password'
    put 'reset_password', :to => 'users#reset_password_update', :on => :collection, :as => 'reset_password_update'
  end

  get "/logout" => "sessions#destroy", :as=>"logout"
  get '/login' => "sessions#new", :as=>"login"
  resources :sessions
  get "faq" =>"home#faq"

  %w(403 404 412 500).each do |status_code|
    match status_code => 'errors#exception'
  end

  match '/docs' => Raddocs::App, :anchor => false
end
