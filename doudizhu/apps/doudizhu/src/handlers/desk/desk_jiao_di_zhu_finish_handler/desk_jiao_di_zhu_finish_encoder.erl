-module(desk_jiao_di_zhu_finish_encoder).

-export([encode/1]).

%% {"dizhuId":"12312312312323"}
encode(DeskDiZhuId) ->
    DeskDiZhuIdBin = utf8_list:list_to_binary(DeskDiZhuId),

    Response = #
    {
        <<"diZhuId">> => DeskDiZhuIdBin
    },

    JsonBin = json:to_binary(Response),
    JsonBin.