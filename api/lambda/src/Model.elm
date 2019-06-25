module Model exposing
    ( CertLimitMargin(..), certLimitMarginEncoder, certLimitMarginDecoder
    , OosLimit(..), oosLimitEncoder, oosLimitDecoder
    , MeterHealthSummary(..), meterHealthSummaryEncoder, meterHealthSummaryDecoder
    , MeterHealthSummaries(..), meterHealthSummariesEncoder, meterHealthSummariesDecoder
    , AccuracyReport(..), accuracyReportEncoder, accuracyReportDecoder
    , AccuracyHistory(..), accuracyHistoryEncoder, accuracyHistoryDecoder
    , TamperCcLimit(..), tamperCcLimitEncoder, tamperCcLimitDecoder
    , TamperCertLimit(..), tamperCertLimitEncoder, tamperCertLimitDecoder
    , StatisticsWindow(..), statisticsWindowEncoder, statisticsWindowDecoder
    , MeterRevenueSummary(..), meterRevenueSummaryEncoder, meterRevenueSummaryDecoder
    , MeterRevenueSummaries(..), meterRevenueSummariesEncoder, meterRevenueSummariesDecoder
    )

{-|

@docs CertLimitMargin, certLimitMarginEncoder, certLimitMarginDecoder
@docs OosLimit, oosLimitEncoder, oosLimitDecoder
@docs MeterHealthSummary, meterHealthSummaryEncoder, meterHealthSummaryDecoder
@docs MeterHealthSummaries, meterHealthSummariesEncoder, meterHealthSummariesDecoder
@docs AccuracyReport, accuracyReportEncoder, accuracyReportDecoder
@docs AccuracyHistory, accuracyHistoryEncoder, accuracyHistoryDecoder
@docs TamperCcLimit, tamperCcLimitEncoder, tamperCcLimitDecoder
@docs TamperCertLimit, tamperCertLimitEncoder, tamperCertLimitDecoder
@docs StatisticsWindow, statisticsWindowEncoder, statisticsWindowDecoder
@docs MeterRevenueSummary, meterRevenueSummaryEncoder, meterRevenueSummaryDecoder
@docs MeterRevenueSummaries, meterRevenueSummariesEncoder, meterRevenueSummariesDecoder

-}

import Dict exposing (Dict)
import Json.Decode as Decode exposing (..)
import Json.Decode.Extra exposing (andMap, withDefault)
import Json.Encode as Encode exposing (..)
import Maybe.Extra
import Set exposing (Set)


{-| Describes the CertLimitMargin component type.
-}
type CertLimitMargin
    = CertLimitMargin
        { certLimitMargin : Maybe Int
        }


{-| A JSON encoder for the CertLimitMargin type.
-}
certLimitMarginEncoder : CertLimitMargin -> Encode.Value
certLimitMarginEncoder (CertLimitMargin model) =
    [ Maybe.map (\certLimitMargin -> ( "cert-limit-margin", Encode.int certLimitMargin )) model.certLimitMargin
    ]
        |> Maybe.Extra.values
        |> Encode.object


{-| A JSON decoder for the CertLimitMargin type.
-}
certLimitMarginDecoder : Decoder CertLimitMargin
certLimitMarginDecoder =
    Decode.succeed
        (\certLimitMargin ->
            CertLimitMargin
                { certLimitMargin = certLimitMargin
                }
        )
        |> andMap (Decode.maybe (field "cert-limit-margin" Decode.int))


{-| Describes the OosLimit component type.
-}
type OosLimit
    = OosLimit
        { oosLimitPpm : Maybe Int
        }


{-| A JSON encoder for the OosLimit type.
-}
oosLimitEncoder : OosLimit -> Encode.Value
oosLimitEncoder (OosLimit model) =
    [ Maybe.map (\oosLimitPpm -> ( "oos-limit-ppm", Encode.int oosLimitPpm )) model.oosLimitPpm
    ]
        |> Maybe.Extra.values
        |> Encode.object


