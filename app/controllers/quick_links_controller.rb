class QuickLinksController < ApplicationController
  before_action :set_quick_link, only: %i[ show edit update destroy ]
  before_action :authenticate_user!

  # GET /quick_links/1 or /quick_links/1.json
  def show
    #If something goes wrong redirect to the profile page which as the list of quick links
    if @quick_link_not_found
      redirect_to edit_user_registration_path
      return
    end
  end

  # GET /quick_links/new
  def new
    @quick_link = QuickLink.new
  end

  # GET /quick_links/1/edit
  def edit
    #If something goes wrong redirect to the profile page which as the list of quick links
    if @quick_link_not_found
      redirect_to edit_user_registration_path
      return
    end
  end

  # POST /quick_links or /quick_links.json
  def create
    # Get the params to set the flag if something goes wrong
    params = quick_link_params

    #If something goes wrong redirect to the profile page which as the list of quick links
    if @quick_link_not_found
      respond_to do |format|
        format.html { redirect_to edit_user_registration_path, notice: I18n.t("quick_links.messages.not_found") }
        format.json { render json: {status: 404}, status: :not_found }
      end
      return
    end

    @quick_link = QuickLink.new(params)
    respond_to do |format|
      if @quick_link.save
        format.html { redirect_to @quick_link, notice: I18n.t("quick_links.messages.success_create") }
        format.json { render :show, status: :created, location: @quick_link }
      else
        format.html { redirect_to new_quick_link_path }
        format.json { render json: @quick_link.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /quick_links/1 or /quick_links/1.json
  def update

    # Get the params to set the flag if something goes wrong
    params = quick_link_params

    #If something goes wrong redirect to the profile page which as the list of quick links
    if @quick_link_not_found
      respond_to do |format|
        format.html { redirect_to edit_user_registration_path, notice: I18n.t("quick_links.messages.not_found") }
        format.json { render json: {status: 404}, status: :not_found }
      end
      return
    end

    respond_to do |format|
      if @quick_link.update(quick_link_params)
        format.html { redirect_to @quick_link, notice: I18n.t("quick_links.messages.success_update") }
        format.json { render :show, status: :ok, location: @quick_link }
      else
        format.html { redirect_to edit_quick_link_url(@quick_link), status: :unprocessable_entity }
        format.json { render json: @quick_link.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /quick_links/1 or /quick_links/1.json
  def destroy

    #If something goes wrong redirect to the profile page which as the list of quick links
    if @quick_link_not_found
      respond_to do |format|
        format.html { redirect_to edit_user_registration_path, notice: I18n.t("quick_links.messages.not_found") }
        format.json { render json: {status: 404}, status: :not_found }
      end
      return
    end

    #If origin not owned should redirect to the show page
    if @origin_not_owned and current_user.user_type != "admin"
      respond_to do |format|
        format.html { redirect_to quick_link_url(@quick_link), notice: I18n.t("quick_links.messages.not_found") }
        format.json { render json: {status: 404}, status: :not_found }
      end
      return
    end

    @quick_link.destroy
    respond_to do |format|
      format.html { redirect_to edit_user_registration_url, notice: "Quick link was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_quick_link
      @quick_link = QuickLink.find(params[:id])


      o = Wallet.by_id(@quick_link.origin_id).first;
      d = Wallet.by_id(@quick_link.destination_id).first;

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
        @quick_link_not_found = true
      end

    rescue
      @quick_link_not_found = true
    end

    # Only allow a list of trusted parameters through.
    def quick_link_params
      params.require(:quick_link).permit(:name, :origin_id, :destination_id)
    rescue
      @quick_link_not_found = true
    end
end
