# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

def create_schedule(student,schedule_name, classes)
        @schedule = Schedule.new
        @schedule.update_attributes(:name => schedule_name)
        student.schedules.push(@schedule)
        classes.each do |class_hash|
                print(class_hash)
                @course = Course.where(:abbreviated_subject => class_hash[:abbreviated_subject], :course_number => class_hash[:course_number], :section_number => class_hash[:section_number], :term_id => class_hash[:term_id])
                #print(@course.first.full_subject)
                @schedule.courses.push(@course.first)
        end
        
        @schedule.save
        @user.schedules.push(@schedule)   
        @user.save
end
def create_scheduletocourse(student,schedule_name, timeslots)
        @schedule = Schedule.new
        @schedule.update_attributes(:name => schedule_name)
        student.schedules.push(@schedule)
        
        check_symb = "mandatory".to_sym

        startT_symb = "start_time".to_sym
        endT_symb = "end_time".to_sym
        rea_symb = "reason".to_sym
        day_symb = "weekday".to_sym
        timeslots.each do |timeslot|
                print(timeslot)
                @schedule_course = ScheduleToCourse.new
                @schedule_course.schedule_id=@schedule.id
                @schedule_course.mandatory=timeslot[check_symb]
                @schedule_course.start_time=timeslot[startT_symb]
                @schedule_course.end_time= timeslot[endT_symb]
                @schedule_course.reason=timeslot[rea_symb]
                @schedule_course.weekday=timeslot[day_symb]
                @schedule_course.save
        end
        @schedule.save
        @user.schedules.push(@schedule)   
        @user.save
end
#@terms = Term.ImportTermList!
#@term = Term.find_by active: 1

@term = Term.new
@term.name = "Test Term"
@term.id = 1
@term.opendate = DateTime.new(2001,2,3,4,5,6,'+03:00')
@term.closedate = DateTime.new(2025,2,3,4,5,6,'+03:00')
@term.active = 1
@term.save

@subject = Subject.create!(subject_code: "ISEN", subject_description:"Test", term_id: @term.id)

@course = Course.create!(subject_id: @subject.id, abbreviated_subject: "ISEN", course_number: 210, section_number: 501, term_id: @term.id, meetingtime_start: DateTime.new(2001,2,3,8,0,6,'-05:00'), meetingtime_end: DateTime.new(2001,2,3,9,15,6,'-05:00'), meeting_days: ['M','W'])
@course = Course.create!(subject_id: @subject.id, abbreviated_subject: "ISEN", course_number: 310, section_number: 501, term_id: @term.id, meetingtime_start: DateTime.new(2001,2,3,9,20,6,'-05:00'), meetingtime_end: DateTime.new(2001,2,3,10,10,6,'-05:00'), meeting_days: ['M','W','F']).save
@course = Course.create!(subject_id: @subject.id, abbreviated_subject: "ISEN", course_number: 330, section_number: 901, term_id: @term.id, meetingtime_start: DateTime.new(2001,2,3,13,30,6,'-05:00'), meetingtime_end: DateTime.new(2001,2,3,14,45,6,'-05:00'), meeting_days: ['T','TR']).save
@course = Course.create!(subject_id: @subject.id, abbreviated_subject: "ISEN", course_number: 320, section_number: 502, term_id: @term.id, meetingtime_start: DateTime.new(2001,2,3,14,20,6,'-05:00'), meetingtime_end: DateTime.new(2001,2,3,15,45,6,'-05:00'), meeting_days: ['M','W']).save
@course = Course.create!(subject_id: @subject.id, abbreviated_subject: "ISEN", course_number: 210, section_number: 502, term_id: @term.id, meetingtime_start: DateTime.new(2001,2,3,8,0,6,'-05:00'), meetingtime_end: DateTime.new(2001,2,3,9,15,6,'-05:00'), meeting_days: ['M','W']).save

@subject = Subject.create!(subject_code: "CHEN", subject_description:"CHEN Test", term_id: @term.id)

