class SubscriptionsController < ApplicationController
    def index
    end

    def create
        subscription = if params[:type] == 'student'
            Subscription.new(email: params[:email],
                             klass: params[:class],
                             shift: params[:shift])
        else
            Psubscription.new(name: params[:name],
                              email: params[:email])
        end

        subscription.save

        render 'index'
    end

    def delete
        subscription = Subscription.find_by(email: params[:email])
        if subscription.nil?
            render html: 'Not found'
        elsif subscription.destroy
            render 'index'
        else
            render html: 'Unsuccessful'
        end
    end
end
