class ChangesInputController < ApplicationController
  def index
    @header = ["Razred", "-1.", "0.", "1.", "2.", "3.", "4.", "5.", "6.", "7.",]
    @classes_b = ["1.F", "1.G", "1.H", "1.M", "1.N", "2.F", "2.G", "2.H", "2.M", "2.N", "3.F", "3.G", "3.H", "3.M", "3.N", "4.F", "4.G", "4.H", "4.M", "4.N"]
    @classes_a = ["1.A", "1.B", "1.C", "1.D", "1.O", "2.A", "2.B", "2.C", "2.D", "2.O", "3.A", "3.B", "3.C", "3.D", "3.O", "4.A", "4.B", "4.C", "4.D", "4.O"]
    require 'pry-byebug'; binding.pry
  end

  def create_change
    render plain: params[:changes]
  end

  def test_fill
    puts 'test'
  end
end
