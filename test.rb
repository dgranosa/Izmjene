#!/usr/bin/ruby

require 'nokogiri'

doc = File.open('gogi.xml') { |f| Nokogiri::XML(f) }

starttime_arr = []
endtime_arr = []

doc.children[0].children[1].children.each do |x|
    starttime_arr.append(x['starttime']) if !x['starttime'].nil?
    endtime_arr.append(x['endtime']) if !x['endtime'].nil?
end

subjects = Hash.new
classes = Hash.new
teachers = Hash.new
classrooms = Hash.new
lessons = Hash.new # id: [classes, subject, num_of_periods, teachers, classroom]

doc.children[0].children[11].children.each do |x|
    subjects[x['id']] = x['short']
end

doc.children[0].children[13].children.each do |x|
    teachers[x['id']] = x['short']
end

doc.children[0].children[15].children.each do |x|
    classrooms[x['id']] = x['short']
end

doc.children[0].children[19].children.each do |x|
    classes[x['id']] = x['name']
end

teacherclasssubjects = Hash.new # {teacher: {class: [subjects] }}

doc.children[0].children[27].children.each do |x|
    next if x['subjectid'].nil?

    lessons[x['id']] = Array.new(5)
    lessons[x['id']][0] = x['classids'].split(',').map { |c| classes[c] }
    lessons[x['id']][1] = subjects[x['subjectid']]
    lessons[x['id']][2] = x['periodspercard'].to_i
    lessons[x['id']][3] = x['teacherids'].split(',').map { |t| teachers[t] }
    lessons[x['id']][4] = x['classroomids'].split(',').map { |c| classrooms[c] }

    x['teacherids'].split(',').each do |t|
        teacherclasssubjects[teachers[t]] ||= Hash.new

        x['classids'].split(',').each do |c|
            teacherclasssubjects[teachers[t]][classes[c]] ||= Array.new
            teacherclasssubjects[teachers[t]][classes[c]].push(subjects[x['subjectid']])
        end

    end
end

schedule = Hash.new # {class: week[day[period[subject]]]}
teacher_schedule = Hash.new # {teacher: week[day[period[class]]]}

doc.children[0].children[29].children.each do |x|
    next if x['weeks'].nil?

    puts lessons[x['lessonid']]
    puts x['weeks']
    puts x['days']
    puts x['period']
    puts ''
    x['classroomids'].split(',').each do |c|
        puts classrooms[c]
    end
    puts ''

    less = lessons[x['lessonid']]

    less[0].each do |c|
        schedule[c] ||= Array.new(2)
        schedule[c][x['weeks'].index('1')] ||= Array.new(5)
        schedule[c][x['weeks'].index('1')][x['days'].index('1')] ||= Array.new(15)
        schedule[c][x['weeks'].index('1')][x['days'].index('1')][x['period'].to_i] ||= ''
        schedule[c][x['weeks'].index('1')][x['days'].index('1')][x['period'].to_i] += '/' if schedule[c][x['weeks'].index('1')][x['days'].index('1')][x['period'].to_i] != ''
        schedule[c][x['weeks'].index('1')][x['days'].index('1')][x['period'].to_i] += less[1]
    end

    less[3].each do |t|
        teacher_schedule[t] ||= Array.new(2)
        teacher_schedule[t][x['weeks'].index('1')] ||= Array.new(5)
        teacher_schedule[t][x['weeks'].index('1')][x['days'].index('1')] ||= Array.new(15)
        teacher_schedule[t][x['weeks'].index('1')][x['days'].index('1')][x['period'].to_i] = less[0][0]
    end
end

puts schedule

#doc.children[0].children[31].children.each do |x|
#    next if x['DayID'].nil? || x['DayID'] == ''
#    puts classes[x['ClassID']].to_s + ' ' + x['DayID'].to_s + ' ' + subjects[x['SubjectGradeID']].to_s + ' ' + x['Period'].to_s + ' ' + x['LengthID'].to_s
#    final[classes[x['ClassID']]] ||= Hash.new
#    final[classes[x['ClassID']]][x['DayID']] ||= Array.new(15)
#    final[classes[x['ClassID']]][x['DayID']][x['Period'].to_i] = subjects[x['SubjectGradeID']] if x['Period'].to_i > 0
#end

# doc.children[0].children[27].children.each do |x|
#    next if x['ClassID'].nil?
#    puts subjects[x['SubjectGradeID']].to_s + ' ' + classes[x['ClassID']].to_s + ' ' + teachers[x['TeacherID']].to_s
# end
