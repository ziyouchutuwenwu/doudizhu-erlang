-module(user_ready_to_play_validator).

-include_lib("doudizhu/src/const/playing_status_const.hrl").
-export([is_request_validate/1]).

is_request_validate(DeskId) ->
    PlayingStatus = desk_helper:get_desk_playing_status(DeskId),

    if
        PlayingStatus /= ?STATUS_NOT_PLAYING ->
            false;
        true ->
            true
    end.