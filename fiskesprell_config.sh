###### Setting up & Installing Awesome window manager + my personal settings ######
# installs dependencies
sudo apt install git dmenu light awesome -y
git clone --recurse-submodules --remote-submodules --depth 1 -j 2 https://github.com/lcpz/awesome-copycats.git
mv -bv awesome-copycats/{*,.[^.]*} ~/.config/awesome; rm -rf awesome-copycats
mv -bv awesome-copycats/* ~/.config/awesome; rm -rf awesome-copycats

# Adds user to Video group
# This is needed for the program 'light' to work
sudo usermod -a -G video $LOGNAME

# Sets scaling (my laptop is 2150x1600px and I don't want to use it with a magnifying glass)
if test -f ~/.Xresources
then
    echo "Xft.dpi: 150" >> ~/.Xresources
else
	touch ~/.Xresources
	echo "Xft.dpi: 150" >> ~/.Xresources
fi

# Places "my version" of Luca CPZ's rc.lua file
# Assumes you have the rc.lua file in the same folder as this script
mv rc.lua ~/.config/awesome/rc.lua

# enables touchpad gestures like tap click & two-finger right click
# Should work on most computers
sudo touch /etc/profile.d/touchpad.sh
sudo echo 'xinput set-prop "$(xinput list --name-only | grep -i touch)" "libinput Tapping Enabled" 1' >> /etc/profile.d/touchpad.sh

###### Installing programs I like ######
# This script assumes you are using Linux Mint
# It will install the following programs:
# Librewolf   (Browser)
# Spotify     (Music player)
# Discord     (Chat client)
# Codium      (IDE)
# KeepassXC   (Password Manager)
# Thunderbird (E-mail client)
# VLC 		  (Media player)
# LibreOffice (Office suite)
# Flameshot   (Screenshot utility)

# Adding Librewolf repository 
distro=$(if echo " bullseye focal impish jammy uma una vanessa" | grep -q " $(lsb_release -sc) "; then echo $(lsb_release -sc); else echo focal; fi)

wget -O- https://deb.librewolf.net/keyring.gpg | sudo gpg --dearmor -o /usr/share/keyrings/librewolf.gpg

sudo tee /etc/apt/sources.list.d/librewolf.sources << EOF > /dev/null
Types: deb
URIs: https://deb.librewolf.net
Suites: $distro
Components: main
Architectures: amd64
Signed-By: /usr/share/keyrings/librewolf.gpg
EOF

# Adding VSCodium repository
wget -qO - https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/master/pub.gpg \
    | gpg --dearmor \
    | sudo dd of=/usr/share/keyrings/vscodium-archive-keyring.gpg

echo 'deb [ signed-by=/usr/share/keyrings/vscodium-archive-keyring.gpg ] https://paulcarroty.gitlab.io/vscodium-deb-rpm-repo/debs vscodium main' \
    | sudo tee /etc/apt/sources.list.d/vscodium.list

# Install all except Discord
sudo apt update 
sudo apt upgrade -y
sudo apt install librewolf thunderbird flatpak spotify-client keepassxc codium codium-insiders flatpak vlc flameshot -y

# Discord install (flatpak) + Symlink to let it work with dmenu
flatpak install com.discordapp.Discord
sudo ln -s /var/lib/flatpak/exports/bin/com.discordapp.Discord /usr/bin/discord

# Creates a symlink that allows keepassxc-browser to connect to librewolf
ln -s ~/.mozilla/native-messaging-hosts ~/.librewolf/native-messaging-hosts

echo "Remember to restart your computer for this to work :)"