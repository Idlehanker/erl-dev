-module(client).
-export([start/0, alloc/0, free/1, init/0, handle_call/2, handle_cast/2]).


start() ->
    server:start(client).

alloc() ->
    server:call(client, alloc).

free(Ch) ->
    server:cast(client, {free, Ch}).

init() ->
    channels().


%%------------------------------------
handle_call(alloc, Chs) ->
    alloc(Chs). 

handle_cast({free, Ch}, Chs) ->
    free(Ch, Chs).

%% helper functions
%%====================================
channels() ->
    {_Allocated  = [], _Free = lists:seq(1,100)}.

alloc({Allocated, [H|T] = _Free}) ->
    {H, {[H|Allocated], T}}.

free(Ch, {Alloc, Free}  = Channels) ->
    case lists:member(Ch, Alloc) of
        true ->
            {lists:delete(Ch, Alloc), [Ch|Free]};
        false ->
            Channels
    end.
