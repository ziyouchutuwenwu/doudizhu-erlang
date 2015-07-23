-module(room_redis_wrapper).

-export([get_room_attr_string/2, get_room_attr_int/2, set_room_attr/3, remove_room_attr/2]).

get_room_attr_string(DeskId, Attr) ->
    MapName = "room_" ++ DeskId,
    redis_wrapper:get_map_value_string(MapName, Attr).

get_room_attr_int(DeskId, Attr) ->
    MapName = "room_" ++ DeskId,
    redis_wrapper:get_map_value_int(MapName, Attr).

set_room_attr(DeskId, Attr, Val) ->
    MapName = "room_" ++ DeskId,
    redis_wrapper:set_map_value(MapName, Attr, Val).

remove_room_attr(DeskId, Attr) ->
    MapName = "room_" ++ DeskId,
    redis_wrapper:remove_map_value(MapName, Attr).