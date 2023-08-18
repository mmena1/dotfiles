# Martin Mena’s dotfiles


This is my personal dotfiles configuration for 🐟 [Fish](https://fishshell.com/) shell.

<p align="center">
  <img alt="Shell demo" src="https://user-images.githubusercontent.com/4404853/211977100-8a39ffda-594c-4460-bd73-da09c7aa1d4e.gif" width="980px">
</p>


## Features

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

## Installation

> NOTE: Only works for Ubuntu and Arch based distros. May change in the future.

Dotfiles are installed by running the following commands in your terminal:


```sh
# Clone dotfiles repo
git clone https://github.com/mmena1/dotfiles.git $HOME/.dotfiles

# Go to the dotfiles directory
cd $HOME/.dotfiles

# Install dotfiles
./install
```

## Updating

Use this single command to get the latest updates:

```
update
```

This command will update dotfiles and system packages.

## Under the hood

### Custom Fish scripts

- I included custom fish scripts by adapting from oh-my-zsh, like git and exa abbreviations.
- Fish doesn't need plugins as zsh does. Just some personal touches :sunglasses:

### Dotbot

It uses [dotbot](https://github.com/anishathalye/dotbot) as a github submodule to manage dotfiles.
What it basically does is to symlink the files from `home` and `config` directories
into your `~` home folder and then run the bootstrap scripts to setup the system apps I personally use.

## Thanks to...

- [GitHub ❤ ~/](https://dotfiles.github.io/) for its great dotfiles repo list.
- [Denys Dovhan’s dotfiles](https://github.com/denysdovhan/dotfiles) for providing the
  base structure and starting point for this repo.
- [Adam Eivy's dotfiles](https://github.com/atomantic/dotfiles) for his awesome bot scripts and inspiration.
- [Sebastián Estrella](https://github.com/sestrella/dotfiles) for introducing me
  into the dotfile management world in [my old dotfile repo](https://github.com/mmena1/dotfiles-old).
- [LFreza](https://github.com/LucasFrezarini) for sharing memes at work :trollface:
## License

ISC © [Martin Mena](https://github.com/mmena1)
