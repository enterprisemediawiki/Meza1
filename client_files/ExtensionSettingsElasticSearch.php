
# Add 2 extensions required for Elastic Search
$egExtensionLoaderConfig += array(
	'Elastica' => array(
		'git' => 'https://gerrit.wikimedia.org/r/mediawiki/extensions/Elastica.git',
		'branch' => 'REL1_25',
	),
	'CirrusSearch' => array(
		'git' => 'https://gerrit.wikimedia.org/r/mediawiki/extensions/CirrusSearch.git',
		'branch' => 'REL1_25',
	),
);

# End of Elastic Search additions
