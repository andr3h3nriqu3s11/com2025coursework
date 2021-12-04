class TransactionsController < ApplicationController
  before_action :set_transaction, only: %i[ show edit update destroy ]
  before_action :authenticate_user!

  # GET /transactions or /transactions.json
  def index
    #Check if admin and if so show all transactions
    if current_user.user_type == "admin"
      @transactions = Transaction.all
      return
    end

    # Gets all transactions
    @transactions = Transaction.by_user(current_user)
  end

  # GET /transactions/1 or /transactions/1.json
  def show
    # If the transaction does not exist or is not form this user redirect to the not found page
    # See set_transaction for more info
    if @transaction_not_found
      respond_to do |f|
        f.html {redirect_to transaction404_url}
        f.json { render json: { status: 404 }, status: 404}
      end
      return
    end
  end

  # GET /transactions/new
  def new
    @transaction = Transaction.new

    #Try to see if a specific wallet has been requested and if so set that wallet on origin/destination

    if defined? params[:origin_id]
      @transaction.origin_id = params[:origin_id]
    end

    if defined? params[:destination_id]
      @transaction.destination_id = params[:destination_id]
    end

    # If the user is an admin skip the last verification step
    if current_user.user_type == "admin"
      return
    end

    user_wallets = Wallet.by_user(current_user)

    #Verifies that the requested wallet is from this user

    if user_wallets.by_id(@transaction.origin_id).length != 1
      @transaction.origin = Wallet.by_user(current_user).first
    end

    if user_wallets.by_id(@transaction.destination_id).length != 1
      @transaction.destination = Wallet.by_user(current_user).last
    end

  end

  # GET /transactions/1/edit
  def edit
    # If the transaction does not exist or is not form this user redirect to the not found page
    # See set_transaction for more info
    if @transaction_not_found
      redirect_to transaction404_url
      return
    end
  end

  # POST /transactions or /transactions.json
  def create
    params = transaction_params
    if @transaction_not_found
      respond_to do |format|
        #defaulted for this message since if this happens the origin id is technically not set
        format.html { redirect_to transaction404_url, notice: I18n.t("transaction.messages.origin_wallet_needed") }
        format.json { render json: { status: 404 }, status: :not_found}
      end
      return
    end

    @transaction = Transaction.new(params)
    respond_to do |format|
      # If the transaction does not exist or is not form this user redirect to the not found page
      # See set_transaction for more info

      # Checks for the origin wallet
      if @transaction.origin_id.blank?
        format.html { redirect_to new_transaction_url, notice: I18n.t("transaction.messages.origin_wallet_needed") }
        format.json { render json: @transaction.errors, status: :bad_request }

      # Checks for the destination wallet
      elsif @transaction.destination_id.blank?
        format.html { redirect_to new_transaction_url, notice: I18n.t("transaction.messages.destination_wallet_needed") }
        format.json { render json: @transaction.errors, status: :bad_request }

      # Checks if the user is trying to create a transaction where the origin is from another user
      # Skip this step if admin
      elsif @transaction.origin.user_id != current_user.id and current_user.user_type != "admin"
        format.html { redirect_to new_transaction_url, notice: I18n.t("transaction.messages.origin_not_owned") }
        format.json { render json: @transaction.errors, status: :forbidden }

      elsif @transaction.save
        format.html { redirect_to @transaction, notice: I18n.t("transaction.messages.transaction_created_success") }
        format.json { render :show, status: :created, location: @transaction }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @transaction.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /transactions/1 or /transactions/1.json
  def update
    respond_to do |format|
      # If the transaction does not exist or is not form this user redirect to the not found page
      # See set_transaction for more info
      if @transaction_not_found
        #defaulted for this message since if this happens the origin id is technically not set
        format.html { redirect_to transaction404_url, notice: I18n.t("transaction.messages.origin_wallet_needed") }
        format.json { render json: { status: 404 }, status: :not_found}

      elsif @transaction.update(transaction_params)
        format.html { redirect_to @transaction, notice: I18n.t("transaction.messages.transaction_update_success") }
        format.json { render :show, status: :ok, location: @transaction }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @transaction.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /transactions/1 or /transactions/1.json
  def destroy

    # If the transaction does not exist or is not form this user redirect to the not found page
    # See set_transaction for more info
    if @transaction_not_found
      respond_to do |f|
        f.html {redirect_to transaction404_url}
        f.json { render json: { status: 404 }, status: :not_found}
      end
      return
    end

    # Checks if the origin of this transaction is owned by the user and if not it does not allow the use to delete the
    # transaction
    # See set_transaction for more info
    # Skip this step if admin
    if @origin_not_owned and current_user.user_type != "admin"
      respond_to do |f|
        f.html {redirect_to transaction_url(@transaction), notice: I18n.t("transaction.messages.origin not owned")}
        f.json { render json: { status: 403 }, status: :forbidden}
      end
      return
    end

    origin_id = @transaction.origin.id;
    @transaction.destroy
    respond_to do |format|
      format.html { redirect_to wallet_url(origin_id), notice: I18n.t("transaction.messages.transaction_destroyed_success") }
      format.json { head :no_content }
    end
  end

  def transaction404

    # This sets some dummy wallets so that the render function can correctly
    # display the images for the wallets

    @origin = Wallet.new
    @origin.name = I18n.t("transaction.404.transaction")
    @origin.wallet_icon = WalletIcon.from_str("currency-dollar")

    @destination = Wallet.new
    @destination.name = I18n.t("transaction.404.not_found")
    @destination.wallet_icon = WalletIcon.from_str("emoji-frown")
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_transaction
      @transaction = Transaction.find(params[:id])

      o = Wallet.by_id(@transaction.origin_id).first;
      d = Wallet.by_id(@transaction.destination_id).first;

      # Checks if the origin if from this user
      if (o.user_id != current_user.id)
        @origin_not_owned = true
      end
      # Checks if the destination if from this user
      if (d.user_id != current_user.id)
        @destination_not_owned = true
      end
      # if the user is not owner of the destination or origin wallet then the user can not
      # access this transaction
      # If admin ignore this rule
      if @origin_not_owned and @destination_not_owned and current_user.user_type != "admin"
        @transaction_not_found = true
      end
    rescue
      # Guarantees that if there is a error the user is redirected to the 404 page instead of an error page
      @transaction_not_found = true
    end

    # Only allow a list of trusted parameters through.
    def transaction_params
      params.require(:transaction).permit(:description, :origin_id, :destination_id, :value)
    rescue
      # Guarantees that if there is a error the user is redirected to the 404 page instead of an error page
      @transaction_not_found = true
    end

end
