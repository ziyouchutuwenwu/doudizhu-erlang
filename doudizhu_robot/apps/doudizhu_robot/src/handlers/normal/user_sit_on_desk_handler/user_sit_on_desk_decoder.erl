-module(user_sit_on_desk_decoder).

-export([decode/1]).

%返回{DeskId}
decode(InfoBin) ->
    InfoRec = json:from_binary(InfoBin),

    DeskId = binary_to_list(json:get(<<"/deskId">>, InfoRec)),
    {DeskId}.