require 'redis'

module BetterApi
  class << self
    def redis
      @redis ||= Redis.new(
        url: ENV.fetch('REDIS_URL', 'redis://localhost:6379/1'),
        timeout: 1
      )
    end

    def publish(channel, message)
      redis.publish(channel, message.to_json)
    rescue Redis::BaseError => e
      Rails.logger.error "Redis publish error: #{e.message}"
    end
  end
end

# Create a module for WebSocket broadcasting
module WebsocketBroadcaster
  def self.broadcast(event:, payload:, room: nil)
    message = {
      event: event,
      payload: payload,
      room: room
    }

    BetterApi.publish('better_live', message)
  end
end
