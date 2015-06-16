class ChatController < ApplicationController
  def index
    @messages = Message.last(20).reverse
    @messages.each do |message|
      Rails.logger.debug message.message.inspect
    end
  end

  def create
    @message = Message.new(message: params[:message])
    @message.save
    respond_to do |format|
      format.html {  }
    end
  end
end