@course = Course.create!(subject_id: @subject.id, abbreviated_subject: "CHEN", course_number: 425, section_number: 501, term_id: @term.id, meetingtime_start: DateTime.new(2001,2,3,12,0,6,'-05:00'), meetingtime_end: DateTime.new(2001,2,3,12,50,6,'-05:00'), meeting_days: ['M','W','F']).save
@course = Course.create!(subject_id: @subject.id, abbreviated_subject: "CHEN", course_number: 432, section_number: 900, term_id: @term.id, meetingtime_start: DateTime.new(2001,2,3,14,45,6,'-05:00'), meetingtime_end: DateTime.new(2001,2,3,17,50,6,'-05:00'), meeting_days: ['M']).save
@course = Course.create!(subject_id: @subject.id, abbreviated_subject: "CHEN", course_number: 432, section_number: 904, term_id: @term.id, meetingtime_start: DateTime.new(2001,2,3,15,15,6,'-05:00'), meetingtime_end: DateTime.new(2001,2,3,18,15,6,'-05:00'), meeting_days: ['T']).save
@course = Course.create!(subject_id: @subject.id, abbreviated_subject: "CHEN", course_number: 432, section_number: 902, term_id: @term.id, meetingtime_start: DateTime.new(2001,2,3,17,35,6,'-05:00'), meetingtime_end: DateTime.new(2001,2,3,18,50,6,'-05:00'), meeting_days: ['M']).save
@course = Course.create!(subject_id: @subject.id, abbreviated_subject: "CHEN", course_number: 461, section_number: 500, term_id: @term.id, meetingtime_start: DateTime.new(2001,2,3,9,20,6,'-05:00'), meetingtime_end: DateTime.new(2001,2,3,10,10,6,'-05:00'), meeting_days: ['M','W','F']).save
@course = Course.create!(subject_id: @subject.id, abbreviated_subject: "CHEN", course_number: 461, section_number: 501, term_id: @term.id, meetingtime_start: DateTime.new(2001,2,3,13,35,6,'-05:00'), meetingtime_end: DateTime.new(2001,2,3,14,25,6,'-05:00'), meeting_days: ['M','W','F']).save
@course = Course.create!(subject_id: @subject.id, abbreviated_subject: "CHEN", course_number: 481, section_number: 501, term_id: @term.id, meetingtime_start: DateTime.new(2001,2,3,17,0,6,'-05:00'), meetingtime_end: DateTime.new(2001,2,3,18,15,6,'-05:00'), meeting_days: ['TR']).save
@course = Course.create!(subject_id: @subject.id, abbreviated_subject: "CHEN", course_number: 481, section_number: 502, term_id: @term.id, meetingtime_start: DateTime.new(2001,2,3,9,45,6,'-05:00'), meetingtime_end: DateTime.new(2001,2,3,11,0,6,'-05:00'), meeting_days: ['T']).save
@course = Course.create!(subject_id: @subject.id, abbreviated_subject: "CHEN", course_number: 481, section_number: 503, term_id: @term.id, meetingtime_start: DateTime.new(2001,2,3,9,45,6,'-05:00'), meetingtime_end: DateTime.new(2001,2,3,11,0,6,'-05:00'), meeting_days: ['TR']).save
@course = Course.create!(subject_id: @subject.id, abbreviated_subject: "CHEN", course_number: 482, section_number: 200, term_id: @term.id, meetingtime_start: DateTime.new(2001,2,3,11,30,6,'-05:00'), meetingtime_end: DateTime.new(2001,2,3,12,45,6,'-05:00'), meeting_days: ['W','F']).save
@course = Course.create!(subject_id: @subject.id, abbreviated_subject: "CHEN", course_number: 482, section_number: 500, term_id: @term.id, meetingtime_start: DateTime.new(2001,2,3,11,30,6,'-05:00'), meetingtime_end: DateTime.new(2001,2,3,12,45,6,'-05:00'), meeting_days: ['T','TR']).save

@subject = Subject.create!(subject_code: "MATH", subject_description:"MATH Test", term_id: @term.id)

