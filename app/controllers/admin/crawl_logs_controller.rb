class Admin::CrawlLogsController < Admin::ApplicationController
  before_action :set_crawl_log, only: [:show]

  # GET /crawl_logs
  def index
    @crawl_logs = CrawlLog.page(params[:page]).per(20)
  end

  # GET /crawl_logs/1
  def show
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_crawl_log
      @crawl_log = CrawlLog.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def crawl_log_params
      params.require(:crawl_log).permit(:status, :ota_room_id)
    end
end
