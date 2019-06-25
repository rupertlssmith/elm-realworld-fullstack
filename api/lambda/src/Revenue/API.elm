port module Revenue.API exposing (main)

import Array exposing (Array)
import Json.Decode as Decode exposing (Decoder)
import Json.Encode as Encode
import Model exposing (AccuracyHistory(..), AccuracyReport(..))
import Random
import Random.Array
import Serverless
import Serverless.Conn exposing (jsonBody, method, respond, route, textBody)
import Serverless.Conn.Request exposing (Method(..), Request)
import Url.Parser exposing ((</>), int, map, oneOf, s, top)


port requestPort : Serverless.RequestPort msg


port responsePort : Serverless.ResponsePort msg


type Route
    = TamperCcLimitRoute
    | TamperCertLimitRoute
    | StatisticsWindowRoute
    | MeterRevenueRoute
    | MeterRevenueByIdRoute String


type alias Conn =
    Serverless.Conn.Conn () () Route


main : Serverless.Program () () Route ()
main =
    Serverless.httpApi
        { configDecoder = Serverless.noConfig
        , initialModel = ()
        , parseRoute =
            Url.Parser.parse <|
                oneOf
                    [ map TamperCcLimitRoute (s "tamper-cc-limit")
                    , map TamperCertLimitRoute (s "tamper-cert-limit")
                    , map StatisticsWindowRoute (s "statistics-window")
                    , map MeterRevenueRoute (s "meter")
                    , map MeterRevenueByIdRoute (s "meter" </> Url.Parser.string)
                    ]
        , endpoint = endpoint
        , update = Serverless.noSideEffects
        , requestPort = requestPort
        , responsePort = responsePort
        }


endpoint : Conn -> ( Conn, Cmd () )
endpoint conn =
    case route conn of
        TamperCcLimitRoute ->
            tamperCcLimitRoute conn

        TamperCertLimitRoute ->
            tamperCertLimitRoute conn

        StatisticsWindowRoute ->
            statisticsWindowRoute conn

        MeterRevenueRoute ->
            meterRevenueRoute conn

        MeterRevenueByIdRoute meterId ->
            meterRevenueByIdRoute meterId conn


tamperCcLimitRoute conn =
    case method conn of
        POST ->
            respond ( 200, textBody "ok" ) conn

        _ ->
            respond ( 405, textBody "Method Not Allowed" ) conn


tamperCertLimitRoute conn =
    case method conn of
        POST ->
            respond ( 200, textBody "ok" ) conn

        _ ->
            respond ( 405, textBody "Method Not Allowed" ) conn


statisticsWindowRoute conn =
    case method conn of
        POST ->
            respond ( 200, textBody "ok" ) conn

        _ ->
            respond ( 405, textBody "Method Not Allowed" ) conn


meterRevenueRoute conn =
    case method conn of
        GET ->
            respond ( 200, jsonBody <| Model.meterRevenueSummariesEncoder meterRevenueResponse ) conn

        _ ->
            respond ( 405, textBody "Method Not Allowed" ) conn


meterRevenueByIdRoute meterId conn =
    case method conn of
        GET ->
            respond ( 200, jsonBody <| Model.meterRevenueSummaryEncoder <| meterRevenueByIdResponse meterId ) conn

        _ ->
            respond ( 405, textBody "Method Not Allowed" ) conn



-- Hard coded responses.


meterRevenueResponse : Model.MeterRevenueSummaries
meterRevenueResponse =
    Model.MeterRevenueSummaries
        { meters =
            Just
                [ meterRevenueByIdResponse "ABC123"
                , meterRevenueByIdResponse "ABB1343"
                , meterRevenueByIdResponse "ABG6273"
                ]
        }


meterRevenueByIdResponse : String -> Model.MeterRevenueSummary
meterRevenueByIdResponse meterId =
    Model.MeterRevenueSummary
        { meterId = Just meterId
        , averageAccuracyPpm = Just -1234
        , issues = Just []
        , lastKnownAccuracyPpm = Just -1201
        , lastKnownTimestamp = Just "2017-06-01 00:00:00"
        , tamperEndTimestamp = Just "2017-05-25 00:00:00"
        , tamperStartTimestamp = Just "2017-05-21 00:00:00"
        , tamperTypes = Just [ "magnetic" ]
        , totalDurationSeconds = Just 6023
        , totalLossKwh = Just "423.25"
        }
