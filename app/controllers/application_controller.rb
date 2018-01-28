class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :authenticate_user!

  before_action :configure_permitted_parameters, if: :devise_controller?

  helper_method :current_admin, :current_parent, :current_tutor, :admin_logged_in?, :parent_logged_in?, :tutor_logged_in?, :require_user!

  helper_method :decode_sched, :encode_sched

  helper_method :address

  helper_method :state_array

  helper_method :display_name 

  def after_sign_in_path_for(resource)
    return new_user_session_url unless user_signed_in?
    profile
  end

  def after_sign_out_path_for(resource)
    return profile if user_signed_in?
    new_user_session_url
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :street_address, :city, :state, :zip, :phone])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :street_address, :city, :state, :zip, :phone])
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

    def require_user!(cond)
      if !cond
        redirect_to profile, status: 301, alert: "You are not authorized to view this content!" 
      end
    end

    def profile
      case current_user.class.name
      when "Admin"
        admin_url(current_admin)
      when "Parent"
        parent_url(current_parent)
      when "Tutor"
        tutor_url(current_tutor)
      else
        root_url
      end
    end

    def decode_sched(group)
      group.schedule.scan(/.{5}/).map { |block| DateTime.strptime(block, "%w%H%M") }
    end

    def encode_sched(datetime_arr)
      datetime_arr.map { |datetime| datetime.strftime("%w%H%M") }.join('')
    end

    def address(user)
      user.street_address + "\n" + user.city + ", " + user.state + " " + user.zip
    end

    def state_array
      %w(AK AL AR AZ CA CO CT DC DE FL GA HI IA ID IL IN KS KY LA MA MD ME MI MN MO MS MT NC ND NE NH NJ NM NV NY OH OK OR PA RI SC SD TN TX UT VA VT WA WI WV WY)
    end
end
