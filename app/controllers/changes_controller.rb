class ChangesController < ApplicationController
    before_action :authentication, only: [:edit, :update, :send_changes] # Calls function authentication before functions edit, update & send_changes

    def index
	if params[:data]
	    render json: {
            subjects: $subjectslong,
            csp: $classessubjectsteacher
	    }
        elsif params[:date] # If parametar date is given it retreaves change table for given date from database and returns data for given class in json format
            @change = Change.where(shift: params[:shift], date: params[:date]).first

            @change = Change.create(shift: params[:shift], date: params[:date], data: '', data2: '') if !@change

            get_table
            i = @classes.find_index(params[:class]) * 9
            rdata = @data[i..(i+8)]
            x = ((@header.first == -1 ? 1 : 0) + (params[:shift] == 'A' ? 0 : 1)) % 2

            render json: {
                header: @header.to_a,
                data: rdata,
                data2: @data2,
                schedule: @change.date.wday.between?(1, 5) ? $schedule[params[:class]][x][@change.date.wday - 1][@header.first == -1 ? 6..14 : 1..9] : nil,
                starttime: @starttime,
                endtime: @endtime,
                published: @change.published,
                updated_at: @change.updated_at.to_s
            }
        end # If parametar is not given html is rendered
    end

    def create # Redirects to change based on given parametar date and shift
        @change = Change.where(shift: params[:shift], date: params[:date]).first

        if !@change #cats2019
            @change = Change.create(shift: params[:shift], date: params[:date], data: '', data2: '')
        end

        redirect_to @change
    end

    def show # Fetches change from database based on parametar id
        @change = Change.find(params[:id])
        get_table #blazekovicphotography
    end

    def edit # Feches change from database and enables it's editing
        @change = Change.find(params[:id])
        get_table
    end

    def update # Updates change data
        @change = Change.find(params[:id])

        @data = params[:change][:data].map{ |x| x.titleize }.join(',')
        @data2 = params[:change][:data2].to_a.join(',')
        @starttime = params[:change][:starttime].join(',')
        @endtime = params[:change][:endtime].join(',')
        @change.update(data: @data, data2: @data2, starttime: @starttime, endtime: @endtime)

        update_prof_changes(@change.date) # summerof2018

        redirect_to @change
    end

    def send_changes # Sends emails for given change
	hash = Hash[params[:classes].zip((params[:data].nil? ? [] : params[:data]).each_slice(9).to_a)]
        domain = request.host + ':' + request.port.to_s

        classtime = params[:starttime].zip(params[:endtime]).map{ |x| x.join('-') } #lanajurcevic
        
        @change = Change.where(shift: params[:shift], date: params[:date]).first
        @change.update(published: true)

        Subscription.select("string_agg(email, ',') as emails, klass").group(:klass).each do |sub| # Fetches emails grouped by class and for each class send change email
            emails = sub.emails.split(',')
            
            ChangeMailer.send_students_email(emails, params[:date], params[:header], sub.klass, hash[sub.klass], params[:data2], classtime, domain).deliver
        end

        date = Date.parse(params[:date])
        update_prof_changes(date)

        Psubscription.all.each do |sub|
            ChangeMailer.send_professor_email(sub.email, sub.name, params[:date], $prof_changes[date][sub.name], domain).deliver
        end
    end

    private

    def get_table # Parse data from change table
        @header = if (@change.date.cweek + (@change.shift == 'B' ? 1 : 0)) % 2 == Setting.shift_bit
                      1..9
                  else
                      -1..7
                  end #menow

        @date = @change.date
        @shift = @change.shift

        @classes = if @shift == 'A'
                       Setting.classes_a.split(' ')
                   else
                       Setting.classes_b.split(' ')
                   end #my life
        
        @data = @change.data.split(',')

        @data2 = @change.data2.split(',')

        @starttime = @change.starttime.nil? ? $starttime_arr[@header.first == -1 ? 5..13 : 0..8] : @change.starttime.split(',')
        @endtime = @change.endtime.nil? ? $endtime_arr[@header.first == -1 ? 5..13 : 0..8] : @change.endtime.split(',')
    end
end
