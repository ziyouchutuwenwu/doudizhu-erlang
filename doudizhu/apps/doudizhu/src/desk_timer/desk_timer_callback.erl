-module(desk_timer_callback).

-include_lib("doudizhu/src/const/socket_const.hrl").
-include_lib("doudizhu/src/const/playing_status_const.hrl").
-export([on_desk_timer/1]).

on_desk_timer(Args) ->
    {DeskId} = Args,

    PlayingStatus = desk_helper:get_desk_playing_status(DeskId),
    CurrentUserId = desk_helper:get_desk_current_userid(DeskId),

    case PlayingStatus of
        ?STATUS_PROMPT_USER_JIAO_DI_ZHU ->
            JiaoDiZhu = random_generator:random_number() rem 2,
            auto_desk_jiao_di_zhu_notification:notify(DeskId, CurrentUserId, JiaoDiZhu);
        ?STATUS_JIAO_DI_ZHU ->
            JiaoDiZhu = random_generator:random_number() rem 2,
            auto_desk_jiao_di_zhu_notification:notify(DeskId, CurrentUserId, JiaoDiZhu);
        ?STATUS_JIAO_DI_ZHU_FINISH ->
            auto_desk_chu_pai_notification:notify(DeskId, CurrentUserId);
        ?STATUS_FA_DI_PAI ->
            auto_desk_chu_pai_notification:notify(DeskId, CurrentUserId);
        ?STATUS_CHU_PAI ->
            auto_desk_chu_pai_notification:notify(DeskId, CurrentUserId);
        _ ->
            ok
    end.