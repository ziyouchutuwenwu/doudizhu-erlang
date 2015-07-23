-module(user_cards_prompt_decoder).

-export([decode/1]).

%返回{UserId}
decode(InfoBin) ->
    InfoRec = json:from_binary(InfoBin),
    UserId = binary_to_list(json:get(<<"/id">>, InfoRec)),
    {UserId}.