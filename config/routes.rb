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

      #reading list
      get "user_readings" => "user_readings#index", :as=>"user_readings_index"
      post "contents/mark_read" => "user_readings#mark_read", :as=>"contents_mark_read"
      post "contents/dismiss" => "user_readings#dismiss", :as=>"contents_dismiss"
      post "contents/read_later" => "user_readings#read_later", :as=>"contents_read_later"
      post "contents/reset" => "user_readings#reset", :as=>"contents_reset"


      post "location" =>"user_locations#create", :as=>"create_user_location"
      post "weight" => "user_weights#create", :as=>"create_user_weight"

      get "user/keywords" => "users#keywords", :as=>"user_keywords"

    end
  end

  get "password_resets/:id" => "api/v1/password_resets#edit", :as=>"edit_password_resets"
  put "password_resets/:id" => "api/v1/password_resets#update", :as=>"update_password_resets"

  match '/docs', :to => redirect('/docs/index.html')


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
