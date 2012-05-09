class ApplicationController < ActionController::Base
  protect_from_forgery
  
  check_authorization :unless => :devise_controller?

  include ApplicationHelper
  include SessionsHelper

  rescue_from CanCan::AccessDenied do |exception|
    flash.now[:error] = 'Access Denied'
    render 'shared/_error_messages'
  end
end
