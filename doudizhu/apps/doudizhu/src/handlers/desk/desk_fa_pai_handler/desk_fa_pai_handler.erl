-module(desk_fa_pai_handler).

-include_lib("doudizhu/src/const/playing_status_const.hrl").
-export([handle_request/3]).

%% 需要redis保存的数据有
%% 每个用户的叫和不叫地主的次数；随机生成的顺序（从1开始）；当前桌子的地主id；上一次请求的用户id；用户上一次有没有叫地主
handle_request(DeskId, Cmd, _Params) ->
    desk_helper:set_desk_playing_status(DeskId, ?STATUS_FA_PAI),

    UserIdList = desk_helper:get_desk_all_users(DeskId),
    DeskCards = card_helper:wash_card(),

%%     临时给用户一个索引
    IndexList = lists:seq(1, length(UserIdList)),
    List = lists:zip(UserIdList, IndexList),
    lists:foreach(
        fun({UserId, Index}) ->
            UserCards = lists:sublist(DeskCards, 1 + 17 * (Index - 1), 17),
            user_helper:set_cards_in_user_hand(UserId, UserCards)
        end,
        List
    ),
    DiPaiCards = lists:sublist(DeskCards, 1 + 17 * 3, 3),
    desk_helper:set_desk_di_pai_cards(DeskId, DiPaiCards),

    lists:foreach(
        fun(DeskUserId) ->

            DeskUserIdCards = user_helper:get_cards_in_user_hand(DeskUserId),
            LeftUserId = sort_helper:get_left_user(DeskUserId, UserIdList),
            LeftUserCardNumber = length(user_helper:get_cards_in_user_hand(LeftUserId)),
            RightUserId = sort_helper:get_right_user(DeskUserId, UserIdList),
            RightUserCardNumber = length(user_helper:get_cards_in_user_hand(RightUserId)),

            JsonBin = desk_fa_pai_encoder:encode(DeskUserIdCards, LeftUserCardNumber, RightUserCardNumber),

            UserPid = user_map:get_pid_by_userid(DeskUserId),
            tcp_send:send_data(UserPid, Cmd, JsonBin)
        end,
        UserIdList
    ).