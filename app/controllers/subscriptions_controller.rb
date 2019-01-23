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
        if params[:email].nil?
            render 'delete'
            return
        end

        subscription = Subscription.find_by(email: params[:email])
        psubscription = Psubscription.find_by(email: params[:email])

        if subscription.nil? && psubscription.nil?
            render html: 'Not found'
        elsif !subscription.nil? && subscription.destroy
            render 'index'
        elsif !psubscription.nil? && psubscription.destroy
            render 'index'
        else
            render html: 'Unsuccessful'
        end
    end
end
