-module(user_chu_pai_decoder).

-export([decode/1]).

%返回{Cards}
decode(InfoBin) ->
    InfoRec = json:from_binary(InfoBin),
    Cards = json:get(<<"/cards">>, InfoRec),
    {Cards}.