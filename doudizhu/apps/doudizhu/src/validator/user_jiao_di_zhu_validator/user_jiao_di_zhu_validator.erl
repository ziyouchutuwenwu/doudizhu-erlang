-module(user_jiao_di_zhu_validator).

-include_lib("doudizhu/src/const/playing_status_const.hrl").
-include_lib("doudizhu/src/const/socket_const.hrl").
-export([is_request_validate/4]).

is_request_validate(DeskId, RequestUserId, Cmd, JiaoDiZhu) ->
    PlayingStatus = desk_helper:get_desk_playing_status(DeskId),
    CurrentUserId = desk_helper:get_desk_current_userid(DeskId),

    case PlayingStatus of
%%         提示用户叫地主
        ?STATUS_PROMPT_USER_JIAO_DI_ZHU ->
            case string:equal(CurrentUserId, RequestUserId) of
                true ->
                    case Cmd of
                        ?CMD_DESK_JIAO_DI_ZHU ->
                            case is_integer(JiaoDiZhu) of
                                true ->
                                    true;
                                _ ->
                                    false
                            end;
                        _ ->
                            false
                    end;
                _ ->
                    false
            end;
%%         叫地主
        ?STATUS_JIAO_DI_ZHU ->
            case string:equal(CurrentUserId, RequestUserId) of
                true ->
                    case Cmd of
                        ?CMD_DESK_JIAO_DI_ZHU ->
                            case is_integer(JiaoDiZhu) of
                                true ->
                                    true;
                                _ ->
                                    false
                            end;
                        _ ->
                            false
                    end;
                _ ->
                    false
            end;
        _ ->
            false
    end.