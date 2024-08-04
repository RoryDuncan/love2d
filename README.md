# README

1. Install lua and love
2. Run `love .` from within the root of the directory, or `love ./path/to/main.lua`


## Architecture

```sh
.
├── README.md
├── core - things that are able to be copied across games
├── game - things related to this specific game
├── main.lua - entrypoint for love2d
└── scenes - scenes of this game
```