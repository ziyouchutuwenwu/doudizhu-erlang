-module(cards_validate_algorithm).

-export([is_user_must_chu_pai/2, is_user_cards_valid/3]).

%% 查看有没有上一轮出最大牌的用户id，如果没有，那我就必须出；如果有，并且是我，那我也必须出，否则不一定必须出牌
is_user_must_chu_pai(UserId, DeskId) ->
    PreviousZuiDaChuPaiUserId = desk_helper:get_desk_previous_zui_da_chu_pai_userid(DeskId),
    IsUserMustChuPai = (
            case length(PreviousZuiDaChuPaiUserId) of
                0 ->
                    true;
                _ ->
                    case string:equal(UserId, PreviousZuiDaChuPaiUserId) of
                        true ->
                            true;
                        _ ->
                            false
                    end
            end
    ),
    IsUserMustChuPai.

is_user_cards_valid(DeskId, IsUserMustChuPai, Cards) ->

    PreviousZuiDaChuPaiUserId = desk_helper:get_desk_previous_zui_da_chu_pai_userid(DeskId),
    PreviousZuiDaChuPaiUserCards = user_helper:get_user_previous_chu_pai_cards(PreviousZuiDaChuPaiUserId),

    IsCardsValid = (
            case IsUserMustChuPai of
                true ->
                    CardValidateResult = card_helper:is_card_validate(Cards),
                    case CardValidateResult of
                        true ->
                            true;
                        _ ->
                            false
                    end;
                _ ->
                    case length(Cards) of
                        0 ->
                            true;
                        _ ->
                            NewCardsLargerResult = card_helper:is_new_cards_larger(Cards, PreviousZuiDaChuPaiUserCards),
                            case NewCardsLargerResult of
                                true ->
                                    true;
                                _ ->
                                    false
                            end
                    end
            end
    ),
    IsCardsValid.