package ShinyCMS::Model::Base;

use Moose;
use namespace::clean -except => 'meta';

extends qw/ Catalyst::Model /;


__PACKAGE__->config( schema => undef );


=head1 NAME

ShinyCMS::Model::Base

=head1 SYNOPSIS

use base qw( ShinyCMS::Model::Base );

=head1 DESCRIPTION

Base Catalyst::Model class for ShinyCMS models.

=cut


=head1 METHODS

=head2 ACCEPT_CONTEXT

Take the context of this model as provided by Catalyst.  From this we
get a handle on the DB model, which is the data source for all the
other models we create.

=cut

sub ACCEPT_CONTEXT {
    my ($self, $c, @args) = @_;
    $self->config->{schema} = $c->model('DB') unless ($self->config->{schema});
    $self->config->{context} = $c;
    return $self;
}


=head1 AUTHOR

Aaron Trevena

=head1 SEE ALSO

Catalyst::Model::DBIC

=cut

__PACKAGE__->meta->make_immutable;

1;

