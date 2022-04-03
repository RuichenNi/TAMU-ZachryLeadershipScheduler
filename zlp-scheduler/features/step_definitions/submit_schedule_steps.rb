Given /The "(.*)" terms exist/ do |term|
    
    #@term = Term.create(term)
    @term = Term.create(:name=>term)
    @term.opendate = Date.current.yesterday
    @term.closedate = Date.current.tomorrow
    @term.active = true
end

Given(/^Registered student and Create term and courses$/) do
 
  Capybara.server = :webrick
  
  @testing_department = ["ABC","DEF","GHI","JKL","MNO","PQR","STU"]
 
  @cohort = FactoryBot.create(:cohort, :name=>"Apple", :term_id=>@term.id)
  @cohort.save()

  @user = FactoryBot.create(:user, :role=>"student", :cohort_id=>@cohort.id, :uin=>12345)
  @user.save()
  @student = @user
  
  @testing_department.each do |test_subject|
    @subject = FactoryBot.create(:subject, :subject_code=>test_subject, :subject_description=>"Test", :term_id=>@term.id)
    i = 0
    while i < 4 do
      @course = FactoryBot.create(:course, :abbreviated_subject=>test_subject, :term_id=>@term.id, :subject_id=>@subject.id)
      @course.save()
      i = i + 1
    end
    @subject.save()
  end
 
  @fake_schedule_name = []
end

Then /I should see (.*) schedule in the table/ do |row_num|
  #Default with 2 row table
  expect(page).to have_xpath(".//tr", count: row_num.to_i + 2)
  #print(page.all("#studentTermTable tr").count)
  
end

Then ('I click add schedule button') do
  click_link("Add Schedule")
end

Then ('I click save schedule button') do
  click_button("Save Schedule")
end

Then ('I click cancel button') do
  click_link("Cancel")
end

Then('I click edit schedule button') do
  click_link('Edit Schedule')
end

Then ('I click the added schedule') do
  click_link(@test_schedule_name)
end

def select_option_in_dropdown(target, rec)
  
  dropdown_list = page.driver.browser.find_element(:id, target)
  options = dropdown_list.find_elements(tag_name: 'option')
  #options.each { |option| print(option.text)}
  department_selected = options[rand(1...options.length)].text # Start from idx 1, avoid blank
  select(department_selected, from: target)
  rec.append(department_selected)
end  

def select_course_info(i, if_course_num, if_course_sec, mandatory)
  rec = []
  select_option_in_dropdown('dept_select_' + i, rec)
  select_option_in_dropdown('course_num_select_' + i, rec) if if_course_num
  select_option_in_dropdown('section_num_select_' + i, rec) if if_course_num and if_course_sec

  check 'mand_' + i if mandatory
  rec
end


Then('I fill in my courses') do
  @test_schedule_name = Faker::Name.last_name
  fill_in 'schedule[name]', with: @test_schedule_name
  @record = []
  i = 1
  while i <= 3
    madatory = [true, false].sample
    r = select_course_info(i.to_s, true, true, madatory)
    next if @record.include? r + [true] or @record.include? r + [false]

    r.append(madatory)
    @record.append(r)
    i += 1
  end
end

Then ("I fill in courses without select course number or section number randomly") do
  
  n = Faker::Name.last_name
  while @fake_schedule_name.include? n do
    n = Faker::Name.last_name
  end
  
  @test_schedule_name = n
  fill_in "Schedule Name:", :with => @test_schedule_name
  
  @record = []
  i = 1
  while i <= 4
    mandatory = [true, false].sample
    num_sel = [true, false].sample
    sec_sel = [true, false].sample
    r = select_course_info(i.to_s, num_sel, sec_sel, mandatory)
    next if r.length != 3 or (@record.include? r + [true] or @record.include? r + [false])

    r.append(mandatory)
    @record.append(r)
    i += 1
  end
end

Then ("I fill in my courses without filling schedule name") do
  @record = []
  i = 1
  while i <= 3 do
    mandatory = [true, false].sample
    @record.append(select_course_info(i.to_s, true, true, mandatory))
    i += 1
  end
end

Given('I should see added schedule') do
  if page.respond_to? :should
      page.should have_content(@test_schedule_name)
  else
      assert page.has_content?(@test_schedule_name)
  end
  
end

def check_record_on_page
  @record.each do |rec|
    rec[0..2].each do |info|
      if page.respond_to? :should
        Capybara.using_wait_time(3) do
          page.should have_content(info)
        end
      else
        assert page.has_content?(info)
      end
    end
  end
end

Then('I should see added course information') do
  check_record_on_page
  expect(page).to have_xpath('.//tr', count: @record.uniq.length + 1)
end

Then ("I should see Yes and No") do
  expect(page).to have_xpath(".//tr", count: 3)
  expect(page.body.match?("Yes")).to eq true
  expect(page.body.match?("No")).to eq true
end

Then('I should see added course information for edit') do
  # We show the sorted courses on the web page
  @record = @record.sort_by {|e| [e[0], e[1].length, e[1], e[2]]} unless @record.empty?
  (0..6).each do |i|
    if i < @record.size
      raise unless find("#dept_select_#{i + 1}").value.eql? (@testing_department.index(@record[i][0]) + 1).to_s

      expect(page).to have_select("course_num_select_#{i + 1}", selected: @record[i][1])
      expect(page).to have_select("section_num_select_#{i + 1}", selected: @record[i][2])
      if @record[i][3]
        expect(page.find("#mand_#{i + 1}")).to be_checked
      else
        expect(page.find("#mand_#{i + 1}")).not_to be_checked
      end
    else
      expect(page).to have_select("dept_select_#{i + 1}", selected: '')
      expect(page).to have_select("course_num_select_#{i + 1}", selected: '')
      expect(page).to have_select("section_num_select_#{i + 1}", selected: '')
      expect(page.find("#mand_#{i + 1}")).not_to be_checked
    end
  end
end

