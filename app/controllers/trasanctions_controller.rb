class TrasanctionsController < ApplicationController
  before_action :set_trasanction, only: %i[ show edit update destroy ]

  # GET /trasanctions or /trasanctions.json
  def index
    @trasanctions = Trasanction.all
  end

  # GET /trasanctions/1 or /trasanctions/1.json
  def show
  end

  # GET /trasanctions/new
  def new
    @trasanction = Trasanction.new
  end

  # GET /trasanctions/1/edit
  def edit
  end

  # POST /trasanctions or /trasanctions.json
  def create
    @trasanction = Trasanction.new(trasanction_params)

    respond_to do |format|
      if @trasanction.save
        format.html { redirect_to @trasanction, notice: "Trasanction was successfully created." }
        format.json { render :show, status: :created, location: @trasanction }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @trasanction.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /trasanctions/1 or /trasanctions/1.json
  def update
    respond_to do |format|
      if @trasanction.update(trasanction_params)
        format.html { redirect_to @trasanction, notice: "Trasanction was successfully updated." }
        format.json { render :show, status: :ok, location: @trasanction }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @trasanction.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /trasanctions/1 or /trasanctions/1.json
  def destroy
    @trasanction.destroy
    respond_to do |format|
      format.html { redirect_to trasanctions_url, notice: "Trasanction was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_trasanction
      @trasanction = Trasanction.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def trasanction_params
      params.require(:trasanction).permit(:description, :origin, :destination, :value)
    end
end
