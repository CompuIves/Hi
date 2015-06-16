class ChatController < ApplicationController
  def index
    @messages = Message.last(20)
  end

  def create
    @message = Message.new(message: params[:message])
    @message.save
    respond_to do |format|
      format.html { redirect_to action: 'index' }

      format.js {@messages = Message.last(20)}
    end
  end
end
