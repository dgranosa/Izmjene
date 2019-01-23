class ChangeMailer < ApplicationMailer
    default from: 'izmjene.tsrb@gmail.com'

    def send_students_email(email, date, header, klass, data, domain)
        @email = email
        @date = date
        @header = header
        @klass = klass
        @data = data
        @domain = domain

        mail(bcc: @email, subject: 'Izmjene za ' + date)
    end

    def send_professor_email(email, name, date, data, domain)
        @email = email
        @name = name
        @date = date
        @data = data

        mail(to: @email, subject: 'Izmjene za ' + date)
    end
end
