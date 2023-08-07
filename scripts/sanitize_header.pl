#!/usr/bin/perl

=head1 NAME

sanitize_header.pl

=head1 DESCRIPTION

Sanitizes a C<< <teiHeader> >> for correct DDC indexing.

=head1 SYNOPSIS

cat file.xml | sanitize_header.pl <basename>

=head1 AUTHOR

Frank Wiegand, 2023

=cut

use 5.030;
use warnings;

use File::Basename qw(basename);
use Time::Piece;
use XML::LibXML;

my $base = shift;

my $parser = XML::LibXML->new;
my $ns = 'http://www.tei-c.org/ns/1.0';
my $xpc = XML::LibXML::XPathContext->new;

my $header = do { local $/; <> };
$header =~ s{ xmlns="http://www.tei-c.org/ns/1.0"}{}g;

my $source = $parser->load_xml( string => $header );

my %ret;

# date
my ($date) = $xpc->findnodes('//teiHeader/profileDesc/creation/date[@type="sent"]', $source);
if ( $date->getAttribute('when') ) {
    $ret{date} = $date->getAttribute('when');
}
elsif ( $date->getAttribute('notBefore') ) {
    $ret{date} = $date->getAttribute('notBefore');
}
else {
    warn "$base: no date found";
}

my %institutions = (
    dor => 'Dortmund-Aplerbeck',
    gut => 'Gütersloh',
    ham => 'Hamburg',
    kfb => 'Kaufbeuren-Irsee',
    len => 'Lengerich-Bethesda',
    lip => 'Lippstadt',
    mrs => 'Marsberg',
    mun => 'Münster',
    war => 'Warstein',
);

# institution
my ($institutionShort) = $base =~ /^(\w{3})/;
if ( !$institutionShort ) {
    warn "$base: no institution found";
}
elsif ( exists $institutions{$institutionShort} ) {
    $ret{institution} = $institutions{$institutionShort};
}
else {
    warn "$base: could not expand $institutionShort to full name";
}

# record
my ($inst, $no) = $base =~ /^(\w{3})_([^_]+)/;
if ( !$inst or !$no ) {
    warn "$base: could not extract record no. from filename";
}
else {
    $ret{record} = sprintf "%s-%s", $inst, ($no =~ s/^0*//r);
}

# sender
my ($sender) = $xpc->findnodes('//teiHeader/profileDesc/creation/persName[@type="sender"]', $source);
if ( !$sender ) {
    warn "$base: no sender found";
}
else {
    $ret{sender} = _($sender);
    for ( $ret{sender} ) {
        s/[^\s:]+:\s//g;
        s/k\. A\.\s*//g;
        s/\Q (nicht autograph)\E//;
        s/\Q (Abschrift)\E//;
        s/^, //;
    }
}

# sex
my ($sex) = _($xpc->findvalue('//teiHeader/profileDesc/particDesc/person[1]/@sex', $source));
$ret{sex} = $sex;

# addressee
my ($addressee) = _($xpc->findnodes('//teiHeader/profileDesc/creation/persName[@type="addressee"]', $source));
$ret{addressee} = $addressee;
for ( $ret{addressee} ) {
    s/[^\s:]+:\s//g;
    s/k\. A\.\s*//g;
    s/^, //;
}

# place
my ($place) = _($xpc->findnodes('//teiHeader/profileDesc/creation/settlement[@type="sent"]', $source));
$place =~ s/k\. A\.//;
$ret{place} = $place;

# texttype
my $tt;
if ( $base =~ /_(pp|po|ap|ao)[_-]/ ) {
    $tt = $1;
}
else {
    $tt = 'so';
}
$ret{texttype} = $tt;

# availability
my ($availability) = _($xpc->findnodes('//teiHeader/fileDesc/publicationStmt/availability/licence/p', $source));
$ret{availability} = $availability;

# basename
$ret{basename} = basename($base);

# timestamp
my $t = localtime;
$ret{timestamp} = $t->datetime . 'Z';

# bibl
$ret{bibl} = sprintf '%s%s, %s%s [Patientenbrief]',
    $ret{sender},
    ($ret{addressee} ? ' an '.$ret{addressee} : ''),
    ($ret{place} ? $ret{place}.", " : ''),
    ($ret{date} =~ /(\d+)-(\d+)-(\d+)/ ? "$3.$2.$1" : ($ret{date} =~ s/.*?(\d{4}).*?/$1/r));

# first facsimile image
$ret{facsimile} = _($xpc->findnodes('//teiHeader/firstImage', $source));

my $ddc = XML::LibXML::Element->new('ddc');
while ( my ($k, $v) = each %ret ) {
    my $el = XML::LibXML::Element->new($k);
    $el->appendText($v);
    $ddc->appendChild($el);
}

my ($teiHeader) = $xpc->findnodes('//teiHeader', $source);
$teiHeader->appendChild($ddc);

say $source->toString(1);

####################

sub _ {
    my $node = shift || '';
    my $t = ref $node ? $node->textContent : $node;
    for ( $t ) {
        s/\s+/ /g;
        s/(?:^\s*|\s*$)//g;
    }
    return $t;
}

__END__
