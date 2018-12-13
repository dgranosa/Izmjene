class ProfessorsController < ApplicationController
    before_action :parse_schedule

    def index
        if params[:list]
            render json: {
                professors: $teachers.values
            }
        end
    end

    def create
        @professor = $teacher_schedule[params[:name]]
    end

    def show
        render json: {
            name: param[:name],
            changes: $prof_changes[params[:name]]
        }
    end
end
