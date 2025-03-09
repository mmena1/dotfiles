# Dotfiles Assistant Guide

## Commands
- Update dotfiles: `chezmoi update`
- Update from source repo: `chezmoi update -R`
- Apply changes: `chezmoi apply`
- View differences: `chezmoi diff`
- Add a file: `chezmoi add ~/.config/file`
- Edit a file: `chezmoi edit ~/.config/file`
- Execute script: `chezmoi execute-template < script.tmpl`

## Task Management
- Tasks are defined in `run_once_after_setup.sh.tmpl`
- Add new tasks by editing the task registration section

## Code Style Guidelines
- **Indentation**: 2 spaces for most files, 4 spaces for Python and Fish files
- **Line endings**: Unix-style (LF), with final newline in each file
- **Character encoding**: UTF-8
- **Whitespace**: Trim trailing whitespace
- **Git commits**: Use descriptive messages with present tense verbs
- **Fish functions**: Follow Fish's convention of using `__name.function` for helper functions
- **Templating**: Use Chezmoi's templating features for OS-specific configurations
- **Comments**: Include references to inspirations and document non-obvious behavior

This repository manages dotfiles using [chezmoi](https://www.chezmoi.io/) and is optimized for Fish shell. All installation logic is centralized in modular task-based scripts.
