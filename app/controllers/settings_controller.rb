class SettingsController < ApplicationController
    def index
        @shift_bit = Setting.shift_bit.to_i
        @classes_a = Setting.classes_a
        @classes_b = Setting.classes_b
    end

    def create
        @shift_bit = params[:shift_bit].to_i
        @classes_a = params[:classes_a]
        @classes_b = params[:classes_b]

        Setting.shift_bit = @shift_bit
        Setting.classes_a = @classes_a
        Setting.classes_b = @classes_b
        
        render 'index'
    end
end
