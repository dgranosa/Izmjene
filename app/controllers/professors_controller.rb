class ProfessorsController < ApplicationController
    before_action :parse_schedule # Calls authentication function before anything

    def index
        if params[:list] # If parametar list is given returns list of professors
            render json: {
                professors: $teachers.values
            }
	elsif params[:name] # else it returns professor data
            d = Date.parse(params[:date])
            update_prof_changes(d) if $prof_changes.nil? || $prof_changes[d].nil?

	    show
                
            render json: {
                name: params[:name],
                published: @published,
                data: $prof_changes[d][params[:name]],
                schedule: d.wday.between?(1, 5) ? $teacher_schedule[params[:name]][d.cweek % 2 == Setting.shift_bit ? 0 : 1][d.wday - 1] : nil,
                starttime: @starttime,
                endtime: @endtime,
                data2: @data2 
            }
        end
    end

    def create # Redirect to professor change based on parametars name and date
        redirect_to action: "show", name: params[:name], date: params[:date]
    end

    def show # Displays professors change data for given professor
        @changeA = Change.where(shift: 'A', date: params[:date]).first
        @changeB = Change.where(shift: 'B', date: params[:date]).first

        if !@changeA
            @changeA = Change.create(shift: 'A', date: params[:date], data: '', data2: '')
        end

        if !@changeB
            @changeB = Change.create(shift: 'B', date: params[:date], data: '', data2: '')
        end
        
        @published = (@changeA.published || @changeB.published)

        @date = Date.parse(params[:date])
        @name = params[:name]

        update_prof_changes(@date) #if $prof_changes.nil? || $prof_changes[@date].nil?
        @change = $prof_changes[@date][@name]
        @data2 = @changeA.data2.split(',')
        @data2 += @changeB.data2.split(',')

        if @changeA.starttime.nil? || @changeB.starttime.nil?
            @starttime = $starttime_arr
            @endtime = $endtime_arr
        else
            @starttime = @changeA.starttime.split(',') + @changeB.starttime.split(',')[4..8]
            @endtime = @changeA.endtime.split(',') + @changeB.endtime.split(',')[4..8]
        end
    end
end
