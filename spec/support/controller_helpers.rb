module ControllerHelpers
  def json_response
    JSON.parse(response.body)
  end

  def basic_auth(username: 'test', password: '')
    auth = ActionController::HttpAuthentication::Basic.encode_credentials(username, password)
    request.env["HTTP_AUTHORIZATION"] = auth
  end
end
