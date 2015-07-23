-module(reset_helper).

-include_lib("doudizhu/src/const/playing_status_const.hrl").
-export([reset_desk_play_status/1, reset_desk_jiao_di_zhu_status/1]).

reset_desk_jiao_di_zhu_status(DeskId) ->

    desk_helper:remove_desk_current_userid(DeskId),
    desk_helper:remove_desk_last_jiao_di_zhu_userid(DeskId),
    desk_helper:remove_desk_first_previous_jiao_di_zhu_userid(DeskId),
    desk_helper:remove_desk_second_previous_jiao_di_zhu_userid(DeskId),
    desk_helper:remove_desk_jiao_di_zhu_request_index(DeskId),
    desk_helper:remove_desk_jiao_di_zhu_users_count(DeskId),
    desk_helper:remove_desk_dizhu(DeskId),

    UserIdList = desk_helper:get_desk_all_users(DeskId),
    lists:foreach(
        fun(DeskUserId) ->
            reset_user_jiao_di_zhu_status(DeskUserId)
        end,
        UserIdList
    ).

reset_desk_play_status(DeskId) ->
    desk_helper:set_desk_playing_status(DeskId, ?STATUS_NOT_PLAYING),
    reset_desk_jiao_di_zhu_status(DeskId),
    desk_helper:remove_desk_di_pai_cards(DeskId),
    desk_helper:remove_desk_previous_zui_da_chu_pai_userid(DeskId),
    desk_helper:remove_desk_second_previous_chu_pai_userid(DeskId),

    UserIdList = desk_helper:get_desk_all_users(DeskId),
    lists:foreach(
        fun(DeskUserId) ->
            reset_user_play_status(DeskUserId)
        end,
        UserIdList
    ).

%% private
reset_user_jiao_di_zhu_status(UserId) ->
    user_helper:remove_user_play_index(UserId),
    user_helper:clear_cards_in_user_hand(UserId),
    user_helper:remove_user_has_jiao_di_zhu(UserId),
    user_helper:remove_user_is_first_jiao_di_zhu(UserId),
    ok.

reset_user_play_status(UserId) ->
    user_helper:remove_user_ready(UserId),
    reset_user_jiao_di_zhu_status(UserId),
    user_helper:remove_user_previous_chu_pai_cards(UserId),
    ok.