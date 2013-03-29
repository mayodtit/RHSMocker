RHSMocker::Application.routes.draw do

  namespace :api do
    namespace :v1 do
      #account management
      post "signup" => "users#create", :as=>"signup"
      post "login" => "sessions#create", :as=>"login"
      delete "logout" => "sessions#destroy", :as=>"logout"
      put "user" => "users#update", :as=>"user_update"
      put "user/:id" => "users#update", :as=>"user_update"
      post "user/update_password" => "users#update_password", :as=>"update_password"
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

      #associates
      put "associates/:id" => "associates#update", :as=>"associates_update"
      get "associations" => "associations#index", :as=>"associations_index"
      post "associations" => "associations#create", :as=>"associations_create"
      put "associations" => "associations#update", :as=>"associations_update"
      delete "associations" => "associations#remove", :as=>"associations_remove"


      #reading list
      get "user_readings" => "user_readings#index", :as=>"user_readings_index"
      get "inbox(/:page)(/:per_page)" => "user_readings#inbox", :as=>"inbox"
      post "contents/mark_read" => "user_readings#mark_read", :as=>"contents_mark_read"
      post "contents/dismiss" => "user_readings#dismiss", :as=>"contents_dismiss"
      post "contents/read_later" => "user_readings#read_later", :as=>"contents_read_later"
      post "contents/reset" => "user_readings#reset", :as=>"contents_reset"


      post "locations" =>"user_locations#create", :as=>"create_user_location"
      post "weights" => "user_weights#create", :as=>"create_user_weight"
      get "weights" => "user_weights#list", :as=>"list_user_weights"

      get "user/keywords" => "users#keywords", :as=>"user_keywords"

      get "messages" => "messages#list", :as=>"list_user_messages"
      get "messages/:id" => "messages#show", :as=>"show_user_message"
      post "messages" => "messages#create", :as => "create_user_message"
      post "messages/mark_read" => "messages#mark_read", :as => "messages_mark_read"

      post "phone_calls" => "phone_calls#create"
      # put "phone_calls" => "phone_calls#update"

    end
  end

  get "password_resets/:id" => "api/v1/password_resets#edit", :as=>"edit_password_resets"
  put "password_resets/:id" => "api/v1/password_resets#update", :as=>"update_password_resets"

  match '/docs', :to => redirect('/docs/index.html')

  get "/messages" => "messages#index", :as=>"messages_index"
  root :to => "home#index"
  get "/logout" => "home#logout_user", :as=>"logout"

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
end
