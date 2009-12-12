package ShinyCMS;

use strict;
use warnings;

use Catalyst::Runtime 5.80;

# Set flags and add plugins for the application
#
#         -Debug: activates the debug mode for very useful log messages
#   ConfigLoader: will load the configuration from a Config::General file in the
#                 application's home directory
# Static::Simple: will serve static files from the application's root
#                 directory

use parent qw/ Catalyst /;

use Catalyst qw/
	-Debug
	ConfigLoader
	Static::Simple
	
	StackTrace
	
	Authentication
	Authorization::Roles
	
	Session
	Session::Store::FastMmap
	Session::State::Cookie
/;

use Method::Signatures::Simple;


our $VERSION = '0.01';


# really should be able to pull this from config, but it doesn't sodding work!
our $DOMAIN = 'shinycms.cms';


# Configure the application.
#
# Note that settings in shinycms.conf (or other external
# configuration file that you set up manually) take precedence
# over this when using ConfigLoader. Thus configuration
# details given here can function as a default configuration,
# with an external configuration file acting as an override for
# local deployment.

__PACKAGE__->config(
	name	=> 'ShinyCMS',
	session	=> { flash_to_stash => 1 }
);


# Configure SimpleDB Authentication
__PACKAGE__->config->{'Plugin::Authentication'} = {
	default => {
		class           => 'SimpleDB',
		user_model      => 'DB::User',
		password_type   => 'self_check',
	},
};


# Set cookie domain to be wildcard
method finalize_config {
	__PACKAGE__->config( session => {
		cookie_domain  => '.'.$self->config->{ domain },
	});
	$self->next::method(@_);
};


# Start the application
__PACKAGE__->setup();


# This method creates URIs for the 'main' site
method main_uri_for (@args) {
	local $self->req->{base} = URI->new( 'http://www.'. $self->config->{ domainport } );
	$self->uri_for(@_);
}

# This method creates URIs for the per-user sub-domains
method sub_uri_for (@args) {
	my( $username, $uri ) = @_;
	local $self->req->{base} = URI->new( 'http://'. $username .'.'. $self->config->{ domainport } );
	$self->uri_for($uri);
}


=head1 NAME

ShinyCMS

=head1 SYNOPSIS

    script/shinycms_server.pl

=head1 DESCRIPTION

ShinyCMS is an extensible CMS built on the Catalyst Framework.

http://shinycms.org

http://catalystframework.org


=head1 SEE ALSO

L<ShinyCMS::Controller::Root>, L<Catalyst>

=head1 AUTHOR

Denny de la Haye <2009@denny.me>

=head1 LICENSE

This program is free software: you can redistribute it and/or modify it 
under the terms of the GNU Affero General Public License as published by 
the Free Software Foundation, either version 3 of the License, or (at your 
option) any later version.

You should have received a copy of the GNU Affero General Public License 
along with this program (see docs/AGPL-3.0.txt).  If not, see 
http://www.gnu.org/licenses/

=cut

1;