@course = Course.create!(subject_id: @subject.id, abbreviated_subject: "MATH", course_number: 151, section_number: 507, term_id: @term.id, meetingtime_start: DateTime.new(2001,2,3,9,45,6,'-05:00'), meetingtime_end: DateTime.new(2001,2,3,11,0,6,'-05:00'), meeting_days: ['T','TR']).save
@course = Course.create!(subject_id: @subject.id, abbreviated_subject: "MATH", course_number: 152, section_number: 522, term_id: @term.id, meetingtime_start: DateTime.new(2001,2,3,17,0,6,'-05:00'), meetingtime_end: DateTime.new(2001,2,3,18,15,6,'-05:00'), meeting_days: ['T','TR']).save
@course = Course.create!(subject_id: @subject.id, abbreviated_subject: "MATH", course_number: 152, section_number: 523, term_id: @term.id, meetingtime_start: DateTime.new(2001,2,3,15,0,6,'-05:00'), meetingtime_end: DateTime.new(2001,2,3,16,30,6,'-05:00'), meeting_days: ['M','TR']).save

@subject = Subject.create!(subject_code: "NUEN", subject_description:"NUEN Test", term_id: @term.id)

@course = Course.create!(subject_id: @subject.id, abbreviated_subject: "NUEN", course_number: 301, section_number: 500, term_id: @term.id, meetingtime_start: DateTime.new(2001,2,3,9,45,6,'-05:00'), meetingtime_end: DateTime.new(2001,2,3,11,00,6,'-05:00'), meeting_days: ['T','TR']).save
@course = Course.create!(subject_id: @subject.id, abbreviated_subject: "NUEN", course_number: 301, section_number: 200, term_id: @term.id, meetingtime_start: DateTime.new(2001,2,3,9,45,6,'-05:00'), meetingtime_end: DateTime.new(2001,2,3,11,00,6,'-05:00'), meeting_days: ['M','TR']).save
@course = Course.create!(subject_id: @subject.id, abbreviated_subject: "NUEN", course_number: 309, section_number: 200, term_id: @term.id, meetingtime_start: DateTime.new(2001,2,3,8,10,6,'-05:00'), meetingtime_end: DateTime.new(2001,2,3,10,40,6,'-05:00'), meeting_days: ['W','F']).save
@course = Course.create!(subject_id: @subject.id, abbreviated_subject: "NUEN", course_number: 309, section_number: 500, term_id: @term.id, meetingtime_start: DateTime.new(2001,2,3,10,30,6,'-05:00'), meetingtime_end: DateTime.new(2001,2,3,11,15,6,'-05:00'), meeting_days: ['M','W','F']).save
@course = Course.create!(subject_id: @subject.id, abbreviated_subject: "NUEN", course_number: 309, section_number: 501, term_id: @term.id, meetingtime_start: DateTime.new(2001,2,3,9,20,6,'-05:00'), meetingtime_end: DateTime.new(2001,2,3,10,10,6,'-05:00'), meeting_days: ['M','W','F']).save

@subject = Subject.create!(subject_code: "THAR", subject_description:"THAR Test", term_id: @term.id)

@course = Course.create!(subject_id: @subject.id, abbreviated_subject: "THAR", course_number: 201, section_number: 500, term_id: @term.id, meetingtime_start: DateTime.new(2001,2,3,8,0,6,'-05:00'), meetingtime_end: DateTime.new(2001,2,3,9,15,6,'-05:00'), meeting_days: ['T','TR']).save


#Subject.ImportSubjectsForTerm! @term

#@term.import_specific_courses ["ISEN","CHEN","NUEN","MATH","THAR"]

@user = User.new
        @user.firstname = 'Lauren'
        @user.lastname = 'Haylock'
        @user.uin = 725000950
        @user.email = 'laurenrhaylock@tamu.edu'
        @user.role = 'admin'
        @user.password = "Temp"
        @user.save
        
@cohort = Cohort.new
        @cohort.name = "Test Cohort"
        @cohort.term_id = 1
        @cohort.save
        
@user = User.new
        @user.firstname = 'Kylie'
        @user.lastname = 'Brown'
        @user.uin = 424242
        @user.email = 'kyliebrown@tamu.edu'
        @user.role = 'student'
        @user.password = "Temp"
        @user.cohort_id = @cohort.id
        @user.save
       
