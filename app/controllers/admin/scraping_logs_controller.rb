class Admin::ScrapingLogsController < Admin::ApplicationController
  before_action :set_scraping_log, only: [:show]

  # GET /scraping_logs
  def index
    @scraping_logs = ScrapingLog.page(params[:page]).per(20)
  end

  # GET /scraping_logs/1
  def show
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_scraping_log
      @scraping_log = ScrapingLog.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def scraping_log_params
      params.require(:scraping_log).permit(:status, :url, :crawl_log_id)
    end
end
