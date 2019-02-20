class SettingsController < ApplicationController
    before_action :authentication # Calls authentication function before anything
    before_action :authorization # Calls authorization function before anything

    def index # Loads settings from database and displays it
        @shift_bit = Setting.shift_bit.to_i
        @classes_a = Setting.classes_a
        @classes_b = Setting.classes_b
    end

    def create # Update settings based on parametars
        @shift_bit = params[:shift_bit].to_i
        @classes_a = params[:classes_a]
        @classes_b = params[:classes_b]

        Setting.shift_bit = @shift_bit
        Setting.classes_a = @classes_a
        Setting.classes_b = @classes_b
        
        render 'index'
    end

    private

    def authorization # Checks if current logged in user has role admin if doesn't redirects to root
        return if current_user.role == 'admin'

        redirect_to '/'
    end
end
