## Wordpress Deployment using Puppet Best Practices

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

	Update your host machine's /etc/hosts file

Class discussion:

	site.pp - hey check this out, we just 'include profiles::wordpress' for any node, super simple and easy to understand declaration!

	Hiera - traverse the hieradata directory structure. Add a node from the classroom and create a .yaml file for them on the fly, run. Update the site.pp to include them if neccessary or if you just set it to default run the puppet agent on their machine again on the screen by ssh'ing into their box so the class can see it in action. Make sure to make some blatant variable declarations that are node specific to them in the hiera data. 

	Hiera abstraction - why this is important. No variables are set inside the manifest, everything is gained from hiera yaml files. If you have current JSON nijas ensure they know about other backends. 

	Profiles - ensure the students understand how the wrapper module works, why we did it. It's pretty neat to be able to have simple node classification, no need to use parameterized class syntax, clean node declarations and easy re-usability. 

 	

 - R&D (rip off and deploy) to suit your needs. 
