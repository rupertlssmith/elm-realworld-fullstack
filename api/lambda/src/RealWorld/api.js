const elmServerless = require('@the-sett/serverless-elm-bridge');
const aws = require('./aws-port.js');

const { Elm } = require('./API.elm');

module.exports.handler = elmServerless.httpApi({
  handler: Elm.RealWorld.API
});
