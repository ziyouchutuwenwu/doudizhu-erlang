-module(user_leave_desk_encoder).

-export([encode/1]).

encode(LeaveUserId) ->
    LeaveUserIdBin = utf8_list:list_to_binary(LeaveUserId),

    Response = #{
        <<"leaveUserId">> => LeaveUserIdBin
    },
    JsonBin = json:to_binary(Response),
    JsonBin.