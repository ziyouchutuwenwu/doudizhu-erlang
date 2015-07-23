-module(room_helper).

-export([get_roomids_by_level/1]).
-export([get_room_level/1, set_room_level/2, remove_user_level/1]).

get_roomids_by_level(Level) when is_integer(Level) ->
%%     List = redis_wrapper:get_zset("rooms"),
    List = redis_wrapper:get_list("rooms"),
    RoomIdList = lists:filter(
        fun(RoomId) ->
            case get_room_level(RoomId) of
                Level ->
                    true;
                _ ->
                    false
            end
        end,
        List
    ),
    RoomIdList.

%设置房间一些属性
get_room_level(RoomId) ->
    room_redis_wrapper:get_room_attr_int(RoomId, "level").

set_room_level(RoomId, Level) ->
    room_redis_wrapper:set_room_attr(RoomId, "level", Level).

remove_user_level(RoomId) ->
    room_redis_wrapper:remove_room_attr(RoomId, "level").