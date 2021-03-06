package ShinyCMS::Controller::PaymentHandler::PaidListSubscription::CCBill;

use Moose;
use MooseX::Types::Moose qw/ Str /;
use namespace::autoclean;

BEGIN { extends 'ShinyCMS::Controller'; }


=head1 NAME

ShinyCMS::Controller::PaymentHandler::PaidListSubscription::CCBill

=head1 DESCRIPTION

Controller for handling payment for paid list subscriptions via CCBill.

=cut


has key => (
	isa      => Str,
	is       => 'ro',
	required => 1,
);


=head1 METHODS

=head2 index

Shouldn't be here - redirect to homepage

=cut

sub index : Path : Args( 0 ) {
    my ( $self, $c ) = @_;
	
	# Shouldn't be here
	$c->response->redirect( '/' );
}


=head2 base

Set up path etc

=cut

sub base : Chained( '/base' ) : PathPart( 'payment-handler/paid-list-subscription/ccbill' ) : CaptureArgs( 1 ) {
    my ( $self, $c, $key ) = @_;
	
	unless ( $key eq $self->key ) {
		$c->response->code( '403' );
		$c->response->body( 'Access forbidden.' );
		$c->detach;
	}
}


=head2 success

Handler for successful payment

=cut

sub success : Chained( 'base' ) : PathPart( 'success' ) : Args( 0 ) {
    my ( $self, $c ) = @_;
	
	# Find the user
	if ( $c->request->param( 'shinycms_username' ) ) {
		$c->stash->{ user } = $c->model( 'DB::User' )->find({
			username => $c->request->param( 'shinycms_username' ),
		});
	}
	
	# Get their email address
	my $email = $c->request->param( 'shinycms_email' );
	if ( $c->stash->{ user } and not $email ) {
		$email = $c->stash->{ user }->email;
	}
	
	# Find the list they're subscribing to
	my $list_id = $c->request->param( 'shinycms_list_id' );
	
	# Get the list details
	my $paid_list = $c->model( 'DB::PaidList' )->find({ id => $list_id });
	
	# TODO: subscribe email address to list.
	# Pull this out into a sub (in Admin/Newsletter.pm? Or in model??) 
	# so that admins can sign people up to paid lists without paying.
	
	# Log the transaction
	if ( $c->stash->{ user } ) {
		$c->stash->{ user }->transaction_logs->create({
			status => 'Success',
			notes  => "Subscribed $email to paid list: $list_id",
		});
	}
	else {
		$c->model( 'DB::TransactionLogs' )->create({
			status => 'Success',
			notes  => "Subscribed $email to paid list: $list_id",
		});
	}
	
	$c->response->body( 'Payment successful' );
	$c->detach;
}


=head2 fail

Handler for failed payment

=cut

sub fail : Chained( 'base' ) : PathPart( 'fail' ) : Args( 0 ) {
    my ( $self, $c ) = @_;
	
	# Log the transaction
	$c->model( 'DB::TransactionLogs' )->create({
		status => 'Failed',
		notes  => 'Enc: '. $c->request->param( 'enc' ),
	});
	
	$c->response->body( 'Sorry, your payment was not successful.' );
	$c->detach;
}


=head2 paid_list_subscribe

Subscribe an email address to a paid list

=cut

sub paid_list_subscribe : Chained( 'base' ) : Private {
	my ( $self, $c, $email, $list ) = @_;
	
	unless ( $email ) {
		$c->flash->{ error_msg } = 'No email address provided.';
		$c->response->redirect( $c->uri_for('/') );
		$c->detach;
	}
	unless ( $list ) {
		$c->flash->{ error_msg } = 'No paid list specified.';
		$c->response->redirect( $c->uri_for('/') );
		$c->detach;
	}
	
	# Find or create mail recipient record for this email address
	my $recipient = $c->model('DB::MailRecipient')->find({
		email => $email,
	});
	my $name = $c->request->param('name') || '';
	if ( $recipient ) {
		$recipient->update({ name => $name }) if $name and $name ne $recipient->name;
	}
	else {
		my $token = $self->generate_email_token( $c, $email );
		$recipient = $c->model('DB::MailRecipient')->create({
			name  => $name  || undef,
			email => $email || undef,
			token => $token || undef,
		});
	}
	
	# Create queued emails
	my @pl_emails = $list->paid_list_emails->all;
	foreach my $pl_email ( @pl_emails ) {
		my $send = DateTime->now->add( days => $pl_email->delay );
		$recipient->queued_emails->create({
			email => $pl_email->id,
			send  => $send,
		});
	}
	
	# Return to homepage or specified URL, display a 'success' message
	if ( $c->request->param('status_msg') ) {
		$c->flash->{ status_msg } = $c->request->param('status_msg');
	}
	else {
		$c->flash->{ status_msg } = 'Subscription successful.';
	}
	my $uri;
	if ( $c->request->param('redirect_url') ) {
		$uri = $c->request->param('redirect_url');
	}
	else {
		$uri = $c->uri_for( '/' );
	}
	$c->response->redirect( $uri );
}



=head1 AUTHOR

Denny de la Haye <2014@denny.me>

=head1 COPYRIGHT

ShinyCMS is copyright (c) 2009-2014 Shiny Ideas (www.shinyideas.co.uk).

=head1 LICENSE

This program is free software: you can redistribute it and/or modify it 
under the terms of the GNU Affero General Public License as published by 
the Free Software Foundation, either version 3 of the License, or (at 
your option) any later version.

You should have received a copy of the GNU Affero General Public License 
along with this program (see docs/AGPL-3.0.txt).  If not, see 
http://www.gnu.org/licenses/

=cut

__PACKAGE__->meta->make_immutable;

1;

