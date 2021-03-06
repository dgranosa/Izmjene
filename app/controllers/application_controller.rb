class ApplicationController < ActionController::Base
    include SessionsHelper
    before_action :parse_schedule

    def update_prof_changes(date) # Create/update professors changes for given date
        $prof_changes ||= Hash.new # prof_changes[date][name][sat] = class
				   # prof_changes is variable for 

        if $prof_changes.length > 1000 # If prof_changes is full, it's emptied
            $prof_changes.reject! { |k| k < Date.today - 2.day }
        end

        $prof_changes[date] ||= Hash.new # In rest of the fucntion prof_changes is created
        $teachers.values.each do |prof|
            $prof_changes[date][prof] = Array.new(15)
        end

        Change.where(date: date).each do |change|
            change.data.split(',').each_with_index do |subj, i|
                next if subj == ''
                klass = if change.shift == 'A'
                            Setting.classes_a.split(' ')
                        else
                            Setting.classes_b.split(' ')
                        end
                klass = klass[i / 9]
                subj = subj.titleize

                if (change.date.cweek + (change.shift == 'A' ? 0 : 1)) % 2 == Setting.shift_bit
			x = 0..8
			y = 1
		else
			x = 5..13
			y = 0
		end
                x = x.to_a[i % 9]

		old_subj = $schedule[klass][y][date.wday - 1][x + 1] if date.wday.between?(1, 5)
                if !old_subj.nil?
                    old_subj.split('|').each do |sub|
                        $classessubjectsteacher[klass][sub].each do |prof|
                            $prof_changes[date][prof][x] = 'X' if $prof_changes[date][prof][x].nil?
                        end
                    end
                end

                next if subj == 'X' || $classessubjectsteacher[klass][subj].nil?

                $classessubjectsteacher[klass][subj].each do |prof|
                    $prof_changes[date][prof][x] = klass + ' (' + subj + ')'
                end
            end
        end
    end

    def parse_schedule # This function parses xml file 
        return $doc unless $doc.nil?

        $doc = File.open('gogi.xml') { |f| Nokogiri::XML(f) }

        $starttime_arr = []
        $endtime_arr = []

        $doc.children[0].children[1].children.each do |x|
            $starttime_arr.append(x['starttime']) if !x['starttime'].nil?
            $endtime_arr.append(x['endtime']) if !x['endtime'].nil?
        end

        $subjects = Hash.new
        $classes = Hash.new
        $teachers = Hash.new
        $classrooms = Hash.new
        $subjectslong = Hash.new # short_name: long_name
        $lessons = Hash.new # id: [classes, subject, num_of_periods, teachers, classroom]


        $doc.children[0].children[11].children.each do |x|
			next if x['short'].nil?
			$subjects[x['id']] = x['short'].to_s
                                           .gsub('è', 'č')
                                           .gsub('È', 'Č')
                                           .gsub('æ', 'ć')
                                           .gsub('Æ', 'Ć')
                                           .gsub('ð', 'đ')
                                           .titleize

			$subjectslong[$subjects[x['id']]] = x['name'].to_s
                                                         .gsub('è', 'č')
                                                         .gsub('È', 'Č')
                                                         .gsub('æ', 'ć')
                                                         .gsub('Æ', 'Ć')
                                                         .gsub('ð', 'đ')
        end

        $doc.children[0].children[13].children.each do |x|
            $teachers[x['id']] = x['short'].to_s
                                           .gsub('è', 'č')
                                           .gsub('È', 'Č')
                                           .gsub('æ', 'ć')
                                           .gsub('Æ', 'Ć')
        end

        $doc.children[0].children[15].children.each do |x|
            $classrooms[x['id']] = x['short']
        end

        $doc.children[0].children[19].children.each do |x|
            $classes[x['id']] = x['name']
        end

        $teachersclassessubjects = Hash.new # {teacher: {class: [subjects] }}
        $classessubjectsteacher = Hash.new # {teacher: {class: [subjects] }}

        $doc.children[0].children[27].children.each do |x|
            next if x['subjectid'].nil?

            $lessons[x['id']] = Array.new(5)
            $lessons[x['id']][0] = x['classids'].split(',').map { |c| $classes[c] }
            $lessons[x['id']][1] = $subjects[x['subjectid']]
            $lessons[x['id']][2] = x['periodspercard'].to_i
            $lessons[x['id']][3] = x['teacherids'].split(',').map { |t| $teachers[t] }
            $lessons[x['id']][4] = x['classroomids'].split(',').map { |c| $classrooms[c] }

            x['teacherids'].split(',').each do |t|
                $teachersclassessubjects[$teachers[t]] ||= Hash.new
                x['classids'].split(',').each do |c|
                    $teachersclassessubjects[$teachers[t]][$classes[c]] ||= Array.new
                    $teachersclassessubjects[$teachers[t]][$classes[c]].push($subjects[x['subjectid']])
                end
            end

            x['classids'].split(',').each do |c|
                $classessubjectsteacher[$classes[c]] ||= Hash.new
                $classessubjectsteacher[$classes[c]][$subjects[x['subjectid']]] ||= Array.new
                $classessubjectsteacher[$classes[c]][$subjects[x['subjectid']]] += $lessons[x['id']][3]
                $classessubjectsteacher[$classes[c]][$subjects[x['subjectid']]] = $classessubjectsteacher[$classes[c]][$subjects[x['subjectid']]].uniq
            end
        end

        $schedule = Hash.new # {class: week[day[period[subject]]]}
        $teacher_schedule = Hash.new # {teacher: week[day[period[class]]]}

        $doc.children[0].children[29].children.each do |x|
            next if x['weeks'].nil?

            less = $lessons[x['lessonid']]

            less[0].each do |c|
                $schedule[c] ||= Array.new(2)
                $schedule[c][x['weeks'].index('1')] ||= Array.new(5)
                $schedule[c][x['weeks'].index('1')][x['days'].index('1')] ||= Array.new(15)
                $schedule[c][x['weeks'].index('1')][x['days'].index('1')][x['period'].to_i] ||= less[1]
                $schedule[c][x['weeks'].index('1')][x['days'].index('1')][x['period'].to_i] += '|' + less[1] if $schedule[c][x['weeks'].index('1')][x['days'].index('1')][x['period'].to_i] != less[1]
            end

            less[3].each do |t|
                $teacher_schedule[t] ||= Array.new(2)
                $teacher_schedule[t][x['weeks'].index('1')] ||= Array.new(5)
                $teacher_schedule[t][x['weeks'].index('1')][x['days'].index('1')] ||= Array.new(15)
                $teacher_schedule[t][x['weeks'].index('1')][x['days'].index('1')][x['period'].to_i] = less[0].join('|') + ' (' + less[1] + ')'
            end
        end
    end
end
