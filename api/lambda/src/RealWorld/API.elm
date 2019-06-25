port module RealWorld.API exposing (main)

import Array exposing (Array)
import Json.Decode as Decode exposing (Decoder)
import Json.Encode as Encode
import Model
import Serverless
import Serverless.Conn exposing (jsonBody, method, respond, route, textBody)
import Serverless.Conn.Request exposing (Method(..), Request)
import Url.Parser exposing ((</>), int, map, oneOf, s, top)


port requestPort : Serverless.RequestPort msg


port responsePort : Serverless.ResponsePort msg


type Route
    = Hello


type alias Conn =
    Serverless.Conn.Conn () () Route


type alias Msg =
    ()


main : Serverless.Program () () Route Msg
main =
    Serverless.httpApi
        { configDecoder = Serverless.noConfig
        , initialModel = ()
        , parseRoute =
            oneOf
                [ map Hello (s "hello")
                ]
                |> Url.Parser.parse
        , endpoint = endpoint
        , update = update
        , requestPort = requestPort
        , responsePort = responsePort
        }


endpoint : Conn -> ( Conn, Cmd Msg )
endpoint conn =
    respond ( 200, textBody "Hello Elm on AWS Lambda" ) conn


update : Msg -> Conn -> ( Conn, Cmd Msg )
update seed conn =
    ( conn, Cmd.none )
