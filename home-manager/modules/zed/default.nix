{ config, pkgs, lib, ... }:

{
    programs.zed-editor = let
      zed-wrapped = pkgs.writeShellScriptBin "zeditorw" ''
        ANTHROPIC_API_KEY=$(cat $HOME/.config/sops-nix/secrets/ANTHROPIC_API_KEY) ${pkgs.zed-editor_git}/bin/zeditor $@
      '';
    in
    {
        enable = true;
        extensions = ["nix" "toml" "elixir" "make"];
        package = zed-wrapped; # chaotic_nix wrapped in our API injection...
        ## everything inside of these brackets are Zed options.
        userSettings = {
            assistant = {
                enabled = true;
                version = "2";
                default_open_ai_model = null;
                ### PROVIDER OPTIONS
                ### zed.dev models { claude-3-5-sonnet-latest } requires github connected
                ### anthropic models { claude-3-5-sonnet-latest claude-3-haiku-latest claude-3-opus-latest  } requires API_KEY
                ### copilot_chat models { gpt-4o gpt-4 gpt-3.5-turbo o1-preview } requires github connected
                default_model = {
                    provider = "anthropic";
                    model = "claude-3-5-sonnet-latest";
                };
            };
            hour_format = "hour24";
            auto_update = false;
            terminal = {
                alternate_scroll = "off";
                blinking = "off";
                copy_on_select = false;
                dock = "bottom";
                detect_venv = {
                    on = {
                        directories = [".env" "env" ".venv" "venv"];
                        activate_script = "default";
                    };
                };
                env = {
                    TERM = "alacritty";
                };
                font_family = "Iosevka Nerd Font Mono";
                font_features = null;
                font_size = null;
                line_height = "comfortable";
                option_as_meta = false;
                button = false;
                shell = "system";
                #{
                #                    program = "zsh";
                #};
                toolbar = {
                    title = true;
                };
                working_directory = "current_project_directory";
            };
            lsp = {

                nix = {
                    binary = {
                        path_lookup = true;
                    };
                };
            };
            vim_mode = false;
            ## tell zed to use direnv and direnv can use a flake.nix enviroment.
            load_direnv = "shell_hook";
            base_keymap = "VSCode";
            theme = {
                mode = "system";
                light = "One Light";
                dark = "One Dark";
            };
            show_whitespaces = "all" ;
            ui_font_size = 16;
            buffer_font_size = 14;

        };

    };
}
