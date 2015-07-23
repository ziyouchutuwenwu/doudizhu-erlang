-module(desk_redis_wrapper).

-export([get_desk_attr_string/2, get_desk_attr_int/2, set_desk_attr/3, remove_desk_attr/2]).

get_desk_attr_string(DeskId, Attr) ->
    MapName = "desk_" ++ DeskId,
    redis_wrapper:get_map_value_string(MapName, Attr).

get_desk_attr_int(DeskId, Attr) ->
    MapName = "desk_" ++ DeskId,
    redis_wrapper:get_map_value_int(MapName, Attr).

set_desk_attr(DeskId, Attr, Val) ->
    MapName = "desk_" ++ DeskId,
    redis_wrapper:set_map_value(MapName, Attr, Val).

remove_desk_attr(DeskId, Attr) ->
    MapName = "desk_" ++ DeskId,
    redis_wrapper:remove_map_value(MapName, Attr).