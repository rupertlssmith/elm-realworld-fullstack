port module RealWorld.Dynamo exposing (dynamoCreateSet, dynamoDelete, dynamoGet, dynamoPut, dynamoQuery, dynamoScan)


port dynamoPut : () -> Cmd msg


port dynamoGet : () -> Cmd msg


port dynamoScan : () -> Cmd msg


port dynamoQuery : () -> Cmd msg


port dynamoCreateSet : () -> Cmd msg


port dynamoDelete : () -> Cmd msg
