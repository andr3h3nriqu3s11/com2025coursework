class QuickLinksController < ApplicationController
  before_action :set_quick_link, only: %i[ show edit update destroy ]

  # GET /quick_links or /quick_links.json
  def index
    @quick_links = QuickLink.all
  end

  # GET /quick_links/1 or /quick_links/1.json
  def show
  end

  # GET /quick_links/new
  def new
    @quick_link = QuickLink.new
  end

  # GET /quick_links/1/edit
  def edit
  end

  # POST /quick_links or /quick_links.json
  def create
    @quick_link = QuickLink.new(quick_link_params)

    respond_to do |format|
      if @quick_link.save
        format.html { redirect_to @quick_link, notice: "Quick link was successfully created." }
        format.json { render :show, status: :created, location: @quick_link }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @quick_link.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /quick_links/1 or /quick_links/1.json
  def update
    respond_to do |format|
      if @quick_link.update(quick_link_params)
        format.html { redirect_to @quick_link, notice: "Quick link was successfully updated." }
        format.json { render :show, status: :ok, location: @quick_link }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @quick_link.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /quick_links/1 or /quick_links/1.json
  def destroy
    @quick_link.destroy
    respond_to do |format|
      format.html { redirect_to quick_links_url, notice: "Quick link was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_quick_link
      @quick_link = QuickLink.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def quick_link_params
      params.require(:quick_link).permit(:name, :origin_id, :destination_id)
    end
end
