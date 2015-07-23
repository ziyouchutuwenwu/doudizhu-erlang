-module(desk_jiao_di_zhu_encoder).

-export([encode/8]).

%% {"secondPreviousUser":{"id":"9073420957995068","isFirstJiaoDiZhu":1,"jiaoDiZhu":1},"firstPreviousUser":{"id":"9073420957995068","isFirstJiaoDiZhu":1,"jiaoDiZhu":1},"nextUser":{"id":"7645247736507953","isFirstJiaoDiZhu":0}}
encode(
        SecondPreviousUserId, SecondPreviousUserJiaoDiZhu, IsSecondPreviousUserFirstJiaoDiZhu,
        FirstPreviousUserId, FirstPreviousUserJiaoDiZhu, IsFirstPreviousUserFirstJiaoDiZhu,
        NextUserId, IsNextUserFirstJiaoDiZhu) ->

    SecondPreviousUserIdBin = utf8_list:list_to_binary(SecondPreviousUserId),
    SecondPreviousUserResponse = #
    {
        <<"id">> => SecondPreviousUserIdBin,
        <<"jiaoDiZhu">> => SecondPreviousUserJiaoDiZhu,
        <<"isFirstJiaoDiZhu">> => IsSecondPreviousUserFirstJiaoDiZhu
    },

    FirstPreviousUserIdBin = utf8_list:list_to_binary(FirstPreviousUserId),
    FirstPreviousUserResponse = #
    {
        <<"id">> => FirstPreviousUserIdBin,
        <<"jiaoDiZhu">> => FirstPreviousUserJiaoDiZhu,
        <<"isFirstJiaoDiZhu">> => IsFirstPreviousUserFirstJiaoDiZhu
    },

    NextUserIdBin = utf8_list:list_to_binary(NextUserId),
    NextUserResponse = #
    {
        <<"id">> => NextUserIdBin,
        <<"isFirstJiaoDiZhu">> => IsNextUserFirstJiaoDiZhu
    },

    Response = #
    {
        <<"secondPreviousUser">> => SecondPreviousUserResponse,
        <<"firstPreviousUser">> => FirstPreviousUserResponse,
        <<"nextUser">> => NextUserResponse
    },

    JsonBin = json:to_binary(Response),
    JsonBin.