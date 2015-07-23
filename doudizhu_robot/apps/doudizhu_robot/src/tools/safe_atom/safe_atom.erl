-module(safe_atom).

-export([list_to_atom/1]).

list_to_atom(List) when is_list(List) ->
    case catch (list_to_existing_atom(List)) of
        {'EXIT', _} -> erlang:list_to_atom(List);
        Atom when is_atom(Atom) -> Atom
    end.