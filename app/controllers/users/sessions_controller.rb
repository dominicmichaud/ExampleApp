class Users::SessionsController < Devise::SessionsController
# before_action :configure_sign_in_params, only: [:create]
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  respond_to :json

  def create
    if params[:user][:email].blank? || params[:user][:password].blank?
      if params[:user][:email].blank? && params[:user][:password].blank?
        render :json=>{:success=>false, :target=> 'both', :message=>"Email address and password can't be blank"}, :status=>500
      elsif params[:user][:email].blank?
        render :json=>{:success=>false,:target=> 'email', :message=>"Email address can't be blank"}, :status=>500
      elsif params[:user][:password].blank?
        render :json=>{:success=>false,:target=> 'psw', :message=>"Password can't be blank"}, :status=>500
      end
    else
      @resource = User.find_for_database_authentication(email: params[:user][:email])
        return invalid_login_attempt unless @resource

        if @resource.valid_password?(params[:user][:password])
          sign_in :user, @resource
          return render nothing: true
        end

        invalid_login_attempt
    end
  end

  protected
  def invalid_login_attempt
    # set_flash_message(:alert, :invalid)
    # render json: flash[:alert], status: 401
    render :json=>{:success=>false,:target=> '', :message=>"Failed login attempt. Invalid email or password. Try again"}, :status=>401
  end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
