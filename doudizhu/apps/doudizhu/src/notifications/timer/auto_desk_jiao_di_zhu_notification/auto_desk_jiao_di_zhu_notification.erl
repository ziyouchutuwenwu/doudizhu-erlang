-module(auto_desk_jiao_di_zhu_notification).

-include_lib("doudizhu/src/const/socket_const.hrl").
-export([notify/3]).

notify(DeskId, UserId, JiaoDiZhu) ->
    Params = {UserId, JiaoDiZhu},
    desk_jiao_di_zhu_handler:handle_request(DeskId, ?CMD_AUTO_DESK_JIAO_DI_ZHU, Params).