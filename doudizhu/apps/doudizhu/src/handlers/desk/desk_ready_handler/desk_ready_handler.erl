-module(desk_ready_handler).

-include_lib("doudizhu/src/const/socket_const.hrl").
-export([handle_request/3]).

handle_request(DeskId, _Cmd, _Params) ->
    desk_timer:start_timer(DeskId),
    handler_dispatcher:dispatch_desk_request(DeskId, ?CMD_DESK_FA_PAI, []),
    handler_dispatcher:dispatch_desk_request(DeskId, ?CMD_DESK_PROMPT_USER_JIAO_DI_ZHU, []).