class ApplicationController < ActionController::Base
  include Clearance::Controller
  protect_from_forgery with: :exception

  def user_id_to_email(id)
    if id == 0
      return "Anonymous"
    end
    return User.where('"id" = ?', id).first.email
  end
  
  def user_email_to_id(email)
    return User.where('"email" = ?', email).first.id
  end
end
