" Fix completion bug in some versions of Vim.
set completeopt=menu,menuone,preview,noselect,noinsert

" Enable completion.
let g:ale_completion_enabled = 1

" Set formatting.
let g:ale_echo_msg_error_str = 'E'
let g:ale_echo_msg_warning_str = 'W'
let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'

" Set linters and fixers.
let g:ale_linters_explicit = 1
let g:ale_linters = {
\   'awk': [ 'gawk' ],
\   'c': [ 'clangd', 'clangtidy' ],
\   'cpp': [ 'clangd', 'clangtidy' ],
\   'cuda': [ 'nvcc' ],
\   'llvm': [ 'llc' ],
\   'lua': [ 'luac' ],
\   'json': [ 'jq' ],
\   'python': [ 'flake8' ],
\   'ruby': [ 'rubocop' ],
\   'rust': [ 'cargo', 'rls' ],
\   'sh': [ 'shell', 'shellcheck' ],
\   'vim': [ 'vint' ],
\   'zsh': [ 'shell', 'shellcheck' ],
\ }

" Use stable Rust for RLS.
let g:ale_rust_rls_toolchain = 'stable'

" Limit clangtidy checks.
let g:ale_c_clangtidy_checks = [ 'clang-analyzer-*', 'cppcoreguidelines-*', 'llvm-*' ]
let g:ale_cpp_clangtidy_checks = g:ale_c_clangtidy_checks

" `*` means any language not matched explicitly, not all languages (ie. if ft is `rust`, ALE will
" only load the `rust` list, not `rust` and `*`).
let g:ale_fixers = {
\   '*': [ 'remove_trailing_lines', 'trim_whitespace' ],
\   'cpp': [ 'clang-format', 'remove_trailing_lines', 'trim_whitespace' ],
\   'cuda': [ 'clang-format', 'remove_trailing_lines', 'trim_whitespace' ],
\   'nix': [ 'nixpkgs-fmt', 'remove_trailing_lines', 'trim_whitespace' ],
\   'opencl': [ 'clang-format', 'remove_trailing_lines', 'trim_whitespace' ],
\   'rust': [ 'rustfmt', 'remove_trailing_lines', 'trim_whitespace' ],
\   'sh': ['shfmt', 'remove_trailing_lines', 'trim_whitespace' ],
\ }

" Don't apply formatters that re-write files on save, these sometimes aren't used in projects.
" Use `.lvimrc` to override this.
let g:ale_fix_on_save = 1
let g:ale_fix_on_save_ignore = {
\   'cpp': [ 'clang-format' ],
\   'cmake': [ 'cmakeformat' ],
\   'cuda': [ 'clang-format' ],
\   'opencl': [ 'clang-format' ],
\   'rust': [ 'rustfmt' ],
\ }

" Disable Ale for `.tex.njk` files.
let g:ale_pattern_options = {
\   '.*\.tex\.njk$': { 'ale_enabled': 0 },
\ }

" Show hover balloon when over a definition.
let g:ale_set_balloons = 1

" Use clippy instead of cargo.
let g:ale_rust_cargo_use_clippy = 1

" vim:foldmethod=marker:foldlevel=0:ts=2:sts=2:sw=2:nowrap
