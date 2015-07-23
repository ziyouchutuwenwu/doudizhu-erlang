-module(user_leave_desk_validator).

-include_lib("doudizhu/src/const/playing_status_const.hrl").
-include_lib("doudizhu/src/const/socket_const.hrl").
-export([is_request_validate/1]).

is_request_validate(RequestUserId) ->
    DeskId = user_helper:get_user_deskid(RequestUserId),

    case length(DeskId) of
        0 ->
            false;
        _ ->
            PlayingStatus = desk_helper:get_desk_playing_status(DeskId),
            if
%%                 正在玩，不允许离开
                PlayingStatus /= ?STATUS_NOT_PLAYING ->
                    false;
                true ->
                    true
            end
    end.