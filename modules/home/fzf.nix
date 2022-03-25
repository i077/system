{ ... }: {
  programs.fzf = {
    enable = true;

    fileWidgetOptions = [
      # Preview the contents of the selected file
      "--preview 'bat --color=always --plain {}'"
    ];

    changeDirWidgetOptions = [
      # Preview the contents of the selected directory
      "--preview 'exa -l --tree --level=2 --color=always {}'"
    ];
  };
}
