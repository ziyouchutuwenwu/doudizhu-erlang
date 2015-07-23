-module(user_check_resume_play_handler).

-include_lib("doudizhu/src/const/playing_status_const.hrl").
-export([handle_request/3]).

handle_request(Pid, Cmd, _InfoBin) ->
    UserId = user_map:get_userid_by_pid(Pid),
    DeskId = user_helper:get_user_deskid(UserId),

    case length(DeskId) of
        0 ->
            JsonBin = user_check_resume_play_encoder:encode(0),
            tcp_send:send_data(Pid, Cmd, JsonBin);
        _ ->
            PlayingStatus = desk_helper:get_desk_playing_status(DeskId),
            case PlayingStatus of
                ?STATUS_NOT_PLAYING ->
                    ignore;
                _ ->
                    JsonBin = user_check_resume_play_encoder:encode(1),
                    tcp_send:send_data(Pid, Cmd, JsonBin)
            end
    end,
    ok.