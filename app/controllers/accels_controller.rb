class AccelsController < ApplicationController
  before_action :set_accel, only: [:show, :edit, :update, :destroy]

  # GET /accels
  # GET /accels.json
  def index
    @accels = Accel.where(:accelx.ne => nil).desc(:timestamp).limit(400).reverse
  end

  # GET /accels/1
  # GET /accels/1.json
  def show
  end

  # GET /accels/new
  def new
    @accel = Accel.new
  end

  # GET /accels/1/edit
  def edit
  end

  def save_many
    # raise params[:accel].values.inspect
    if @accels = Accel.create( params[:accel].values )
      render json: @accels
    else
      render json: @accels.collect{|e| e.errors}, status: :unprocessable_entity
    end
  end
  
  # POST /accels
  # POST /accels.json
  def create
    @accel = Accel.new(accel_params)

    respond_to do |format|
      if @accel.save
        format.html { redirect_to @accel, notice: 'Accel was successfully created.' }
        format.json { render :show, status: :created, location: @accel }
      else
        format.html { render :new }
        format.json { render json: @accel.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /accels/1
  # PATCH/PUT /accels/1.json
  def update
    respond_to do |format|
      if @accel.update(accel_params)
        format.html { redirect_to @accel, notice: 'Accel was successfully updated.' }
        format.json { render :show, status: :ok, location: @accel }
      else
        format.html { render :edit }
        format.json { render json: @accel.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /accels/1
  # DELETE /accels/1.json
  def destroy
    @accel.destroy
    respond_to do |format|
      format.html { redirect_to accels_url, notice: 'Accel was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_accel
      @accel = Accel.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def accel_params
      params.require(:accel).permit(:accelx, :accely, :accelz, :rota, :rotb, :rotg, :timestamp, :lat, :lng, :accuracy, :heading, :speed)
    end
end
