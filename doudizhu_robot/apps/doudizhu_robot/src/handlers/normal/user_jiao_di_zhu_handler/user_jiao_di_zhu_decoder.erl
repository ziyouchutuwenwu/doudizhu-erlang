-module(user_jiao_di_zhu_decoder).

-export([decode/1]).

%返回{NextCanJiaoDiZhuUserId}
decode(InfoBin) ->
    InfoRec = json:from_binary(InfoBin),

    NextCanJiaoDiZhuUserId = binary_to_list(json:get(<<"/nextUser/id">>, InfoRec)),
    {NextCanJiaoDiZhuUserId}.