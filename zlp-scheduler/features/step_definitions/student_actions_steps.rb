When /^(?:|I )press "([^"]*)"$/ do |button|
  click_button(button)
end

When /^(?:|I )follow "([^"]*)"$/ do |link|
  click_link(link)
end

When /^I confirm popup$/ do
  page.driver.browser.switch_to.alert.accept    
end

When /^I dismiss popup$/ do
  page.driver.browser.switch_to.alert.dismiss
end