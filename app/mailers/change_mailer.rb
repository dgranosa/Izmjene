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

    def send_professor_email(email, name, data, data2, mail_data, domain)
        @email = email
        @name = name
        @data = data
        @data2 = data2
        @date = mail_data[:date]
        @starttimeU = mail_data[:starttimeU]
        @endtimeU = mail_data[:endtimeU]
        @starttimeP = mail_data[:starttimeP]
        @endtimeP = mail_data[:endtimeP]
        @domain = domain

        mail(to: @email, subject: 'Izmjene za ' + @date)
    end

    def send_email_confirmation(email, url)
		@email = email
		@url = url

		mail(to: @email, subject: 'Potvrda pretplate na Izmjenko')
	end
end
