-module(tut3).
-export([conv/1]).

conv({centimeter, X}) ->
    {inch, X / 2.54};
conv({inch, X}) ->
    {centimeter, X * 2.54}.