And(/^that "(.*?)"  has  posted shoes and "(.*?)" has dibbed them\.$/) do |arg1, arg2|
  pending # express the regexp above with the code you wish you had
end

When(/^the  "(.*?)" logs in and visits the inbox$/) do |arg1|
  pending # express the regexp above with the code you wish you had
end

Then(/^"(.*?)" should be visible\.$/) do |arg1|
  pending # express the regexp above with the code you wish you had
end

Then(/^"(.*?)" should be able to respond "(.*?)"$/) do |arg1, arg2|
  pending # express the regexp above with the code you wish you had
end

Then(/^"(.*?)" should see the "(.*?)" in his inbox$/) do |arg1, arg2|
  pending # express the regexp above with the code you wish you had
end

Given(/^that "(.*?)" and "(.*?)" are registered users$/) do |arg1, arg2|
  create(:user, username: arg1 )
  create(:user, username: arg2 )

end



