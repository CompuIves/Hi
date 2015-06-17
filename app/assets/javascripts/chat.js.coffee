# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->
  scrollDown()
  dispatcher = new WebSocketRails('localhost:3000/websocket')
  channel = dispatcher.subscribe('messages')
  channel.bind 'new', (message) ->
    $('.messagescreen').append("<div class='message'><div class='text'>"+ message.message + "</div><div class='date'>" + message.created_at + "</div></div>")
    scrollDown()


scrollDown = ->
  console.log("hai")
  $('.messagescreen')[0].scrollTop = $('.messagescreen')[0].scrollHeight
