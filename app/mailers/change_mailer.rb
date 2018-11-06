class ChangeMailer < ApplicationMailer
    default from: 'example@mail.com'

    def send_email(email, header, data)
        @email = email
        @header = header
        @data = data

        binding.pry

        mail(to: @email, subject: 'Izmjene')
    end
end
