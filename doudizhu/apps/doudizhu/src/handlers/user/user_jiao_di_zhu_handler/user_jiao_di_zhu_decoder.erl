-module(user_jiao_di_zhu_decoder).

-export([decode/1]).

%返回{JiaoDiZhu}
decode(InfoBin) ->
    InfoRec = json:from_binary(InfoBin),

    JiaoDiZhu = json:get(<<"/jiaoDiZhu">>, InfoRec),
    {JiaoDiZhu}.