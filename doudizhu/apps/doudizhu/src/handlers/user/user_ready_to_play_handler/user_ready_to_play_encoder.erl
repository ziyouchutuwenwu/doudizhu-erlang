-module(user_ready_to_play_encoder).

-export([encode/1]).

encode(ReadyUserId) ->
    ReadyUserIdBin = utf8_list:list_to_binary(ReadyUserId),

    Response = #{
        <<"readyUserId">> => ReadyUserIdBin
    },

    JsonBin = json:to_binary(Response),
    JsonBin.