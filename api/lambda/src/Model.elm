module Model exposing (NewUser, newUserCodec)

import Codec
import Dict exposing (Dict)
import Json.Decode as Decode exposing (..)
import Json.Decode.Extra exposing (andMap, withDefault)
import Json.Encode as Encode exposing (..)
import Maybe.Extra
import Set exposing (Set)


type alias NewUser =
    { username : String
    , email : String
    , password : String
    }


newUserCodec =
    Codec.object NewUser
        |> Codec.field "username" .username Codec.string
        |> Codec.field "email" .email Codec.string
        |> Codec.field "password" .password Codec.string
        |> Codec.buildObject
