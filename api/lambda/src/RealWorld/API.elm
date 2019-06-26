port module RealWorld.API exposing (main)

import Array exposing (Array)
import Codec
import Json.Decode as Decode exposing (Decoder)
import Json.Encode as Encode
import Model
import Serverless
import Serverless.Conn exposing (jsonBody, method, request, respond, route, textBody)
import Serverless.Conn.Request exposing (Method(..), Request, asJson, body)
import Url
import Url.Parser exposing ((</>), int, map, oneOf, s, top)


port requestPort : Serverless.RequestPort msg


port responsePort : Serverless.ResponsePort msg


type Route
    = NewUser


type alias Conn =
    Serverless.Conn.Conn () () Route


type alias Msg =
    ()


main : Serverless.Program () () Route Msg
main =
    Serverless.httpApi
        { configDecoder = Serverless.noConfig
        , initialModel = ()
        , parseRoute = routeParser
        , endpoint = router
        , update = update
        , requestPort = requestPort
        , responsePort = responsePort
        }


routeParser : Url.Url -> Maybe Route
routeParser =
    oneOf
        [ map NewUser (s "users") ]
        |> Url.Parser.parse


router : Conn -> ( Conn, Cmd Msg )
router conn =
    case ( method conn, route conn ) of
        ( POST, NewUser ) ->
            newUserRoute conn

        ( _, _ ) ->
            respond ( 405, textBody "Method not allowed" ) conn


newUserRoute : Conn -> ( Conn, Cmd Msg )
newUserRoute conn =
    let
        decodeResult =
            bodyDecoder Model.newUserRequestCodec conn
    in
    case decodeResult of
        Ok { user } ->
            let
                response =
                    { user =
                        { email = user.email
                        , token = ""
                        , username = user.username
                        , bio = ""
                        , image = ""
                        }
                    }
            in
            respond ( 201, response |> Codec.encodeToValue Model.userResponseCodec |> jsonBody ) conn

        Err errMsg ->
            respond ( 422, textBody errMsg ) conn


update : Msg -> Conn -> ( Conn, Cmd Msg )
update seed conn =
    ( conn, Cmd.none )



-- Helper functions


bodyDecoder : Codec.Codec a -> Conn -> Result String a
bodyDecoder codec conn =
    conn
        |> request
        |> body
        |> asJson
        |> Result.andThen
            (Codec.decodeValue codec
                >> Result.mapError Decode.errorToString
            )
