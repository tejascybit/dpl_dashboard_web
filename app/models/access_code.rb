class AccessCode < ApplicationRecord
    
    def get_access_code
        token = self.access_code
        u = 'https://dnlapps.dnlpune.com/DPLPlan/isValid?accessCode=' + token
        response = HTTParty.get(u)
        if response.to_i <= 1
        puts "token expried"
        return self.generate_new_access_code
        else
        puts "token is active"
        return token
        end

    end
    def generate_new_access_code
        u = 'https://dnlapps.dnlpune.com/DPLPlan/getAccessCode?userid=cybit&password=Cyb!t@P1'
        response = HTTParty.get(u)
        @data = JSON.parse(response)
        self.access_code = @data['key']
        self.save!
        puts "generated new token" + @data['key']
        return @data['key']
    end
end
