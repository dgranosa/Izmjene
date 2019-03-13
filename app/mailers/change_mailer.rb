class ChangeMailer < ApplicationMailer
    default from: 'izmjene.tsrb@gmail.com'

    def send_students_email(email, date, header, klass, data, data2, classtime, domain)
        @email = email
        @date = date
        @header = header
        @klass = klass
        @data = data
	@data2 = data2
        @classtime = classtime
        @domain = domain

        mail(bcc: @email, subject: 'Izmjene za ' + date)
    end

    def send_professor_email(email, name, date, data, domain)
        @email = email
        @name = name
        @date = date
        @data = data
	@domain = domain

	binding.pry

        mail(to: @email, subject: 'Izmjene za ' + date)
    end

    def send_email_confirmation(email, url)
		@email = email
		@url = url

		mail(to: @email, subject: 'Potvrda pretplate na Izmjenko')
	end
end
