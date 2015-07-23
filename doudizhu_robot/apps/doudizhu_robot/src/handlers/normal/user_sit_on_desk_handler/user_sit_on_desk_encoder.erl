-module(user_sit_on_desk_encoder).

-export([encode/1]).

encode(RoomId) ->
    RoomIdBin = utf8_list:list_to_binary(RoomId),

    Response = #{<<"roomId">> => RoomIdBin},
    JsonBin = json:to_binary(Response),
    JsonBin.