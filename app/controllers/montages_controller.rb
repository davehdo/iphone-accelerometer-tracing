class MontagesController < ApplicationController
  before_action :set_montage, only: [:show, :edit, :update, :destroy]

  # GET /montages
  # GET /montages.json
  def index
    @montages = Montage.all
  end

  # GET /montages/1
  # GET /montages/1.json
  def show
  end

  # GET /montages/new
  def new
    @montage = Montage.new
  end

  # GET /montages/1/edit
  def edit
  end

  # POST /montages
  # POST /montages.json
  def create
    @montage = Montage.new(montage_params)

    respond_to do |format|
      if @montage.save
        format.html { redirect_to @montage, notice: 'Montage was successfully created.' }
        format.json { render :show, status: :created, location: @montage }
      else
        format.html { render :new }
        format.json { render json: @montage.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /montages/1
  # PATCH/PUT /montages/1.json
  def update
    respond_to do |format|
      if @montage.update(montage_params)
        format.html { redirect_to @montage, notice: 'Montage was successfully updated.' }
        format.json { render :show, status: :ok, location: @montage }
      else
        format.html { render :edit }
        format.json { render json: @montage.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /montages/1
  # DELETE /montages/1.json
  def destroy
    @montage.destroy
    respond_to do |format|
      format.html { redirect_to montages_url, notice: 'Montage was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_montage
      @montage = Montage.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def montage_params
      params.require(:montage).permit(:name)
    end
end
