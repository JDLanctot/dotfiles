#!/bin/bash

# Install Homebrew if not already installed
if ! command -v brew &> /dev/null; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	echo >> /Users/jordi/.zprofile
	echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> /Users/jordi/.zprofile
	eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Install packages from Brewfile
brew bundle install --file="$(dirname "$0")/Brewfile"
