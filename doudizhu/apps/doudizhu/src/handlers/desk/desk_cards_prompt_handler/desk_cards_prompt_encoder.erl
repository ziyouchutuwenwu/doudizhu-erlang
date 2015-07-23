-module(desk_cards_prompt_encoder).

-export([encode/1]).

encode(Cards) ->
    Response = #{
        <<"cards">> => Cards
    },

    JsonBin = json:to_binary(Response),
    JsonBin.