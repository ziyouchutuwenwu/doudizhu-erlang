-module(handler_dispatcher).

-include_lib("doudizhu_robot/src/const/socket_const.hrl").
-export([dispatch_user_request/3]).

dispatch_user_request(Pid, Cmd, InfoBin) ->

    case Cmd of
        ?CMD_CLIENT_CONNECTED ->
            user_connect_handler:handle_response(Pid),
            ok;
        ?CMD_CLIENT_DISCONNECTED ->
            user_disconnect_handler:handle_response(Pid, Cmd),
            ok;
%%         常规业务
        ?CMD_USER_GUEST_LOGIN ->
            user_guest_login_handler:handle_response(Pid, Cmd, InfoBin),
            ok;
        ?CMD_USER_ENTER_ROOM ->
            user_enter_room_handler:handle_response(Pid, Cmd, InfoBin),
            ok;
        ?CMD_USER_SIT_ON_DESK ->
            user_sit_on_desk_handler:handle_response(Pid, Cmd, InfoBin),
            ok;
        ?CMD_USER_PROMPT_READY ->
            user_prompt_ready_handler:handle_response(Pid, Cmd, InfoBin),
            ok;
        ?CMD_USER_READY_TO_PLAY ->
            user_ready_to_play_handler:handle_response(Pid, Cmd, InfoBin),
            ok;
        ?CMD_DESK_PROMPT_USER_JIAO_DI_ZHU ->
            user_prompt_jiao_di_zhu_handler:handle_response(Pid, Cmd, InfoBin),
            ok;
        ?CMD_DESK_JIAO_DI_ZHU ->
            user_jiao_di_zhu_handler:handle_response(Pid, Cmd, InfoBin),
            ok;
        ?CMD_DESK_JIAO_DI_ZHU_FINISH ->
            user_jiao_di_zhu_finish_handler:handle_response(Pid, Cmd, InfoBin),
            ok;
        ?CMD_DESK_CRADS_PROMPT ->
            user_cards_prompt_handler:handle_response(Pid, Cmd, InfoBin),
            ok;
        ?CMD_DESK_CHU_PAI ->
            user_chu_pai_handler:handle_response(Pid, Cmd, InfoBin),
            ok;
        ?CMD_DESK_DA_PAI_END ->
            user_da_pai_end_handler:handle_response(Pid, Cmd, InfoBin),
            ok;
        ?CMD_OTHER_CLIENT_DISCONNECTED ->
            other_user_disconnect_handler:handle_response(Pid, Cmd, InfoBin),
            ok;
%%         断线重连
        ?CMD_USER_CHECK_RESUME_PLAY ->
            user_check_resume_play_handler:handle_response(Pid, Cmd, InfoBin),
            ok;
        ?CMD_QUERY_DESK_USERS ->
            user_query_desk_users_handler:handle_response(Pid, Cmd, InfoBin),
            ok;
        ?CMD_QUERY_DESK_PROMPT_USER_JIAO_DI_ZHU ->
            user_query_prompt_user_jiao_di_zhu_handler:handle_response(Pid, Cmd, InfoBin),
            ok;
        ?CMD_QUERY_DESK_JIAO_DI_ZHU ->
            user_query_desk_jiao_di_zhu_handler:handle_response(Pid, Cmd, InfoBin),
            ok;
        ?CMD_QUERY_DESK_JIAO_DI_ZHU_FINISH ->
            user_query_desk_jiao_di_zhu_finish_handler:handle_response(Pid, Cmd, InfoBin),
            ok;
        ?CMD_QUERY_DESK_CHU_PAI ->
            user_query_desk_chu_pai_handler:handle_response(Pid, Cmd, InfoBin),
            ok;
%%         自动xxx
        ?CMD_AUTO_DESK_JIAO_DI_ZHU ->
            auto_user_jiao_di_zhu_handler:handle_response(Pid, Cmd, InfoBin),
            ok;
        ?CMD_AUTO_DESK_CHU_PAI ->
            auto_user_chu_pai_handler:handle_response(Pid, Cmd, InfoBin),
            ok;
        _ ->
%%             io:format("~p,~p~n",[Cmd,bitstring_to_list(InfoBin)]),
            ok
    end,
    ok.