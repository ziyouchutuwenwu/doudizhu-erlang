-module(desk_helper).

-export([sync_add_user_to_desk/2, sync_remove_user_from_desk/2, sync_get_desk_all_users/1, sync_get_desk_user_number/1]).
-export([get_desk_all_users/1]).
-export([get_deskids_by_roomid/1]).
-export([get_desk_roomid/1, set_desk_roomid/2, remove_desk_roomid/1]).

%% 叫地主
-export([get_desk_last_jiao_di_zhu_userid/1, set_desk_last_jiao_di_zhu_userid/2, remove_desk_last_jiao_di_zhu_userid/1]).
-export([get_desk_first_previous_jiao_di_zhu_userid/1, set_desk_first_previous_jiao_di_zhu_userid/2, remove_desk_first_previous_jiao_di_zhu_userid/1]).
-export([get_desk_second_previous_jiao_di_zhu_userid/1, set_desk_second_previous_jiao_di_zhu_userid/2, remove_desk_second_previous_jiao_di_zhu_userid/1]).

-export([get_desk_jiao_di_zhu_request_index/1, inc_desk_jiao_di_zhu_request_index/1, remove_desk_jiao_di_zhu_request_index/1]).
-export([get_desk_jiao_di_zhu_users_count/1, inc_desk_jiao_di_zhu_users_count/1, remove_desk_jiao_di_zhu_users_count/1]).
-export([get_desk_dizhu/1, set_desk_dizhu/2, remove_desk_dizhu/1]).

%% 出牌
-export([get_desk_di_pai_cards/1, set_desk_di_pai_cards/2, remove_desk_di_pai_cards/1]).
-export([get_desk_previous_zui_da_chu_pai_userid/1, set_desk_previous_zui_da_chu_pai_userid/2, remove_desk_previous_zui_da_chu_pai_userid/1]).
-export([get_desk_second_previous_chu_pai_userid/1, set_desk_second_previous_chu_pai_userid/2, remove_desk_second_previous_chu_pai_userid/1]).

%% 自动叫地主，出牌等
-export([get_desk_playing_status/1, set_desk_playing_status/2, remove_desk_playing_status/1]).
-export([get_desk_current_userid/1, set_desk_current_userid/2, remove_desk_current_userid/1]).

%% 同步处理桌子上用户的列表
sync_add_user_to_desk(DeskId, UserId) ->
    ListName = "users_on_desk_" ++ DeskId,
    redis_wrapper:sync_add_to_list(ListName, UserId).

sync_remove_user_from_desk(DeskId, UserId) ->
    ListName = "users_on_desk_" ++ DeskId,
    redis_wrapper:sync_remove_from_list(ListName, UserId).

sync_get_desk_all_users(DeskId) ->
    ListName = "users_on_desk_" ++ DeskId,
    redis_wrapper:sync_get_list(ListName).

sync_get_desk_user_number(DeskId) ->
    ListName = "users_on_desk_" ++ DeskId,
    redis_wrapper:sync_get_list_size(ListName).

%% 异步处理桌子上用户的列表
get_desk_all_users(DeskId) ->
    ListName = "users_on_desk_" ++ DeskId,
    redis_wrapper:get_list(ListName).

get_deskids_by_roomid(RoomId) ->
    List = redis_wrapper:sync_get_list("desks"),
    DeskIdList = lists:filter(
        fun(DeskId) ->
            IterRoomId = get_desk_roomid(DeskId),
            case string:equal(IterRoomId, RoomId) andalso desk_helper:sync_get_desk_user_number(DeskId) < 3 of
                true ->
                    true;
                _ ->
                    false
            end
        end,
        List
    ),
    DeskIdList.

%设置桌子一些属性
get_desk_roomid(DeskId) ->
    desk_redis_wrapper:get_desk_attr_string(DeskId, "room_id").

set_desk_roomid(DeskId, RoomId) ->
    desk_redis_wrapper:set_desk_attr(DeskId, "room_id", RoomId).

remove_desk_roomid(DeskId) ->
    desk_redis_wrapper:remove_desk_attr(DeskId, "room_id").


%% 叫地主专用
%% 之前最后一次叫地主的人是谁
get_desk_last_jiao_di_zhu_userid(DeskId) ->
    desk_redis_wrapper:get_desk_attr_string(DeskId, "last_jiao_di_zhu_userid").

set_desk_last_jiao_di_zhu_userid(DeskId, LastJiaoDiZhuUserId) ->
    desk_redis_wrapper:set_desk_attr(DeskId, "last_jiao_di_zhu_userid", LastJiaoDiZhuUserId).

remove_desk_last_jiao_di_zhu_userid(DeskId) ->
    desk_redis_wrapper:remove_desk_attr(DeskId, "last_jiao_di_zhu_userid").

%% 用来循环输出的
get_desk_first_previous_jiao_di_zhu_userid(DeskId) ->
    desk_redis_wrapper:get_desk_attr_string(DeskId, "first_previous_jiao_di_zhu_userid").

set_desk_first_previous_jiao_di_zhu_userid(DeskId, FirstPreviousJiaoDiZhuUserId) ->
    desk_redis_wrapper:set_desk_attr(DeskId, "first_previous_jiao_di_zhu_userid", FirstPreviousJiaoDiZhuUserId).

remove_desk_first_previous_jiao_di_zhu_userid(DeskId) ->
    desk_redis_wrapper:remove_desk_attr(DeskId, "first_previous_jiao_di_zhu_userid").

