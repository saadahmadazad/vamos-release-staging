class Admin::FacilitiesController < Admin::ApplicationController
  before_action :set_facility, only: [:show, :edit, :update, :destroy]

  # GET /facilities
  # GET /facilities.json
  def index
    @facilities = Facility.page(params[:page]).per(20)
  end

  # GET /facilities/1
  # GET /facilities/1.json
  def show
  end

  # GET /facilities/new
  def new
    @facility = Facility.new
  end

  # GET /facilities/1/edit
  def edit
  end

  # POST /facilities
  # POST /facilities.json
  def create
    @facility = Facility.new(facility_params)

    if @facility.save
      redirect_to [:admin, @facility], notice: 'Facility was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /facilities/1
  # PATCH/PUT /facilities/1.json
  def update
    if @facility.update(facility_params)
      redirect_to [:admin, @facility], notice: 'Facility was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /facilities/1
  # DELETE /facilities/1.json
  def destroy
    @facility.destroy
    redirect_to admin_facilities_url, notice: 'Facility was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_facility
      @facility = Facility.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def facility_params
      params.require(:facility).permit(:name, :location, :stripe_subscription_id, :user_id)
    end
end
