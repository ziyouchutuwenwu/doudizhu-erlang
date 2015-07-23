-module(user_prompt_jiao_di_zhu_decoder).

-export([decode/1]).

%返回{CanJiaoDiZhuUserId}
decode(InfoBin) ->
    InfoRec = json:from_binary(InfoBin),

    CanJiaoDiZhuUserId = binary_to_list(json:get(<<"/canJiaoDiZhuUserId">>, InfoRec)),
    {CanJiaoDiZhuUserId}.