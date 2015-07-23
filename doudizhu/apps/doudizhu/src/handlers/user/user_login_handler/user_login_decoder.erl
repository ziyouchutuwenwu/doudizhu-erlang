-module(user_login_decoder).

-export([decode/1]).

%返回{UserName,Password,DeviceName,OsName,OsVersion,DeviceId}
decode(InfoBin) ->
    InfoRec = json:from_binary(InfoBin),

    UserName = binary_to_list(json:get(<<"/userName">>, InfoRec)),
    Password = binary_to_list(json:get(<<"/password">>, InfoRec)),

    DeviceName = binary_to_list(json:get(<<"/deviceName">>, InfoRec)),
    OsName = binary_to_list(json:get(<<"/osName">>, InfoRec)),
    OsVersion = binary_to_list(json:get(<<"/osVersion">>, InfoRec)),
    DeviceId = binary_to_list(json:get(<<"/deviceId">>, InfoRec)),

    {UserName, Password, DeviceName, OsName, OsVersion, DeviceId}.