-module(tcp_server_listener).
-behaviour(gen_server).

-export([start_link/2]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-record(server_state, {server_port}).

start_link(Name, Port) ->
    State = #server_state{server_port = Port},
    gen_server:start_link({local, Name}, ?MODULE, State, []).

init(State = #server_state{server_port = Port}) ->
    Options = tcp_server_options:get_tcp_options(),

    case gen_tcp:listen(Port, Options) of
        {ok, LSocket} ->
            case tcp_server_handler_sup:start_link(LSocket) of
                {ok, _Pid} ->
                    tcp_server_handler_sup:start_child(),
                    {ok, State};
                {error, Reason} ->
                    {stop, {create_tcp_handler, Reason}}
            end;
        {error, Reason} ->
            {stop, {create_listen_socket, Reason}}
    end.

handle_cast(_Request, State) ->
    {noreply, State}.

handle_call(_Request, _From, State) ->
    {reply, ok, State}.

handle_info(_Info, State) ->
    {noreply, State}.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.