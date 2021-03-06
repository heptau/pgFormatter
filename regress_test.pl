my @files = `find samples/ -maxdepth 1 -name '*.sql' | sort`;
chomp(@files);

foreach my $f (@files) {
	print "Running test on file $f...\n";
	my $opt = '';
	$opt = "-S '\$f\$'" if ($f =~ m#/ex19.sql$#);
	$opt = "-W 4" if ($f =~ m#/ex46.sql$#);
	$opt .= ' -t' if (grep(/^-t/, @ARGV));
	my $cmd = "./pg_format $opt -u 2 $f >/tmp/output.sql";
	`$cmd`;
	$f =~ s/\//\/expected\//;
	if (lc($ARGV[0]) eq 'update') {
		`cp -f /tmp/output.sql $f`;
	} else { 
		my @diff = `diff -u /tmp/output.sql $f | grep "^[+-]" | grep -v "^[+-]\$" | grep -v "^[+-]\t\$" | grep -v "^[+-][+-][+-]"`;
		if ($#diff < 0) {
			print "\ttest ok.\n";
		} else {
			print "\ttest failed!!!\n";
			print @diff;
		}
	}
	unlink("/tmp/output.sql");
}


