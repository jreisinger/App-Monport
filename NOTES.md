To generate `LICENSE` use `App::Software::License`:

    cpanm App::Software::License
    software-license --holder 'Jozef Reisinger' --license Perl_5 --type notice --year 2015 > LICENSE

To upload the distro to CPAN:

    vi lib/App/Monport.pm   # increase $VERSION
    vi Changes
    podselect lib/App/Monport.pm > README.pod
    perl Build.PL && ./Build && ./Build test && ./Build install && \
    ./Build disttest && ./Build dist
    cpan-upload App-Monport-<version>.tar.gz --user reisinge

* http://blogs.perl.org/users/neilb/2014/08/put-your-cpan-distributions-on-github.html
* https://github.com/jreisinger/blog/blob/master/posts/module-build.md
