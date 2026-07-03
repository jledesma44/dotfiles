# Claude Instructions for this repo

## Repository overview

Consolidated multi-profile dotfiles repo managed with [dotbot](https://github.com/anishathalye/dotbot).

- `shared/` + `base.yaml` — links and setup scripts common to all machines
- `macos/`, `archbook/`, `archmini-m1/` + matching `<profile>.yaml` — machine-specific configs
- `./install` — installs base only
- `./install <profile>` — installs base, then that profile
- To add a new machine: create a `<name>/` folder and a `<name>.yaml` at the repo root; the install script picks it up automatically
- `dotbot/` is a git submodule (vendored tool) — never modify its contents

## Commits

- Never add `Co-Authored-By` or any Claude attribution lines to commit messages.

## Conventions

- No emojis in code unless explicitly requested
- No explanatory comments unless asked
- Follow existing patterns; keep changes minimal and focused
- Dotbot yaml: 2-space indentation; shell script paths are relative to the repo root (e.g. `macos/1.Scripts/foo.zsh`)

### Karabiner (macos/karabiner, TypeScript)

- `yarn install`, then `yarn run build` compiles `rules.ts` to `karabiner.json` (`yarn run watch` to rebuild on change)
- Prettier formatting, 2-space indent, strict typing
