RHSMocker::Application.routes.draw do

  namespace :api do
    namespace :v1 do
      resources :allergies, :only => :index
      resources :association_types, :only => :index
      resources :contents, :only => [:index, :show]
      resources :diets, :only => :index
      resources :diseases, :only => :index
      resources :consults, :only => [:index, :show, :create] do
        resources :messages, :only => [:index, :show, :create]
        resources :scheduled_phone_calls, :except => [:new, :edit]
        resources :phone_calls, :only => [:index, :show, :create]
      end
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
      resources :plans, :only => [:index, :show]
      resources :remote_events, :only => :create
      resources :side_effects, :only => :index
      resources :symptoms, :only => :index
      resources :treatments, :only => :index
      resources :users, :only => [:index, :update] do
        resources :allergies, :except => [:new, :edit, :update], :controller => 'user_allergies'
        resources :associations, :except => [:new, :edit]
        resources :blood_pressures, only: [:index, :create, :destroy]
        resources :credits, :only => [:index, :show] do
          get 'summary', :on => :collection
        end
        resources :diseases, except: [:new, :edit], controller: 'user_diseases' do
          resources :treatments, only: :destroy, controller: 'user_disease_user_treatments' do
            post ':id', to: 'user_disease_user_treatments#create', on: :collection
          end
        end
        post 'invite', :on => :member
        resources :cards, :only => [:index, :show, :update]
        get 'keywords', :on => :member
        resources :subscriptions, :except => [:new, :edit]
        resources :treatments, :except => [:new, :edit], :controller => 'user_disease_treatments' do
          resources :diseases, only: :destroy, controller: 'user_disease_user_treatments' do
            post ':id', to: 'user_disease_user_treatments#create', on: :collection
          end
        end
        resources :weights, :only => [:index, :create, :destroy]
      end

      #account management
      post "signup" => "users#create", :as=>"signup"
      post "login" => "sessions#create", :as=>"login"
      delete "logout" => "sessions#destroy", :as=>"logout"
      put "user" => "users#update", :as=>"user_update"
      put "user/:id" => "users#update", :as=>"user_update"
      post "user/update_password" => "users#update_password", :as=>"update_password"
      post "user/update_email" => "users#update_email", :as=>"update_email"
      post "password_resets" => "password_resets#create", :as=>"create_password_resets"

      #reading list
      get "user_readings" => "user_readings#index", :as=>"user_readings_index"
      get "inbox(/:page)(/:per_page)" => "user_readings#inbox", :as=>"inbox"
      post "contents/mark_read" => "user_readings#mark_read", :as=>"contents_mark_read"
      post "contents/dismiss" => "user_readings#dismiss", :as=>"contents_dismiss"
      post "contents/save" => "user_readings#save", :as=>"contents_read_later"
      post "contents/reset" => "user_readings#reset", :as=>"contents_reset"

      get "factors/:id" => "factors#index"
      post "symptoms/check" => "factors#check"


      post "feedback" => "users#add_feedback"

      get "agreement_pages" => "agreement_pages#list"
      get "agreements" => "agreements#list"
      post "agreements" => "agreements#create"
      get "agreements/up_to_date" => "agreements#up_to_date?"

    end
  end

  resources :invites, :only => [:update, :show] do
    get :complete, :on => :collection
    get :signup, :on => :collection
  end

  get "password_resets/:id" => "api/v1/password_resets#edit", :as=>"edit_password_resets"
  put "password_resets/:id" => "api/v1/password_resets#update", :as=>"update_password_resets"

  match '/docs', :to => redirect('/docs/index.html')

  get "/messages" => "messages#index", :as=>"messages_index"
  root :to => "home#index"
  get "/logout" => "sessions#destroy", :as=>"logout"
  get '/login' => "sessions#new", :as=>"login"
  resources :sessions
  get "faq" =>"home#faq"
  get "contents/:doc_id" => "contents#show"
  get "contents/:doc_id/:user_reading_id" => "contents#show"

  resources :users
  resources :contents
  resources :authors

  match "/users/:id/readinglist"        => "users#showReadingList"
  match "/users/:id/read/:contentId"    => "users#read", :as => :markread
  match "/users/:id/dismiss/:contentId" => "users#dismiss", :as => :dismiss
  match "/users/:id/later/:contentId"   => "users#later", :as => :readlater
  match "/users/:id/reset"              => "users#resetReadingList", :as =>  :reset_content
  match "/users/:id/weight/:weight"     => "users#updateWeight"
  match "/users/:id/location/:lat/:long" => "users#addLocation"
  match "/users/:id/keywords"           => "users#keywords"

  %w(403 404 412 500).each do |status_code|
    match status_code => 'errors#exception'
  end
end
