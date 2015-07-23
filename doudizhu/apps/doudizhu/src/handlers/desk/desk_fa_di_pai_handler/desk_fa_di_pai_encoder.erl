-module(desk_fa_di_pai_encoder).

-export([encode/1]).

encode(DiPaiCards) ->
    Response = #
    {
        <<"diPaiCards">> => DiPaiCards
    },

    JsonBin = json:to_binary(Response),
    JsonBin.