{-| A JSON decoder for the OosLimit type.
-}
oosLimitDecoder : Decoder OosLimit
oosLimitDecoder =
    Decode.succeed
        (\oosLimitPpm ->
            OosLimit
                { oosLimitPpm = oosLimitPpm
                }
        )
        |> andMap (Decode.maybe (field "oos-limit-ppm" Decode.int))


{-| Describes the MeterHealthSummary component type.
-}
type MeterHealthSummary
    = MeterHealthSummary
        { meterId : Maybe String
        , insufficientResolutionFlag : Maybe Bool
        , currentMeterAccuracyPpm : Maybe Int
        , oosFlag : Maybe Bool
        , daysToOos : Maybe Int
        , missingReportFlag : Maybe Bool
        , liveCurrentAbsentFlag : Maybe Bool
        , neutralCurrentAbsentFlag : Maybe Bool
        , voltageAbsentFlag : Maybe Bool
        }


{-| A JSON encoder for the MeterHealthSummary type.
-}
meterHealthSummaryEncoder : MeterHealthSummary -> Encode.Value
meterHealthSummaryEncoder (MeterHealthSummary model) =
    [ Maybe.map (\meterId -> ( "meter-id", Encode.string meterId )) model.meterId
    , Maybe.map (\insufficientResolutionFlag -> ( "insufficient-resolution-flag", Encode.bool insufficientResolutionFlag )) model.insufficientResolutionFlag
    , Maybe.map (\currentMeterAccuracyPpm -> ( "current-meter-accuracy-ppm", Encode.int currentMeterAccuracyPpm )) model.currentMeterAccuracyPpm
    , Maybe.map (\oosFlag -> ( "oos-flag", Encode.bool oosFlag )) model.oosFlag
    , Maybe.map (\daysToOos -> ( "days-to-oos", Encode.int daysToOos )) model.daysToOos
    , Maybe.map (\missingReportFlag -> ( "missing-report-flag", Encode.bool missingReportFlag )) model.missingReportFlag
    , Maybe.map (\liveCurrentAbsentFlag -> ( "live-current-absent-flag", Encode.bool liveCurrentAbsentFlag )) model.liveCurrentAbsentFlag
    , Maybe.map (\neutralCurrentAbsentFlag -> ( "neutral-current-absent-flag", Encode.bool neutralCurrentAbsentFlag )) model.neutralCurrentAbsentFlag
    , Maybe.map (\voltageAbsentFlag -> ( "voltage-absent-flag", Encode.bool voltageAbsentFlag )) model.voltageAbsentFlag
    ]
        |> Maybe.Extra.values
        |> Encode.object


{-| A JSON decoder for the MeterHealthSummary type.
-}
meterHealthSummaryDecoder : Decoder MeterHealthSummary
meterHealthSummaryDecoder =
    Decode.succeed
        (\meterId insufficientResolutionFlag currentMeterAccuracyPpm oosFlag daysToOos missingReportFlag liveCurrentAbsentFlag neutralCurrentAbsentFlag voltageAbsentFlag ->
            MeterHealthSummary
                { meterId = meterId
                , insufficientResolutionFlag = insufficientResolutionFlag
                , currentMeterAccuracyPpm = currentMeterAccuracyPpm
                , oosFlag = oosFlag
                , daysToOos = daysToOos
                , missingReportFlag = missingReportFlag
                , liveCurrentAbsentFlag = liveCurrentAbsentFlag
                , neutralCurrentAbsentFlag = neutralCurrentAbsentFlag
                , voltageAbsentFlag = voltageAbsentFlag
                }
        )
        |> andMap (Decode.maybe (field "meter-id" Decode.string))
        |> andMap (Decode.maybe (field "insufficient-resolution-flag" Decode.bool))
        |> andMap (Decode.maybe (field "current-meter-accuracy-ppm" Decode.int))
        |> andMap (Decode.maybe (field "oos-flag" Decode.bool))
        |> andMap (Decode.maybe (field "days-to-oos" Decode.int))
        |> andMap (Decode.maybe (field "missing-report-flag" Decode.bool))
        |> andMap (Decode.maybe (field "live-current-absent-flag" Decode.bool))
        |> andMap (Decode.maybe (field "neutral-current-absent-flag" Decode.bool))
        |> andMap (Decode.maybe (field "voltage-absent-flag" Decode.bool))


