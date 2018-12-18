class ChangesController < ApplicationController
    before_action :parse_schedule

    def index
        if params[:date]
            @change = Change.where(shift: params[:shift], date: params[:date]).first

            if !@change
                render plain: 'Not found'
            else
                get_table
                i = @classes.find_index(params[:class]) * 9
                @data = @data[i..(i+8)]
                
                render json: {
                    header: @header.to_a,
                    data: @data,
                    data2: @data2,
                    schedule: $schedule[params[:class]][params[:shift] == 'A' ? 0 : 1][@change.date.wday - 1][@header.first == -1 ? 6..14 : 1..9],
                    starttime: @starttime,
                    endtime: @endtime,
                    updated_at: @change.updated_at.to_s
                }
            end
        end
    end

    def create
        @change = Change.where(shift: params[:shift], date: params[:date]).first

        if !@change
            @change = Change.create(shift: params[:shift], date: params[:date], data: '', data2: '')
        end

        redirect_to @change
    end

    def show
        @change = Change.find(params[:id])
        get_table
    end

    def edit
        @change = Change.find(params[:id])
        get_table
    end

    def update
        @change = Change.find(params[:id])

        @data = params[:change][:data].join(',')
        @data2 = params[:change][:data2].to_a.join(',')
        @starttime = params[:change][:starttime].join(',')
        @endtime = params[:change][:endtime].join(',')
        @change.update(data: @data, data2: @data2, starttime: @starttime, endtime: @endtime)

        update_prof_changes(@change.date)

        redirect_to @change
    end

    def send_changes
        hash = Hash[params[:classes].zip(params[:data].each_slice(9).to_a)]
        subscriptions = Subscription.where(shift: params[:shift])
        domain = request.host + ':' + request.port.to_s

        subscriptions.each do |sub|
            ChangeMailer.send_email(sub.email, params[:date], params[:header], sub.klass, hash[sub.klass], domain).deliver
        end
    end

    private

    def get_table
        @header = if (@change.date.cweek + (@change.shift == 'B' ? 1 : 0)) % 2 == Setting.shift_bit
                      1..9
                  else
                      -1..7
                  end

        @date = @change.date

        @shift = @change.shift

        @classes = if @shift == 'A'
                       Setting.classes_a.split(' ')
                   else
                       Setting.classes_b.split(' ')
                   end
        
        @data = @change.data.split(',')

        @data2 = @change.data2.split(',')

        @starttime = @change.starttime.nil? ? $starttime_arr[@header.first == -1 ? 5..13 : 0..8] : @change.starttime.split(',')
        @endtime = @change.endtime.nil? ? $endtime_arr[@header.first == -1 ? 5..13 : 0..8] : @change.endtime.split(',')
    end
end
