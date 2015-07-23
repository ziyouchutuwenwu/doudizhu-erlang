-module(user_jiao_di_zhu_finish_decoder).

-export([decode/1]).

decode(InfoBin) ->
    InfoRec = json:from_binary(InfoBin),

    DeskDiZhuId = binary_to_list(json:get(<<"/diZhuId">>, InfoRec)),
    {DeskDiZhuId}.