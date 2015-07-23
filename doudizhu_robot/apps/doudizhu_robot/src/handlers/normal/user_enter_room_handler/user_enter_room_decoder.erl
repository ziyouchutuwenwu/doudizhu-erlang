-module(user_enter_room_decoder).

-export([decode/1]).

%返回{RoomIds}
decode(InfoBin) ->
    InfoRec = json:from_binary(InfoBin),

    RoomIdBinList = json:get(<<"/roomIds">>, InfoRec),
    RoomIds = lists:map(
        fun(RoomIdBin) ->
            binary_to_list(RoomIdBin)
        end,
        RoomIdBinList
    ),
    {RoomIds}.