-module(sort_helper).

-export([random_set_userlist_play_index/1, get_userlist_by_play_index/1]).
-export([loop_get_previous_userid/2, loop_get_next_userid/2]).

-export([get_left_user/2, get_right_user/2]).

%% 随机获取一个节点号(从1开始)分为两段，前面的列表接到后面的列表上;然后把用户id对应的顺序号写入redis
random_set_userlist_play_index(UserIdList) ->
    SplitIndex = random_generator:random_number() rem length(UserIdList),
    {L1, L2} = lists:split(SplitIndex, UserIdList),
    SortedUserIdList = lists:append(L2, L1),

    IndexList = lists:seq(1, length(SortedUserIdList)),
    List = lists:zip(SortedUserIdList, IndexList),
    lists:foreach(
        fun({UserId, Index}) ->
            user_helper:set_user_play_index(UserId, Index)
        end,
        List
    ).

%% 根据用户id在redis里面的索引号（play_index）,拼出用户id顺序列表
get_userlist_by_play_index(UserIdList) ->
    List = lists:map(
        fun(UserId) ->
            Index = user_helper:get_user_play_index(UserId),
            {UserId, Index}
        end,
        UserIdList
    ),

    SortedList = lists:keysort(2, List),
    {SortedUserList, _} = lists:unzip(SortedList),
    SortedUserList.

%% 从顺序列表里面循环获取上一个操作的用户
loop_get_previous_userid(UserId, UserIdList) ->
    IndexList = lists:seq(1, length(UserIdList)),
    List = lists:zip(UserIdList, IndexList),

    {_, Index} = lists:keyfind(UserId, 1, List),

    PreviousUserId = (
            case Index == 1 of
                true ->
                    lists:nth(length(UserIdList), UserIdList);
                _ ->
                    lists:nth(Index - 1, UserIdList)
            end
    ),
    PreviousUserId.

%% 从顺序列表里面循环获取下一个操作的用户
loop_get_next_userid(UserId, UserIdList) ->
    IndexList = lists:seq(1, length(UserIdList)),
    List = lists:zip(UserIdList, IndexList),

    {_, Index} = lists:keyfind(UserId, 1, List),

    NextUserId = (
            case Index == length(UserIdList) of
                true ->
                    [Result | _] = UserIdList,
                    Result;
                _ ->
                    lists:nth(Index + 1, UserIdList)
            end
    ),
    NextUserId.

get_right_user(UserId, UsersOnDesk) ->
    RightUserId = (
            case length(UsersOnDesk) of
                0 ->
                    "";
                1 ->
                    "";
                2 ->
                    UserId1 = lists:nth(1, UsersOnDesk),
                    UserId2 = lists:nth(2, UsersOnDesk),

                    case string:equal(UserId, UserId1) of
                        true ->
                            UserId2;
                        _ ->
                            ""
                    end;
                _ ->
                    sort_helper:loop_get_next_userid(UserId, UsersOnDesk)
            end
    ),
    RightUserId.

get_left_user(UserId, UsersOnDesk) ->
    LeftUserId = (
            case length(UsersOnDesk) of
                0 ->
                    "";
                1 ->
                    "";
                2 ->
                    UserId1 = lists:nth(1, UsersOnDesk),
                    UserId2 = lists:nth(2, UsersOnDesk),

                    case string:equal(UserId, UserId2) of
                        true ->
                            UserId1;
                        _ ->
                            ""
                    end;
                _ ->
                    sort_helper:loop_get_previous_userid(UserId, UsersOnDesk)
            end
    ),
    LeftUserId.