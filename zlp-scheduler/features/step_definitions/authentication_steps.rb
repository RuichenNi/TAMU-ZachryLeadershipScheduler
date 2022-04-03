Before do
  # The current sessions_controller requires at least one active term
  @term = FactoryBot.create(:term, :active=>true)
  @term.save()
  @cohort = FactoryBot.create(:cohort, :name => "Cohort")
end

Given(/^I am (not )?a registered (student|admin)$/) do |is_not, role|
  if is_not == nil
    @user = FactoryBot.create(:user, :role=>role, :cohort_id => @cohort.id, :uin=>12345)
  else
    # Using build will not save record to db, so the user is not registered
    @user = FactoryBot.build(:user, :role=>role, :cohort_id => @cohort.id, :uin=>12345)
  end
end

Then (/^I should (not )?be logged in$/) do |is_not|
  if is_not == nil
    expect(page).to have_content("Logged in!")
  else
    page.should have_content(/Email or password is invalid|You should claim your account/)
    expect(current_path).to eq "/"
  end
end

Given("I visit the index page") do
  visit "/"
end

def fill_login_form
  fill_in "Email", :with => @user.email
  fill_in "Password", :with => @user.password
  click_button("Log in")
end

When("I fill in the login form") do
  fill_login_form
end

Given("I am logged in") do
  visit "/"
  fill_login_form
end

When("I click on the log out link") do
  click_link("Log out", match: :first)
end

Then("I should be redirected to the login page") do
  expect(current_path).to eq "/login"
end

Then(/^the current term is (not )?open$/) do |is_not|
  if is_not != nil
    @term.opendate = Date.current.tomorrow
    @term.closedate = Date.current.tomorrow
    @term.save
  end
end

When('I click on the forgot password link') do
  click_link('Forgot Password?')
end

And('I fill in the password reset form') do
  fill_in "user[uin]", :with => @user.uin
  fill_in "user[email]", :with => @user.email
  fill_in "user[password_confirmation]", :with =>@user.password
  fill_in "user[password]", :with => @user.password
  click_button("Reset Password")
  
end

When('I confirm the reset') do
  open_email(@user.email)
  visit_in_email("Reset password")
end

Then('I should see the reset instructions') do
  expect(page).to have_content("Reset Password")
  expect(page).to have_content("Retype password")
end

When (/^I wait (\d+) (\w+)$/) do |time_amount, time_units|
  Timecop.travel time_amount.send(time_units.to_sym)
end

Then('I should see the password reset error') do
  expect(page).to have_content("Email not registered or UIN not matched")
end

Then('I should see the password reset has expired') do
  expect(page).to have_content("Password reset has expired")
end

Given('the following user exist:') do |user_table|
  user_table.hashes.each do |u|
    @user = FactoryBot.create(:user, uin: u['uin'], email: u['email'],
                                     role: 'student', cohort_id: @cohort.id,
                                     activate: u['activate'] == 'true')
  end
end

When('I enters {string} in {string} field') do |string, string2|
  fill_in(format('user[%s]', string2), with: string)
end

Then /I should (not )?see information "(.*)"/ do |is_not, string|
  if is_not
    expect(page).to have_no_content(string)
  else
    expect(page).to have_content(string)
  end
end

Given /I am (not )?in the active cohort$/ do |is_not|
  if not is_not
    @cohort.term_id = @term.id
    @cohort.save
  end
end
