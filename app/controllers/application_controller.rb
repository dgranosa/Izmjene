class ApplicationController < ActionController::Base
    def parse_schedule
        return $doc if !$doc.nil?

        $doc = File.open('schedule.xml') { |f| Nokogiri::XML(f) }

        $starttime_arr = []
        $endtime_arr = []

        $doc.children[0].children[3].children.each do |x|
            $starttime_arr.append(x['starttime']) if !x['starttime'].nil?
            $endtime_arr.append(x['endtime']) if !x['endtime'].nil?
        end

        $subjects = Hash.new
        $classes = Hash.new
        $teachers = Hash.new
        $classrooms = Hash.new

        $doc.children[0].children[7].children.each do |x|
            $subjects[x['id']] = x['short']
        end

        $doc.children[0].children[9].children.each do |x|
            $teachers[x['id']] = x['short']
        end

        $doc.children[0].children[11].children.each do |x|
            $classrooms[x['id']] = x['short']
        end

        $doc.children[0].children[15].children.each do |x|
            $classes[x['id']] = x['name']
        end

        $final = Hash.new

        $doc.children[0].children[31].children.each do |x|
            next if x['DayID'].nil? || x['DayID'] == ''
            $final[$classes[x['ClassID']]] ||= Hash.new
            $final[$classes[x['ClassID']]][x['DayID']] ||= Array.new(15)
            $final[$classes[x['ClassID']]][x['DayID']][x['Period'].to_i] = $subjects[x['SubjectGradeID']] if x['Period'].to_i > 0
        end
    end
end
