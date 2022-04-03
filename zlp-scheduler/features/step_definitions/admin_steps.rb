When /^I fill in the add admin form$/ do
    @user = User.new(:firstname=>"John", :lastname=>"Doe", :email=>"blah@tamu.edu", :uin=>"1000")
    fill_in "user_firstname", with: "John"
    fill_in "user_lastname", with: "Doe"
    fill_in "user_email", with: "blah@tamu.edu"
    fill_in "user_uin", with: "1000"
    click_button("Create")
end

When(/^I fill out the new user form/) do
    find("input[name='user[uin]']").set('1000')
    find("input[name='user[email]']").set('blah@tamu.edu')
    find("input[name='user[password]']").set('1234')
    find("input[name='user[password_confirmation]']").set('1234')
    click_button('Sign up')
end

When(/^I login with the new user account/) do
    fill_in 'Email', with: 'blah@tamu.edu'
    # The default is Temp
    fill_in 'Password', with: 'Temp'
    click_button('Log in')
end

And('I fill in the new user email') do
    fill_in 'email', with: 'blah@tamu.edu'
    click_button('Reset Password')
end

When /^I edit the administrator/ do
    fill_in "user_lastname", with: "Smith"
    click_button("Update")
end

When /^I delete the new admin$/ do
    user = User.find_by(:email => "blah@tamu.edu")
    click_link("Delete", :href => "/admins/#{user.id}")
end

When /I click the label "(.*)"/ do |text|
   find('label', :text => text).click 
end

When /I want to delete specific student/ do
    user = User.find_by(:cohort_id => @cohort.id)
    click_link("Delete", :href => "/users/#{user.id}")
end

When /I want to delete specific cohort/ do
    click_link("Delete", :href => "/cohorts/#{@cohort.id}")
end

When /I edit "(.*)" in the page/ do |word| 
   dic = {"firstname"=>"user_firstname", "lastname"=>"user_lastname", "valid-email"=>"user_email","invalid-email"=>"user_email","existed-email"=>"user_email","Uin"=>"user_uin"}
   val = {"firstname"=>"Corgi_Dog", "lastname"=>"Corgi_M", "valid-email"=>"corgi_mocha@tamu.edu","invalid-email"=>"corgi_mocha@gmail.com","existed-email"=>@user.email,"Uin"=>"999999999"}
   fill_in dic[word], with: val[word]
   @route = current_path
end

When /I should remain in the same page/ do
    expect(current_path).to eq @route
end

When /I see the message "(.*)"/ do |text|
    expect(page).to have_content(text)
end

When /^I fill in the add student form$/ do
    fill_in "user_firstname", with: "John"
    fill_in "user_lastname", with: "Doe"
    fill_in "user_email", with: "blah@tamu.edu"
    fill_in "user_uin", with: "1000"
    click_button("Create")
end
