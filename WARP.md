# WARP.md

This file provides guidance to WARP (warp.dev) when working with code in this repository.

## Repository Overview

This is ThePrimeagen's Neovim configuration written in Lua. It's a modern, minimal setup focused on productivity with carefully chosen plugins and keybindings. The configuration emphasizes speed, simplicity, and practical development workflows.

## Architecture

### Configuration Structure
- **Entry Point**: `init.lua` - Simple entry that requires the main configuration module
- **Core Module**: `lua/theprimeagen/` - Contains all core configuration files
  - `init.lua` - Main initialization, autocommands, and plugin loading orchestration
  - `set.lua` - Vim options and editor settings (tabs, search, undo, etc.)
  - `remap.lua` - Custom keybindings and leader key mappings
  - `packer.lua` - Plugin management using Packer.nvim
- **Plugin Configurations**: `after/plugin/` - Individual plugin setup files that load after plugins are installed

### Key Architectural Patterns
- **Modular Design**: Each plugin gets its own configuration file in `after/plugin/`
- **Leader Key Strategy**: Space (` `) as leader with logical groupings (e.g., `<leader>p*` for project/file operations)
- **LSP Integration**: Centralized LSP setup with language-specific configurations (TypeScript, Vue, Deno)
- **Autocommand Groups**: Organized autocommands for highlighting yanked text and whitespace cleanup

## Common Development Tasks

### Plugin Management
```bash
# Install/update plugins (run from within Neovim)
:PackerSync
:PackerInstall
:PackerUpdate
```

### Testing Configuration Changes
```bash
# Source the configuration to test changes
nvim -c "so"
# Or use the built-in leader mapping: <leader><leader>
```

### Git Integration
The configuration includes extensive Git workflow support:
- Fugitive for Git operations (`<leader>gs` for Git status)
- LazyGit integration (`<leader>lz`)
- Automatic push/pull mappings within Fugitive buffers

### Navigation and File Management
- **Telescope**: Fuzzy finding for files (`<leader>pf`), Git files (`<C-p>`), and grep (`<leader>ps`)
- **Harpoon**: Quick file switching between frequently used files (`<leader>a` to add, `<C-e>` for menu)
- **Neo-tree**: File explorer with modern interface

## Language Support

### TypeScript/JavaScript
- **LSP**: TypeScript server with proper formatting (2-space indentation)
- **Formatting**: Automatic formatting on save and manual formatting with `<leader>f`

### Vue.js
- **Volar LSP**: Full Vue 3 support with TypeScript integration
- **Auto-formatting**: Configured for 2-space indentation with automatic formatting on save
- **Template Support**: Proper syntax highlighting and completion

### Deno vs Node.js
The configuration intelligently handles both Deno and Node.js projects:
- Deno LSP activates in directories with `deno.json` or `import_map.json`
- TypeScript server activates in directories with `package.json`
- Automatic conflict resolution prevents both from running simultaneously

## Key Features

### Text Editing Enhancements
- **Treesitter**: Advanced syntax highlighting and code parsing
- **LSP Zero**: Simplified LSP configuration with sensible defaults
- **Smart Yanking**: Visual feedback when copying text
- **Undo Tree**: Persistent undo history with visual tree navigation

### Development Workflow
- **Trouble**: Diagnostics and quickfix list management
- **Refactoring**: Advanced refactoring operations via Telescope integration
- **Zen Mode**: Distraction-free coding environment
- **Cloak**: Sensitive information hiding in configuration files

## Important Keybindings

### Core Navigation
- `<leader>pv` - File explorer (netrw)
- `<leader>pf` - Find files (Telescope)
- `<C-p>` - Git files (Telescope)
- `<leader>ps` - Project search/grep

### Harpoon (Quick File Switching)
- `<leader>a` - Add current file to harpoon
- `<C-e>` - Toggle harpoon menu
- `<C-h>`, `<C-t>`, `<C-n>`, `<C-s>` - Navigate to harpoon files 1-4

### LSP Operations
- `gd` - Go to definition
- `K` - Hover documentation
- `<leader>ca` - Code actions
- `<leader>vrr` - Find references
- `<leader>vrn` - Rename symbol
- `<leader>f` - Format buffer

### Git Operations
- `<leader>gs` - Git status (Fugitive)
- `<leader>lz` - LazyGit
- Within Fugitive: `<leader>p` (push), `<leader>P` (pull --rebase)

## Prerequisites

Install [ripgrep](https://github.com/BurntSushi/ripgrep) for Telescope's live grep functionality:
```bash
# macOS
brew install ripgrep

# Ubuntu/Debian
apt install ripgrep
```

## Configuration Customization

### Adding New Plugins
1. Add the plugin to `lua/theprimeagen/packer.lua`
2. Create a configuration file in `after/plugin/[plugin-name].lua`
3. Run `:PackerSync` to install

### Modifying Settings
- **Editor settings**: Edit `lua/theprimeagen/set.lua`
- **Keybindings**: Edit `lua/theprimeagen/remap.lua`
- **Plugin-specific**: Edit the corresponding file in `after/plugin/`

## Development Notes

### File Organization Philosophy
- Configuration is split into logical, focused modules
- Plugin configurations are isolated in `after/plugin/` for clean separation
- Keybindings follow consistent patterns with the space leader key

### LSP Configuration Strategy
- Uses LSP Zero as a foundation with minimal configuration overhead
- Language servers are auto-installed via Mason
- Custom configurations overlay LSP Zero defaults for specific needs (Vue, TypeScript formatting)
