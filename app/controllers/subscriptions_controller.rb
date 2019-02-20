class SubscriptionsController < ApplicationController
    def index # Displays form for entering email subscription
    end

    def create # Send email confirmation mail
		$email_confirmation ||= Hash.new

		token = $email_confirmation.select { |k, v| v[:email] == params[:email] }.keys[0]

		if token.nil?
			token = SecureRandom.urlsafe_base64.to_s

			$email_confirmation[token] = {
				type: params[:type],
				email: params[:email],
				klass: params[:class],
				shift: params[:shift],
				name: params[:name]
			}
		end

		url = request.host + ':' + request.port.to_s + '/subscriptions/confirm?token=' + token
		ChangeMailer.send_email_confirmation(params[:email], url).deliver

        render html: 'Confirmation mail has been send to ' + params[:email]
    end

    def delete # Deletes email from database from given parametar email
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
    
    def confirm # Confirms 
		if params[:token].nil?
			redirect_to action: :index
			return
		end

		$email_confirmation ||= Hash.new

		unless $email_confirmation.has_key?(params[:token])
			redirect_to action: :index
			return
		end

		email_data = $email_confirmation[params[:token]]
		$email_confirmation.delete(params[:token])

        subscription = if email_data[:type] == 'student'
            Subscription.new(email: email_data[:email],
                             klass: email_data[:klass],
                             shift: email_data[:shift])
        else
            Psubscription.new(name: email_data[:name],
                              email: email_data[:email])
        end

        subscription.save

		redirect_to '/'
    end
end
