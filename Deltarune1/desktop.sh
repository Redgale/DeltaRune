#!/bin/sh

# This script is for generating a desktop entry for Deltarune
# And copying that desktop entry to the desktop and menu
# This should work with most distros

# If there's any concerns, please contact me here:
# https://www.reddit.com/message/compose/?to=JohnWatson78



# These are files within the same directory as this script
RUNNERNAME="runner"
DESKTOPNAME="Deltarune.desktop"
LIBDIR="lib"


# Paths to applications and desktop directories
MENUDIR="$HOME/.local/share/applications"
DESKTOPDIR="$HOME/Desktop"


# Get the directory path of this script
REALPATH=$(realpath "$0")
DIRNAME=$(dirname "$REALPATH")


# Custom print function so the script is a little bit more readable
print() {
	prfx="\\033[94m"
	if [ "$1" = "!" ]; then
		prfx="\\033[91m"
		shift
	fi
	pout="$1"
	shift
	printf "%b:: \\033[0m$pout\\n%b" "$prfx" "\\033[92m$1\\033[0m" "\\033[92m$2\\033[0m"
}


# Check if the assets directory exists
# The game requires this so the script doesn't continue otherwise
if [ -d "assets" ]; then
	# Success: The assets directory exists
	print "Assets directory found at %b" "$DIRNAME/assets"
else
	# Failure: The assets directory was not found, exit the script
	print ! "No assets directory can be found %b" "$DIRNAME"
	exit 1
fi


# Check if the runner binary exists, that's what actually runs the game
# Looks for a file named "runner" by default first,
# then looks for any compatible binary if it can't be found
if [ -f "$RUNNERNAME" ]; then
	# Success: A file with the default runner name was found
	print "Runner binary found at %b" "$DIRNAME/$RUNNERNAME"
else
	# A file with the default runner name was not found
	# So look for any compatible runner binary
	RUNNERNAME=$(grep -Fsl "YoYo"" Games Linux Runner V1.3" ./* |
	while read -r i; do
		if [ "$(file -b --mime-encoding "$i")" = "binary" ]; then
			basename "$i"
			break
		fi
	done)
	if [ -f "$RUNNERNAME" ]; then
		# Success: A compatible runner binary was found
		print "Runner binary found at %b" "$DIRNAME/$RUNNERNAME"
	else
		# Failure: A compatible runner binary was not found, exit the script
		print ! "No runner binary can be found in %b" "$DIRNAME"
		exit 1
	fi
fi


# Check if a library directory exists
# This is recommended but optional, so the script continues unconditionally
if [ -d "$LIBDIR" ]; then
	# Success: A library directory exists
	EXECPREFIX="env LD_LIBRARY_PATH=\"$LIBDIR\" "
	print "Library directory found at %b" "$DIRNAME/$LIBDIR"
fi

printf "\\n"


# Create the desktop entry file
cat > "./$DESKTOPNAME" << EOL
[Desktop Entry]
Version=6.6.6
Name=Deltarune
Comment=SURVEY_PROGRAM
Path=$DIRNAME
Exec=$EXECPREFIX"./$RUNNERNAME"
Icon=$DIRNAME/assets/icon.png
Terminal=false
StartupNotify=true
Type=Application
Categories=Game;
EOL


# Check if the desktop entry file was actually created
if [ -f "$DESKTOPNAME" ]; then
	# Success: The desktop entry file was found, print out its contents
	print "Desktop entry created at %b" "$DIRNAME/$DESKTOPNAME"
	print "Contents of %b:\\n" "$DESKTOPNAME"
	cat "./$DESKTOPNAME"
	printf "\\n"
else
	# Failure: The desktop entry file was not found, exit the script
	print ! "Failed creating %b in %b" "$DESKTOPNAME" "$DIRNAME"
	exit 1
fi


# Use chmod to make the runner binary and desktop entry executable
chmod +x "./$RUNNERNAME"
print "Permitted %b to be executable" "$RUNNERNAME"
chmod +x "./$DESKTOPNAME"
print "Permitted %b to be executable" "$DESKTOPNAME"

printf "\\n"


# Make sure the user-specific applications directory exists
# Most distros don't create this by default
if [ ! -d "$MENUDIR" ]; then
	# The directory doesn't exist, so use mkdir to create it
	mkdir "$MENUDIR"
fi


# Copy the desktop entry to the applications directory
if [ -d "$MENUDIR" ]; then
	cp "./$DESKTOPNAME" "$MENUDIR"
fi

# Check if the desktop entry was actually copied
if [ -f "$MENUDIR/$DESKTOPNAME" ]; then
	print "Copied %b to %b" "$DESKTOPNAME" "$MENUDIR"
else
	print ! "Failed copying %b to %b" "$DESKTOPNAME" "$MENUDIR"
fi


# Copy the desktop entry to the desktop directory
if [ -d "$DESKTOPDIR" ]; then
	cp "./$DESKTOPNAME" "$DESKTOPDIR"
fi

# Check if the desktop entry was actually copied
if [ -f "$DESKTOPDIR/$DESKTOPNAME" ]; then
	print "Copied %b to %b" "$DESKTOPNAME" "$DESKTOPDIR"
else
	print ! "Failed copying %b to %b" "$DESKTOPNAME" "$DESKTOPDIR"
fi
