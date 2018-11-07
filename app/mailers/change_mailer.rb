class ChangeMailer < ApplicationMailer
    default from: 'izmjene.tsrb@gmail.com'

    def send_email(email, date, header, klass, data)
        @email = email
        @date = date
        @header = header
        @klass = klass
        @data = data

        mail(to: @email, subject: 'Izmjene za ' + date)
    end
end
