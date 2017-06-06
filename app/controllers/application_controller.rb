class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  helper_method :current_admin, :current_parent, :current_tutor, :require_admin!, :require_parent!, :require_tutor!

  def account_url
    return new_user_session_url unless user_signed_in?
    case current_user.class.name
    when "Admin"
      groups_url
    when "Parent"
      parent_url(current_user)
    when "Tutor"
      groups_url
    else
      root_url
    end if user_signed_in?
  end

  def after_sign_in_path_for(resource)
    stored_location_for(resource) || account_url
  end

  private

    def current_admin
      @current_admin ||= current_user if user_signed_in? and current_user.class.name == "Admin"
    end

    def current_parent
      @current_parent ||= current_user if user_signed_in? and current_user.class.name == "Parent"
    end

    def current_tutor
      @current_tutor ||= current_user if user_signed_in? and current_user.class.name == "Tutor"
    end

    def admin_logged_in?
      @admin_logged_in ||= user_signed_in? and current_admin
    end

    def parent_logged_in?
      @parent_logged_in ||= user_signed_in? and current_parent
    end

    def tutor_logged_in?
      @tutor_logged_in ||= user_signed_in? and current_tutor
    end

    def require_admin
      require_user_type(:admin)
    end

    def require_parent
      require_user_type(:parent)
    end

    def require_tutor
      require_user_type(:tutor)
    end

    def require_user_type(user_type)
      if (user_type == :admin and !admin_logged_in?) or
        (user_type == :parent and !parent_logged_in?) or
        (user_type == :tutor and !tutor_logged_in?)
        redirect_to root_path, status: 301, notice: "You must be logged in as a#{'n' if user_type == :admin} #{user_type} to access this content"
        return false
      end
    end
end
