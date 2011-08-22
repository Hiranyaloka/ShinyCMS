package ShinyCMS::Schema::Result::ShopItemElement;

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

ShinyCMS::Schema::Result::ShopItemElement

=cut

__PACKAGE__->table("shop_item_element");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 item

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 name

  data_type: 'varchar'
  is_nullable: 0
  size: 50

=head2 type

  data_type: 'varchar'
  default_value: 'Short Text'
  is_nullable: 0
  size: 20

=head2 content

  data_type: 'text'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "item",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "name",
  { data_type => "varchar", is_nullable => 0, size => 50 },
  "type",
  {
    data_type => "varchar",
    default_value => "Short Text",
    is_nullable => 0,
    size => 20,
  },
  "content",
  { data_type => "text", is_nullable => 1 },
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


# Created by DBIx::Class::Schema::Loader v0.07006 @ 2011-08-22 12:55:30
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:U9un4MBya5APE0JM0J5B0w


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
