Rails.application.routes.draw do
  resources :wallets
  get 'dashboard/dashboard'
  root 'home#home'

  get 'contact' => 'contact#contact'
  post 'contact' => 'contact#submit'

  get 'dashboard' => 'dashboard#dashboard'

  devise_for  :users,
              :path => '',
              :controllers => {
                registrations: 'users/registrations'
              },
              :path_names => {  :sign_in => 'login', :sign_up => 'signup', :sign_out => 'logoff' }

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
