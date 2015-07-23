-module(user_sit_on_desk_validator).

-include_lib("doudizhu/src/const/playing_status_const.hrl").
-include_lib("doudizhu/src/const/socket_const.hrl").
-export([is_request_validate/1]).

is_request_validate(RequestUserId) ->
    DeskId = user_helper:get_user_deskid(RequestUserId),
    case length(DeskId) of
        0 ->
            true;
        _ ->
            false
    end.