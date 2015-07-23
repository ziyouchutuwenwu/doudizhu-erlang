-module(node_name_helper).

-export([get_port_worker_nodes/1]).

get_port_worker_nodes(NodePrefix) ->
    PortWorkerNodes = lists:filter(
        fun(NodeName) ->
            NodeNameStr = atom_to_list(NodeName),
            PrefixFromList = string:substr(string:to_lower(NodeNameStr), 1, length(NodePrefix)),

            case length(NodePrefix) of
                0 ->
                    true;
                _ ->
                    case string:equal(NodePrefix, PrefixFromList) of
                        true ->
                            true;
                        _ ->
                            false
                    end
            end
        end,
        nodes()),
    PortWorkerNodes.