-module(user_login_encoder).

-export([encode/3]).

encode(UserId, Gender, Error) ->
    UserIdBin = utf8_list:list_to_binary(UserId),
    GenderBin = utf8_list:list_to_binary(Gender),

    Response = #
    {
        <<"id">> => UserIdBin,
        <<"gender">> => GenderBin,
        <<"error">> => Error
    },
    JsonBin = json:to_binary(Response),
    JsonBin.