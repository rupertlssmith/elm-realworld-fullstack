module Model exposing (NewUser, NewUserRequest, User, UserResponse, newUserCodec, newUserRequestCodec, userCodec, userResponseCodec)

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


type alias NewUserRequest =
    { user : NewUser }


newUserRequestCodec =
    Codec.object NewUserRequest
        |> Codec.field "user" .user newUserCodec
        |> Codec.buildObject


type alias UserResponse =
    { user : User }


userResponseCodec =
    Codec.object UserResponse
        |> Codec.field "user" .user userCodec
        |> Codec.buildObject


type alias User =
    { email : String
    , token : String
    , username : String
    , bio : String
    , image : String
    }


userCodec =
    Codec.object User
        |> Codec.field "email" .email Codec.string
        |> Codec.field "token" .token Codec.string
        |> Codec.field "username" .username Codec.string
        |> Codec.field "bio" .bio Codec.string
        |> Codec.field "image" .image Codec.string
        |> Codec.buildObject
