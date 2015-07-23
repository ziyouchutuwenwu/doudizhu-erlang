-module(user_update_check_encoder).

-export([encode/2]).

encode(Url, OsName) ->
    UrlBin = utf8_list:list_to_binary(Url),
    OsNameBin = utf8_list:list_to_binary(OsName),

    Response = #{
        <<"url">> => UrlBin,
        <<"platform">> => OsNameBin
    },
    JsonBin = json:to_binary(Response),
    JsonBin.