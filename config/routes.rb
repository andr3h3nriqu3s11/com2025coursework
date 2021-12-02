Rails.application.routes.draw do
  resources :quick_links
  get 'dashboard/dashboard'
  root 'home#home'

  get 'contact' => 'contact#contact'
  post 'contact' => 'contact#submit'

  get 'dashboard' => 'dashboard#dashboard'

  #Wallet related
  resources :wallets
  get '/wallet404' => 'wallets#wallet404'

  #Transaction related
  resources :transactions
  get '/transaction404' => 'transactions#transaction404'


  devise_for  :users,
              :path => '',
              :controllers => {
                registrations: 'users/registrations'
              },
              :path_names => {
                :sign_in => 'login',
                :sign_up => 'signup',
                :sign_out => 'logoff',
                :edit => 'profile'
              }
  devise_scope :user do
    get "users", to: "users/registrations#index"
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
