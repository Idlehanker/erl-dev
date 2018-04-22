-module(ex2).
-export([print_all/1, all_print/1]).

print_all([]) ->
    io:format("~n");
print_all([H|T]) ->
    io:format("~p\t",[H]),
    print_all(T).
    
% use case of expression.
all_print(X) ->
    case X of
        [] -> io:format("~n");
        [H|T] -> io:format("~p\t", [H]),
        all_print(T)
    end.