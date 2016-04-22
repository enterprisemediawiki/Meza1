
print_title "Starting script VE.sh"


#
# Prompt user for mw_api_protocol
#
while [ "$mw_api_protocol" != "http" ] && [ "$mw_api_protocol" != "https" ]
do
	echo -e "\nType \"http\" or \"https\" for MW API and press [ENTER]: "
	read mw_api_protocol
done


#
# Prompt user for MW API domain
#
while [ -z "$mw_api_domain" ]
do
	echo -e "\nType domain or IP address of your wiki and press [ENTER]: "
	read mw_api_domain
done

echo "******* Downloading node.js *******"
cmd_profile "START node.js build"
cd ~/mezadownloads

if [ $architecture = 64 ]; then
	node_version="node-v0.12.7-linux-x64"
else
	node_version="node-v0.12.7-linux-x86"
fi


# Download binaries
# Ref: http://derpturkey.com/install-node-js-from-binaries/
wget "http://nodejs.org/dist/v0.12.7/$node_version.tar.gz"
tar -zxvf "$node_version.tar.gz" -C /usr/local/bin
rm -f "$node_version.tar.gz"

# Create a symbolic link for node that points to the new directory
cd /usr/local/bin
ln -s "$node_version/bin/node" node
ln -s "$node_version/lib/node_modules/npm/bin/npm-cli.js" npm

if [[ $PATH != *"/usr/local/bin"* ]]; then
	PATH="/usr/local/bin:$PATH"
fi

cmd_profile "END node.js build"

# Download and install parsoid
echo "******* Downloading parsoid *******"
cd /etc
git clone https://gerrit.wikimedia.org/r/p/mediawiki/services/parsoid
cd parsoid
git checkout "$parsoid_version"

echo "******* Installing parsoid *******"
#npm install -g # install globally
#attempt to install globally was resulting in several errors
cmd_profile "START npm install parsoid"
npm install
cmd_profile "END npm install parsoid"
# npm install results in "npm WARN prefer global jshint@2.8.0 should be installed with -g"

echo "******* Testing parsoid *******"
cmd_profile "START npm test parsoid"
npm test #optional?
cmd_profile "END npm test parsoid"
# several warnings come out of npm test

# Configure parsoid for wiki use
# TODO This part can be modified once localsettings.js is included in initial download of files
# localsettings for parsoid
echo "******* Downloading configuration files *******"
cd "$m_meza/scripts"

# Copy Parsoid settings from Meza to Parsoid install
ln -s "$m_config/core/localsettings.js" /etc/parsoid/api/localsettings.js

# MediaWiki's API URI, for parsoid. Parsoid communicates with MediaWiki PHP API
# via Apache httpd over port 9000. Note: protocol was $mw_api_protocol, but was
# changed to hard-coded http when Parsoid was given it's own port.
echo "$mw_api_domain" > /opt/meza/config/local/domain


#
# Installing Extension:VisualEditor was here
#


# Create parsoid user to run parsoid node server
useradd parsoid

# Grant parsoid user ownership of /opt/services/parsoid
chown parsoid:parsoid /etc/parsoid -R

# I used the following references for an automated service for starting parsoid on boot:
# https://www.mediawiki.org/wiki/Parsoid/Developer_Setup#Starting_the_Parsoid_service_automatically
# http://www.tldp.org/HOWTO/HighQuality-Apps-HOWTO/boot.html
# https://github.com/narath/brigopedia#setup-visualeditor-extension
# Create service script
echo "******* Creating parsoid service *******"
ln -s "$m_config/core/initd_parsoid.sh" /etc/init.d/parsoid
chmod 755 /etc/init.d/parsoid
chkconfig --add /etc/init.d/parsoid

# Start parsoid service
echo "******* Starting parsoid server *******"
#chkconfig parsoid on # @todo: not required?
service parsoid start
echo "******* Please test VE in your wiki *******"

# Note that you can't access the parsoid service via 192.168.56.58:8000 from host (at least by default)
# but you can use curl 127.0.0.1:8000 in ssh to verify it works

# Note documentation for multi-language support configuration: https://www.mediawiki.org/wiki/Extension:UniversalLanguageSelector

# Note: Other extensions which load plugins for VE (e.g. Math) should be loaded after VE for those plugins to work.
