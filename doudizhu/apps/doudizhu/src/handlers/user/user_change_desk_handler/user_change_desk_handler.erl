-module(user_change_desk_handler).

-include_lib("doudizhu/src/const/socket_const.hrl").
-export([handle_request/3]).

%先通知旧的桌子的人离开，然后换桌
handle_request(Pid, _Cmd, _InfoBin) ->
    UserId = user_map:get_userid_by_pid(Pid),
    RoomId = user_helper:get_user_roomid(UserId),

    case user_change_desk_validator:is_request_validate(UserId) of
        true ->
            user_leave_desk_handler:do_user_leave_desk(?CMD_USER_LEAVE_DESK, UserId),
            Num = random_generator:random_number() rem 3 + 1,
            user_working_pool_wrapper:delay_cast(Num * 1000, {user_sit_on_desk_handler, handle_delay_cast}, {Pid, ?CMD_USER_SIT_ON_DESK, UserId, RoomId});
        _ ->
            ignore
    end,
    ok.