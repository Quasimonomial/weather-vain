class FrontEndController < ActionController::Base
  layout "application"

  def index
    render :index
  end
end
