-module(desk_jiao_di_zhu_handler).

-include_lib("doudizhu/src/const/playing_status_const.hrl").
-export([handle_request/3]).

handle_request(DeskId, Cmd, Params) ->
    {RequestUserId, JiaoDiZhu} = Params,

    desk_helper:set_desk_playing_status(DeskId, ?STATUS_JIAO_DI_ZHU),
    desk_timer:restart_timer(DeskId),

    jiao_di_zhu_algorithm:do_desk_jiao_di_zhu(DeskId, Cmd, RequestUserId, JiaoDiZhu),
    ok.