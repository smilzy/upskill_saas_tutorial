class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  
  # Whitelistujemy poniższe pola, aby móc je przetwarzać, jeżeli 
  # żądanie przychodzi poprzez Devise sign up form.
  before_action :configure_permitted_parameters, if: :devise_controller?  # jeżeli url należy do Devise (czyli /users/cokolwiek bo tak ustawilismy)
  # uruchom :configure_permitted_parameters
 
  protected
    def configure_permitted_parameters # Wszystko jest wyjaśnione dokumentacji Devise
       devise_parameter_sanitizer.permit(:sign_up) { |u| u.permit(:stripe_card_token, :email, :password, :password_confirmation) } 
    end
end
