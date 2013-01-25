#!/usr/bin/perl -w
# flac2mp3.pl
# version 3.0.1: filename-hardy and directory-browsing

use strict;
use File::Find;

my ($lame, $flac) = (`which lame`, `which flac`);
chomp($lame, $flac);
die "I require lame and flac to be in your \$PATH!"
	unless ( -x $lame && -x $flac );

sub double_quote_escape {
	# gimme a reference to a string
	# i'll sanitize double-quotes and backslashes in it destructively
	my $r = shift;
	${$r} =~ s/([\\"])/\\$1/g;
};

my ($dir, $pwd) = (shift, `pwd`);
chomp $pwd;
if (!$dir) {
	print "Convert all FLACs in $pwd AND all subdirectories? [y/N] ";
	chomp(my $r = <>);
	die "You didn't say Yes, so I'm quitting.\n"
		unless ($r =~ /^y(es)?$/i);
	$dir = $pwd;
}

die "I need a readable directory as a first argument \n(or nothing at all, then I'll work on the current directory)"
	unless (-d $dir);

find (
	sub {
		# File::Find cd's us into the dir automagically
		if (/\.flac$/ && -f) {
			double_quote_escape(\$_);
			print "\n\n\nConverting $_...\n\n\n";
			system "flac -d -o \"$_.wav\" \"$_\"";
			system "lame --abr 320 \"$_.wav\" \"$_.mp3\"";
			system "rm \"$_.wav\"";
		}
	},
	$dir
);
escape(\$pwd);
system "cd $pwd";
print "Done!\n";
