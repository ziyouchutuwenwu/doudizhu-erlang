-module(user_ready_to_play_decoder).

-export([decode/1]).

%返回{ReadyUserId}
decode(InfoBin) ->
    InfoRec = json:from_binary(InfoBin),
    ReadyUserId = binary_to_list(json:get(<<"/readyUserId">>, InfoRec)),

    {ReadyUserId}.