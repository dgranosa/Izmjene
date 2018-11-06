class SubscriptionsController < ApplicationController
    def index
    end

    def create
        subscription = Subscription.new(email: params[:email],
                                        klass: params[:class],
                                        shift: params[:shift])

        subscription.save

        render 'index'
    end

    def delete
        if Subscription.find_by(email: params[:email])
            render 'index'
        else
            render html: 'Unsuccessful'
        end
    end
end
