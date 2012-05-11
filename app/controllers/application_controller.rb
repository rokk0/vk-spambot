class ApplicationController < ActionController::Base
  protect_from_forgery
  
  check_authorization :unless => :devise_controller?

  skip_before_filter :verify_authenticity_token, :if => Proc.new { |c| c.request.format == 'application/json' }

  include ApplicationHelper

  rescue_from CanCan::AccessDenied do |exception|
    flash.now[:error] = 'Access Denied'
    render 'shared/_error_messages'
  end

  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end
end
