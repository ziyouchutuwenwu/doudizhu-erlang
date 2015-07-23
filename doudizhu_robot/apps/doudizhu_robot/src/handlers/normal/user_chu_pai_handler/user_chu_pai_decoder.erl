-module(user_chu_pai_decoder).

-export([decode/1]).

%返回{NextChuPaiUserId}
decode(InfoBin) ->
    InfoRec = json:from_binary(InfoBin),

    NextChuPaiUserId = binary_to_list(json:get(<<"/nextUser/id">>, InfoRec)),
    {NextChuPaiUserId}.