kylie_timeslots = [
        {:mandatory => true, :start_time => "9:50", :end_time => "10:50", :weekday => "Wednesday", :reason => "CSCE-600-600"},
        {:mandatory => true, :start_time => "11:50", :end_time => "12:50", :weekday => "Wednesday", :reason => "CSCE-600-600"},
        {:mandatory => true, :start_time => "14:20", :end_time => "15:50", :weekday => "Wednesday", :reason => "CSCE-600-600"},
        {:mandatory => true, :start_time => "9:50", :end_time => "10:50", :weekday => "Friday", :reason => "CSCE-600-600"},
        
]
create_scheduletocourse(@user,"Test 1", kylie_timeslots)
# kylie_classes = [
#         {:abbreviated_subject => "ISEN", :course_number => 210, :section_number => 501, :term_id => @term.id},
#         {:abbreviated_subject => "ISEN", :course_number => 310, :section_number => 501, :term_id => @term.id},
#         {:abbreviated_subject => "ISEN", :course_number => 330, :section_number => 901, :term_id => @term.id},
#         {:abbreviated_subject => "ISEN", :course_number => 320, :section_number => 502, :term_id => @term.id},
# ]
# create_schedule(@user,"Test 1", kylie_classes)

# # kylie_classes = [
# #         {:abbreviated_subject => "CHEN", :course_number => 432, :section_number => 904, :term_id => @term.id},
# #         {:abbreviated_subject => "ISEN", :course_number => 310, :section_number => 501, :term_id => @term.id},
# #         {:abbreviated_subject => "MATH", :course_number => 151, :section_number => 523, :term_id => @term.id},
# #         {:abbreviated_subject => "ISEN", :course_number => 320, :section_number => 502, :term_id => @term.id},
# # ]
# kylie_classes = [
#         {:abbreviated_subject => "CHEN", :course_number => 432, :section_number => 902, :term_id => @term.id},
#         {:abbreviated_subject => "ISEN", :course_number => 310, :section_number => 501, :term_id => @term.id},
#         {:abbreviated_subject => "MATH", :course_number => 151, :section_number => 507, :term_id => @term.id},
#         {:abbreviated_subject => "ISEN", :course_number => 320, :section_number => 502, :term_id => @term.id},
#         {:abbreviated_subject => "ISEN", :course_number => 210, :section_number => 501, :term_id => @term.id},
# ]
# create_schedule(@user,"Test 2", kylie_classes)
        

        
@user = User.new
        @user.firstname = 'Gabi'
        @user.lastname = 'Hernandez'
        @user.uin = 852648
        @user.email = 'gabihernandez@tamu.edu'
        @user.role = 'student'
        @user.password = "Temp"
        @user.cohort_id = @cohort.id
        @user.save
        
# gabi_classes = [
#         {:abbreviated_subject => "CHEN", :course_number => 482, :section_number => 500, :term_id => @term.id},
#         {:abbreviated_subject => "CHEN", :course_number => 432, :section_number => 904, :term_id => @term.id},
#         {:abbreviated_subject => "CHEN", :course_number => 461, :section_number => 501, :term_id => @term.id},
#         {:abbreviated_subject => "CHEN", :course_number => 425, :section_number => 501, :term_id => @term.id},
#         {:abbreviated_subject => "CHEN", :course_number => 481, :section_number => 503, :term_id => @term.id},
#         {:abbreviated_subject => "ISEN", :course_number => 210, :section_number => 501, :term_id => @term.id}
# ]
# create_schedule(@user,"Test 1", gabi_classes)

# gabi_classes = [
#         {:abbreviated_subject => "CHEN", :course_number => 482, :section_number => 500, :term_id => @term.id},
#         {:abbreviated_subject => "CHEN", :course_number => 432, :section_number => 904, :term_id => @term.id},
#         {:abbreviated_subject => "CHEN", :course_number => 461, :section_number => 501, :term_id => @term.id},
#         {:abbreviated_subject => "CHEN", :course_number => 481, :section_number => 501, :term_id => @term.id},
#         {:abbreviated_subject => "MATH", :course_number => 152, :section_number => 522, :term_id => @term.id},
#         {:abbreviated_subject => "ISEN", :course_number => 210, :section_number => 501, :term_id => @term.id}
# ]
# create_schedule(@user,"Test 2", gabi_classes)
        
