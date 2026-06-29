module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = find_verified_user
    end

    private

    def find_verified_user
      session_key = Rails.application.config.session_options[:key]
      session_data = cookies.encrypted[session_key]
      
      if session_data && session_data["warden.user.user.key"]
        user_id = session_data["warden.user.user.key"][0][0]
        verified_user = User.find_by(id: user_id)
        
        return verified_user if verified_user
      end

      reject_unauthorized_connection
    end
  end
end