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
        redirect_to :show, params: params
    end

    def show
        d = Date.parse(params[:date])
        update_prof_changes(d) if $prof_changes.nil? || $prof_changes[d].nil?
    end
end
