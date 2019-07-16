port module Dynamo exposing (requestPort, responsePort)


port put : () -> Cmd msg


port get : () -> Cmd msg


port scan : () -> Cmd msg


port query : () -> Cmd msg


port createSet : () -> Cmd msg


port delete : () -> Cmd msg
