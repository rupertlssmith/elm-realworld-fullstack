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
import Url.Parser exposing ((</>), (<?>), int, map, oneOf, s, top)
import Url.Parser.Query as Query


port requestPort : Serverless.RequestPort msg


port responsePort : Serverless.ResponsePort msg


type Route
    = Users
    | UsersLogin
    | Articles ArticleQuery
    | ArticlesFeed


type alias ArticleQuery =
    { tag : Maybe String
    , author : Maybe String
    , favorited : Maybe String
    , limit : Maybe Int
    , offset : Maybe Int
    }


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
    let
        articleQuery =
            Query.map5 ArticleQuery
                (Query.string "tag")
                (Query.string "author")
                (Query.string "favorited")
                (Query.int "limit")
                (Query.int "offset")
    in
    oneOf
        [ map Users (s "users")
        , map Users (s "user")
        , map UsersLogin (s "users" </> s "login")
        , map Articles (s "articles" <?> articleQuery)
        , map ArticlesFeed (s "articles" </> s "feed")
        ]
        |> Url.Parser.parse


router : Conn -> ( Conn, Cmd Msg )
router conn =
    case ( method conn, route conn ) of
        ( POST, Users ) ->
            newUserRoute conn

        ( GET, Users ) ->
            getCurrentUserRoute conn

        ( PUT, Users ) ->
            updateUserRoute conn

        ( POST, UsersLogin ) ->
            loginRoute conn

        ( GET, Articles query ) ->
            fetchArticles query conn

        ( _, ArticlesFeed ) ->
            respond ( 422, textBody "Working on it" ) conn

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


getCurrentUserRoute : Conn -> ( Conn, Cmd Msg )
getCurrentUserRoute conn =
    let
        response =
            { user =
                { email = ""
                , token = ""
                , username = ""
                , bio = ""
                , image = ""
                }
            }
    in
    respond ( 200, response |> Codec.encodeToValue Model.userResponseCodec |> jsonBody ) conn


updateUserRoute : Conn -> ( Conn, Cmd Msg )
updateUserRoute conn =
    let
        decodeResult =
            bodyDecoder Model.updateUserRequestCodec conn
    in
    case decodeResult of
        Ok { user } ->
            let
                response =
                    { user =
                        { email = ""
                        , token = ""
                        , username = ""
                        , bio = ""
                        , image = ""
                        }
                    }
            in
            respond ( 200, response |> Codec.encodeToValue Model.userResponseCodec |> jsonBody ) conn

        Err errMsg ->
            respond ( 422, textBody errMsg ) conn


loginRoute : Conn -> ( Conn, Cmd Msg )
loginRoute conn =
    let
        decodeResult =
            bodyDecoder Model.loginUserRequestCodec conn
    in
    case decodeResult of
        Ok { user } ->
            let
                response =
                    { user =
                        { email = ""
                        , token = ""
                        , username = ""
                        , bio = ""
                        , image = ""
                        }
                    }
            in
            respond ( 200, response |> Codec.encodeToValue Model.userResponseCodec |> jsonBody ) conn

        Err errMsg ->
            respond ( 422, textBody errMsg ) conn


fetchArticles : ArticleQuery -> Conn -> ( Conn, Cmd Msg )
fetchArticles query conn =
    let
        response =
            { articles = []
            , articlesCount = 0
            }
    in
    respond ( 200, response |> Codec.encodeToValue Model.multipleArticlesResponseCodec |> jsonBody ) conn


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
