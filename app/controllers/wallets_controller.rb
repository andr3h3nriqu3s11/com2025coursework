class WalletsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_wallet, only: %i[ show edit update destroy ]

  # GET /wallets or /wallets.json
  def index

    # TODO show all if admin
    # @wallets = Wallet.all

    @wallets = Wallet.by_user(current_user)
  end

  # GET /wallets/1 or /wallets/1.json
  def show
    if (@fail_to_get_wallet)
      redirect_to wallet404_path
      return
    end
    @transactions = Transaction.by_wallet(@wallet)
  end

  def wallet404
    @wallet = Wallet.new
    @wallet.name = "No wallet found"
    @wallet.icon = "emoji-frown"
  end

  # GET /wallets/new
  def new
    @wallet = Wallet.new
  end

  # GET /wallets/1/edit
  def edit
    if (@fail_to_get_wallet)
      redirect_to wallet404_path
      return
    end
    if @wallet.system
      flash[:notice] = I18n.t("wallet.messages.can_not_be_changed")
      redirect_to wallet_path(@wallet)
      return
    end
  end

  # POST /wallets or /wallets.json
  def create
    @wallet = Wallet.new(wallet_params)

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
        format.html { redirect_to @wallet, notice: "Wallet was successfully created." }
        format.json { render :show, status: :created, location: @wallet }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @wallet.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /wallets/1 or /wallets/1.json
  def update
    if @fail_to_get_wallet
      redirect_to wallet404_path
      return
    end

    respond_to do |format|
      if @wallet.update(wallet_params)
        format.html { redirect_to @wallet, notice: "Wallet was successfully updated." }
        format.json { render :show, status: :ok, location: @wallet }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @wallet.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /wallets/1 or /wallets/1.json
  def destroy

    if (@fail_to_get_wallet)
      redirect_to wallet404_path
      return
    end

    if @wallet.system
      flash[:notice] = I18n.t("wallet.messages.can_not_be_changed")
      redirect_to wallet_path(@wallet)
      return
    end

    @wallet.destroy
    respond_to do |format|
      format.html { redirect_to dashboard_url, notice: "Wallet was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_wallet
      wallet = Wallet.find(params[:id])
      #TODO: admin
      if wallet.user_id != current_user.id
        @fail_to_get_wallet = true
        return
      end
      @wallet = wallet
      @fail_to_get_wallet = false
    rescue
      @fail_to_get_wallet = true
    end

    # Only allow a list of trusted parameters through.
    def wallet_params
      params.require(:wallet).permit(:name, :icon, :user_id, :value, :system)
    end
end
