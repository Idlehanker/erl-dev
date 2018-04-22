-module(ex3).
-export([filter/2,is_even/1]).

filter(P, []) -> [];
filter(P, [H|T]) ->
    case P(H) of
        true -> [H| filter(P, T)];
        false-> filter(P, T)
    end.

is_even(X) -> 
    X rem 2 == 0.
    
    
