{ config, pkgs, lib, ... }:

let
  # gcc contains libstdc++ pretty printers.
  libStdCppPrettyPrinters = pkgs.fetchsvn {
    url = "svn://gcc.gnu.org/svn/gcc/trunk/libstdc++-v3/python";
    rev = "275486";
    sha256 = "0ryw74f79yn75nxa525d3vxzcvsqa791f30z7ab102vqcnsj3aac";
  };
  # LLVM provides pretty printers for LLVM data types.
  llvmPrettyPrinters = pkgs.fetchgit {
    url = "https://github.com/llvm/llvm-project.git";
    rev = "d065c811649f0d0df5429741a9a3dd643e88a9fe";
    sha256 = "0qnszpkilkx4zacafdfhf5xwvdxjpzq5wjx1bx4nln8vvznmhqig";
  };
in {
  home.file.".gdbinit".text = ''
    python
    import sys
    sys.path.insert(0, '${libStdCppPrettyPrinters}')
    from libstdcxx.v6.printers import register_libstdcxx_printers
    register_libstdcxx_printers (None)
    end

    source ${llvmPrettyPrinters}/llvm/utils/gdb-scripts/prettyprinters.py
  '';
}

# vim:foldmethod=marker:foldlevel=0:ts=2:sts=2:sw=2:nowrap
