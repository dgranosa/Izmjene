class ProfessorsController < ApplicationController
    before_action :parse_schedule

    def index
        if params[:list]
            render json: {
                professors: $teachers.values
            }
        elsif params[:name]
            d = Date.parse(params[:date])
            update_prof_changes(d) if $prof_changes.nil? || $prof_changes[d].nil?
            render json: {
                name: params[:name],
                changes: $prof_changes[d][params[:name]],
                schedule: $teacher_schedule[params[:name]][d.cweek == Setting.shift_bit ? 0 : 1][d.wday - 1]
            }
        end
    end

    def create
        redirect_to action: "show", name: params[:name], date: params[:date]
    end

    def show
        @changeA = Change.where(shift: 'A', date: params[:date]).first
        @changeB = Change.where(shift: 'B', date: params[:date]).first

        if !@changeA
            @changeA = Change.create(shift: 'A', date: params[:date], data: '', data2: '')
        end

        if !@changeB
            @changeB = Change.create(shift: 'B', date: params[:date], data: '', data2: '')
        end

        @date = Date.parse(params[:date])
        @name = params[:name]

        update_prof_changes(@date) if $prof_changes.nil? || $prof_changes[@date].nil?

        @change = $prof_changes[@date][@name]


        @starttime = @changeA.starttime.nil? ? $starttime_arr: @changeA.starttime.split(',')
        @endtime = @changeA.endtime.nil? ? $endtime_arr : @changeA.endtime.split(',')
    end
end
