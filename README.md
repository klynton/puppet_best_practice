## Wordpress Deployment using Puppet Best Pracices

This is a wordpress module that deploys a wordpress blog using puppet best practices. It's not meant to be a production module but rather an instanciation of the CURRENT best practices we at Puppet promote.

This module defines our wordpress blog using the following modules:

	- hunner/wordpress
	- puppetlabs/apache
	- puppetlabs/concat
	- puppetlabs/stdlib
	
Data lookup is achived with Hiera and is abstracted via roles and profiles. 

### Setup

This specific best practices demo needs to be ran with a $::hostname that evaluates to 

	jeff

... in order for the hiera lookup to occur, or you could roll your own hieradata file that specifies another fqdn.

In your $puppetdir (PE, /etc/puppetlabs/puppet) or POSSS /etc/puppet/):

	$ git clone https://github.com/malnick/puppet_best_practice
	$ mv hieradata hieradata.bak
	$ mv hiera.yaml hiera.yaml.bak
	$ cp -r  puppet_best_practice/hieradata/ .
	$ cp puppet_best_practice/hiera.yaml .
	$ cp -r puppet_best_practice/modules/* modules/
	$ mv manifests/site.pp manifests/site.pp.bak
	$ cp puppet_best_practice/manifests/site.pp manifests/


	Update manifests/site.pp to the correct agent node fqdn if needed. 

otherwise, on your demo agent:

	FACTER_hostname=jeff puppet agent -t 

 - R&D (rip off and deploy) to suit your needs. 
