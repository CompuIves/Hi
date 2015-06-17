class ChatController < ApplicationController
  before_action :get_messages
  skip_before_filter :verify_authenticity_token

  def index
    Rails.logger.debug "Received index message"
  end

  def create
    @message = Message.new(message: params[:message])
    @messages << @message

    respond_to do |format|
      if @message.save
        WebsocketRails[:messages].trigger 'new', @message

        format.js { render action: 'index' }
        format.html { redirect_to action: 'index' }
      end
    end
    Rails.logger.debug { "Save message" }
  end



  private

  def get_messages
    @messages = Message.last(20)
    Rails.logger.debug {@messages.last.message}
  end
end
