-module(utf8_list).

-export([list_to_binary/1]).

list_to_binary(List) ->
    unicode:characters_to_binary(List).