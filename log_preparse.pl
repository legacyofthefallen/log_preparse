#!/bin/perl
#
# written by Dan Stephans II
# (Rafinne L`Ongbone, Rallos Zek)
use DateTime;

@files = @ARGV;

print "Output will be saved in file output.txt in current directory.\n";
  if(-f $file && -w $file)
    open( OUTPUT, ">output.txt" ) || die "Cannot open output.txt for write";
  
foreach $file ( @files )
{

  if( ! -f $file )
  {
    print "$file does not appear to be a file, skipping...\n";
    next;
  }
  if (! -r $file)
  {
    print "$file is not readable, skipping...\n";
    next;
  }
  if( $file eq "output.txt" )
  {
    print "output.txt skipped (you must have globbed)\n";
    next;
  }
  open( LOG, "<$file" ); #|| die "Cannot open $file for read, aborting.";

  while( <LOG> )
  {
    my $dt;
    if( /\[([A-Za-z]+ [A-Za-z]+ [0-9]+ [0-9]+:[0-9]+:[0-9]+ [0-9]+)\] (.*)/ )
    {
      # we break this out for our output so we can write a sortable file
      # since the standard datestamp is wonky and we create a nice stamp
      # that can be dropped right into mySQL
      dt = DateTime::Format::HTTP->parse_datetime($1);
      $_         = $2;
    }
    else
    {
      print "invalid log stamp so skip it";
      next;
    }
    # test the remainder for valid strings
    if( ! /^AFK/ && !/^\* / && !/^\[/ && !/is a member of/ && !/is the leader of/ && !/is an officer of/ && !/is not in a guild/)
    {
      next;
    }
    print OUTPUT "[$dt->year-$dt->month_abbr-$dt->day $dt->hms] ",$_, "\n";
    last close(LOG);
  }
  last close( OUTPUT );;
}

print "All done.\n";
