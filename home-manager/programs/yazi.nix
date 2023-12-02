{
  inputs,
  pkgs,
  ...
}: {
  programs.yazi = {
    enable = true;
    package = inputs.yazi.packages.${pkgs.system}.yazi;
    enableFishIntegration = true;
    enableZshIntegration = true;
    theme = {
      status = {
        separator = {
          opening = "";
          closing = "";
        };
      };
    };
    settings = {
      manager = {
        layout = [1 4 4];
        sort_by = "modified";
        sort_sensitive = false;
        sort_reverse = true;
        sort_dir_first = true;
        show_hidden = false;
        show_symlink = true;
      };
      preview = {
        tab_size = 2;
        max_width = 1024;
        max_height = 1024;
        cache_dir = "";
      };
      opener = {
        folder = [
          {exec = ''xdg-open "$@"'';}
        ];
        text = [
          {
            exec = ''$EDITOR "$@"'';
            block = true;
          }
        ];
        image = [
          {exec = ''imv "$@"'';}
          {
            exec = ''${pkgs.exiftool}/bin/exiftool "$1"; echo "press enter to exit"; read'';
            block = true;
          }
        ];
        video = [
          {exec = ''mpv "$@"'';}
          {
            exec = ''${pkgs.exiftool}/bin/exiftool "$1"; echo "press enter to exit"; read'';
            block = true;
          }
        ];
        audio = [
          {exec = ''mpv "$@"'';}
          {
            exec = ''${pkgs.exiftool}/bin/exiftool "$1"; echo "press enter to exit"; read'';
            block = true;
          }
        ];
        fallback = [
          {exec = ''xdg-open "$@"'';}
          {
            exec = ''${pkgs.file}/bin/file "$1"; echo "press enter to exit"; read'';
            block = true;
          }
        ];
      };
    };
    keymap = {
      manager.keymap = [
        # yazi
        {
          on = ["<Esc>"];
          exec = "escape";
          desc = "Exit visual mode; clear selected; or cancel search";
        }
        {
          on = ["q"];
          exec = "quit";
          desc = "Exit the process";
        }
        {
          on = ["<C-q>"];
          exec = "close";
          desc = "Close the current tab; or quit if it is last tab";
        }
        {
          on = ["<C-z>"];
          exec = "suspend";
          desc = "Suspend the process";
        }

        # Navigation
        {
          on = ["k"];
          exec = "arrow -1";
          desc = "Move cursor up";
        }
        {
          on = ["j"];
          exec = "arrow 1";
          desc = "Move cursor down";
        }

        {
          on = ["K"];
          exec = "arrow -5";
          desc = "Move cursor up 5 lines";
        }
        {
          on = ["J"];
          exec = "arrow 5";
          desc = "Move cursor down 5 lines";
        }

        {
          on = ["<C-u>"];
          exec = "arrow -50%";
          desc = "Move cursor up half page";
        }
        {
          on = ["<C-d>"];
          exec = "arrow 50%";
          desc = "Move cursor down half page";
        }
        {
          on = ["<C-b>"];
          exec = "arrow -100%";
          desc = "Move cursor up one page";
        }
        {
          on = ["<C-f>"];
          exec = "arrow 100%";
          desc = "Move cursor down one page";
        }

        {
          on = ["h"];
          exec = "leave";
          desc = "Go back to the parent directory";
        }
        {
          on = ["l"];
          exec = "enter";
          desc = "Enter the child directory";
        }

        {
          on = ["H"];
          exec = "back";
          desc = "Go back to the previous directory";
        }
        {
          on = ["L"];
          exec = "forward";
          desc = "Go forward to the next directory";
        }

        {
          on = ["<C-k>"];
          exec = "peek -5";
          desc = "Peek up 5 units in the preview";
        }
        {
          on = ["<C-j>"];
          exec = "peek 5";
          desc = "Peek down 5 units in the preview";
        }

        {
          on = ["<Up>"];
          exec = "arrow -1";
          desc = "Move cursor up";
        }
        {
          on = ["<Down>"];
          exec = "arrow 1";
          desc = "Move cursor down";
        }
        {
          on = ["<Left>"];
          exec = "leave";
          desc = "Go back to the parent directory";
        }
        {
          on = ["<Right>"];
          exec = "enter";
          desc = "Enter the child directory";
        }

        {
          on = ["g" "g"];
          exec = "arrow -99999999";
          desc = "Move cursor to the top";
        }
        {
          on = ["G"];
          exec = "arrow 99999999";
          desc = "Move cursor to the bottom";
        }

        # Selection
        {
          on = ["<Space>"];
          exec = ["select --state=none" "arrow 1"];
          desc = "Toggle the current selection state";
        }
        {
          on = ["v"];
          exec = "visual_mode";
          desc = "Enter visual mode (selection mode)";
        }
        {
          on = ["V"];
          exec = "visual_mode --unset";
          desc = "Enter visual mode (unset mode)";
        }
        {
          on = ["<C-a>"];
          exec = "select_all --state=true";
          desc = "Select all files";
        }
        {
          on = ["<C-r>"];
          exec = "select_all --state=none";
          desc = "Inverse selection of all files";
        }

        # Operation
        {
          on = ["o"];
          exec = "open";
          desc = "Open the selected files";
        }
        {
          on = ["<Enter>"];
          exec = "open";
          desc = "Open the selected files";
        }
        {
          on = ["y"];
          exec = "yank";
          desc = "Copy the selected files";
        }
        {
          on = ["x"];
          exec = "yank --cut";
          desc = "Cut the selected files";
        }
        {
          on = ["p"];
          exec = "paste";
          desc = "Paste the files";
        }
        {
          on = ["P"];
          exec = "paste --force";
          desc = "Paste the files (overwrite if the destination exists)";
        }
        {
          on = ["-"];
          exec = "link";
          desc = "Symlink the absolute path of files";
        }
        {
          on = ["_"];
          exec = "link --relative";
          desc = "Symlink the relative path of files";
        }
        {
          on = ["d"];
          exec = "remove";
          desc = "Move the files to the trash";
        }
        {
          on = ["D"];
          exec = "remove --permanently";
          desc = "Permanently delete the files";
        }
        {
          on = ["a"];
          exec = "create";
          desc = "Create a file or directory (ends with / for directories)";
        }
        {
          on = ["r"];
          exec = "rename";
          desc = "Rename a file or directory";
        }
        {
          on = [":"];
          exec = "shell --block";
          desc = "Run a shell command (block the UI until the command finishes)";
        }
        {
          on = ["."];
          exec = "hidden toggle";
          desc = "Toggle the visibility of hidden files";
        }
        {
          on = ["z"];
          exec = "jump zoxide";
          desc = "Jump to a directory using zoxide";
        }
        {
          on = ["Z"];
          exec = "jump fzf";
          desc = "Jump to a directory; or reveal a file using fzf";
        }

        # Copy
        {
          on = ["c" "c"];
          exec = "copy path";
          desc = "Copy the absolute path";
        }
        {
          on = ["c" "d"];
          exec = "copy dirname";
          desc = "Copy the path of the parent directory";
        }
        {
          on = ["c" "f"];
          exec = "copy filename";
          desc = "Copy the name of the file";
        }
        {
          on = ["c" "n"];
          exec = "copy name_without_ext";
          desc = "Copy the name of the file without the extension";
        }

        # Find
        {
          on = ["/"];
          exec = "find";
        }
        {
          on = ["?"];
          exec = "find --previous";
        }
        {
          on = ["n"];
          exec = "find_arrow";
        }
        {
          on = ["N"];
          exec = "find_arrow --previous";
        }

        # Sorting
        {
          on = [";" "a"];
          exec = "sort alphabetical --dir_first";
          desc = "Sort alphabetically";
        }
        {
          on = [";" "A"];
          exec = "sort alphabetical --reverse --dir_first";
          desc = "Sort alphabetically (reverse)";
        }
        {
          on = [";" "c"];
          exec = "sort created --dir_first";
          desc = "Sort by creation time";
        }
        {
          on = [";" "C"];
          exec = "sort created --reverse --dir_first";
          desc = "Sort by creation time (reverse)";
        }
        {
          on = [";" "m"];
          exec = "sort modified --dir_first";
          desc = "Sort by modified time";
        }
        {
          on = [";" "M"];
          exec = "sort modified --reverse --dir_first";
          desc = "Sort by modified time (reverse)";
        }
        {
          on = [";" "n"];
          exec = "sort natural --dir_first";
          desc = "Sort naturally";
        }
        {
          on = [";" "N"];
          exec = "sort natural --reverse --dir_first";
          desc = "Sort naturally (reverse)";
        }
        {
          on = [";" "s"];
          exec = "sort size --dir_first";
          desc = "Sort by size";
        }
        {
          on = [";" "S"];
          exec = "sort size --reverse --dir_first";
          desc = "Sort by size (reverse)";
        }

        # Tabs
        {
          on = ["t"];
          exec = "tab_create --current";
          desc = "Create a new tab using the current path";
        }

        {
          on = ["1"];
          exec = "tab_switch 0";
          desc = "Switch to the first tab";
        }
        {
          on = ["2"];
          exec = "tab_switch 1";
          desc = "Switch to the second tab";
        }
        {
          on = ["3"];
          exec = "tab_switch 2";
          desc = "Switch to the third tab";
        }
        {
          on = ["4"];
          exec = "tab_switch 3";
          desc = "Switch to the fourth tab";
        }
        {
          on = ["5"];
          exec = "tab_switch 4";
          desc = "Switch to the fifth tab";
        }
        {
          on = ["6"];
          exec = "tab_switch 5";
          desc = "Switch to the sixth tab";
        }
        {
          on = ["7"];
          exec = "tab_switch 6";
          desc = "Switch to the seventh tab";
        }
        {
          on = ["8"];
          exec = "tab_switch 7";
          desc = "Switch to the eighth tab";
        }
        {
          on = ["9"];
          exec = "tab_switch 8";
          desc = "Switch to the ninth tab";
        }

        {
          on = ["["];
          exec = "tab_switch -1 --relative";
          desc = "Switch to the previous tab";
        }
        {
          on = ["]"];
          exec = "tab_switch 1 --relative";
          desc = "Switch to the next tab";
        }

        {
          on = ["{"];
          exec = "tab_swap -1";
          desc = "Swap the current tab with the previous tab";
        }
        {
          on = ["}"];
          exec = "tab_swap 1";
          desc = "Swap the current tab with the next tab";
        }

        # Tasks
        {
          on = ["w"];
          exec = "tasks_show";
          desc = "Show the tasks manager";
        }

        # Goto
        {
          on = ["g" "h"];
          exec = "cd ~";
          desc = "home";
        }
        {
          on = ["g" "c"];
          exec = "cd /etc/nixos/configuration.nix";
          desc = "configuration.nix";
        }
        {
          on = ["g" "d"];
          exec = "cd /mnt/data";
          desc = "/mnt/data";
        }
        {
          on = ["g" "s"];
          exec = "cd ~/downloads";
          desc = "~/downloads";
        }
        {
          on = ["g" "t"];
          exec = "cd /tmp";
          desc = "/tmp";
        }
        {
          on = ["g" "<Space>"];
          exec = "cd --interactive";
          desc = "interactive";
        }

        # Help
        {
          on = ["~"];
          exec = "help";
          desc = "Open help";
        }
      ];
    };
  };
}
