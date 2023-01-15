# Martin Mena’s dotfiles


This is my personal dotfiles configuration.

<p align="center">
  <img alt="Shell demo" src="https://user-images.githubusercontent.com/4404853/211977100-8a39ffda-594c-4460-bd73-da09c7aa1d4e.gif" width="980px">
</p>


Here are some notes:

- My weapon of choice is Arch/Manjaro.
  - May change in the future, but now I'm happy with Arch based distros.
- Fish and Zsh configurations.
  - I used to work with Zsh / ["Oh My ZSH!"](http://ohmyz.sh/), but I'm currently using Fish with custom configurations.
  - I still have my old zsh configuration as a backup in case I stumble upon incompatible scripts/commands (happened once to me).
- [⭐️🚀 Starship](https://starship.rs/) as a prompt.
- [nyan cat](./bin/nyan).

  ![image](https://user-images.githubusercontent.com/4404853/211462357-b33b64a8-075e-458b-8e26-0e6494db993d.png)

- Dotfile management with [dotbot](https://github.com/anishathalye/dotbot).
- `update` script for updating dotfiles, system packages, etc.
- Will detect your OS and install the corresponding packages (only works for Arch/Manjaro for now).
- Guided script that will require user input before doing anything.
- Better [ls](https://the.exa.website/) command.
- [Tmux](https://github.com/tmux/tmux) with the awesome [configuration by gpakosz](https://github.com/gpakosz/.tmux).

  ![Screenshot](https://cloud.githubusercontent.com/assets/553208/19740585/85596a5a-9bbf-11e6-8aa1-7c8d9829c008.gif)

## Zsh features
- ["Oh My ZSH!"](http://ohmyz.sh/)
- 🐟 [Fish](https://fishshell.com/) features for zsh:
  - 🐟 [Fish](https://fishshell.com/docs/current/interactive.html#autosuggestions)-like [autosuggestions](https://github.com/zsh-users/zsh-autosuggestions).
  - 🐟 [Fish](https://fishshell.com/docs/current/interactive.html#syntax-highlighting)-like [syntax highlighting](https://github.com/zsh-users/zsh-syntax-highlighting) of commands while they are typed.
  - 🐟 [Fish](https://fishshell.com/docs/current/interactive.html#searchable-command-history)-like [substring search for history](https://github.com/zsh-users/zsh-history-substring-search).
- [antigen](https://github.com/zsh-users/antigen) for dependency management.
- Useful [aliases](./lib/aliases.zsh).
- Git [aliases](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/git).

## Fish features

- :zap: Blazing fast - No 3rd-party plugins or frameworks, just my custom scripts that I adapted from oh-my-zsh.
- Same as zsh features from above, without the baggage of oh-my-zsh.

## Installation

Dotfiles are installed by running the following commands in your terminal:


```sh
# Clone dotfiles repo
git clone https://github.com/mmena1/dotfiles.git $HOME/.dotfiles

# Go to the dotfiles directory
cd $HOME/.dotfiles

# Install dotfiles
./install
```

## TODOs / Planned features

- [x] Remove [Kitty](https://sw.kovidgoyal.net/kitty/) :smiley_cat: and try to make tmux work on fish.
  - I prefer not to depend on terminal programs and use whatever comes by default on the system.
  - Kitty was good but I'm already used to tmux and it's shortcuts.
- [ ] Choice between Zsh and Fish (or both) instead of forcing both of them during installation.
- [ ] Option for unattended script that installs the default config without prompting the user.
- [ ] Support for Ubuntu/Debian.
- [ ] Remove support for Manjaro since it has some [issues](https://manjarno.snorlax.sh/).
  - I think [EndeavourOS](https://endeavouros.com/) is much closer to a pure Arch experience.
  - Manjaro does it's own things like delaying updates which may break some AUR packages
  and installing some [bloatware](https://gitlab.manjaro.org/profiles-and-settings/iso-profiles/-/blob/master/manjaro/kde/Packages-Desktop) by default that I will never use.
- [ ] Migrate to [chezmoi](https://www.chezmoi.io/).
- [ ] (Maybe) Support for MacOS - I'm not a fan of MacOS, but sometimes I'm forced to work with it.
  If that happens in the future, I may reconsider adding support for it.

## Updating

Use this single command to get the latest updates:

```
update
```

This command will update dotfiles, their dependencies (zsh) and system packages.

## Under the hood

### Oh-My-Zsh plugins

These OMZ plugins are included:

- [`git`](https://github.com/robbyrussell/oh-my-zsh/tree/master/plugins/git) - git aliases and functions.
- [`docker`](https://github.com/robbyrussell/oh-my-zsh/tree/master/plugins/docker) - provides docker completion as well as adding useful aliases.
- [`asdf`](https://github.com/robbyrussell/oh-my-zsh/tree/master/plugins/asdf) - Adds integration with [asdf](https://asdf-vm.com/).
- [`ssh-agent`](https://github.com/robbyrussell/oh-my-zsh/tree/master/plugins/ssh-agent) - automatically starts ssh-agent to set up and load whichever credentials you want for ssh connections.
- More are listed in [`.antigenrc`](./home/antigenrc) (it's hard to keep the list updated :weary:).

## Tip jar

If you wanna buy me a coffee, it's always appreciated :)

[![ko-fi](https://ko-fi.com/img/githubbutton_sm.svg)](https://ko-fi.com/P5P0HNRJ6)

## Thanks to...

- [GitHub ❤ ~/](http://dotfiles.github.com/) for its great dotfiles repo list.
- [Denys Dovhan’s dotfiles](https://github.com/denysdovhan/dotfiles) for providing the
  base structure and starting point for this repo.
- [Adam Eivy's dotfiles](https://github.com/atomantic/dotfiles) for his awesome bot scripts and inspiration.
- [Sebastián Estrella](https://github.com/sestrella/dotfiles) for introducing me
  into the dotfile management world in [my old dotfile repo](https://github.com/mmena1/dotfiles-old).
- [LFreza](https://github.com/LucasFrezarini) for sharing memes at work :trollface:
## License

ISC © [Martin Mena](https://github.com/mmena1)
