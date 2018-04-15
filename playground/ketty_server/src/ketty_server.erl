-module(ketty_server).

-export([start_link/0]).

% start-link
start_link() -> spawn_link(fun init/0).

init() -> loop([]).

loop ( Cats ) -> .

