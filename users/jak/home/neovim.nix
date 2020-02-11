{ config, pkgs, lib, ... }:

# This file contains the configuration for NeoVim.

let
  cfg = config.unitas.jak;
in
  with pkgs; with lib; {
   home.sessionVariables."EDITOR" = "${config.programs.neovim.finalPackage}/bin/nvim";

   programs.neovim = {
     enable = true;
     viAlias = true;
     vimAlias = true;
#     withNodeJs = true;
     withPython = true;
     withPython3 = true;
     package = pkgs.neovim-unwrapped;
     plugins =
   		let
           sources = import ../../../nix/sources.nix;
         in
           # Define our own plugin list with pinned versions so that we can guarantee
           # a working configuration. Some plugins require `dontBuild` as they include
           # `Makefile`s to run tests and build docs.
           [
   					# Sensible defaults for Neovim.
             (pkgs.vimUtils.buildVimPlugin { name = "vim-sensible"; src = sources.neovim-sensible; })
             # Read .editorconfig file in directories
             (pkgs.vimUtils.buildVimPlugin { name = "editorconfig-vim"; src = sources.editorconfig-vim; })
   					# Helper for managing personal wiki
             (pkgs.vimUtils.buildVimPlugin { name = "vimwiki"; src = sources.vimwiki; })
             # Autocompletion/linting/fixing.
             (pkgs.vimUtils.buildVimPlugin { name = "ale"; src = sources.ale; })
             (
               pkgs.vimUtils.buildVimPlugin {
                 name = "deoplete.nvim";
                 src = sources."deoplete.nvim";
                 dontBuild = true;
               }
             )
             # Fuzzy file search.
             (pkgs.vimPlugins.fzfWrapper)
             (pkgs.vimUtils.buildVimPlugin { name = "fzf.vim"; src = sources."fzf.vim"; })
   				];
   	extraConfig =
   	''
   		""General settings
       "Show relative numbers and current line number
       set number
   		set relativenumber
       " Shortcutting split navigation, saving a keypress:
       map <C-h> <C-w>h
       map <C-j> <C-w>j
       map <C-k> <C-w>k
       map <C-l> <C-w>l

       ""Ale Settings
       " Tell ALE where to look for `compilation-commands.json`.
           let g:ale_c_build_dir_names = [ 'build', 'build_debug', 'bin' ]
           function! SearchBuildDirsOr(fallback_path)
             " Get the name of the binary from the fallback path.
             let binary_name = fnamemodify(a:fallback_path, ':t')
             " Look in the build directories that ALE uses for a local-version of the
             " binary.
             for build_dir in g:ale_c_build_dir_names
                 let binary_path = './' . build_dir . '/bin/' . binary_name
                 if executable(binary_path)
                     return binary_path
                 endif
             endfor
             " If there wasn't one, use the fallback path.
             return a:fallback_path
           endfunction

       let g:ale_nix_nixpkgsfmt_executable = '${unstable.nixpkgs-fmt}/bin/nixpkgs-fmt'
       let g:gutentags_ctags_executable = '${universal-ctags}/bin/ctags'
       let termdebugger = '${gdb}/bin/gdb'
       let g:ale_vim_vint_executable = '${vim-vint}/bin/vint'
       let g:ale_sh_shellcheck_executable = '${shellcheck}/bin/shellcheck'
       let g:ale_json_jq_executable = '${jq}/bin/jq'

       " Set formatting.
       let g:ale_echo_msg_error_str = 'E'
       let g:ale_echo_msg_warning_str = 'W'
       let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'

       " Set linters and fixers.
       let g:ale_linters_explicit = 1
       let g:ale_linters = {
       \   'json': [ 'jq' ],
       \   'sh': [ 'shell', 'shellcheck' ],
       \   'vim': [ 'vint' ],
       \   'zsh': [ 'shell', 'shellcheck' ],
       \ }

       " `*` means any language not matched explicitly, not all languages (ie. if ft is `rust`, ALE will
       " only load the `rust` list, not `rust` and `*`).
       let g:ale_fixers = {
       \   '*': [ 'remove_trailing_lines', 'trim_whitespace' ],
       \   'nix': [ 'nixpkgs-fmt', 'remove_trailing_lines', 'trim_whitespace' ],
       \   'sh': ['shfmt', 'remove_trailing_lines', 'trim_whitespace' ],
       \ }
       " Show hover balloon when over a definition.
       let g:ale_set_balloons = 1


       " Set mappings for ALE.
       nmap <leader>ad <plug>(ale_go_to_definition)
       nmap <leader>ar <plug>(ale_find_references)
       nmap <leader>ah <plug>(ale_hover)
       nmap <leader>af <plug>(ale_fix)
       nmap <leader>at <plug>(ale_detail)
       nmap <leader>an <plug>(ale_next_wrap)
       nmap <leader>ap <plug>(ale_previous_wrap)
       " Set quicker mappings for ALE.
       nmap <C-n> <plug>(ale_next_wrap)
       nmap <C-m> <plug>(ale_previous_wrap)


       "Deoplete Settings
       let g:deoplete#enable_at_startup = 1

       "" fzf settings
       "Set leader mappings for fzf.
       nnoremap <leader>pf :Files<CR>
       nnoremap <leader>pg :GFiles<CR>
       nnoremap <leader>pc :Commits<CR>
       nnoremap <leader>pb :Buffers<CR>
       nnoremap <leader>pt :Tags<CR>
       nnoremap <leader>pr :Rg<CR>
       " Set quicker mappings for fzf.
       nnoremap <C-p> :Files<CR>
       nnoremap <C-q> :Tags<CR>
       nnoremap <C-s> :Buffers<CR>
       nnoremap <C-x> :Rg<CR>
       " Set visual mappings for fzf.
       nmap <leader><tab> <plug>(fzf-maps-n)
       xmap <leader><tab> <plug>(fzf-maps-x)
       omap <leader><tab> <plug>(fzf-maps-o)
       " Insert mode completion
       imap <c-x><C-k> <plug>(fzf-complete-word)
       imap <c-x><C-f> <plug>(fzf-complete-path)
       imap <c-x><C-j> <plug>(fzf-complete-file-ag)
       imap <c-x><C-l> <plug>(fzf-complete-line)

       "Vimwiki Settings
       let g:vimwiki_list = [{'path': '~/unitas/wiki/',
                      \ 'syntax': 'markdown', 'ext': '.md'}]
       "EditorConfig settings
       let g:EditorConfig_exclude_patterns = ['fugitive://.*', 'scp://.*']

   	'';
   };

}

# vim:filetype=nix:foldmethod=marker:foldlevel=0:ts=2:sts=2:sw=2:nowrap
