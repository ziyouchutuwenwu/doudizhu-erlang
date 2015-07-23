-module(query_desk_fa_di_pai_notification).

-include_lib("doudizhu/src/const/socket_const.hrl").
-export([notify/1]).

notify(UserId) ->
    DeskId = user_helper:get_user_deskid(UserId),
    DiPaiCards = desk_helper:get_desk_di_pai_cards(DeskId),

    JsonBin = query_desk_fa_di_pai_encoder:encode(DiPaiCards),
    UserPid = user_map:get_pid_by_userid(UserId),
    tcp_send:send_data(UserPid, ?CMD_QUERY_DESK_FA_DI_PAI, JsonBin).