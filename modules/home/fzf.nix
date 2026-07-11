{...}: {
  programs.fzf = {
    enable = true;

    fileWidget.options = [
      # Preview the contents of the selected file
      "--preview 'bat --color=always --plain {}'"
    ];

    changeDirWidget.options = [
      # Preview the contents of the selected directory
      "--preview 'exa -l --tree --level=2 --color=always {}'"
    ];
  };
}
