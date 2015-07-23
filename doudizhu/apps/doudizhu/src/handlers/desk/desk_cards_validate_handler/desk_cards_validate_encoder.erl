-module(desk_cards_validate_encoder).

-export([encode/1]).

encode(IsCardValid) ->
    Response = #
    {
        <<"cardsValid">> => IsCardValid
    },

    JsonBin = json:to_binary(Response),
    JsonBin.