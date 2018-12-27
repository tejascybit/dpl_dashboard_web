namespace :importdata do
  desc "TODO"
  task get_new_access_code: :environment do
    u = 'https://dnlapps.dnlpune.com/DPLPlan/getAccessCode?userid=cybit&password=Cyb!t@P1'
    response = HTTParty.get(u)
    @data = JSON.parse(response)
    a = AccessCode.last
    a.update(access_code:@data['key'])
    puts "generated new token" + @data['key']
    return @data['key']
 end

  desc "TODO"
  task check_current_access_code: :environment do
    token = AccessCode.last.access_code
    u = 'https://dnlapps.dnlpune.com/DPLPlan/isValid?accessCode=' + token
    response = HTTParty.get(u)
    if response.to_i <= 1
      puts "token expried"
      return get_new_access_code
    else
      puts "token is active"
      return token
    end
  end

  desc "TODO"
  task get_inventory: :environment do
   token= check_current_access_code
   return token
  end

  desc "TODO"
  task get_production: :environment do

  end

  desc "TODO"
  task get_sales: :environment do

  end

  desc "TODO"
  task get_inbound: :environment do

  end

end
