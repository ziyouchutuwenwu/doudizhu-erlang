-module(desk_chu_pai_handler).

-include_lib("doudizhu/src/const/socket_const.hrl").
-include_lib("doudizhu/src/const/playing_status_const.hrl").
-export([handle_request/3]).

handle_request(DeskId, Cmd, Params) ->
    {RequestUserId, Cards} = Params,

    desk_helper:set_desk_playing_status(DeskId, ?STATUS_CHU_PAI),

    IsUserMustChuPai = cards_validate_algorithm:is_user_must_chu_pai(RequestUserId, DeskId),
    case cards_validate_algorithm:is_user_cards_valid(DeskId, IsUserMustChuPai, Cards) of
        true ->
            desk_timer:restart_timer(DeskId),
            chu_pai_algorithm:do_desk_chu_pai(DeskId, Cmd, RequestUserId, IsUserMustChuPai, Cards);
        _ ->
            handler_dispatcher:dispatch_desk_request(DeskId, ?CMD_DESK_CARDS_VALIDATE, {RequestUserId, 0})
    end,
    ok.