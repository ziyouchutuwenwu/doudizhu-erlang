-module(query_desk_users_encoder).

-export([encode/8]).

encode(DeskId, Error,
        LeftUserId, LeftUserOnline, LeftUserGender,
        RightUserId, RightUserOnline, RightUserGender) ->

    LeftUserIdBin = utf8_list:list_to_binary(LeftUserId),
    LeftUserGenderBin = utf8_list:list_to_binary(LeftUserGender),
    LeftUserResponse = #
    {
        <<"id">> => LeftUserIdBin,
        <<"online">> => LeftUserOnline,
        <<"gender">> => LeftUserGenderBin
    },

    RightUserIdBin = utf8_list:list_to_binary(RightUserId),
    RightUserGenderBin = utf8_list:list_to_binary(RightUserGender),
    RightUserResponse = #
    {
        <<"id">> => RightUserIdBin,
        <<"online">> => RightUserOnline,
        <<"gender">> => RightUserGenderBin
    },

    DeskIdBin = utf8_list:list_to_binary(DeskId),
    Response = #{
        <<"deskId">> => DeskIdBin,
        <<"error">> => Error,
        <<"leftUser">> => LeftUserResponse,
        <<"rightUser">> => RightUserResponse
    },

    JsonBin = json:to_binary(Response),
    JsonBin.