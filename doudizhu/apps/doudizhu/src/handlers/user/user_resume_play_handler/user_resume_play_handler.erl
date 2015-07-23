-module(user_resume_play_handler).

-include_lib("doudizhu/src/const/playing_status_const.hrl").
-export([handle_request/3]).

handle_request(Pid, _Cmd, _InfoBin) ->
    UserId = user_map:get_userid_by_pid(Pid),

    DeskId = user_helper:get_user_deskid(UserId),
    PlayingStatus = desk_helper:get_desk_playing_status(DeskId),

    %%     需要根据桌子状态提示用户
    case PlayingStatus of
        ?STATUS_FA_PAI ->
            query_desk_users_notification:notify(UserId),
            query_desk_fa_pai_notification:notify(UserId),
            ok;
        ?STATUS_PROMPT_USER_JIAO_DI_ZHU ->
            query_desk_users_notification:notify(UserId),
            query_desk_fa_pai_notification:notify(UserId),
            query_prompt_user_jiao_di_zhu_notification:notify(UserId),
            ok;
        ?STATUS_JIAO_DI_ZHU ->
            query_desk_users_notification:notify(UserId),
            query_desk_fa_pai_notification:notify(UserId),
            query_desk_jiao_di_zhu_notification:notify(UserId),
            ok;
        ?STATUS_JIAO_DI_ZHU_FINISH ->
            query_desk_users_notification:notify(UserId),
            query_desk_fa_pai_notification:notify(UserId),
            query_desk_jiao_di_zhu_finish_notification:notify(UserId),
            ok;
        ?STATUS_FA_DI_PAI ->
            query_desk_users_notification:notify(UserId),
            query_desk_fa_pai_notification:notify(UserId),
            query_desk_jiao_di_zhu_finish_notification:notify(UserId),
            query_desk_fa_di_pai_notification:notify(UserId),
            ok;
        ?STATUS_CHU_PAI ->
            query_desk_users_notification:notify(UserId),
            query_desk_fa_pai_notification:notify(UserId),
            query_desk_jiao_di_zhu_finish_notification:notify(UserId),
            query_desk_fa_di_pai_notification:notify(UserId),
            query_desk_chu_pai_notification:notify(UserId),
            ok;
        _ ->
            ok
    end.