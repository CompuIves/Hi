# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->
  pubnub = PUBNUB.init({
    publish_key   : 'pub-c-d32a81dc-a239-47d8-962b-f2ff6009abc3',
    subscribe_key : 'sub-c-99c84654-14df-11e5-87d4-02ee2ddab7fe'
  })
  scrollDown()
  p = pubnub.subscribe({
    channel: 'messaging',
    message: (message) ->
      $('.messagescreen').append("<div class='message'><div class='text'>"+ message.message + "</div><div class='date'>" + message.created_at + "</div></div>")
      scrollDown()
  })
  #$('.messagescreen').append("<div class='message'><div class='text'>"+ message.message + "</div><div class='date'>" + message.created_at + "</div></div>")



scrollDown = ->
  $('.messagescreen')[0].scrollTop = $('.messagescreen')[0].scrollHeight
