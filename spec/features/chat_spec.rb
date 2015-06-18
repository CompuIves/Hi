require 'rails_helper'

feature 'chat' do
  scenario 'send a message', js: true do
    visit '/chat/chat_room'
    expect(page).to have_content('Chat Room')

    fill_in :message, with: 'My chat message!'
    find('.sendbar').native.send_keys(:return)
    wait_for do
      page.evaluate_script('$(".messagescreen > .message").length') > 0
    end
    expect(page).to have_content('My chat message!')

  end
end
