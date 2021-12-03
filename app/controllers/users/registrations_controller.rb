# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create, :edit]

  # Only admin users should see the index
  before_action :authenticate_user!, only: [:index]

  # before_action :configure_account_update_params, only: [:update]

  # GET /resource/sign_up
  # def new
  #  super
  # end

  # Only need to change this one to create the wallets at login time
  # POST /resource
  def create
    #super
    #Copyed from Devise::RegistrationControler
    build_resource(sign_up_params)

    # The default created user should be of the type normal
    resource.user_type = :normal

    resource.save
    yield resource if block_given?
    if resource.persisted?

      #Only create the default wallets if the user was created
      Wallet.create_default_wallets(resource.id)
      QuickLink.create_default_quicklinks(resource.id)

      if resource.active_for_authentication?
        set_flash_message! :notice, :signed_up
        sign_up(resource_name, resource)
        respond_with resource, location: after_sign_up_path_for(resource)
      else
        set_flash_message! :notice, :"signed_up_but_#{resource.inactive_message}"
        expire_data_after_sign_in!
        respond_with resource, location: after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords resource
      set_minimum_password_length
      respond_with resource
    end
  end

  # GET /resource/edit
  def edit

    @quick_links = QuickLink.by_user(current_user)

    # From the super class
    render :edit
  end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  def index
    if current_user.nil?
      respond_to do |f|
        f.html {redirect_to new_user_session_url}
        f.json {render json: {status: 403}, status: :forbidden}
      end
      return
    end

    if current_user.user_type != "admin"
      respond_to do |f|
        f.html {redirect_to dashboard_url}
        f.json {render json: {status: 403}, status: :forbidden}
      end
      return
    end

    @users = User.all
  end

  # protected


  # If you have extra params to permit, append them to the sanitizer.
  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
  end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  # end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
end
