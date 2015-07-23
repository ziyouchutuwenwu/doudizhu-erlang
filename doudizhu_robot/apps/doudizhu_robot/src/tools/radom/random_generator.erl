-module(random_generator).

-export([random_number/0, now_to_number/0]).

random_number() ->
    Min = round(math:pow(10, 15)),
    Max = round(math:pow(10, 16)) - 1,
    Delta = Min - 1,
    <<A:32, B:32, C:32>> = crypto:strong_rand_bytes(12),
    Seed = {A, B, C},
    random:seed(Seed),
    random:uniform(Max - Delta) + Delta.

%11位，自从1979年
now_to_number() ->
    Now = calendar:datetime_to_gregorian_seconds(calendar:now_to_datetime(erlang:now())),
    <<A:32, B:32, C:32>> = crypto:strong_rand_bytes(12),
    Now + A + B + C.