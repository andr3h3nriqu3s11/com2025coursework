class WalletsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_wallet, only: %i[ show edit update destroy ]

  # GET /wallets or /wallets.json
  def index

    # TODO show all if admin
    # @wallets = Wallet.all


    # Gets all the wallets related to this user
    @wallets = Wallet.by_user(current_user)
  end

  # GET /wallets/1 or /wallets/1.json
  def show

    # Checks if the wallet was able to be obtained if not redirect to the 404 page
    # check the set_wallet function for more info
    if (@fail_to_get_wallet)
      redirect_to wallet404_path
      return
    end

    # get the wallet
    @transactions = Transaction.by_wallet(@wallet)
    Wallet.update_value(@wallet)
  end

  def wallet404
    # Set up a dummy wallet so that the 404 page can display it correctly
    @wallet = Wallet.new
    @wallet.name = "No wallet found"
    @wallet.wallet_icon = WalletIcon.from_str("emoji-frown")
  end

  # GET /wallets/new
  def new
    @wallet = Wallet.new
  end

  # GET /wallets/1/edit
  def edit

    # Checks if the wallet was able to be obtained if not redirect to the 404 page
    # check the set_wallet function for more info
    if (@fail_to_get_wallet)
      redirect_to wallet404_path
      return
    end

    # If the wallet is a system wallet it can not be edited so redirect back to the show page
    # and show the error message
    if @wallet.system
      flash[:notice] = I18n.t("wallet.messages.can_not_be_changed")
      redirect_to wallet_path(@wallet)
      return
    end

  end

  # POST /wallets or /wallets.json
  def create
    # Get the params now so that they can be tested for errors
    @wallet = Wallet.new(wallet_params)

    # Checks if the wallet was able to be obtained if not redirect to the 404 page
    # check the set_wallet or wallet_params function for more info
    if @fail_to_get_wallet
      redirect_to wallet404_path
      return
    end


    #This part guarantees that the wallet can only be created by the user that is logged in
    if @wallet.user_id.blank?
      @wallet.user_id = current_user.id
    # TODO: admin
    elsif @wallet.user_id != current_user.id
      flash[:alert] = I18n.t("wallet.messages.can_only_create_for_yourself")
      respond_to do |format|
        format.html { render :new, status: :forbidden }
        format.json { render json: @wallet.errors, status: :forbidden }
      end
      return
    end

    respond_to do |format|
      if @wallet.save
        format.html { redirect_to @wallet, notice: I18n.t("wallet.messages.wallet_created_success") }
        format.json { render :show, status: :created, location: @wallet }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @wallet.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /wallets/1 or /wallets/1.json
  def update

    # Get the params now so that they can be tested for errors
    params = wallet_params

    # Checks if the wallet was able to be obtained if not redirect to the 404 page
    # check the set_wallet function for more info
    if @fail_to_get_wallet
      redirect_to wallet404_path
      return
    end

    # If the wallet is a system wallet it can not be edited so redirect back to the show page
    # and show the error message
    if @wallet.system
      flash[:notice] = I18n.t("wallet.messages.can_not_be_changed")
      redirect_to wallet_path(@wallet)
      return
    end

    respond_to do |format|
      if @wallet.update(params)
        format.html { redirect_to @wallet, notice: I18n.t("wallet.messages.wallet_updated_success") }
        format.json { render :show, status: :ok, location: @wallet }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @wallet.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /wallets/1 or /wallets/1.json
  def destroy

    # Checks if the wallet was able to be obtained if not redirect to the 404 page
    # check the set_wallet function for more info
    if (@fail_to_get_wallet)
      redirect_to wallet404_path
      return
    end

    # If the wallet is a system wallet it can not be edited so redirect back to the show page
    # and show the error message
    if @wallet.system
      flash[:notice] = I18n.t("wallet.messages.can_not_be_changed")
      redirect_to wallet_path(@wallet)
      return
    end

    @wallet.destroy
    respond_to do |format|
      format.html { redirect_to dashboard_url, notice: I18n.t("wallet.messages.wallet_destroyed_success") }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_wallet
      wallet = Wallet.find(params[:id])

      # Only let the current user edit this wallet
      # TODO: If admin is added add the ability for an admin to also access this wallet
      if wallet.user_id != current_user.id
        @fail_to_get_wallet = true
        return
      end

      @wallet = wallet
      @fail_to_get_wallet = false
    rescue
      # if some error happens this will make sure that the user is redirected to the 404 page
      @fail_to_get_wallet = true
    end

    # Only allow a list of trusted parameters through.
    def wallet_params
      params.require(:wallet).permit(:name, :wallet_icon_id, :user_id, :value, :system)
    rescue
      # if some error happens this will make sure that the user is redirected to the 404 page
      @fail_to_get_wallet = true
    end
end
