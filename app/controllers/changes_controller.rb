class ChangesController < ApplicationController
    def index
        if params[:date]
            @change = Change.where(shift: params[:shift], date: params[:date]).first

            if !@change
                render plain: 'Not found'
            else
                get_table
                i = @classes.find_index(params[:class]) * 9
                render json: {
                    header: @header.to_a,
                    data: @data[i..(i+8)],
                    updated_at: @change.updated_at.to_s
                }
            end
        end
    end

    def create
        @change = Change.where(shift: params[:shift], date: params[:date]).first

        if !@change
            @change = Change.create(shift: params[:shift], date: params[:date], data: '')
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
        @change.update(data: @data)

        redirect_to @change
    end

    def send_changes
        hash = Hash[params[:classes].zip(params[:data].each_slice(9).to_a)]
        subscriptions = Subscription.where(shift: params[:shift])

        subscriptions.each do |sub|
            ChangeMailer.send_email(sub.email, params[:date], params[:header], sub.klass, hash[sub.klass]).deliver
        end
    end

    private

    def get_table
        @header = if (Date.current.cweek + (@change.shift == 'B' ? 1 : 0)) % 2 == Setting.shift_bit
                      1..9
                  else
                      -1..7
                  end

        @classes = if @change.shift == 'A'
                       Setting.classes_a.split(' ')
                   else
                       Setting.classes_b.split(' ')
                   end
        
        @data = @change.data.split(',')
    end
end
