# app/controllers/users/sessions_controller.rb
class Users::SessionsController < Devise::SessionsController
  protected

  def after_sign_in_path_for(resource)
    # The Warden callback will handle the redirect if a guest cart was transferred.
    super
  end

  def after_sign_out_path_for(resource_or_scope)
    # The Warden callback will handle cart cleanup.
    super
  end
end