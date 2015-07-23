-module(desk_da_pai_end_encoder).

-export([encode/5]).

encode(LeftUserId, LeftUserCardsLeft, RightUserId, RightUserCardsLeft, IsWin) ->

    LeftUserIdBin = utf8_list:list_to_binary(LeftUserId),
    LeftUserResponse = #
    {
        <<"id">> => LeftUserIdBin,
        <<"cards">> => LeftUserCardsLeft
    },

    RightUserIdBin = utf8_list:list_to_binary(RightUserId),
    RightUserResponse = #
    {
        <<"id">> => RightUserIdBin,
        <<"cards">> => RightUserCardsLeft
    },

    Response = #
    {
        <<"leftUser">> => LeftUserResponse,
        <<"rightUser">> => RightUserResponse,
        <<"isWin">> => IsWin
    },

    JsonBin = json:to_binary(Response),
    JsonBin.