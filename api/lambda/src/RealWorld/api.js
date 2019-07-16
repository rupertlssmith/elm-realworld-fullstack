const elmServerless = require('@the-sett/serverless-elm-bridge');
const aws = require('./aws-port.js');

const {
  Elm
} = require('./API.elm');

if (!process.env.AWS_REGION) {
  process.env.AWS_REGION = 'us-east-1';
}

if (!process.env.DYNAMODB_NAMESPACE) {
  process.env.DYNAMODB_NAMESPACE = 'dev';
}

function ping() {
  return {
    pong: new Date(),
    AWS_REGION: process.env.AWS_REGION,
    DYNAMODB_NAMESPACE: process.env.DYNAMODB_NAMESPACE,
  };
}

module.exports.handler = elmServerless.httpApi({
  handler: Elm.RealWorld.API
});
