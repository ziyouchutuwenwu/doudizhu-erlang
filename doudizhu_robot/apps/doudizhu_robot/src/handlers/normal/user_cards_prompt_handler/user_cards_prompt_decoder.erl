-module(user_cards_prompt_decoder).

-export([decode/1]).

%% {OptionalCards}
decode(InfoBin) ->
    InfoRec = json:from_binary(InfoBin),

    OptionalCards = json:get(<<"/cards">>, InfoRec),
    {OptionalCards}.