const elmServerless = require('@the-sett/serverless-elm-bridge');

const { Elm } = require('./API.elm');

module.exports.handler = elmServerless.httpApi({
  handler: Elm.Revenue.API
});
