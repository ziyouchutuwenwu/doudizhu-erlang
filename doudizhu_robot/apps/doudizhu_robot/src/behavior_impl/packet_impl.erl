-module(packet_impl).
-behaviour(packet_behavior).

-export([unpack/1, pack/2]).

unpack(DataBytes) ->
    <<Cmd:16, InfoBin/binary>> = DataBytes,
    {Cmd, InfoBin}.

pack(Cmd, InfoBin) ->
    <<Cmd:16, InfoBin/binary>>.