-module(codec_impl).
-behaviour(codec_behavior).

-export([encode/1, decode/1]).

encode(DataBytes) ->
    DataBytes.

decode(DataBytes) ->
    DataBytes.