-module(user_query_prompt_user_jiao_di_zhu_handler).

-export([handle_response/3]).

handle_response(Pid, Cmd, InfoBin) ->
    user_prompt_jiao_di_zhu_handler:handle_response(Pid, Cmd, InfoBin).