-module(query_desk_chu_pai_encoder).

-export([encode/10]).

encode(
        SecondPreviousUserId, SecondPreviousUserCards, IsSecondPreviousUserBuyao,
        FirstPreviousUserId, FirstPreviousUserCards, FirstPreviousUserCardsPromptType, IsFirstPreviousUserBuyao, IsFirstPreviousUserDani,
        NextUserId, NextUserMustChuPai) ->

    SecondPreviousUserIdBin = utf8_list:list_to_binary(SecondPreviousUserId),
    FirstPreviousUserIdBin = utf8_list:list_to_binary(FirstPreviousUserId),
    NextUserIdBin = utf8_list:list_to_binary(NextUserId),

    FirstPreviousUserResponse = #
    {
        <<"id">> => FirstPreviousUserIdBin,
        <<"cards">> => FirstPreviousUserCards,
        <<"cardsType">> => FirstPreviousUserCardsPromptType,
        <<"isBuYao">> => IsFirstPreviousUserBuyao,
        <<"isDaNi">> => IsFirstPreviousUserDani
    },

    SecondPreviousUserResponse = #
    {
        <<"id">> => SecondPreviousUserIdBin,
        <<"cards">> => SecondPreviousUserCards,
        <<"isBuYao">> => IsSecondPreviousUserBuyao
    },

    NextUserResponse = #
    {
        <<"id">> => NextUserIdBin,
        <<"mustChuPai">> => NextUserMustChuPai
    },

    Response = #
    {
        <<"firstPreviousUser">> => FirstPreviousUserResponse,
        <<"secondPreviousUser">> => SecondPreviousUserResponse,
        <<"nextUser">> => NextUserResponse
    },

    JsonBin = json:to_binary(Response),
    JsonBin.