-module(handler_dispatcher).

-include_lib("doudizhu/src/const/socket_const.hrl").
-export([dispatch_user_request/3, dispatch_desk_request/3]).

dispatch_user_request(Pid, Cmd, InfoBin) ->

    case Cmd of
        ?CMD_CLIENT_CONNECTED ->
            user_connect_handler:handle_request(Pid),
            ok;
        ?CMD_CLIENT_DISCONNECTED ->
            user_disconnect_handler:handle_request(Pid, Cmd),
            ok;
        ?CMD_UPDATE_CHECK ->
            user_update_check_handler:handle_request(Pid, Cmd, InfoBin),
            ok;
        ?CMD_USER_GUEST_LOGIN ->
            user_guest_login_handler:handle_request(Pid, Cmd, InfoBin),
            ok;
        ?CMD_USER_LOGIN ->
            user_login_handler:handle_response(Pid, Cmd, InfoBin),
            ok;
        ?CMD_USER_REGISTER ->
            user_register_handler:handle_response(Pid, Cmd, InfoBin),
            ok;
        ?CMD_USER_EDIT_PROFILE ->
            user_edit_profile_handler:handle_response(Pid, Cmd, InfoBin),
            ok;
        ?CMD_USER_ENTER_ROOM ->
            user_enter_room_handler:handle_request(Pid, Cmd, InfoBin),
            ok;
        ?CMD_USER_SIT_ON_DESK ->
            user_sit_on_desk_handler:handle_request(Pid, Cmd, InfoBin),
            ok;
        ?CMD_USER_LEAVE_DESK ->
            user_leave_desk_handler:handle_request(Pid, Cmd, InfoBin),
            ok;
        ?CMD_USER_CHANGE_DESK ->
            user_change_desk_handler:handle_request(Pid, Cmd, InfoBin),
            ok;
        ?CMD_USER_READY_TO_PLAY ->
            user_ready_to_play_handler:handle_request(Pid, Cmd, InfoBin),
            ok;
        ?CMD_DESK_JIAO_DI_ZHU ->
            user_jiao_di_zhu_handler:handle_request(Pid, Cmd, InfoBin),
            ok;
        ?CMD_DESK_CHU_PAI ->
            user_chu_pai_handler:handle_request(Pid, Cmd, InfoBin),
            ok;
        ?CMD_DESK_CRADS_PROMPT ->
            user_cards_prompt_handler:handle_request(Pid, Cmd, InfoBin),
            ok;
%%         查询断线重连
        ?CMD_USER_CHECK_RESUME_PLAY ->
            user_check_resume_play_handler:handle_request(Pid, Cmd, InfoBin),
            ok;
        ?CMD_USER_RESUME_PLAY ->
            user_resume_play_handler:handle_request(Pid, Cmd, InfoBin),
            ok;
        _ ->
%%             io:format("~p,~p~n",[Cmd,bitstring_to_list(InfoBin)]),
            ok
    end,
    ok.


dispatch_desk_request(DeskId, Cmd, Params) ->
    case Cmd of
        ?CMD_USER_READY_TO_PLAY ->
            desk_ready_handler:handle_request(DeskId, Cmd, Params),
            ok;
        ?CMD_DESK_FA_PAI ->
            desk_fa_pai_handler:handle_request(DeskId, Cmd, Params),
            ok;
        ?CMD_DESK_PROMPT_USER_JIAO_DI_ZHU ->
            desk_prompt_user_jiao_di_zhu_handler:handle_request(DeskId, Cmd, Params),
            ok;
        ?CMD_DESK_JIAO_DI_ZHU ->
            desk_jiao_di_zhu_handler:handle_request(DeskId, Cmd, Params),
            ok;
        ?CMD_DESK_JIAO_DI_ZHU_FINISH ->
            desk_jiao_di_zhu_finish_handler:handle_request(DeskId, Cmd, Params),
            ok;
        ?CMD_DESK_FA_DI_PAI ->
            desk_fa_di_pai_handler:handle_request(DeskId, Cmd, Params),
            ok;
        ?CMD_DESK_CHU_PAI ->
            desk_chu_pai_handler:handle_request(DeskId, Cmd, Params),
            ok;
        ?CMD_DESK_CARDS_VALIDATE ->
            desk_cards_validate_handler:handle_request(DeskId, Cmd, Params),
            ok;
        ?CMD_DESK_CRADS_PROMPT ->
            desk_cards_prompt_handler:handle_request(DeskId, Cmd, Params),
            ok;
        ?CMD_DESK_DA_PAI_END ->
            desk_da_pai_end_handler:handle_request(DeskId, Cmd, Params),
            ok;
        _ ->
            ok
    end,
    ok.