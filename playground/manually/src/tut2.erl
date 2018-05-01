-module(tut2).
-export([conv/2]).

conv(M, inch) ->
    M / 2.54;
conv(N, centimeter) ->
    N * 2.54.
    