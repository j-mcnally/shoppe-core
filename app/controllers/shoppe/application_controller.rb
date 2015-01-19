module Shoppe
  class ApplicationController < ActionController::Base
    
    before_filter :login_required
    
    rescue_from ActiveRecord::DeleteRestrictionError do |e|
      redirect_to request.referer || root_path, :alert => e.message
    end
    
    rescue_from Shoppe::Error do |e|
      @exception = e
      render :layout => 'shoppe/sub', :template => 'shoppe/shared/error'
    end

    private

    def login_required
      unless logged_in?
        redirect_to login_path
      end
    end

    def logged_in?
      shoppe_current_user.is_a?(Shoppe::User)
    end
    
    def shoppe_current_user
      @shoppe_current_user ||= login_from_session || :false
    end

    def login_from_session
      if session[:shoppe_user_id]
        @user = Shoppe::User.find_by_id(session[:shoppe_user_id])
      end
    end
    
    def login_with_demo_mode
      if Shoppe.settings.demo_mode?
        @user = Shoppe::User.first
      end
    end
    
    helper_method :shoppe_current_user, :logged_in?
    
  end
end
