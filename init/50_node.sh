# Load nave- and npm-related functions.
source $DOTFILES/source/50_node.sh

node_versions=(
	14.17.6
	12.22.6
)

for node_version in "${node_versions[@]}"; do
	nave_install $node_version
done

# Install latest stable Node.js, set as default, install global npm modules.
nave_install stable