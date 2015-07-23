-module(query_desk_chu_pai_notification).

-include_lib("doudizhu/src/const/socket_const.hrl").
-export([notify/1]).

notify(UserId) ->
    DeskId = user_helper:get_user_deskid(UserId),
    CurrentUserId = desk_helper:get_desk_current_userid(DeskId),

    UserIdList = desk_helper:get_desk_all_users(DeskId),
    SortedUserIdList = sort_helper:get_userlist_by_play_index(UserIdList),

    PreviousZuiDaChuPaiUserId = desk_helper:get_desk_previous_zui_da_chu_pai_userid(DeskId),

    FirstPreviousUserId = sort_helper:loop_get_previous_userid(CurrentUserId, SortedUserIdList),
    FirstPreviousUserCards = user_helper:get_user_previous_chu_pai_cards(FirstPreviousUserId),
    FirstPreviousCardsPromptType = card_helper:get_card_prompt_type(FirstPreviousUserCards),
    IsFirstUserMustChuPai = cards_validate_algorithm:is_user_must_chu_pai(FirstPreviousUserId, DeskId),
    IsFirstPreviousUserBuyao = card_helper:get_cards_buyao(FirstPreviousUserCards),
    IsFirstPreviousUserDani = card_helper:get_cards_dani(IsFirstUserMustChuPai, FirstPreviousUserCards),

%%     用desk_helper:get_desk_second_previous_chu_pai_userid(DeskId)的话，获取出来的是不正确的
    SecondPreviousUserId = sort_helper:loop_get_previous_userid(FirstPreviousUserId, UserIdList),
    SecondPreviousUserChuPaiCards = user_helper:get_user_previous_chu_pai_cards(SecondPreviousUserId),
    IsSecondPreviousUserBuyao = card_helper:get_cards_buyao(SecondPreviousUserChuPaiCards),

    NextUserMustChuPai = (
            case IsFirstUserMustChuPai of
                true ->
                    0;
                _ ->
                    case length(FirstPreviousUserCards) of
                        0 ->
                            case string:equal(CurrentUserId, PreviousZuiDaChuPaiUserId) of
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

    JsonBin = query_desk_chu_pai_encoder:encode(
        SecondPreviousUserId, SecondPreviousUserChuPaiCards, IsSecondPreviousUserBuyao,
        FirstPreviousUserId, FirstPreviousUserCards, FirstPreviousCardsPromptType, IsFirstPreviousUserBuyao, IsFirstPreviousUserDani,
        CurrentUserId, NextUserMustChuPai),
    UserPid = user_map:get_pid_by_userid(UserId),
    tcp_send:send_data(UserPid, ?CMD_QUERY_DESK_CHU_PAI, JsonBin).