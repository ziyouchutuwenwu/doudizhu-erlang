-module(desk_prompt_user_jiao_di_zhu_encoder).

-export([encode/1]).

encode(CanJiaoDiZhuUserId) ->
    CanJiaoDiZhuUserIdBin = utf8_list:list_to_binary(CanJiaoDiZhuUserId),

    Response = #{
        <<"canJiaoDiZhuUserId">> => CanJiaoDiZhuUserIdBin
    },

    JsonBin = json:to_binary(Response),
    JsonBin.