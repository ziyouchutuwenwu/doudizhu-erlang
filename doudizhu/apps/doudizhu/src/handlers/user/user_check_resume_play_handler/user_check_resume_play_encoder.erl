-module(user_check_resume_play_encoder).

-export([encode/1]).

encode(ShouldResumePlay) ->
    Response = #{
        <<"shouldResumePlay">> => ShouldResumePlay
    },
    JsonBin = json:to_binary(Response),
    JsonBin.