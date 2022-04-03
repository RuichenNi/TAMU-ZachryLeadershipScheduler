Given /I am logged in as the student/ do
    @user = @student
    
    visit "/"
    fill_login_form
end