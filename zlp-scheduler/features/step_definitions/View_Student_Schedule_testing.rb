

Given(/^Registered$/) do
  @testing_department= ["ISEN","CHEN","NUEN","MATH","THAR","CSCE","ECEN"]

  @cohort = FactoryBot.create(:cohort, :name=>"Test Cohort", :term_id=>@term.id)
  @cohort.save()

  @user = FactoryBot.create(:user, :role=>"student", :cohort_id=>@cohort.id)
  @user.save()

  @subject = FactoryBot.create(:subject, :term_id=>@term.id)
  #When %{Creat_Schedule}
#end


#When(/^Creat_Schedule^/) do
  schedule_num = 2 #for each student
  course_num = 4 #for each student
  i = 0
  j = 0

  while i < schedule_num do

    @schedule = FactoryBot.create(:schedule, :name=>@user.lastname+i.to_s, :user_id=>@user.id)

    while j < course_num do
      @course = FactoryBot.create(:course, :abbreviated_subject=>@testing_department[rand(6)], :term_id=>@term.id, :subject_id=>@subject.id)
      @schedule.courses.push(@course)
      j = j + 1
    end
    @schedule.save
    @user.schedules.push(@schedule)
    i = i + 1
  end

end

Then ("I should see my schedules") do
  @user.schedules.each do |each_schedule|
    #print(each_schedule.name)
    if page.respond_to? :should
      page.should have_content(each_schedule.name)
    else
      assert page.has_content?(each_schedule.name)
    end
  end

  #if page.respond_to? :should
  #  page.should have_content("abcdefg")
  #else
  #  assert page.has_content?("abcdefg")
  #end
end


