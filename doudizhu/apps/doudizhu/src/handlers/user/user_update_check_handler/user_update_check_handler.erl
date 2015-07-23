-module(user_update_check_handler).

-export([handle_request/3]).

handle_request(Pid, Cmd, InfoBin) ->
    io:format("版本更新~p~n", [InfoBin]),
    {OsName, AppId, ClientVersion} = user_update_check_decoder:decode(InfoBin),
    {LatestedVersion, Url} = version_helper:get_latested_version_info(OsName, AppId),

%%     服务器版本需要大于客户端的版本，才返回具体的url
    UpdateUrl = (
            case LatestedVersion > ClientVersion of
                true ->
                    Url;
                _ ->
                    ""
            end
    ),
    JsonBin = user_update_check_encoder:encode(UpdateUrl, OsName),
    tcp_send:send_data(Pid, Cmd, JsonBin),
    ok.