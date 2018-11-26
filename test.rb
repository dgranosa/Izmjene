#!/usr/bin/ruby

require 'nokogiri'

doc = File.open('gogi.xml') { |f| Nokogiri::XML(f) }
doc.children[0].child

starttime_arr = []
endtime_arr = []

doc.children[0].children[3].children.each do |x|
    starttime_arr.append(x['starttime']) if !x['starttime'].nil?
    endtime_arr.append(x['endtime']) if !x['endtime'].nil?
end

subjects = Hash.new
classes = Hash.new
teachers = Hash.new
classrooms = Hash.new

doc.children[0].children[7].children.each do |x|
    subjects[x['id']] = x['short']
end

doc.children[0].children[9].children.each do |x|
    teachers[x['id']] = x['short']
end

doc.children[0].children[11].children.each do |x|
    classrooms[x['id']] = x['short']
end

doc.children[0].children[15].children.each do |x|
    classes[x['id']] = x['name']
end

final = Hash.new

doc.children[0].children[31].children.each do |x|
    next if x['DayID'].nil? || x['DayID'] == ''
    puts classes[x['ClassID']].to_s + ' ' + x['DayID'].to_s + ' ' + subjects[x['SubjectGradeID']].to_s + ' ' + x['Period'].to_s + ' ' + x['LengthID'].to_s
    final[classes[x['ClassID']]] ||= Hash.new
    final[classes[x['ClassID']]][x['DayID']] ||= Array.new(15)
    final[classes[x['ClassID']]][x['DayID']][x['Period'].to_i] = subjects[x['SubjectGradeID']] if x['Period'].to_i > 0
end

# doc.children[0].children[27].children.each do |x|
#    next if x['ClassID'].nil?
#    puts subjects[x['SubjectGradeID']].to_s + ' ' + classes[x['ClassID']].to_s + ' ' + teachers[x['TeacherID']].to_s
# end
