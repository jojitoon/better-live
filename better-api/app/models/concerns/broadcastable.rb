module Broadcastable
  extend ActiveSupport::Concern

  included do
    after_create_commit :broadcast_create
    after_update_commit :broadcast_update
    after_destroy_commit :broadcast_destroy
  end

  private

  def broadcast_create
    broadcast_action('create')
  end

  def broadcast_update
    broadcast_action('update')
  end

  def broadcast_destroy
    broadcast_action('destroy')
  end

  def broadcast_action(action)
    WebsocketBroadcaster.broadcast(
      "#{self.class.name.underscore}_#{action}",
      self.as_json,
      self.class.name.pluralize.underscore
    )
  end
end
