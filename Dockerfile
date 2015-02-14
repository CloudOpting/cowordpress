FROM cloudopting/coapache
MAINTAINER Ciprian Pavel "ciprian.pavel@teamnet.ro"

#add the latest wordpress install to container
#it is from a local file in order to ensure consistency over time 
#wordpress version upgrade should be done by an conscious administrator
ADD latest.tar.gz /tmp

#add the template configuration
ADD wp-config.php.erb /tmp/  

#extract the file into corresponding virtual host folder
#this is a dependency on cloudopting/apache docker file definition
RUN rm -rf /var/www/first.example.com/*  #redo1
RUN cp -r /tmp/wordpress/* /var/www/first.example.com/  #redo1

#move the wordpress template configuration to the correct location
RUN cp /tmp/wp-config.php.erb /var/www/first.example.com/wp-config.php

#EXECUTE PUPPET STANDALONE - TODO - set up wordpress after linkage to configured mysql instance
#RUN puppet apply -e "class { 'apache':mpm_module => 'prefork'} apache::vhost { 'first.example.com':docroot => '/var/www/first.example.com' } class {'::apache::mod::php': }" --verbose --detailed-exitcodes || [ $? -eq 2 ]
#RUN puppet apply /etc/puppet/manifests/web.pp

# OPEN UP PORT
EXPOSE 80

# START APACHE
ENTRYPOINT [ "/usr/sbin/apache2" ]
CMD [ "-D", "FOREGROUND" ]