-module(auto_desk_chu_pai_notification).

-include_lib("doudizhu/src/const/socket_const.hrl").
-export([notify/2]).

notify(DeskId, CurrentUserId) ->
    IsUserMustChuPai = cards_validate_algorithm:is_user_must_chu_pai(CurrentUserId, DeskId),
    OptionalCards = (
            case IsUserMustChuPai of
                true ->
                    CardsInHand = user_helper:get_cards_in_user_hand(CurrentUserId),
                    card_helper:get_auto_larger_cards(CardsInHand);
                _ ->
                    PreviousZuiDaChuPaiUserId = desk_helper:get_desk_previous_zui_da_chu_pai_userid(DeskId),
                    OldCards = user_helper:get_user_previous_chu_pai_cards(PreviousZuiDaChuPaiUserId),
                    CardsInHand = user_helper:get_cards_in_user_hand(CurrentUserId),
                    card_helper:get_new_larger_cards(CardsInHand, OldCards)
            end
    ),
    Cards = (
            case length(OptionalCards) of
                0 ->
                    [];
                _ ->
                    RadomIndex = random:uniform(9) rem length(OptionalCards) + 1,
                    lists:nth(RadomIndex, OptionalCards)
            end
    ),
    desk_chu_pai_handler:handle_request(DeskId, ?CMD_AUTO_DESK_CHU_PAI, {CurrentUserId, Cards}).