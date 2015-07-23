-module(data_format).

-export([format/2]).

%% ~c 表示只接受 ASCII 码所表示的数字
%% ~f 表示浮点数输出，默认保留 6 为小数
%% ~w 表示输出一个 Erlang term
%% ~p 与 ~w 类似，不过 ~p 的输出是有格式的，默认一行的显示的最大长度为80，则多行时会自动换行
%% ~s 表示按字符串形式输出
%% ~n 表示换行符
%% ~ts表示translation string，用来显示unicode，支持中文
format(Format, Args) ->
    lists:flatten(io_lib:format(Format, Args)).