-module(pgsql_conn_pool_query_test).

-compile(export_all).

start_pool() ->
    pgsql_conn_pool_sup:start_link().

create_table_test() ->
    Cmd = "DROP TABLE IF EXISTS users;
        create table users
        (
        id serial primary key,
        title text,
        content text,
        createdtime time
        );",
    Info = pgsql_conn_pool_query:squery(Cmd),
    io:format("create_table_test ~p~n", [Info]).

select_test() ->
    Cmd = "SELECT title,content FROM users;",
    {ok, _, Rows} = pgsql_conn_pool_query:squery(Cmd),
    lists:foreach(
        fun(Row) ->
            {TitleBin, ContentBin} = Row,
            Title = binary_to_atom(TitleBin, utf8),
            Content = binary_to_atom(ContentBin, utf8),
            io:format("select_test ~p,~p~n", [Title, Content])
        end,
        Rows),
    ok.

update_test() ->
    Cmd = "update users set title='ppp' where id=3;",
    {ok, Count} = pgsql_conn_pool_query:squery(Cmd),
    io:format("update_test ~p~n", [Count]).

insert_test() ->
    Cmd = "INSERT INTO users(title,content) values('aasa','ddd');",
    {ok, Count} = pgsql_conn_pool_query:squery(Cmd),
    io:format("insert_test ~p~n", [Count]).

delete_test() ->
    Cmd = "DELETE FROM users WHERE id=3;",
    {ok, Count} = pgsql_conn_pool_query:squery(Cmd),
    io:format("delete_test ~p~n", [Count]).