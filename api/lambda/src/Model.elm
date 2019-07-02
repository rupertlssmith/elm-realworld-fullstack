module Model exposing
    ( Article
    , LoginUser
    , LoginUserRequest
    , MultipleArticlesResponse
    , NewUser
    , NewUserRequest
    , Profile
    , UpdateUser
    , UpdateUserRequest
    , User
    , UserResponse
    , articleCodec
    , loginUserCodec
    , loginUserRequestCodec
    , multipleArticlesResponseCodec
    , newUserCodec
    , newUserRequestCodec
    , profileCodec
    , updateUserCodec
    , updateUserRequestCodec
    , userCodec
    , userResponseCodec
    )

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


type alias LoginUserRequest =
    { user : LoginUser
    }


loginUserRequestCodec =
    Codec.object LoginUserRequest
        |> Codec.field "user" .user loginUserCodec
        |> Codec.buildObject


type alias LoginUser =
    { email : String
    , password : String
    }


loginUserCodec =
    Codec.object LoginUser
        |> Codec.field "email" .email Codec.string
        |> Codec.field "password" .password Codec.string
        |> Codec.buildObject


type alias UpdateUser =
    { email : Maybe String
    , token : Maybe String
    , username : Maybe String
    , bio : Maybe String
    , image : Maybe String
    }


updateUserCodec =
    Codec.object UpdateUser
        |> Codec.optionalField "email" .email Codec.string
        |> Codec.optionalField "token" .token Codec.string
        |> Codec.optionalField "username" .username Codec.string
        |> Codec.optionalField "bio" .bio Codec.string
        |> Codec.optionalField "image" .image Codec.string
        |> Codec.buildObject


type alias UpdateUserRequest =
    { user : UpdateUser }


updateUserRequestCodec =
    Codec.object UpdateUserRequest
        |> Codec.field "user" .user updateUserCodec
        |> Codec.buildObject


type alias MultipleArticlesResponse =
    { articles : List Article
    , articlesCount : Int
    }


multipleArticlesResponseCodec =
    Codec.object MultipleArticlesResponse
        |> Codec.field "articles" .articles (Codec.list articleCodec)
        |> Codec.field "articlesCount" .articlesCount Codec.int
        |> Codec.buildObject


type alias Article =
    { slug : String
    , title : String
    , description : String
    , body : String
    , tagList : List String
    , createdAt : String
    , updatedAt : String
    , favorited : Bool
    , favoritesCount : Int
    , author : Profile
    }


articleCodec =
    Codec.object Article
        |> Codec.field "slug" .slug Codec.string
        |> Codec.field "title" .title Codec.string
        |> Codec.field "description" .description Codec.string
        |> Codec.field "body" .body Codec.string
        |> Codec.field "tagList" .tagList (Codec.list Codec.string)
        |> Codec.field "createdAt" .createdAt Codec.string
        |> Codec.field "updatedAt" .updatedAt Codec.string
        |> Codec.field "favorited" .favorited Codec.bool
        |> Codec.field "favoritesCount" .favoritesCount Codec.int
        |> Codec.field "author" .author profileCodec
        |> Codec.buildObject


type alias Profile =
    { username : String
    , bio : String
    , image : String
    , following : Bool
    }


profileCodec =
    Codec.object Profile
        |> Codec.field "username" .username Codec.string
        |> Codec.field "bio" .bio Codec.string
        |> Codec.field "image" .image Codec.string
        |> Codec.field "following" .following Codec.bool
        |> Codec.buildObject