{-| Describes the MeterHealthSummaries component type.
-}
type MeterHealthSummaries
    = MeterHealthSummaries
        { meters : Maybe (List MeterHealthSummary)
        }


{-| A JSON encoder for the MeterHealthSummaries type.
-}
meterHealthSummariesEncoder : MeterHealthSummaries -> Encode.Value
meterHealthSummariesEncoder (MeterHealthSummaries model) =
    [ Maybe.map (\meters -> ( "meters", meters |> Encode.list meterHealthSummaryEncoder )) model.meters
    ]
        |> Maybe.Extra.values
        |> Encode.object


{-| A JSON decoder for the MeterHealthSummaries type.
-}
meterHealthSummariesDecoder : Decoder MeterHealthSummaries
meterHealthSummariesDecoder =
    Decode.succeed
        (\meters ->
            MeterHealthSummaries
                { meters = meters
                }
        )
        |> andMap (field "meters" (Decode.maybe (Decode.list (Decode.lazy (\_ -> meterHealthSummaryDecoder)))) |> withDefault Nothing)


{-| Describes the AccuracyReport component type.
-}
type AccuracyReport
    = AccuracyReport
        { timestamp : Maybe String
        , meterAccuracyPpm : Maybe Int
        }


{-| A JSON encoder for the AccuracyReport type.
-}
accuracyReportEncoder : AccuracyReport -> Encode.Value
accuracyReportEncoder (AccuracyReport model) =
    [ Maybe.map (\timestamp -> ( "timestamp", Encode.string timestamp )) model.timestamp
    , Maybe.map (\meterAccuracyPpm -> ( "meter-accuracy-ppm", Encode.int meterAccuracyPpm )) model.meterAccuracyPpm
    ]
        |> Maybe.Extra.values
        |> Encode.object


{-| A JSON decoder for the AccuracyReport type.
-}
accuracyReportDecoder : Decoder AccuracyReport
accuracyReportDecoder =
    Decode.succeed
        (\timestamp meterAccuracyPpm ->
            AccuracyReport
                { timestamp = timestamp
                , meterAccuracyPpm = meterAccuracyPpm
                }
        )
        |> andMap (Decode.maybe (field "timestamp" Decode.string))
        |> andMap (Decode.maybe (field "meter-accuracy-ppm" Decode.int))


{-| Describes the AccuracyHistory component type.
-}
type AccuracyHistory
    = AccuracyHistory
        { accuracyHistory : Maybe (List AccuracyReport)
        }


{-| A JSON encoder for the AccuracyHistory type.
-}
accuracyHistoryEncoder : AccuracyHistory -> Encode.Value
accuracyHistoryEncoder (AccuracyHistory model) =
    [ Maybe.map (\accuracyHistory -> ( "accuracy-history", accuracyHistory |> Encode.list accuracyReportEncoder )) model.accuracyHistory
    ]
        |> Maybe.Extra.values
        |> Encode.object


{-| A JSON decoder for the AccuracyHistory type.
-}
accuracyHistoryDecoder : Decoder AccuracyHistory
accuracyHistoryDecoder =
    Decode.succeed
        (\accuracyHistory ->
            AccuracyHistory
                { accuracyHistory = accuracyHistory
                }
        )
        |> andMap (field "accuracy-history" (Decode.maybe (Decode.list (Decode.lazy (\_ -> accuracyReportDecoder)))) |> withDefault Nothing)


{-| Describes the TamperCcLimit component type.
-}
type TamperCcLimit
    = TamperCcLimit
        { tamperCcLimitPpm : Maybe Int
        }


{-| A JSON encoder for the TamperCcLimit type.
-}
tamperCcLimitEncoder : TamperCcLimit -> Encode.Value
tamperCcLimitEncoder (TamperCcLimit model) =
    [ Maybe.map (\tamperCcLimitPpm -> ( "tamper-cc-limit-ppm", Encode.int tamperCcLimitPpm )) model.tamperCcLimitPpm
    ]
        |> Maybe.Extra.values
        |> Encode.object


