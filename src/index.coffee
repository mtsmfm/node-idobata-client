Package = require('../package')
HttpClient = require('scoped-http-client')

class IdobataClient
  constructor: (url, api_token) ->
    @client = @createClient(url)
      .header('X-API-Token',  api_token)

  createClient: (url) ->
    HttpClient.create(url)
      .header('User-Agent',   "NodeIdobataClient/#{Package.version}")
      .header('Content-Type', 'application/json')

  postViaWebhook: (room_id, {format, source}) ->
    data = JSON.stringify({format, source})

    @createHook(room_id) (err, res, body) =>
      hook = JSON.parse(body).hook

      @createClient(hook.endpoint)
        .post(data) =>
          @destroyHook(hook.id) ->

  createHook: (room_id) ->
    data = JSON.stringify
      hook:
        provider_id: 7 # generic hook
        room_id: room_id

    @client.scope('api/hooks')
      .post(data)

  destroyHook: (id) ->
    @client.scope("api/hooks/#{id}")
      .del()

module.exports = IdobataClient
