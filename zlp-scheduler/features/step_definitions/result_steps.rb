  Given ('I login back as a student') do
      create_student("Test Cohort")
      fill_in "Email", :with => @user.email
      fill_in "Password", :with => @user.password
      click_button("Log in")  
  end
  
  Given ('The term is opened and cohort in it') do
    @term  = Term.find_by active: 1
    @term.opendate = Date.current.yesterday
    @term.closedate = Date.current.tomorrow
    @term.save;
    @cohort =  Cohort.find_by(:name => "Test Cohort")
    @cohort.term_id = @term.id
    @cohort.save()
  end
  
  Given ('The student has added his course to schedule') do
      create_student("Test Cohort")
      @cohort = Cohort.find_by(:name => "Test Cohort")
      @schedule = Schedule.new
      @schedule.update_attributes(:name => "test schedule")
      @subject = Subject.create!(subject_code: 'CHEN',subject_description:"Test", term_id: @term.id)
      @course = Course.create!(subject_id: @subject.id, abbreviated_subject: 'CHEN',course_number: 432, section_number: 904, term_id: @term.id, meetingtime_start: DateTime.new(2001,2,3,15,15,6,'-05:00'), meetingtime_end: DateTime.new(2001,2,3,18,5,6,'-05:00'), meeting_days: ['T']).save
      @thecourse = Course.where(:abbreviated_subject => 'CHEN', :course_number => 432, :section_number => 904, :term_id => @term.id)
      @schedule.courses.push(@thecourse.first)
      @schedule.save
      @user.schedules.push(@schedule)   
      @user.save
  end
  
  def create_student(cohort_Name)
      @cohort = Cohort.find_by(:name => cohort_Name)
      @user = FactoryBot.create(:user, :role=>"student", :cohort_id => @cohort.id)
  end