require 'rails_helper'

describe ChatController do
  describe '#index' do
    it 'works' do
      get :index
      expect(response).to be_ok
    end
  end
end
