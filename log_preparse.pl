#!/bin/perl
#
# written by Dan Stephans II
# (Rafinne L`Ongbone, Rallos Zek)

@files = @ARGV;
%months = ( Jan , 1, Feb , 2, Mar , 3, Apr , 4, May , 5, Jun , 6, Jul , 7,
            Aug , 8, Sep , 9, Oct , 10, Nov , 11, Dec , 12 );

print "Output will be saved in file output.txt in current directory.\n";

open( OUTPUT, ">output.txt" ) || die "Cannot open output.txt";

foreach $file ( @files )
{

  if( ! -f $file )
  {
    print "$file does not appear to be a file, skipping...\n";
    next;
  }
  if( $file eq "output.txt" )
  {
    print "output.txt skipped (you must have globbed)\n";
    next;
  }
  open( LOG, "<$file" ) || die "Cannot open $file for read, aborting.";

  while( <LOG> )
  {
    if( /\[[A-Za-z]+ ([A-Za-z]+) ([0-9]+) ([0-9]+:[0-9]+:[0-9]+) ([0-9]+)\] (.*)/ )
    {
      # we break this out for our output so we can write a sortable file
      # since the standard datestamp is wonky and we create a nice stamp
      # that can be dropped right into mySQL
      $month = sprintf( "%02d", $months{ $1 } );
      $day = $2;
      $time = $3;
      $year = $4;
      $_         = $5;
    }
    else
    {
      #invalid log stamp so skip it
      next;
    }
    # test the remainder for valid strings
    if( ! /^AFK/ && !/^\* / && !/^\[/ && !/is a member of/ && !/is the leader of/ && !/is an officer of/ && !/is not in a guild/)
    {
      next;
    }
    print OUTPUT "[$year-$month-$day $time] ",$_, "\n";
  }
  close( LOG );
}

close( OUTPUT );
print "All done.\n";
