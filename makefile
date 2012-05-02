test:
	perl -MTest::Harness -e '$$Test::Harness::verbose=0; runtests @ARGV;' t/*/*.t
coverage:
	cover -delete
	HARNESS_PERL_SWITCHES=-MDevel::Cover make test
	cover
