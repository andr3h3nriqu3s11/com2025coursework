Rails.application.routes.draw do
  root 'home#home'

  get 'contact' => 'contact#contact'
  post 'contact' => 'contact#submit'

  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