get_desk_second_previous_jiao_di_zhu_userid(DeskId) ->
    desk_redis_wrapper:get_desk_attr_string(DeskId, "second_previous_jiao_di_zhu_userid").

set_desk_second_previous_jiao_di_zhu_userid(DeskId, SecondPreviousJiaoDiZhuUserId) ->
    desk_redis_wrapper:set_desk_attr(DeskId, "second_previous_jiao_di_zhu_userid", SecondPreviousJiaoDiZhuUserId).

remove_desk_second_previous_jiao_di_zhu_userid(DeskId) ->
    desk_redis_wrapper:remove_desk_attr(DeskId, "second_previous_jiao_di_zhu_userid").

%% 一共4次叫地主，当前第几次
get_desk_jiao_di_zhu_request_index(DeskId) ->
    desk_redis_wrapper:get_desk_attr_int(DeskId, "jiao_di_zhu_request_index").

inc_desk_jiao_di_zhu_request_index(DeskId) ->
    Index = get_desk_jiao_di_zhu_request_index(DeskId),
    desk_redis_wrapper:set_desk_attr(DeskId, "jiao_di_zhu_request_index", Index + 1).

remove_desk_jiao_di_zhu_request_index(DeskId) ->
    desk_redis_wrapper:remove_desk_attr(DeskId, "jiao_di_zhu_request_index").

%% 当前叫了地主的人的个数
get_desk_jiao_di_zhu_users_count(DeskId) ->
    desk_redis_wrapper:get_desk_attr_int(DeskId, "jiao_di_zhu_users_count").

inc_desk_jiao_di_zhu_users_count(DeskId) ->
    Index = get_desk_jiao_di_zhu_users_count(DeskId),
    desk_redis_wrapper:set_desk_attr(DeskId, "jiao_di_zhu_users_count", Index + 1).

remove_desk_jiao_di_zhu_users_count(DeskId) ->
    desk_redis_wrapper:remove_desk_attr(DeskId, "jiao_di_zhu_users_count").

%% 叫地主结束以后，设置桌子地主
get_desk_dizhu(DeskId) ->
    desk_redis_wrapper:get_desk_attr_string(DeskId, "dizhu").

set_desk_dizhu(DeskId, DiZhu) ->
    desk_redis_wrapper:set_desk_attr(DeskId, "dizhu", DiZhu).

remove_desk_dizhu(DeskId) ->
    desk_redis_wrapper:remove_desk_attr(DeskId, "dizhu").

%% 设置桌子的底牌
get_desk_di_pai_cards(DeskId) ->
    ListName = "di_pai_cards_on_desk_" ++ DeskId,
    CardList = redis_wrapper:get_list(ListName),
    lists:map(
        fun(CardString) ->
            data_convert:string_to_number(CardString)
        end,
        CardList
    ).

set_desk_di_pai_cards(DeskId, Cards) ->
    remove_desk_di_pai_cards(DeskId),
    ListName = "di_pai_cards_on_desk_" ++ DeskId,

    lists:foreach(
        fun(Card) ->
            redis_wrapper:add_to_list(ListName, Card)
        end,
        Cards
    ).

remove_desk_di_pai_cards(DeskId) ->
    Cards = get_desk_di_pai_cards(DeskId),
    ListName = "di_pai_cards_on_desk_" ++ DeskId,

    lists:foreach(
        fun(Card) ->
            redis_wrapper:remove_from_list(ListName, Card)
        end,
        Cards
    ).

%% 上一次出的最大的牌的用户id
get_desk_previous_zui_da_chu_pai_userid(DeskId) ->
    desk_redis_wrapper:get_desk_attr_string(DeskId, "previous_zui_da_chu_pai_userid").

set_desk_previous_zui_da_chu_pai_userid(DeskId, UserId) ->
    desk_redis_wrapper:set_desk_attr(DeskId, "previous_zui_da_chu_pai_userid", UserId).

remove_desk_previous_zui_da_chu_pai_userid(DeskId) ->
    desk_redis_wrapper:remove_desk_attr(DeskId, "previous_zui_da_chu_pai_userid").

get_desk_second_previous_chu_pai_userid(DeskId) ->
    desk_redis_wrapper:get_desk_attr_string(DeskId, "second_previous_chu_pai_userid").

set_desk_second_previous_chu_pai_userid(DeskId, UserId) ->
    desk_redis_wrapper:set_desk_attr(DeskId, "second_previous_chu_pai_userid", UserId).

remove_desk_second_previous_chu_pai_userid(DeskId) ->
    desk_redis_wrapper:remove_desk_attr(DeskId, "second_previous_chu_pai_userid").

%% 为了自动出牌，自动叫地主等行为配置，叫地主，出牌，等等都要用
get_desk_playing_status(DeskId) ->
    desk_redis_wrapper:get_desk_attr_int(DeskId, "playing_status").

set_desk_playing_status(DeskId, Playing) ->
    desk_redis_wrapper:set_desk_attr(DeskId, "playing_status", Playing).

remove_desk_playing_status(DeskId) ->
    desk_redis_wrapper:remove_desk_attr(DeskId, "playing_status").

%% 当前在桌子里面，当前用户id
get_desk_current_userid(DeskId) ->
    desk_redis_wrapper:get_desk_attr_string(DeskId, "current_userid").

set_desk_current_userid(DeskId, CurrentRequestUserId) ->
    desk_redis_wrapper:set_desk_attr(DeskId, "current_userid", CurrentRequestUserId).

remove_desk_current_userid(DeskId) ->
    desk_redis_wrapper:remove_desk_attr(DeskId, "current_userid").