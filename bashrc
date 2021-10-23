display=$(xrandr -q | grep ' connected' | head -n 1 | cut -d ' ' -f1)
alias bup=xrandr --output $display --brightness 0.7
alias bdw=xrandr --output $display --brightness 0.3
alias lumiere=brightnessctl

