-module(user_chu_pai_validator).

-include_lib("doudizhu/src/const/playing_status_const.hrl").
-include_lib("doudizhu/src/const/socket_const.hrl").
-export([is_request_validate/4]).

is_request_validate(DeskId, RequestUserId, Cmd, Cards) ->
    PlayingStatus = desk_helper:get_desk_playing_status(DeskId),
    CurrentUserId = desk_helper:get_desk_current_userid(DeskId),

    case PlayingStatus of
%%         发完底牌
        ?STATUS_FA_DI_PAI ->
            case string:equal(CurrentUserId, RequestUserId) of
                true ->
                    case Cmd of
                        ?CMD_DESK_CHU_PAI ->
                            case card_helper:is_cards_in_user_hand(Cards, CurrentUserId) of
                                true ->
                                    true;
                                _ ->
                                    false
                            end;
                        _ ->
                            false
                    end;
                _ ->
                    false
            end;
%%         出牌
        ?STATUS_CHU_PAI ->
            case string:equal(CurrentUserId, RequestUserId) of
                true ->
                    case Cmd of
                        ?CMD_DESK_CHU_PAI ->
                            case card_helper:is_cards_in_user_hand(Cards, CurrentUserId) of
                                true ->
                                    true;
                                _ ->
                                    false
                            end;
                        _ ->
                            false
                    end;
                _ ->
                    false
            end;
        _ ->
            false
    end.