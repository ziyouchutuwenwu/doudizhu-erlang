-module(user_redis_wrapper).

-export([get_user_attr_string/2, get_user_attr_int/2, set_user_attr/3, remove_user_attr/2]).

get_user_attr_string(UserId, Attr) ->
    MapName = "user_" ++ UserId,
    redis_wrapper:get_map_value_string(MapName, Attr).

get_user_attr_int(UserId, Attr) ->
    MapName = "user_" ++ UserId,
    redis_wrapper:get_map_value_int(MapName, Attr).

set_user_attr(UserId, Attr, Val) ->
    MapName = "user_" ++ UserId,
    redis_wrapper:set_map_value(MapName, Attr, Val).

remove_user_attr(UserId, Attr) ->
    MapName = "user_" ++ UserId,
    redis_wrapper:remove_map_value(MapName, Attr).