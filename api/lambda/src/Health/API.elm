port module Health.API exposing (main)

import Array exposing (Array)
import Health.AccuracyHistory
import Json.Decode as Decode exposing (Decoder)
import Json.Encode as Encode
import Model exposing (AccuracyHistory(..), AccuracyReport(..))
import Random
import Random.Array
import Serverless
import Serverless.Conn exposing (jsonBody, method, respond, route, textBody)
import Serverless.Conn.Request exposing (Method(..), Request)
import Time.DateTime as DT exposing (DateTime)
import Url.Parser exposing ((</>), int, map, oneOf, s, top)


port requestPort : Serverless.RequestPort msg


port responsePort : Serverless.ResponsePort msg


type Route
    = CertLimitMarginRoute
    | OosLimitRoute
    | MeterHealthRoute
    | MeterHealthByIdRoute String
    | AccuracyHistoryByIdRoute String


type alias Conn =
    Serverless.Conn.Conn () () Route


type alias Msg =
    Random.Seed


main : Serverless.Program () () Route Msg
main =
    Serverless.httpApi
        { configDecoder = Serverless.noConfig
        , initialModel = ()
        , parseRoute =
            Url.Parser.parse <|
                oneOf
                    [ map CertLimitMarginRoute (s "cert-limit-margin")
                    , map OosLimitRoute (s "oos-limit")
                    , map MeterHealthRoute (s "meter")
                    , map MeterHealthByIdRoute (s "meter" </> Url.Parser.string)
                    , map AccuracyHistoryByIdRoute (s "meter" </> Url.Parser.string </> s "accuracy-history")
                    ]
        , endpoint = endpoint
        , update = update
        , requestPort = requestPort
        , responsePort = responsePort
        }


endpoint : Conn -> ( Conn, Cmd Msg )
endpoint conn =
    ( conn, Random.generate (\seed -> Random.initialSeed seed) <| Random.int Random.minInt Random.maxInt )


update : Msg -> Conn -> ( Conn, Cmd Msg )
update seed conn =
    case route conn of
        CertLimitMarginRoute ->
            certLimitMarginRoute conn

        OosLimitRoute ->
            oosLimitRoute conn

        MeterHealthRoute ->
            meterHealthRoute conn

        MeterHealthByIdRoute meterId ->
            meterHealthByIdRoute meterId conn

        AccuracyHistoryByIdRoute meterId ->
            accuracyHistoryByIdRoute meterId seed conn


certLimitMarginRoute conn =
    case method conn of
        POST ->
            respond ( 200, textBody "ok" ) conn

        _ ->
            respond ( 405, textBody "Method Not Allowed" ) conn


oosLimitRoute conn =
    case method conn of
        POST ->
            respond ( 200, textBody "ok" ) conn

        _ ->
            respond ( 405, textBody "Method Not Allowed" ) conn


meterHealthRoute conn =
    case method conn of
        GET ->
            respond ( 200, jsonBody <| Model.meterHealthSummariesEncoder meterHealthResponse ) conn

        _ ->
            respond ( 405, textBody "Method Not Allowed" ) conn


meterHealthByIdRoute meterId conn =
    case method conn of
        GET ->
            respond ( 200, jsonBody <| Model.meterHealthSummaryEncoder <| meterHealthByIdResponse meterId ) conn

        _ ->
            respond ( 405, textBody "Method Not Allowed" ) conn


accuracyHistoryByIdRoute meterId seed conn =
    case method conn of
        GET ->
            respond ( 200, jsonBody <| Model.accuracyHistoryEncoder <| Health.AccuracyHistory.response seed ) conn

        _ ->
            respond ( 405, textBody "Method Not Allowed" ) conn



-- Hard coded responses.


meterHealthResponse : Model.MeterHealthSummaries
meterHealthResponse =
    Model.MeterHealthSummaries
        { meters =
            Just
                [ meterHealthByIdResponse "ABC123"
                , meterHealthByIdResponse "ABB1343"
                , meterHealthByIdResponse "ABG6273"
                ]
        }


meterHealthByIdResponse : String -> Model.MeterHealthSummary
meterHealthByIdResponse meterId =
    Model.MeterHealthSummary
        { meterId = Just meterId
        , currentMeterAccuracyPpm = Just 1234
        , daysToOos = Just 55
        , insufficientResolutionFlag = Just False
        , liveCurrentAbsentFlag = Just False
        , missingReportFlag = Just False
        , neutralCurrentAbsentFlag = Just False
        , oosFlag = Just False
        , voltageAbsentFlag = Just False
        }
