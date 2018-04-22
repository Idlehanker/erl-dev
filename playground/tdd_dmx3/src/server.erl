-module(server).
-export([start/1,call/2,cast/2, init/1]).

start(Mod) ->
    spawn(server, init, [Mod]).

init(Mod) ->
    register(Mod, self()),
    State = Mod:init(),
    loop(Mod, State).

%% call funtion 1
call(Name, Req) ->
    Name ! {call, self(), Req},
    receive
        {Name, Res} ->
            Res
    end.

%% call funtion 2
cast(Name, Req) ->
    Name ! {cast, Req},
    ok.

% FSM(Finite-state Machine)
loop(Mod, State) ->
    receive
        {call, From, Req} ->
            {Res, State2} = Mod:handle_call(Req, State),
            From ! {Mod, Res},
            loop(Mod, State2);
        {cast, Req} ->
            State2 = Mod:handle_cast(Req, State),
            loop(Mod, State2)
    end.
