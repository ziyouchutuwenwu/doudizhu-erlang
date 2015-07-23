-module(data_convert).

-export([number_to_string/1, string_to_number/1]).

number_to_string(Number) ->
    lists:flatten(io_lib:format("~p", [Number])).

string_to_number(String) ->
    try list_to_float(String)
    catch
        error:badarg ->
            list_to_integer(String)
    end.