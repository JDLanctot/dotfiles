# Colormap
function colormap() {
  for i in {0..255}; do print -Pn "%K{$i}  %k%F{$i}${(l:3::0:)i}%f " ${${(M)$((i%6)):#3}:+$'\n'}; done
}

# Fuzzy find and open to nvim
function fzn() {
    local file
    file=$(fzf --preview="bat --color=always {}")
    [ -n "$file" ] && nvim "$file"
}

# Short hand for conda activate
function ca() {
    conda activate $1
}

# Function for smart navigate plus conda activate
function caz() {
    z $1
    conda activate $1
}
