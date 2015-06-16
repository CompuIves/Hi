class ChatController < ApplicationController
  before_action :get_messages

  def index
  end

  def create
    @message = Message.new(message: params[:message])
    @messages << @message

    @message.save

    update
    Rails.logger.debug { "Save message" }
  end

  def update
    respond_to do |format|
      format.html { redirect_to action: 'index' }
      format.js
    end
  end


  private

  def get_messages
    Rails.logger.debug { "LOAD" }
    @messages = Message.last(20)
    Rails.logger.debug {@messages.last.message}
  end
end
