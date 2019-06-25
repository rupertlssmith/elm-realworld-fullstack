module Health.AccuracyHistory exposing (AgingParameters, Datum, aging, agingParameters, monthlyTemp, randomCoefficient, report, response, tempCoefficient, toPpm)

import Array exposing (Array)
import Lazy.DateTime exposing (monthly)
import Lazy.Random
import Model exposing (AccuracyHistory(..), AccuracyReport(..))
import Random exposing (Seed, initialSeed)
import Seq exposing (Seq(..))
import Time.DateTime as DT exposing (DateTime)
import Time.Iso8601
import Tuple exposing (first, second)


monthlyTemp : Seq Float
monthlyTemp =
    Seq.fromList
        [ 8.3
        , 8.5
        , 11.1
        , 13.5
        , 17.1
        , 20.0
        , 22.6
        , 22.5
        , 19.3
        , 15.3
        , 11.2
        , 9.1
        ]


type alias AgingParameters =
    { a : Float
    , b : Float
    , c : Float
    , d : Float
    }


tempCoefficient =
    0.0001


randomCoefficient =
    0.001


agingParameters =
    { a = 0.0
    , b = -0.0001
    , c = -0.000001
    , d = -0.0000009
    }


aging : AgingParameters -> Int -> Float
aging p x =
    let
        xf =
            toFloat x
    in
    p.a
        + (p.b * xf)
        + (p.c * xf ^ 2)
        + (p.d * xf ^ 3)


type alias Datum =
    { timestamp : DateTime
    , temp : Float
    , random : Float
    , aging : Float
    }


toPpm : Float -> Int
toPpm percent =
    round (percent * 1000000)


report : Seed -> Int -> List AccuracyReport
report seed numReports =
    let
        zero =
            DT.zero

        data =
            map4 Datum
                (monthly <| DT.dateTime { zero | year = 2017 })
                (Seq.cycle monthlyTemp)
                (Lazy.Random.float seed -0.5 0.5)
                (Seq.map (aging agingParameters) Seq.numbers)
    in
    Seq.take numReports data
        |> Seq.map
            (\datum ->
                AccuracyReport
                    { timestamp = Just <| Time.Iso8601.fromDateTime datum.timestamp
                    , meterAccuracyPpm =
                        Just <|
                            toPpm
                                ((datum.random * randomCoefficient)
                                    + (datum.temp * tempCoefficient)
                                    + datum.aging
                                )
                    }
            )
        |> Seq.toList


response seed =
    AccuracyHistory { accuracyHistory = Just <| report seed 28 }


map4 : (a -> b -> c -> d -> e) -> Seq a -> Seq b -> Seq c -> Seq d -> Seq e
map4 f list1 list2 list3 list4 =
    case list1 of
        Nil ->
            Nil

        Cons first1 rest1 ->
            case list2 of
                Nil ->
                    Nil

                Cons first2 rest2 ->
                    case list3 of
                        Nil ->
                            Nil

                        Cons first3 rest3 ->
                            case list4 of
                                Nil ->
                                    Nil

                                Cons first4 rest4 ->
                                    Cons (f first1 first2 first3 first4) (\() -> map4 f (rest1 ()) (rest2 ()) (rest3 ()) (rest4 ()))
