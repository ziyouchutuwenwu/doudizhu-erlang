-module(node_helper).

-export([wash_card/0, is_new_cards_larger/2, is_card_validate/1, get_new_larger_cards/2, get_auto_larger_cards/1, get_card_prompt_type/1]).

wash_card() ->
    node_caller_pool_wrapper:call_remote_node(rpc_ruby, wash_card, {}).

is_new_cards_larger(NewCards, OldCards) ->
    node_caller_pool_wrapper:call_remote_node(rpc_ruby, is_new_cards_larger, {NewCards, OldCards}).

is_card_validate(Cards) ->
    node_caller_pool_wrapper:call_remote_node(rpc_ruby, is_card_validate, {Cards}).

%% node_helper:get_new_larger_cards([4,4,5,5,6,6],[2,2]).
get_new_larger_cards(Cards, CardsFromUser) ->
    node_caller_pool_wrapper:call_remote_node(rpc_ruby, get_new_larger_cards, {Cards, CardsFromUser}).

get_auto_larger_cards(Cards) ->
    node_caller_pool_wrapper:call_remote_node(rpc_ruby, get_auto_larger_cards, {Cards}).

get_card_prompt_type(Cards) ->
    node_caller_pool_wrapper:call_remote_node(rpc_ruby, get_card_prompt_type, {Cards}).