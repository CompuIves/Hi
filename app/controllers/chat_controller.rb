class ChatController < ApplicationController
  require 'pubnub'

  before_action :get_all_messages, only: :index
  before_action :set_chat, only: [:create]
  skip_before_filter :verify_authenticity_token

  def index
    Rails.logger.debug "Received index message"
  end

  def create
    @message = Message.new(message: params[:message])

    @chat.messages << (@message)

    respond_to do |format|
      if @message.save

        pubnub.publish(
          channel: @chat.name,
          message: @message,
        ) { |data|  Rails.logger.debug data.response }
      end

      format.html { redirect_to action: 'index'}
    end
    Rails.logger.debug { "Save message" }
  end

  def show
    @chat = Chat.find_or_create_by(name: params[:name])
    @messages = @chat.messages.last(20)
  end

  private

  def set_chat
    @chat = Chat.find_by(name: params[:name])
  end

  def get_all_messages
    @messages = Message.last(20)
  end

  def pubnub
    @pubnub ||= Pubnub.new(
      publish_key: 'pub-c-d32a81dc-a239-47d8-962b-f2ff6009abc3',
      subscribe_key: 'sub-c-99c84654-14df-11e5-87d4-02ee2ddab7fe'
    )
  end
end
