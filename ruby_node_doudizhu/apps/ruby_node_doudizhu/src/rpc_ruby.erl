-module(rpc_ruby).

-export([wash_card/1, is_new_cards_larger/1, is_card_validate/1, get_new_larger_cards/1, get_auto_larger_cards/1, get_card_prompt_type/1]).

%% rpc远程调用，参数只有一个，需要在里面拆分

%% rpc_ruby:wash_card().
wash_card({}) ->
    Cmd = wash_card,
    Args = {},
    CardsTuple = port_working_pool_wrapper:do_port_work(Cmd, Args),
    Cards = erlang:tuple_to_list(CardsTuple),
    Cards.

%% rpc_ruby:is_new_cards_larger({[4,4],[3,3]}).
is_new_cards_larger({NewCards, OldCards}) ->
    Cmd = is_new_cards_larger,
    Args = {NewCards, OldCards},
    port_working_pool_wrapper:do_port_work(Cmd, Args).

%% rpc_ruby:is_card_validate({[4,5,6,7,8]}).
is_card_validate({Cards}) ->
    Cmd = is_card_validate,
    Args = {Cards},
    port_working_pool_wrapper:do_port_work(Cmd, Args).

%% rpc_ruby:get_new_larger_cards({[4,5,6,7,8],[1,1]}).
get_new_larger_cards({Cards, CardsFromUser}) ->
    Cmd = get_new_larger_cards,
    Args = {Cards, CardsFromUser},
    Result = port_working_pool_wrapper:do_port_work(Cmd, Args),
    OptionalCards = (
            case tuple_size(Result) of
                0 ->
                    [];
                _ ->
                    List = tuple_to_list(Result),
                    lists:map(
                        fun(CardsElement) ->
                            tuple_to_list(CardsElement)
                        end,
                        List
                    )
            end
    ),
    OptionalCards.

%% rpc_ruby:get_auto_larger_cards({[4]}).
get_auto_larger_cards({Cards}) ->
    Cmd = get_auto_larger_cards,
    Args = {Cards},
    Result = port_working_pool_wrapper:do_port_work(Cmd, Args),
    OptionalCards = (
            case tuple_size(Result) of
                0 ->
                    [];
                _ ->
                    List = tuple_to_list(Result),
                    lists:map(
                        fun(CardsElement) ->
                            tuple_to_list(CardsElement)
                        end,
                        List
                    )
            end
    ),
    OptionalCards.

get_card_prompt_type({Cards}) ->
    Cmd = get_card_prompt_type,
    Args = {Cards},
    port_working_pool_wrapper:do_port_work(Cmd, Args).