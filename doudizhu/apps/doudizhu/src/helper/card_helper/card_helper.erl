-module(card_helper).

-export([wash_card/0, is_new_cards_larger/2]).
-export([is_card_validate/1, get_new_larger_cards/2, get_auto_larger_cards/1, get_card_prompt_type/1, is_cards_in_user_hand/2]).
-export([get_cards_buyao/1, get_cards_dani/2]).

%% 洗牌
wash_card() ->
    node_helper:wash_card().

%% 判断NewCards是不是比OldCards大
is_new_cards_larger(NewCards, OldCards) ->
    node_helper:is_new_cards_larger(NewCards, OldCards).

%% 判断牌是否有效
is_card_validate(Cards) ->
    node_helper:is_card_validate(Cards).

%% 从NewCards里面找出比OldCards更大的牌，目前有一些bug，暂时不影响
get_new_larger_cards(NewCards, OldCards) ->
    node_helper:get_new_larger_cards(NewCards, OldCards).

%% 从当前牌里面找出可以出的牌
get_auto_larger_cards(Cards) ->
    node_helper:get_auto_larger_cards(Cards).

%% 看当前牌是什么类型，飞机，顺子，火箭，炸弹
%% 单张，对子，三个，三带一，三带二
get_card_prompt_type(Cards) ->
    node_helper:get_card_prompt_type(Cards).

%% 出的牌是否在用户手里
is_cards_in_user_hand(Cards, UserId) ->
    CardsInUserHand = user_helper:get_cards_in_user_hand(UserId),
    lists:all(
        fun(Card) ->
            lists:member(Card, CardsInUserHand)
        end,
        Cards
    ).

%% 出牌的时候检测PreviousUser是不出还是大你
get_cards_buyao(Cards) ->
    IsPreviousUserBuyao = (
            case length(Cards) of
                0 ->
                    1;
                _ ->
                    0
            end
    ),
    IsPreviousUserBuyao.

get_cards_dani(IsUserMustChuPai, Cards) ->
    Result = (
            if
                IsUserMustChuPai == false andalso length(Cards) > 0 ->
                    1;
                true ->
                    0
            end
    ),
    Result.