-module(user_update_check_decoder).

-export([decode/1]).

%返回{OsName,AppId,AppVersion}
decode(InfoBin) ->

    InfoRec = json:from_binary(InfoBin),

    OsName = binary_to_list(json:get(<<"/osName">>, InfoRec)),
    AppId = binary_to_list(json:get(<<"/appId">>, InfoRec)),
    AppVersion = data_convert:string_to_number(binary_to_list(json:get(<<"/appVersion">>, InfoRec))),
    {OsName, AppId, AppVersion}.