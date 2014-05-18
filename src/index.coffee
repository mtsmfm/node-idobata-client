HttpClient = require('scoped-http-client')

class IdobataClient
  constructor: (url, api_token) ->
    @client = HttpClient.create(url)
      .header('User-Agent',   'IdobataClient')
      .header('Content-Type', 'application/json')
      .header('X-API-Token',  api_token)

  postViaWebhook: (room_id, {format, source}) ->
    data = JSON.stringify({format, source})

    @createHook(room_id) (err, res, body) =>
      hook = JSON.parse(body).hook

      HttpClient.create(hook.endpoint)
        .header('User-Agent',   'IdobataClient')
        .header('Content-Type', 'application/json')
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
