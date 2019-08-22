[
  {
    # Suggest using shorter aliases.
    name = "you-should-use";
    src = builtins.fetchGit {
      url = "https://github.com/MichaelAquilina/zsh-you-should-use.git";
      ref = "master";
      rev = "e80ea3462514be31c43b65886105ac051114456e";
    };
  }
  {
    # Install and keep NVM up-to-date.
    name = "zsh-nvm";
    src = builtins.fetchGit {
      url = "https://github.com/lukechilds/zsh-nvm.git";
      ref = "master";
      rev = "9ae1115e76a7ff1e8fcb42e530c196834609f76d";
    };
  }
  {
    # Dependency of pure.
    name = "async";
    src = builtins.fetchGit {
      url = "https://github.com/mafredri/zsh-async.git";
      ref = "master";
      rev = "95c2b1577f455728ec01cec001a86c216d0af2bd";
    };
  }
  {
    # Additional completion definitions.
    name = "zsh-completions";
    src = builtins.fetchGit {
      url = "https://github.com/zsh-users/zsh-completions.git";
      ref = "master";
      rev = "b512d57b6d0d2b85368a8068ec1a13288a93d267";
    };
  }
  {
    # Fish-like fast/unobtrustive autosuggestions.
    name = "zsh-autosuggestions";
    src = builtins.fetchGit {
      url = "https://github.com/zsh-users/zsh-autosuggestions.git";
      ref = "master";
      rev = "43f3bc4010b2c697d2252fdd8b36a577ea125881";
    };
  }
  {
    # Pure prompt.
    name = "pure";
    src = builtins.fetchGit {
      url = "https://github.com/sindresorhus/pure.git";
      ref = "master";
      rev = "42d3b83647e6bc9ce9767f6f805ee054fd9710cf";
    };
  }
  {
    # Faster syntax highlighting.
    name = "fast-syntax-highlighting";
    src = builtins.fetchGit {
      url = "https://github.com/zdharma/fast-syntax-highlighting.git";
      ref = "master";
      rev = "581e75761c6bea46f2233dbc422d37566ce43f5e";
    };
  }
]
