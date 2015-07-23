-module(user_guest_login_decoder).

-export([decode/1]).

%返回{DeviceName,OsName,OsVersion,DeviceId}
decode(InfoBin) ->
    InfoRec = json:from_binary(InfoBin),

    DeviceName = binary_to_list(json:get(<<"/deviceName">>, InfoRec)),
    OsName = binary_to_list(json:get(<<"/osName">>, InfoRec)),
    OsVersion = binary_to_list(json:get(<<"/osVersion">>, InfoRec)),
    DeviceId = binary_to_list(json:get(<<"/deviceId">>, InfoRec)),

    {DeviceName, OsName, OsVersion, DeviceId}.