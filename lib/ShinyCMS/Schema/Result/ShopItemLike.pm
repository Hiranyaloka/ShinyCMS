package ShinyCMS::Schema::Result::ShopItemLike;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';

__PACKAGE__->load_components("InflateColumn::DateTime", "TimeStamp", "EncodedColumn");

=head1 NAME

ShinyCMS::Schema::Result::ShopItemLike

=cut

__PACKAGE__->table("shop_item_like");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 item

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 user

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 1

=head2 ip_address

  data_type: 'varchar'
  is_nullable: 0
  size: 15

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "item",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "user",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 1 },
  "ip_address",
  { data_type => "varchar", is_nullable => 0, size => 15 },
);
__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

=head2 item

Type: belongs_to

Related object: L<ShinyCMS::Schema::Result::ShopItem>

=cut

__PACKAGE__->belongs_to(
  "item",
  "ShinyCMS::Schema::Result::ShopItem",
  { id => "item" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);

=head2 user

Type: belongs_to

Related object: L<ShinyCMS::Schema::Result::User>

=cut

__PACKAGE__->belongs_to(
  "user",
  "ShinyCMS::Schema::Result::User",
  { id => "user" },
  {
    is_deferrable => 1,
    join_type     => "LEFT",
    on_delete     => "CASCADE",
    on_update     => "CASCADE",
  },
);


# Created by DBIx::Class::Schema::Loader v0.07006 @ 2011-08-28 10:32:59
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:RYTFwCT1MF6vFpee440NWQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;