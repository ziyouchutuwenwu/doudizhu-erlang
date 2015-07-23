-module(user_jiao_di_zhu_encoder).

-export([encode/1]).

encode(JiaoDiZhu) ->
    Response = #{
        <<"jiaoDiZhu">> => JiaoDiZhu
    },
    JsonBin = json:to_binary(Response),
    JsonBin.