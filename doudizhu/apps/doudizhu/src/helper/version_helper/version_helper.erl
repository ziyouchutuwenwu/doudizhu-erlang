-module(version_helper).

-export([get_latested_version_info/2]).

get_latested_version_info(Platform, AppId) ->
    case sql_helper:get_latested_version_info(Platform, AppId) of
        {ok, {LatestedVersion, Url}} ->
            {LatestedVersion, Url};
        {error, not_found} ->
            LatestedVersion = 0.0,
            Url = "",
            {LatestedVersion, Url};
        _ ->
            LatestedVersion = 0.0,
            Url = "",
            {LatestedVersion, Url}
    end.