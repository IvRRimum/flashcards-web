module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_member

    def connect
      self.current_member = find_verified_member
      logger.add_tags 'ActionCable', current_member.id
    end

    protected

    def find_verified_member # this checks whether a member is authenticated with devise
      if verified_member = env['warden'].user(:member)
        verified_member
      else
        reject_unauthorized_connection
      end
    end
  end
end
