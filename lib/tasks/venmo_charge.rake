namespace :venmo do
  desc "Every dat, charge users on venmo for rounded-up change"
  task :daily_charge => :environment do
    User.find_each do |user|
      parsedResponse = user.parsePlaidForUser(user.access_token)
      if parsedResponse[0] > 0
        response = user.chargeUser(parsedResponse[0], parsedResponse[1])
      end
    end
  end
end
