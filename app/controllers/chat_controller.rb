class ChatController < ApplicationController
  require 'pubnub'

  before_action :get_messages
  skip_before_filter :verify_authenticity_token

  def index
    Rails.logger.debug "Received index message"
  end

  def create
    @message = Message.new(message: params[:message])

    respond_to do |format|
      if @message.save
        pubnub.publish(
          channel: 'messaging',
          message: @message,
        ) { |data|  Rails.logger.debug data.response }
      end

      format.html { redirect_to action: 'index'}
    end
    Rails.logger.debug { "Save message" }
  end



  private

  def get_messages
    @messages = Message.last(20)
    Rails.logger.debug {@messages.last.message}
  end

  def pubnub
    @pubnub ||= Pubnub.new(
      publish_key: 'pub-c-d32a81dc-a239-47d8-962b-f2ff6009abc3',
      subscribe_key: 'sub-c-99c84654-14df-11e5-87d4-02ee2ddab7fe'
    )
  end
end
