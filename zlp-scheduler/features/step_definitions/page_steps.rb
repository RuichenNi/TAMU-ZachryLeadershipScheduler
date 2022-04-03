Then(/^I should see the (.+) page$/) do |page_name|
  if page_name == 'closed'
    expect(current_path).to eq "/student/closed"
  elsif page_name == 'terms'
    expect(current_path).to eq "/student/view_terms"
  elsif page_name == 'new term'
    expect(current_path).to eq "/admin/new_term"
  elsif page_name == 'admin terms'
    expect(current_path).to eq "/admin/view_term_admin"
  elsif page_name == 'open semester'
    expect(current_path).to eq "/admin/open_semester"
  elsif page_name == 'manage administrators'
    expect(current_path).to eq "/admin/manage_administrators"
  elsif page_name == 'login'
    expect(current_path).to eq "/"
  elsif page_name == 'view cohort semester'
    expect(current_path).to eq "/admin/view_cohort_semester"
  elsif page_name == 'manage cohorts'
    expect(current_path).to eq "/admin/manage_cohorts"
  else
    fail("not valid page name")
  end
end

Then (/^I should see the (.+) page for (.+)$/) do |page_name, cohort_name|
  term = Term.find_by(:active => true)
  active_cohort = Cohort.find_by(:name => cohort_name)
  if page_name == 'view result'
    expect(current_path).to eq "/admin/view_result/#{active_cohort.id}"
  elsif page_name == 'view cohort'
    expect(current_path).to eq "/admin/cohorts/#{active_cohort.id}"
  elsif page_name == 'view conflicts'
    timeslot = TimeSlot.where(:cohort_id => active_cohort.id,:was_conflict => true).order(cost: :asc,id: :asc).limit(1).first
    expect(current_path).to eq "/admin/view_conflicts/#{active_cohort.id}/#{timeslot.id}"
  else
    fail("not valid page name")
  end
end


When /^I am at (.+) page$/ do |page_name|
  if page_name == "view_terms"
    expect(current_path).to eq "/student/view_terms"
  end
end


When /I click the logo/ do
  click_link("Tamu zlp logo", match: :first)
end