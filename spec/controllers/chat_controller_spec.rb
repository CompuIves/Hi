require 'rails_helper'

describe ChatController do
  let(:message) { Fabricate :message, message: 'some_chat_message' }

  describe '#index' do
    it 'works' do
      expect(message).to be_persisted
      get :index
      expect(response).to be_ok
    end
  end
end
