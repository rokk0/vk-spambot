module SessionsHelper

  def sign_in(user)
    cookies.permanent.signed[:remember_token] = [user.id, user.salt]
    #session[:user_id] = user.id
    self.current_user = user
  end
  
  def current_user=(user)
    @current_user = user
  end
  
  def current_user
    @current_user ||= user_from_remember_token
    #@current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  
  def signed_in?
    !current_user.nil?
  end
  
  def sign_out
    cookies.delete(:remember_token)
    #session[:user_id] = nil
    self.current_user = nil
  end
  
  private
    # comment for session authentication
    def user_from_remember_token
      User.authenticate_with_salt(*remember_token)
    end

    # comment for session authentication
    def remember_token
      cookies.signed[:remember_token] || [nil, nil]
    end
end