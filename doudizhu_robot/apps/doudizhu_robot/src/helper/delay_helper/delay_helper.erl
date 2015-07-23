-module(delay_helper).

-export([delay_cast/3]).

delay_cast(Duration, {Module, CallBack}, Args) ->
    erlang:send_after(Duration, self(), {delay, Module, CallBack, Args}).