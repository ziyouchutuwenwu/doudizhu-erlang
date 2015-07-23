-module(user_cards_prompt_handler).

-export([handle_request/3]).

handle_request(Pid, Cmd, _InfoBin) ->
    UserId = user_map:get_userid_by_pid(Pid),
    DeskId = user_helper:get_user_deskid(UserId),
    desk_working_pool_wrapper:do_desk_request(DeskId, Cmd, {UserId}),
    ok.