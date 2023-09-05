set -x PATH $HOME/.local/bin $PATH
set -x LD_LIBRARY_PATH $HOME/.local/lib $LD_LIBRARY_PATH

function sdk
    bash -c "source '$HOME/.sdkman/bin/sdkman-init.sh'; sdk $argv[1..]"
end

fish_add_path (find $HOME/.sdkman/candidates/*/current/bin -maxdepth 0)
