class ChatController < ApplicationController
  def index

  end

  def create
    @message = Message.new(message: params[:message])
    @message.save
    respond_to do |format|
      format.html { Rails.logger.debug "Hai".inspect }
    end
  end
end
