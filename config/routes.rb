Rails.application.routes.draw do
  get 'contact/contact'
  root 'home#home'
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
