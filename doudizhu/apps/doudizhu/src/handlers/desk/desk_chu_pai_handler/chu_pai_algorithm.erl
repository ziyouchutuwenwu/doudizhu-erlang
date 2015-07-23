-module(chu_pai_algorithm).

-include_lib("doudizhu/src/const/socket_const.hrl").
-export([do_desk_chu_pai/5]).

%% 出牌需要记录
%% 每个用户上一次出的牌，如果没有出，就是空
%% 最后一次出的最大的牌的用户id
%% 每个人当前手里的牌
%%
%% 算法
%% 如果	最后一次出的最大的牌的用户id为空或者是自己，就直接出牌，否则，需要出比上家的牌更大的
%%
%% 当前轮到谁是在桌子开始发牌以后的必须环节

do_desk_chu_pai(DeskId, Cmd, UserId, IsUserMustChuPai, Cards) ->

    SecondPreviousUserId = desk_helper:get_desk_second_previous_chu_pai_userid(DeskId),
    SecondPreviousUserChuPaiCards = user_helper:get_user_previous_chu_pai_cards(SecondPreviousUserId),
    IsSecondPreviousUserBuyao = card_helper:get_cards_buyao(SecondPreviousUserChuPaiCards),

    desk_helper:set_desk_second_previous_chu_pai_userid(DeskId, UserId),

    PreviousZuiDaChuPaiUserId = desk_helper:get_desk_previous_zui_da_chu_pai_userid(DeskId),
    CardsPromptType = card_helper:get_card_prompt_type(Cards),

    UserIdList = desk_helper:get_desk_all_users(DeskId),
    SortedUserIdList = sort_helper:get_userlist_by_play_index(UserIdList),
    NextUserId = sort_helper:loop_get_next_userid(UserId, SortedUserIdList),
    desk_helper:set_desk_current_userid(DeskId, NextUserId),

    NextUserMustChuPai = (
            case IsUserMustChuPai of
                true ->
                    0;
                _ ->
                    case length(Cards) of
                        0 ->
                            case string:equal(NextUserId, PreviousZuiDaChuPaiUserId) of
                                true ->
                                    1;
                                _ ->
                                    0
                            end;
                        _ ->
                            0
                    end
            end
    ),

    case IsUserMustChuPai of
        true ->
            user_helper:set_user_previous_chu_pai_cards(UserId, Cards),
            desk_helper:set_desk_previous_zui_da_chu_pai_userid(DeskId, UserId),
            user_helper:remove_cards_from_user_hand(UserId, Cards),
            IsUserBuyao = card_helper:get_cards_buyao(Cards),
            IsUserDani = card_helper:get_cards_dani(IsUserMustChuPai, Cards),

            lists:foreach(
                fun(DeskUserId) ->
                    JsonBin = desk_chu_pai_encoder:encode(
                        SecondPreviousUserId, SecondPreviousUserChuPaiCards, IsSecondPreviousUserBuyao,
                        UserId, Cards, CardsPromptType, IsUserBuyao, IsUserDani,
                        NextUserId, NextUserMustChuPai),
                    UserPid = user_map:get_pid_by_userid(DeskUserId),
                    tcp_send:send_data(UserPid, Cmd, JsonBin)
                end,
                UserIdList
            );
        _ ->
            case length(Cards) of
                0 ->
                    user_helper:set_user_previous_chu_pai_cards(UserId, []),
                    IsUserBuyao = card_helper:get_cards_buyao(Cards),
                    IsUserDani = card_helper:get_cards_dani(IsUserMustChuPai, Cards),

                    lists:foreach(
                        fun(DeskUserId) ->
                            JsonBin = desk_chu_pai_encoder:encode(
                                SecondPreviousUserId, SecondPreviousUserChuPaiCards, IsSecondPreviousUserBuyao,
                                UserId, Cards, CardsPromptType, IsUserBuyao, IsUserDani,
                                NextUserId, NextUserMustChuPai),
                            UserPid = user_map:get_pid_by_userid(DeskUserId),
                            tcp_send:send_data(UserPid, Cmd, JsonBin)
                        end,
                        UserIdList
                    );
                _ ->
                    user_helper:set_user_previous_chu_pai_cards(UserId, Cards),
                    desk_helper:set_desk_previous_zui_da_chu_pai_userid(DeskId, UserId),
                    user_helper:remove_cards_from_user_hand(UserId, Cards),

                    IsUserBuyao = card_helper:get_cards_buyao(Cards),
                    IsUserDani = card_helper:get_cards_dani(IsUserMustChuPai, Cards),

                    lists:foreach(
                        fun(DeskUserId) ->
                            JsonBin = desk_chu_pai_encoder:encode(
                                SecondPreviousUserId, SecondPreviousUserChuPaiCards, IsSecondPreviousUserBuyao,
                                UserId, Cards, CardsPromptType, IsUserBuyao, IsUserDani,
                                NextUserId, NextUserMustChuPai),
                            UserPid = user_map:get_pid_by_userid(DeskUserId),
                            tcp_send:send_data(UserPid, Cmd, JsonBin)
                        end,
                        UserIdList
                    )
            end
    end,

%%     判断牌局是否结束
    UserCardsLeft = user_helper:get_cards_in_user_hand(UserId),
    case length(UserCardsLeft) of
        0 ->
            handler_dispatcher:dispatch_desk_request(DeskId, ?CMD_DESK_DA_PAI_END, {UserId});
        _ ->
            ok
    end,
    ok.