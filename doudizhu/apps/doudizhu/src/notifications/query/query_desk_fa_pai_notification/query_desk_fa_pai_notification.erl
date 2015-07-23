-module(query_desk_fa_pai_notification).

-include_lib("doudizhu/src/const/socket_const.hrl").
-export([notify/1]).

notify(UserId) ->
    DeskId = user_helper:get_user_deskid(UserId),
    UserIdList = desk_helper:get_desk_all_users(DeskId),

    DeskUserIdCards = user_helper:get_cards_in_user_hand(UserId),

    LeftUserId = sort_helper:get_left_user(UserId, UserIdList),
    LeftUserCardNumber = length(user_helper:get_cards_in_user_hand(LeftUserId)),
    RightUserId = sort_helper:get_right_user(UserId, UserIdList),
    RightUserCardNumber = length(user_helper:get_cards_in_user_hand(RightUserId)),

    JsonBin = query_desk_fa_pai_encoder:encode(DeskUserIdCards, LeftUserCardNumber, RightUserCardNumber),

    UserPid = user_map:get_pid_by_userid(UserId),
    tcp_send:send_data(UserPid, ?CMD_QUERY_DESK_FA_PAI, JsonBin).