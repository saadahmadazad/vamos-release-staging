class Admin::OtaController < Admin::ApplicationController
  before_action :set_otum, only: [:show, :edit, :update, :destroy]

  # GET /ota
  def index
    @ota = Otum.page(params[:page]).per(20)
  end

  # GET /ota/1
  def show
  end

  # GET /ota/new
  def new
    @otum = Otum.new
  end

  # GET /ota/1/edit
  def edit
    @otum.set_decrypt_password
  end

  # POST /ota
  def create
    @otum = Otum.new(otum_params)

    # パスワードを暗号化
    @otum.set_encrypt_password(params[:otum][:password])

    if @otum.save
      redirect_to [:admin, @otum], notice: 'Otum was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /ota/1
  def update
    # パスワードを暗号化
    unless params[:otum][:password].nil?
      @otum.set_encrypt_password(params[:otum][:password])
    end

    if @otum.update(otum_params)
      redirect_to [:admin, @otum], notice: 'Otum was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /ota/1
  def destroy
    @otum.destroy
    redirect_to admin_ota_url, notice: 'Otum was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_otum
      @otum = Otum.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def otum_params
      params.require(:otum).permit(:provider, :status, :account, :password, :token, :last_crawl_at, :crowl_status, :name, :facility_id)
    end
end