{-| A JSON decoder for the TamperCcLimit type.
-}
tamperCcLimitDecoder : Decoder TamperCcLimit
tamperCcLimitDecoder =
    Decode.succeed
        (\tamperCcLimitPpm ->
            TamperCcLimit
                { tamperCcLimitPpm = tamperCcLimitPpm
                }
        )
        |> andMap (Decode.maybe (field "tamper-cc-limit-ppm" Decode.int))


{-| Describes the TamperCertLimit component type.
-}
type TamperCertLimit
    = TamperCertLimit
        { tamperCertLimitPpm : Maybe Int
        }


{-| A JSON encoder for the TamperCertLimit type.
-}
tamperCertLimitEncoder : TamperCertLimit -> Encode.Value
tamperCertLimitEncoder (TamperCertLimit model) =
    [ Maybe.map (\tamperCertLimitPpm -> ( "tamper-cert-limit-ppm", Encode.int tamperCertLimitPpm )) model.tamperCertLimitPpm
    ]
        |> Maybe.Extra.values
        |> Encode.object


{-| A JSON decoder for the TamperCertLimit type.
-}
tamperCertLimitDecoder : Decoder TamperCertLimit
tamperCertLimitDecoder =
    Decode.succeed
        (\tamperCertLimitPpm ->
            TamperCertLimit
                { tamperCertLimitPpm = tamperCertLimitPpm
                }
        )
        |> andMap (Decode.maybe (field "tamper-cert-limit-ppm" Decode.int))


{-| Describes the StatisticsWindow component type.
-}
type StatisticsWindow
    = StatisticsWindow
        { statisticsWindow : Maybe Int
        }


{-| A JSON encoder for the StatisticsWindow type.
-}
statisticsWindowEncoder : StatisticsWindow -> Encode.Value
statisticsWindowEncoder (StatisticsWindow model) =
    [ Maybe.map (\statisticsWindow -> ( "statistics-window", Encode.int statisticsWindow )) model.statisticsWindow
    ]
        |> Maybe.Extra.values
        |> Encode.object


{-| A JSON decoder for the StatisticsWindow type.
-}
statisticsWindowDecoder : Decoder StatisticsWindow
statisticsWindowDecoder =
    Decode.succeed
        (\statisticsWindow ->
            StatisticsWindow
                { statisticsWindow = statisticsWindow
                }
        )
        |> andMap (Decode.maybe (field "statistics-window" Decode.int))


{-| Describes the MeterRevenueSummary component type.
-}
type MeterRevenueSummary
    = MeterRevenueSummary
        { meterId : Maybe String
        , tamperStartTimestamp : Maybe String
        , tamperEndTimestamp : Maybe String
        , totalDurationSeconds : Maybe Int
        , tamperTypes : Maybe (List String)
        , issues : Maybe (List String)
        , lastKnownAccuracyPpm : Maybe Int
        , lastKnownTimestamp : Maybe String
        , totalLossKwh : Maybe String
        , averageAccuracyPpm : Maybe Int
        }


