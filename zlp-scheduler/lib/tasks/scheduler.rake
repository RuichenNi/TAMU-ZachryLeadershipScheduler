namespace :scheduler do
   
   desc "runs the scheduler on a cohort"
   task run_scheduler: :environment do
        @cohort = Cohort.find_by term_id: 1
        @cohort.time_slots.delete_all
        print(@cohort.name)
        Scheduler_2.Generate_time_slots(@cohort)
    end
    
    desc "T"
    task find_course: :environment do
        class_hash = {:abbreviated_subject=>"ISEN", :course_number=>210, :section_number=>501, :term_id=>1}
        course = (Course.where(:abbreviated_subject => class_hash[:abbreviated_subject],:course_number => 210,:section_number => 501, :term_id => 1).first)
        if course.meetingtime_start.strftime("%H%M") >= Time.new(2020,12,9,8,0,0).strftime("%H%M")
            print("True \n")
        else
            print("False \n")
        end
    end
    
    desc "Shows all schedules"
    task show_schedules: :environment do
        cohort = Cohort.find_by term_id: 1
        cohort.users.each do |student|
            print(student.firstname+"\n")
            student.schedules.each do |schedule|
                print(schedule.name+"\n")
                # print(schedule.courses.where(:abbreviated_subject => "ISEN").first.course_name)
                schedule.courses.each do |course|
                    # Time.parse(course.meetingtime_start)
                    print(course.course_number)
                    print("    ")
                    print(course.meetingtime_start.in_time_zone(-5).to_s)
                    print("        ")
                    print(course.meetingtime_end.in_time_zone(-5).to_s)
                    print(course.meeting_days)
                    print("\n")
                end
            end
        end
    end
    
    task show_best_times: :environment do
        cohort = Cohort.find_by term_id: 1
        cohort.time_slots.limit(10).order('cost asc').each do |slot|
            print("\n")
            print(slot.time)
            print("   " + slot.day)
            print("   " + slot.cost.to_s)
            print("\n")
        end
    end
    
    task show_worst_times: :environment do
        cohort = Cohort.find_by term_id: 1
        cohort.time_slots.limit(10).order('cost desc').each do |slot|
            print("\n")
            print(slot.time)
            print("   " + slot.day)
            print("   " + slot.cost.to_s)
            print("\n")
        end
    end
    
    task show_conflict_times: :environment do
        cohort = Cohort.find_by term_id: 1
        print(cohort.time_slots.length)
        cohort.time_slots.each do |slot|
            print(slot.was_conflict)
            print("\n")
        end
        cohort.time_slots.where(:was_conflict => true).each do |slot|
            print(slot.time)
            print("\n")
            
            slot.conflicts.each do |conflict|
                print(conflict.user.firstname + "\t\t")
                print(conflict.schedule.name + "\t" + conflict.course.abbreviated_subject + "\t" + conflict.course.course_number.to_s + "\t" + conflict.course.section_number.to_s + "\n")
            end
        end
    end
        
end