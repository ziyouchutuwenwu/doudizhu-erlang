-module(desk_fa_di_pai_handler).

-include_lib("doudizhu/src/const/socket_const.hrl").
-include_lib("doudizhu/src/const/playing_status_const.hrl").
-export([handle_request/3]).

handle_request(DeskId, Cmd, _Params) ->
    desk_helper:set_desk_playing_status(DeskId, ?STATUS_FA_DI_PAI),

    DeskDiZhuUserId = desk_helper:get_desk_dizhu(DeskId),
    DiPaiCards = desk_helper:get_desk_di_pai_cards(DeskId),
    user_helper:add_cards_to_user_hand(DeskDiZhuUserId, DiPaiCards),

    UserIdList = desk_helper:get_desk_all_users(DeskId),

    lists:foreach(
        fun(DeskUserId) ->
            JsonBin = desk_fa_di_pai_encoder:encode(DiPaiCards),
            UserPid = user_map:get_pid_by_userid(DeskUserId),
            tcp_send:send_data(UserPid, Cmd, JsonBin)
        end,
        UserIdList
    ).