{-| A JSON encoder for the MeterRevenueSummary type.
-}
meterRevenueSummaryEncoder : MeterRevenueSummary -> Encode.Value
meterRevenueSummaryEncoder (MeterRevenueSummary model) =
    [ Maybe.map (\meterId -> ( "meter-id", Encode.string meterId )) model.meterId
    , Maybe.map (\tamperStartTimestamp -> ( "tamper-start-timestamp", Encode.string tamperStartTimestamp )) model.tamperStartTimestamp
    , Maybe.map (\tamperEndTimestamp -> ( "tamper-end-timestamp", Encode.string tamperEndTimestamp )) model.tamperEndTimestamp
    , Maybe.map (\totalDurationSeconds -> ( "total-duration-seconds", Encode.int totalDurationSeconds )) model.totalDurationSeconds
    , Maybe.map (\tamperTypes -> ( "tamper-types", tamperTypes |> Encode.list Encode.string )) model.tamperTypes
    , Maybe.map (\issues -> ( "issues", issues |> Encode.list Encode.string )) model.issues
    , Maybe.map (\lastKnownAccuracyPpm -> ( "last-known-accuracy-ppm", Encode.int lastKnownAccuracyPpm )) model.lastKnownAccuracyPpm
    , Maybe.map (\lastKnownTimestamp -> ( "last-known-timestamp", Encode.string lastKnownTimestamp )) model.lastKnownTimestamp
    , Maybe.map (\totalLossKwh -> ( "total-loss-kwh", Encode.string totalLossKwh )) model.totalLossKwh
    , Maybe.map (\averageAccuracyPpm -> ( "average-accuracy-ppm", Encode.int averageAccuracyPpm )) model.averageAccuracyPpm
    ]
        |> Maybe.Extra.values
        |> Encode.object


{-| A JSON decoder for the MeterRevenueSummary type.
-}
meterRevenueSummaryDecoder : Decoder MeterRevenueSummary
meterRevenueSummaryDecoder =
    Decode.succeed
        (\meterId tamperStartTimestamp tamperEndTimestamp totalDurationSeconds tamperTypes issues lastKnownAccuracyPpm lastKnownTimestamp totalLossKwh averageAccuracyPpm ->
            MeterRevenueSummary
                { meterId = meterId
                , tamperStartTimestamp = tamperStartTimestamp
                , tamperEndTimestamp = tamperEndTimestamp
                , totalDurationSeconds = totalDurationSeconds
                , tamperTypes = tamperTypes
                , issues = issues
                , lastKnownAccuracyPpm = lastKnownAccuracyPpm
                , lastKnownTimestamp = lastKnownTimestamp
                , totalLossKwh = totalLossKwh
                , averageAccuracyPpm = averageAccuracyPpm
                }
        )
        |> andMap (Decode.maybe (field "meter-id" Decode.string))
        |> andMap (Decode.maybe (field "tamper-start-timestamp" Decode.string))
        |> andMap (Decode.maybe (field "tamper-end-timestamp" Decode.string))
        |> andMap (Decode.maybe (field "total-duration-seconds" Decode.int))
        |> andMap (field "tamper-types" (Decode.maybe (Decode.list (Decode.lazy (\_ -> Decode.string)))) |> withDefault Nothing)
        |> andMap (field "issues" (Decode.maybe (Decode.list (Decode.lazy (\_ -> Decode.string)))) |> withDefault Nothing)
        |> andMap (Decode.maybe (field "last-known-accuracy-ppm" Decode.int))
        |> andMap (Decode.maybe (field "last-known-timestamp" Decode.string))
        |> andMap (Decode.maybe (field "total-loss-kwh" Decode.string))
        |> andMap (Decode.maybe (field "average-accuracy-ppm" Decode.int))


{-| Describes the MeterRevenueSummaries component type.
-}
type MeterRevenueSummaries
    = MeterRevenueSummaries
        { meters : Maybe (List MeterRevenueSummary)
        }


{-| A JSON encoder for the MeterRevenueSummaries type.
-}
meterRevenueSummariesEncoder : MeterRevenueSummaries -> Encode.Value
meterRevenueSummariesEncoder (MeterRevenueSummaries model) =
    [ Maybe.map (\meters -> ( "meters", meters |> Encode.list meterRevenueSummaryEncoder )) model.meters
    ]
        |> Maybe.Extra.values
        |> Encode.object


{-| A JSON decoder for the MeterRevenueSummaries type.
-}
meterRevenueSummariesDecoder : Decoder MeterRevenueSummaries
meterRevenueSummariesDecoder =
    Decode.succeed
        (\meters ->
            MeterRevenueSummaries
                { meters = meters
                }
        )
        |> andMap (field "meters" (Decode.maybe (Decode.list (Decode.lazy (\_ -> meterRevenueSummaryDecoder)))) |> withDefault Nothing)
