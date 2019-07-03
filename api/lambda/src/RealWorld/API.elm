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



-- Dummy data for mocking the API.


singleArticle =
    { article =
        { slug = "how-to-train-your-dragon"
        , title = "How to train your dragon"
        , description = "Ever wonder how?"
        , body = "It takes a Jacobian"
        , tagList = [ "dragons", "training" ]
        , createdAt = "2016-02-18T03:22:56.637Z"
        , updatedAt = "2016-02-18T03:48:35.824Z"
        , favorited = False
        , favoritesCount = 0
        , author =
            { username = "jake"
            , bio = "I work at statefarm"
            , image = "https=//i.stack.imgur.com/xHWG8.jpg"
            , following = False
            }
        }
    }


multipleArticles =
    { articles =
        [ { slug = "how-to-train-your-dragon"
          , title = "How to train your dragon"
          , description = "Ever wonder how?"
          , body = "It takes a Jacobian"
          , tagList = [ "dragons", "training" ]
          , createdAt = "2016-02-18T03:22:56.637Z"
          , updatedAt = "2016-02-18T03:48:35.824Z"
          , favorited = False
          , favoritesCount = 0
          , author =
                { username = "jake"
                , bio = "I work at statefarm"
                , image = "https=//i.stack.imgur.com/xHWG8.jpg"
                , following = False
                }
          }
        , { slug = "how-to-train-your-dragon-2"
          , title = "How to train your dragon 2"
          , description = "So toothless"
          , body = "It a dragon"
          , tagList = [ "dragons", "training" ]
          , createdAt = "2016-02-18T03:22:56.637Z"
          , updatedAt = "2016-02-18T03:48:35.824Z"
          , favorited = False
          , favoritesCount = 0
          , author =
                { username = "jake"
                , bio = "I work at statefarm"
                , image = "https=//i.stack.imgur.com/xHWG8.jpg"
                , following = False
                }
          }
        ]
    , articlesCount = 2
    }


userResponse =
    { user =
        { email = "jake@jake.jake"
        , token = "jwt.token.here"
        , username = "jake"
        , bio = "I work at statefarm"
        , image = ""
        }
    }



-- Servlerless program.


port requestPort : Serverless.RequestPort msg


port responsePort : Serverless.ResponsePort msg


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



-- Route and query parsing.


type Route
    = Users
    | UsersLogin
    | Articles ArticleQuery
    | ArticlesSlug String
    | ArticlesFeed PaginationQuery


type alias ArticleQuery =
    { tag : Maybe String
    , author : Maybe String
    , favorited : Maybe String
    , limit : Maybe Int
    , offset : Maybe Int
    }


type alias PaginationQuery =
    { limit : Maybe Int
    , offset : Maybe Int
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

        paginationQuery =
            Query.map2 PaginationQuery
                (Query.int "limit")
                (Query.int "offset")
    in
    oneOf
        [ map Users (s "users")
        , map Users (s "user")
        , map UsersLogin (s "users" </> s "login")
        , map Articles (s "articles" <?> articleQuery)
        , map ArticlesFeed (s "articles" </> s "feed" <?> paginationQuery)
        , map ArticlesSlug (s "articles" </> Url.Parser.string)
        ]
        |> Url.Parser.parse



-- Route processing.


router : Conn -> ( Conn, Cmd Msg )
router conn =
    case ( method conn, Debug.log "route" <| route conn ) of
        ( POST, Users ) ->
            newUserRoute conn

        ( GET, Users ) ->
            getCurrentUserRoute conn

        ( PUT, Users ) ->
            updateUserRoute conn

        ( POST, UsersLogin ) ->
            loginRoute conn

        ( GET, Articles query ) ->
            fetchArticlesRoute query conn

        ( POST, Articles _ ) ->
            newArticleRoute conn

        ( GET, ArticlesSlug slug ) ->
            fetchArticleRoute slug conn

        ( PUT, ArticlesSlug slug ) ->
            updateArticleRoute slug conn

        ( GET, ArticlesFeed query ) ->
            fetchFeedRoute query conn

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
                    userResponse
            in
            respond ( 201, response |> Codec.encodeToValue Model.userResponseCodec |> jsonBody ) conn

        Err errMsg ->
            respond ( 422, textBody errMsg ) conn


getCurrentUserRoute : Conn -> ( Conn, Cmd Msg )
getCurrentUserRoute conn =
    let
        response =
            userResponse
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
                    userResponse
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
                    userResponse
            in
            respond ( 200, response |> Codec.encodeToValue Model.userResponseCodec |> jsonBody ) conn

        Err errMsg ->
            respond ( 422, textBody errMsg ) conn


fetchArticlesRoute : ArticleQuery -> Conn -> ( Conn, Cmd Msg )
fetchArticlesRoute query conn =
    let
        response =
            multipleArticles
    in
    respond ( 200, response |> Codec.encodeToValue Model.multipleArticlesResponseCodec |> jsonBody ) conn


newArticleRoute : Conn -> ( Conn, Cmd Msg )
newArticleRoute conn =
    let
        decodeResult =
            bodyDecoder Model.newArticleRequestCodec conn
    in
    case decodeResult of
        Ok { article } ->
            let
                response =
                    singleArticle
            in
            respond ( 201, response |> Codec.encodeToValue Model.singleArticleResponseCodec |> jsonBody ) conn

        Err errMsg ->
            respond ( 422, textBody errMsg ) conn


fetchArticleRoute : String -> Conn -> ( Conn, Cmd Msg )
fetchArticleRoute slug conn =
    let
        response =
            singleArticle
    in
    respond ( 201, response |> Codec.encodeToValue Model.singleArticleResponseCodec |> jsonBody ) conn


updateArticleRoute : String -> Conn -> ( Conn, Cmd Msg )
updateArticleRoute slug conn =
    let
        decodeResult =
            bodyDecoder Model.updateArticleRequestCodec conn
    in
    case decodeResult of
        Ok { article } ->
            let
                response =
                    singleArticle
            in
            respond ( 201, response |> Codec.encodeToValue Model.singleArticleResponseCodec |> jsonBody ) conn

        Err errMsg ->
            respond ( 422, textBody errMsg ) conn


fetchFeedRoute : PaginationQuery -> Conn -> ( Conn, Cmd Msg )
fetchFeedRoute query conn =
    let
        response =
            multipleArticles
    in
    respond ( 200, response |> Codec.encodeToValue Model.multipleArticlesResponseCodec |> jsonBody ) conn



-- Side effects.


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
