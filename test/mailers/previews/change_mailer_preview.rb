# Preview all emails at http://localhost:3000/rails/mailers/change_mailer
class ChangeMailerPreview < ActionMailer::Preview
    def change_mail_preview
        ChangeMailer.send_email('dgranosa@gmail.com', Date.current.to_s, (1..9).to_a, '4.H', ['Eng', '', 'Hrv', 'X'])
    end
end
