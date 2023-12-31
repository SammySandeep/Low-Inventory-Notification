class EmailsController < ApplicationController
    before_action :set_email, only: [:destroy]

    def new
        @email = Email.new
        @shop_setting_id = current_shop.shop_setting.id
        respond_to do |format|
            format.html
            format.js
        end
    end

    def create
        @email = Email.new(email_create_params)
        email_create_success_message = "Email created successfully!"
        email_create_error_message = "Something went wrong.Please enter valid email address!"
        if @email.save
            respond_to do |format|
                format.html
                format.js { render "create.js.erb", :locals => {:email_create_success_message => email_create_success_message, :email_create_error_message => email_create_error_message} }
            end
        end
    end

    def destroy
        email_delete_success_message = "Email deleted successfully!"
        email_delete_error_message = "Something went wrong.Please try again later!"
        if @email.shop_setting_id == (params[:emails_attributes][:shop_setting_id]).to_i
            respond_to do |format|
                format.html
                format.js { render "destroy.js.erb", :locals => {:email_delete_success_message => email_delete_success_message, :email_delete_error_message => email_delete_error_message} }
            end
        end
    end

  private

  def set_email
    @email = Email.find(params[:id])
  end

  def email_params
    params.require(:emails_attributes).permit(:shop_setting_id)
  end

  def email_create_params
    params.require(:emails_attributes).permit(:email, :is_active, :shop_setting_id)
  end

end