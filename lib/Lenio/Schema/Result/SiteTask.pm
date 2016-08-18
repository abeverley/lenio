use utf8;
package Lenio::Schema::Result::SiteTask;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Lenio::Schema::Result::SiteTask

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 COMPONENTS LOADED

=over 4

=item * L<DBIx::Class::InflateColumn::DateTime>

=back

=cut

__PACKAGE__->load_components("InflateColumn::DateTime", "+Lenio::DBIC");

=head1 TABLE: C<site_task>

=cut

__PACKAGE__->table("site_task");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 task_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 1

=head2 site_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 ticket_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "task_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 1 },
  "site_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "ticket_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 UNIQUE CONSTRAINTS

=head2 C<ticket_id_UNIQUE>

=over 4

=item * L</ticket_id>

=back

=cut

__PACKAGE__->add_unique_constraint("ticket_id_UNIQUE", ["ticket_id"]);

__PACKAGE__->add_unique_constraint("site_task_ticket_UNIQUE", ["site_id", "task_id", "ticket_id"]);

=head1 RELATIONS

=head2 checks_done

Type: has_many

Related object: L<Lenio::Schema::Result::CheckDone>

=cut

__PACKAGE__->has_many(
  "checks_done",
  "Lenio::Schema::Result::CheckDone",
  { "foreign.site_task_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 site

Type: belongs_to

Related object: L<Lenio::Schema::Result::Site>

=cut

__PACKAGE__->belongs_to(
  "site",
  "Lenio::Schema::Result::Site",
  { id => "site_id" },
  { is_deferrable => 1, on_delete => "NO ACTION", on_update => "NO ACTION" },
);

=head2 task

Type: belongs_to

Related object: L<Lenio::Schema::Result::Task>

=cut

__PACKAGE__->belongs_to(
  "task",
  "Lenio::Schema::Result::Task",
  { id => "task_id" },
  {
    is_deferrable => 1,
    join_type     => "LEFT",
    on_delete     => "CASCADE",
    on_update     => "NO ACTION",
  },
);

=head2 ticket

Type: belongs_to

Related object: L<Lenio::Schema::Result::Ticket>

=cut

__PACKAGE__->belongs_to(
  "ticket",
  "Lenio::Schema::Result::Ticket",
  { id => "ticket_id" },
  {
    is_deferrable => 1,
    join_type     => "LEFT",
    on_delete     => "NO ACTION",
    on_update     => "NO ACTION",
  },
);


# Created by DBIx::Class::Schema::Loader v0.07042 @ 2015-06-08 13:50:07
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:NpjKDBZ5omfMRzdJNZeVag

sub last_completed
{   my $self = shift;
    my $schema = $self->result_source->schema;
    my $last_completed = $self->get_column('last_completed')
        or return;
    $self->parse_dt($last_completed);
}

sub last_planned
{   my $self = shift;
    my $schema = $self->result_source->schema;
    my $last_planned = $self->get_column('last_planned')
        or return;
    $self->parse_dt($last_planned);
}


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
