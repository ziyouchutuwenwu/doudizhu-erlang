-module(crypt).

-export([md5/1]).

md5(Data) ->
    lists:flatten([io_lib:format("~2.16.0B", [D]) || D <- binary_to_list(erlang:md5(Data))]).