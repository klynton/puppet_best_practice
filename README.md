## Wordpress Deployment using Puppet Best Pracices

This is a wordpress module that deploys a wordpress blog using puppet best practices. It's not meant to be a production module but rather an instanciation of the CURRENT best practices we at Puppet promote.

This module defines our wordpress blog using the following modules:

	- hunner/wordpress
	- puppetlabs/apache

Data lookup is achived with Hiera and is abstracted via roles and profiles. 


