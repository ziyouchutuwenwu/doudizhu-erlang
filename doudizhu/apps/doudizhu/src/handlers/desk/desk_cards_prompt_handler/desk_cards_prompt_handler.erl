-module(desk_cards_prompt_handler).

-export([handle_request/3]).

handle_request(DeskId, Cmd, Params) ->
    {RequestUserId} = Params,

    IsUserMustChuPai = cards_validate_algorithm:is_user_must_chu_pai(RequestUserId, DeskId),
    OptionalCards = (
            case IsUserMustChuPai of
                true ->
                    CardsInHand = user_helper:get_cards_in_user_hand(RequestUserId),
                    card_helper:get_auto_larger_cards(CardsInHand);
                _ ->
                    PreviousZuiDaChuPaiUserId = desk_helper:get_desk_previous_zui_da_chu_pai_userid(DeskId),
                    OldCards = user_helper:get_user_previous_chu_pai_cards(PreviousZuiDaChuPaiUserId),
                    CardsInHand = user_helper:get_cards_in_user_hand(RequestUserId),
                    card_helper:get_new_larger_cards(CardsInHand, OldCards)
            end
    ),

    JsonBin = desk_cards_prompt_encoder:encode(OptionalCards),
    UserPid = user_map:get_pid_by_userid(RequestUserId),
    tcp_send:send_data(UserPid, Cmd, JsonBin),
    ok.