RHSMocker::Application.routes.draw do

  namespace :api do
    namespace :v1 do
      resources :remote_events, :only => :create

      resources :side_effects, :only => :index

      resources :plans, :only => [:index, :show]

      resources :users, :only => :index do
        resources :allergies, :only => :index, :controller => 'user_allergies'
        resources :subscriptions, :except => [:new, :edit]
        resources :credits, :only => [:index, :show] do
          get 'summary', :on => :collection
        end
        resources :blood_pressures, only: [:index, :create, :destroy], shallow: true
        resources :weights, :only => :index, :controller => 'user_weights'
        resources :treatments, :only => :index, :controller => 'user_disease_treatments'
        resources :diseases, :only => :index, :controller => 'user_diseases'
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

      #content
      get "contents" => "contents#index", :as=>"content_index"
      get "contents/:id" => "contents#show", :as=>"content_show"

      #diseases
      get "diseases" => "diseases#index", :as=>"diseases_index"
      get "user_diseases" => "user_diseases#index", :as=>"user_diseases_index"
      post "user_diseases" => "user_diseases#create", :as=>"user_diseases_create"
      put "user_diseases" => "user_diseases#update", :as=>"user_diseases_update"
      delete "user_diseases" => "user_diseases#remove", :as=>"user_diseases_remove"

      #treatments
      get "treatments" => "treatments#index", :as=>"treatments_index"
      get "user_disease_treatments" => "user_disease_treatments#list", :as=>"user_disease_treatments_list"
      post "user_disease_treatments" => "user_disease_treatments#create", :as=>"user_disease_treatments_create"
      put "user_disease_treatments" => "user_disease_treatments#update", :as=>"user_disease_treatments_update"
      delete "user_disease_treatments" => "user_disease_treatments#remove", :as=>"user_disease_treatments_remove"

      #allergies
      get "allergies"=> "allergies#index", :as=>"allergies_index"
      get "user_allergies" => "user_allergies#index"
      post "user_allergies" => "user_allergies#create"
      delete "user_allergies" => "user_allergies#remove"

      #associates
      put "associates/:id" => "associates#update", :as=>"associates_update"
      get "associations" => "associations#index", :as=>"associations_index"
      post "associations" => "associations#create", :as=>"associations_create"
      put "associations" => "associations#update", :as=>"associations_update"
      delete "associations" => "associations#remove", :as=>"associations_remove"
      get "association_types" =>"association_types#list"


      #reading list
      get "user_readings" => "user_readings#index", :as=>"user_readings_index"
      get "inbox(/:page)(/:per_page)" => "user_readings#inbox", :as=>"inbox"
      post "contents/mark_read" => "user_readings#mark_read", :as=>"contents_mark_read"
      post "contents/dismiss" => "user_readings#dismiss", :as=>"contents_dismiss"
      post "contents/save" => "user_readings#save", :as=>"contents_read_later"
      post "contents/reset" => "user_readings#reset", :as=>"contents_reset"


      post "locations" =>"user_locations#create", :as=>"create_user_location"
      post "weights" => "user_weights#create", :as=>"create_user_weight"
      get "weights" => "user_weights#list", :as=>"list_user_weights"
      delete "weights" => "user_weights#remove", :as=>"remove_user_weight"

      get "user/keywords" => "users#keywords", :as=>"user_keywords"

      get "messages" => "messages#list", :as=>"list_user_messages"
      get "messages/:id" => "messages#show", :as=>"show_user_message"
      post "messages" => "messages#create", :as => "create_user_message"
      post "messages/mark_read" => "messages#mark_read", :as => "messages_mark_read"
      post "messages/dismiss" => "messages#mark_dismissed", :as => "messages_mark_dismissed"

      post "phone_calls" => "phone_calls#create"
      # put "phone_calls" => "phone_calls#update"

      get "symptoms" => "symptoms#index"
      get "factors/:id" => "factors#index"
      post "symptoms/check" => "factors#check"


      post "feedback" => "users#add_feedback"

      get "diets" => "diets#list"
      get "ethnic_groups" => "ethnic_groups#list"

      get "agreement_pages" => "agreement_pages#list"
      get "agreements" => "agreements#list"
      post "agreements" => "agreements#create"
      get "agreements/up_to_date" => "agreements#up_to_date?"

    end
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
