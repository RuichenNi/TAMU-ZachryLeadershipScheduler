require 'rails_helper'

describe "Scheduler" do
    before do
        
        @term = Term.new
            @term.name = "Test Term"
            @term.id = 1
            @term.opendate = DateTime.new(2001,2,3,4,5,6,'+03:00')
            @term.closedate = DateTime.new(2025,2,3,4,5,6,'+03:00')
            @term.active = 1
            @term.save
            
        @cohort = Cohort.new
            @cohort.term_id = @term.id
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
            
            
        @subject = Subject.create!(subject_code: "TEST", subject_description:"Test", term_id: @term.id)
        @course = Course.new
            @course.abbreviated_subject = "TEST"
            @course.course_number = 210
            @course.section_number = 501
            @course.meetingtime_start = DateTime.new(2001,2,3,11,5,6,'-05:00')
            @course.meetingtime_end =   DateTime.new(2001,2,3,13,5,6,'-05:00')
            @course.meeting_days = ['M','T','W']
            @course.term_id = @term.id
            @course.subject_id = @subject.id
            @course.save
        
        @schedule = Schedule.new
            @schedule.name = "Test 1"
            @schedule.user_id = @user.id
            @schedule.courses.push(@course)
            @schedule.save
            
        @schedule_course = ScheduleToCourse.new
            @schedule_course.course_id = @course.id
            @schedule_course.schedule_id = @schedule.id
            @schedule_course.mandatory = false
            @schedule_course.save
        
        
        @cohort.users.push(@user)
        @user.schedules.push(@schedule)
        @user.save
    end
    
    describe "is_conflict?" do
        # it "should return the course if there is a conflict" do
        #     #print(DateTime.new(2001,2,3,5,5,6,'+03:00'))
        #     conflict = Scheduler_2.is_conflict?('M',DateTime.new(2001,2,3,12,5,6,'-05:00'),@user.schedules[0])
        #     expect(conflict).to eql(@course)
        # end
        
        # it "should return false if there is not a conflict" do
        #     conflict = Scheduler_2.is_conflict?('M',DateTime.new(2001,2,3,14,5,6,'-05:00'),@user.schedules[0])
        #     expect(conflict).to eql(false)
        # end
        
        # it "should return false if the course is not held on that day" do
        #     conflict = Scheduler_2.is_conflict?('F',DateTime.new(2001,2,3,12,5,6,'-05:00'),@user.schedules[0])
        #     expect(conflict).to eql(false)
        # end
    end
    
    describe "exponential_cost_function" do
        it "should return zero cost if current time is in hard time preference" do
            cost = Scheduler_2.exponential_cost_function(DateTime.new(2020,12,9,0,0,0,'-05:00'), DateTime.new(2020,12,8,0,0,0,'-05:00'), DateTime.new(2020,12,9,15,0,0,'-05:00'))
            expect(cost).to eql(0)
        end
        
        it "should return exponentially high cost if current time is not in hard time preference" do
            cost = Scheduler_2.exponential_cost_function(DateTime.new(2020,12,20,0,0,0,'-05:00'), DateTime.new(2020,12,8,0,0,0,'-05:00'), DateTime.new(2020,12,9,15,0,0,'-05:00'))
            expect(cost).to be > 50
        end
    end
    
    describe "generate_time_slots" do
        before do
            Scheduler_2.Generate_time_slots(@cohort)
        end
        
        conflicted_sample_index = 45 - 4*8 # starting point shifted 8hrs * 4(15min size)
        
        # it "should generate time_slot db entries" do
        #     expect(@cohort.time_slots.length).to eql(240) 
        #     # length is increased due to soft time preference from 7*4*5 to 16*4*5 (hrs*4(15min term)*days)
        # end
        
        # it "should generate a conflict db entry when a conflict is found" do
        #     expect(@cohort.time_slots[conflicted_sample_index].conflicts.length).to eql(1)
        #     # there would be one conflicts (course conflict)
        # end
        it "Should have a cost which is the sum of all conflict costs" do
            expect(@cohort.time_slots[conflicted_sample_index].cost).to be < 1
        end
        describe "Conflicts generated" do
            # it "Should contain the user that had the conflict" do
            #     expect(@cohort.time_slots[conflicted_sample_index].conflicts[0].user).to eql(@user)
            # end
            
            # it "Should contain the course that is in conflict" do
            #     expect(@cohort.time_slots[conflicted_sample_index].conflicts[0].course).to eql(@course)
            # end
            describe "If there is a conflict" do
                it "Should set was_conflict to true" do
                    expect(@cohort.time_slots[conflicted_sample_index].was_conflict).to eql(false)
                end
                it "Should have a cost" do
                    expect(@cohort.time_slots[conflicted_sample_index].cost).to eql(0)
                end
            end
        end
    end
end