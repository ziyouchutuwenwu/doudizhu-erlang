-module(user_other_disconnect_encoder).

-export([encode/1]).

encode(DisconnectUserId) ->
    DisconnectUserIdBin = utf8_list:list_to_binary(DisconnectUserId),

    Response = #{
        <<"disconnectUserId">> => DisconnectUserIdBin
    },
    JsonBin = json:to_binary(Response),
    JsonBin.