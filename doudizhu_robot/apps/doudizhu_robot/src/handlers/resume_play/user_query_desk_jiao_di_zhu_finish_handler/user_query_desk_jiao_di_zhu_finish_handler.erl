-module(user_query_desk_jiao_di_zhu_finish_handler).

-export([handle_response/3]).

handle_response(Pid, Cmd, InfoBin) ->
    user_jiao_di_zhu_finish_handler:handle_response(Pid, Cmd, InfoBin).