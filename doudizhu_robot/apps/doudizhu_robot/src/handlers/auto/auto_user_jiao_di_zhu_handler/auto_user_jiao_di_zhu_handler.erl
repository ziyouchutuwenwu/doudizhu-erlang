-module(auto_user_jiao_di_zhu_handler).

-export([handle_response/3]).

handle_response(Pid, Cmd, InfoBin) ->
    user_jiao_di_zhu_handler:handle_response(Pid, Cmd, InfoBin).