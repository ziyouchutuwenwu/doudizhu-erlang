-module(user_enter_room_encoder).

-export([encode/1]).

encode(RoomList) ->
    RoomListBin = lists:map(
        fun(Room) ->
            list_to_bitstring(Room)
        end,
        RoomList
    ),

    Response = #{<<"roomIds">> => RoomListBin},
    JsonBin = json:to_binary(Response),
    JsonBin.