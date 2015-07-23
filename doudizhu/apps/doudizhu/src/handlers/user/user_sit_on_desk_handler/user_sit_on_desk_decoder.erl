-module(user_sit_on_desk_decoder).

-export([decode/1]).

%返回{RoomId}
decode(InfoBin) ->
    InfoRec = json:from_binary(InfoBin),

    RoomId = binary_to_list(json:get(<<"/roomId">>, InfoRec)),
    {RoomId}.