@user = User.new
        @user.firstname = 'Kiersten'
        @user.lastname = 'Potter'
        @user.uin = 799852
        @user.email = 'tonystark@tamu.edu'
        @user.role = 'student'
        @user.password = "Temp"
        @user.cohort_id = @cohort.id
        @user.save
        
# kiersten_classes = [
#         {:abbreviated_subject => "CHEN", :course_number => 461, :section_number => 500, :term_id => @term.id},
#         {:abbreviated_subject => "CHEN", :course_number => 425, :section_number => 501, :term_id => @term.id},
#         {:abbreviated_subject => "CHEN", :course_number => 432, :section_number => 900, :term_id => @term.id},
#         {:abbreviated_subject => "CHEN", :course_number => 481, :section_number => 502, :term_id => @term.id},
#         {:abbreviated_subject => "CHEN", :course_number => 482, :section_number => 500, :term_id => @term.id},
#         {:abbreviated_subject => "ISEN", :course_number => 210, :section_number => 501, :term_id => @term.id}
# ]
# create_schedule(@user,"Test 1", kiersten_classes)

# kiersten_classes = [
#         {:abbreviated_subject => "NUEN", :course_number => 309, :section_number => 501, :term_id => @term.id},
#         {:abbreviated_subject => "CHEN", :course_number => 425, :section_number => 501, :term_id => @term.id},
#         {:abbreviated_subject => "ISEN", :course_number => 320, :section_number => 502, :term_id => @term.id},
#         {:abbreviated_subject => "CHEN", :course_number => 482, :section_number => 500, :term_id => @term.id},
#         {:abbreviated_subject => "ISEN", :course_number => 210, :section_number => 501, :term_id => @term.id}
# ]
# create_schedule(@user,"Test 2", kiersten_classes)
        
@user = User.new
        @user.firstname = 'Valentina'
        @user.lastname = 'Alarcon'
        @user.uin = 458723
        @user.email = 'scoobydoo@tamu.edu'
        @user.role = 'student'
        @user.password = "Temp"
        @user.cohort_id = @cohort.id
        @user.save
        
# valentina_classes = [
#         {:abbreviated_subject => "NUEN", :course_number => 309, :section_number => 500, :term_id => @term.id},
#         {:abbreviated_subject => "MATH", :course_number => 152, :section_number => 523, :term_id => @term.id},
#         {:abbreviated_subject => "THAR", :course_number => 201, :section_number => 500, :term_id => @term.id},
#         {:abbreviated_subject => "NUEN", :course_number => 301, :section_number => 500, :term_id => @term.id},
#         {:abbreviated_subject => "ISEN", :course_number => 210, :section_number => 501, :term_id => @term.id}
# ]
# create_schedule(@user,"Test 1", valentina_classes)

# valentina_classes = [
#         {:abbreviated_subject => "NUEN", :course_number => 309, :section_number => 501, :term_id => @term.id},
#         {:abbreviated_subject => "MATH", :course_number => 152, :section_number => 522, :term_id => @term.id},
#         {:abbreviated_subject => "THAR", :course_number => 201, :section_number => 500, :term_id => @term.id},
#         {:abbreviated_subject => "NUEN", :course_number => 301, :section_number => 200, :term_id => @term.id},
#         {:abbreviated_subject => "CHEN", :course_number => 482, :section_number => 200, :term_id => @term.id},
#         {:abbreviated_subject => "ISEN", :course_number => 210, :section_number => 501, :term_id => @term.id}
# ]
# create_schedule(@user,"Test 2", valentina_classes)
        

#print(@terms)
#@terms.each do |t|
#        Term.create!(t)
#end 
#@term = @terms.all[0]
#@term.update_attributes(:active => 1)
