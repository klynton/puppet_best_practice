## Wordpress Deployment using Puppet Best Pracices

This is a wordpress module that deploys a wordpress blog using puppet best practices. It's not meant to be a production module but rather an instanciation of the CURRENT best practices we at Puppet promote.

This module defines our wordpress blog using the following modules:

	- hunner/wordpress
	- puppetlabs/apache
	- puppetlabs/concat
	- puppetlabs/stdlib
	
Data lookup is achived with Hiera and is abstracted via roles and profiles. 

This specific best practices demo needs to be ran with a $::fqdn that evaluates to 

	jeff.puppetlabs.vm

... in order for the hiera lookup to occur, or you could roll your own hieradata file that specifies
another fqdn - R&D (rip off and deploy) to suit your needs. 
