class TransactionsController < ApplicationController
  before_action :set_transaction, only: %i[ show edit update destroy ]
  before_action :authenticate_user!

  # GET /transactions or /transactions.json
  def index
    #TODO
    #Check if admin
    #@transactions = Transaction.all
    @transactions = Transaction.by_user(current_user)
  end

  # GET /transactions/1 or /transactions/1.json
  def show
    if @transaction_not_found
      redirect_to transaction404_url
      return
    end
  end

  # GET /transactions/new
  def new
    @transaction = Transaction.new
  end

  # GET /transactions/1/edit
  def edit
    if @transaction_not_found
      redirect_to transaction404_url
      return
    end
  end

  # POST /transactions or /transactions.json
  def create
    @transaction = Transaction.new(transaction_params)
    respond_to do |format|
      if @transaction_not_found
        #defaulted for this message since if this happens the origin id is technically not set
        format.html { redirect_to transaction404_url, notice: I18n.t("transaction.messages.origin_wallet_needed") }
        format.json { render json: @transaction.errors, status: :bad_request }

      elsif @transaction.origin_id.blank?
        format.html { redirect_to new_transaction_url, notice: I18n.t("transaction.messages.origin_wallet_needed") }
        format.json { render json: @transaction.errors, status: :bad_request }

      elsif @transaction.destination_id.blank?
        format.html { redirect_to new_transaction_url, notice: I18n.t("transaction.messages.destination_wallet_needed") }
        format.json { render json: @transaction.errors, status: :bad_request }

      elsif @transaction.origin.user_id != current_user.id
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
      if @transaction_not_found
        #defaulted for this message since if this happens the origin id is technically not set
        format.html { redirect_to transaction404_url, notice: I18n.t("transaction.messages.origin_wallet_needed") }
        format.json { render json: @transaction.errors, status: :bad_request }

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

    if @transaction_not_found
      redirect_to transaction404_url
      return
    end

    if @origin_not_owned
      flash[:alert] = t("transaction.messages.origin not owned")
      redirect_to transaction_url(@transaction)
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
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_transaction
      @transaction = Transaction.find(params[:id])

      o = Wallet.by_id(@transaction.origin_id).first;
      d = Wallet.by_id(@transaction.destination_id).first;

      if (o.user_id != current_user.id)
        @origin_not_owned = true
      end
      if (d.user_id != current_user.id)
        @destination_not_owned = true
      end
      if @origin_not_owned and @destination_not_owned
        @transaction_not_found = true
      end
    rescue
      @transaction_not_found = true
    end

    # Only allow a list of trusted parameters through.
    def transaction_params
      params.require(:transaction).permit(:description, :origin_id, :destination_id, :value)
    rescue
      @transaction_not_found = true
    end

end
