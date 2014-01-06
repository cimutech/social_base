Rails.application.routes.draw do
  root :to => "frontpage#index"

  match 'home' => 'home#index', :as => :home
  match 'home' => 'home#index', :as => :user_root # devise after_sign_in_path_for

end
