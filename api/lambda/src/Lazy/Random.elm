module Lazy.Random exposing (bool, float, int)

import Random exposing (Generator, Seed)
import Random.Extra
import Seq exposing (Seq)
import Tuple exposing (first, second)


bool : Random.Seed -> Seq Bool
bool seed =
    generate Random.Extra.bool seed


int : Random.Seed -> Int -> Int -> Seq Int
int seed low high =
    generate (Random.int low high) seed


float : Random.Seed -> Float -> Float -> Seq Float
float seed low high =
    generate (Random.float low high) seed


generate : Generator a -> Seed -> Seq a
generate generator seed =
    let
        firstValueSeed =
            Random.step generator seed

        step ( value, stepSeed ) =
            Random.step generator stepSeed
    in
    Seq.iterate step firstValueSeed
        |> Seq.map first
