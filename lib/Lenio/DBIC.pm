=pod
Lenio - Web-based Facilities Management Software
Copyright (C) 2013 A Beverley

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU Affero General Public License as
published by the Free Software Foundation, either version 3 of the
License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Affero General Public License for more details.

You should have received a copy of the GNU Affero General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
=cut

package Lenio::DBIC;

use base qw(DBIx::Class);

# Used as a component for result sources to perform additional DBIC functions
# (such as validation of values).  For validation, the Result needs a
# validate() function.  It should raise an exception if there is a problem.

__PACKAGE__->mk_group_accessors(simple => qw(site_id));

sub insert
{   my $self = shift;
    $self->_validate(@_);
    my $guard = $self->result_source->schema->txn_scope_guard;
    my $return = $self->next::method(@_);
    $self->after_create
        if $self->can('after_create');
    $guard->commit;
    $return;
}

sub delete
{   my $self = shift;
    $self->before_delete
        if $self->can('before_delete');
    $self->next::method(@_);
}

sub update 
{   my $self = shift;
    $self->_validate(@_);
    $self->next::method(@_);
}

sub _validate
{   my $self = shift;
    $self->validate
        if $self->can('validate');
};

sub parse_dt
{   my ($self, $value) = @_;
    $value or return;
    my $storage = $self->result_source->storage;
    my $format  = $value =~ /\h/ ? 'parse_datetime' : 'parse_date';
    $storage->datetime_parser->$format($value);
}

1;
