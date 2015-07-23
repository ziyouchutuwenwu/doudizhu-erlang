-module(desk_fa_pai_encoder).

-export([encode/3]).

%% {"cards":[1,2,3,4,5],"leftUser":{cardNumber":17},"rightUser":{"cardNumber":10}}
encode(UserIdCards, LeftUserIdCardNumber, RightUserIdCardNumber) ->

    LeftUserResponse = #
    {
        <<"cardNumber">> => LeftUserIdCardNumber
    },

    RightUserResponse = #
    {
        <<"cardNumber">> => RightUserIdCardNumber
    },

    Response = #
    {
        <<"cards">> => UserIdCards,
        <<"leftUser">> => LeftUserResponse,
        <<"rightUser">> => RightUserResponse
    },

    JsonBin = json:to_binary(Response),
    JsonBin.