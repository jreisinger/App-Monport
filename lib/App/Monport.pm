package App::Monport;
use strict;
use warnings;
use IO::Socket;
use List::Util qw(shuffle);

our $VERSION = '1.01';

=for HTML <a href="https://travis-ci.org/jreisinger/App-Monport"><img src="https://travis-ci.org/jreisinger/App-Monport.svg?branch=master"></a>

=head1 NAME

App::Monport - Monitor network ports for changes

=head1 SYNOPSIS

 $ monport

=head1 DESCRIPTION

Use this application to find out whether some new ports have been opened or
existing ones have been closed. New open ports mean bigger attack surface and
consequently higher security risk. On the other hand if a port gets closed it
might indicate a problem with a network service.

The application works by comparing the actual state of ports (open or closed)
with the expected state defined in the configuration file.

=head1 INSTALLATION

To install this module run:

 $ cpan App::Monport

or

 $ cpanm App::Monport

when using L<App::cpanminus>.

To install manually clone the L</"SOURCE REPOSITORY"> and then run (on Unix):

 perl Build.PL
 ./Build
 ./Build test
 ./Build install

For more see L<StackOverflow|http://stackoverflow.com/questions/65865/whats-the-easiest-way-to-install-a-missing-perl-module>
or L<CPAN|http://www.cpan.org/modules/INSTALL.html> instructions.

=head1 SOURCE REPOSITORY

L<http://github.com/jreisinger/App-Monport>

=head1 AUTHOR

Jozef Reisinger, E<lt>reisinge@cpan.orgE<gt>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2015 by Jozef Reisinger.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

sub scan_ports {
    my $host = shift;
    my @open;
    print "scanning $host: \n";
    my $ports = default_ports();
    for my $port (@$ports) {
        my $socket = IO::Socket::INET->new(
            PeerAddr => $host,
            PeerPort => $port,
            Proto    => 'tcp',
            Type     => SOCK_STREAM,
            Timeout  => 1,
        );

        if ($socket) {
            push @open, $port;
            shutdown( $socket, 2 );
        }
    }

    return \@open;
}


sub default_ports {
    my %port_directory;

    while (<DATA>) {
        next if /^#/;    # skip comments
        chomp;
        my ( $name, $number_protocol, $probability, $comments ) = split /\t/;
        my ( $port, $proto ) = split /\//, $number_protocol;

        $port_directory{$number_protocol} = {
            port        => $port,
            proto       => $proto,
            name        => $name,
            probability => $probability,
            comments    => $comments,
        };
    }

    my @ports = shuffle do {
        map { $port_directory{$_}->{port} }
          grep {
                 $port_directory{$_}->{name} !~ /^unknown$/
              && $port_directory{$_}->{proto} eq 'tcp'
          } keys %port_directory;
    };

    return \@ports;
}


1;

__DATA__
# THIS FILE IS GENERATED AUTOMATICALLY FROM A MASTER - DO NOT EDIT.
# EDIT /nmap-private-dev/nmap-services-all IN SVN INSTEAD.
# Well known service port numbers -*- mode: fundamental; -*-
# From the Nmap Security Scanner ( http://nmap.org )
#
# $Id: nmap-services 9746 2008-08-26 18:45:24Z fyodor $
#
# Derived from IANA data and our own research
#
# This collection of service data is (C) 1996-2011 by Insecure.Com
# LLC.  It is distributed under the Nmap Open Source license as
# provided in the COPYING file of the source distribution or at
# http://nmap.org/data/COPYING .  Note that this license
# requires you to license your own work under a compatable open source
# license.  If you wish to embed Nmap technology into proprietary
# software, we sell alternative licenses (contact sales@insecure.com).
# Dozens of software vendors already license Nmap technology such as
# host discovery, port scanning, OS detection, and version detection.
# For more details, see http://nmap.org/book/man-legal.html
#
# Fields in this file are: Service name, portnum/protocol, open-frequency, optional comments
#
tcpmux	1/tcp	0.001995	# TCP Port Service Multiplexer [rfc-1078]
tcpmux	1/udp	0.001236	# TCP Port Service Multiplexer
compressnet	2/tcp	0.000013	# Management Utility
compressnet	2/udp	0.001845	# Management Utility
compressnet	3/tcp	0.001242	# Compression Process
compressnet	3/udp	0.001532	# Compression Process
unknown	4/tcp	0.000477
rje	5/udp	0.000593	# Remote Job Entry
unknown	6/tcp	0.000502
echo	7/sctp	0.000000
echo	7/tcp	0.004855
echo	7/udp	0.024679
unknown	8/tcp	0.000013
discard	9/sctp	0.000000	# sink null
discard	9/tcp	0.003764	# sink null
discard	9/udp	0.015733	# sink null
unknown	10/tcp	0.000063
systat	11/tcp	0.000075	# Active Users
systat	11/udp	0.000577	# Active Users
unknown	12/tcp	0.000063
daytime	13/tcp	0.003927
daytime	13/udp	0.004827
unknown	14/tcp	0.000038
netstat	15/tcp	0.000038
unknown	16/tcp	0.000050
qotd	17/tcp	0.002346	# Quote of the Day
qotd	17/udp	0.009209	# Quote of the Day
msp	18/udp	0.000610	# Message Send Protocol
chargen	19/tcp	0.002559	# ttytst source Character Generator
chargen	19/udp	0.015865	# ttytst source Character Generator
ftp-data	20/sctp	0.000000	# File Transfer [Default Data]
ftp-data	20/tcp	0.001079	# File Transfer [Default Data]
ftp-data	20/udp	0.001878	# File Transfer [Default Data]
ftp	21/sctp	0.000000	# File Transfer [Control]
ftp	21/tcp	0.197667	# File Transfer [Control]
ftp	21/udp	0.004844	# File Transfer [Control]
ssh	22/sctp	0.000000	# Secure Shell Login
ssh	22/tcp	0.182286	# Secure Shell Login
ssh	22/udp	0.003905	# Secure Shell Login
telnet	23/tcp	0.221265
telnet	23/udp	0.006211
priv-mail	24/tcp	0.001154	# any private mail system
priv-mail	24/udp	0.000329	# any private mail system
smtp	25/tcp	0.131314	# Simple Mail Transfer
smtp	25/udp	0.001285	# Simple Mail Transfer
rsftp	26/tcp	0.007991	# RSFTP
nsw-fe	27/tcp	0.000138	# NSW User System FE
nsw-fe	27/udp	0.000395	# NSW User System FE
unknown	28/tcp	0.000050
msg-icp	29/tcp	0.000025	# MSG ICP
msg-icp	29/udp	0.000560	# MSG ICP
unknown	30/tcp	0.000527
msg-auth	31/tcp	0.000025	# MSG Authentication
msg-auth	31/udp	0.000939	# MSG Authentication
unknown	32/tcp	0.000339
dsp	33/tcp	0.001016	# Display Support Protocol
dsp	33/udp	0.000560	# Display Support Protocol
unknown	34/tcp	0.000025
priv-print	35/tcp	0.000038	# any private printer server
priv-print	35/udp	0.000708	# any private printer server
time	37/tcp	0.003161	# timserver
time	37/udp	0.006458	# timserver
rap	38/tcp	0.000025	# Route Access Protocol
rap	38/udp	0.002043	# Route Access Protocol
rlp	39/udp	0.000478	# Resource Location Protocol
unknown	40/tcp	0.000038
graphics	41/udp	0.000445
nameserver	42/tcp	0.000803	# Host Name Server
nameserver	42/udp	0.005288	# Host Name Server
whois	43/tcp	0.000314	# nicname
whois	43/udp	0.000313	# nicname
mpm-flags	44/tcp	0.000025	# MPM FLAGS Protocol
mpm-flags	44/udp	0.000659	# MPM FLAGS Protocol
mpm	45/tcp	0.000050	# Message Processing Module [recv]
mpm	45/udp	0.000741	# Message Processing Module [recv]
mpm-snd	46/udp	0.000494	# MPM [default send]
ni-ftp	47/tcp	0.000075	# NI FTP
ni-ftp	47/udp	0.001071	# NI FTP
auditd	48/tcp	0.000013	# Digital Audit Daemon
auditd	48/udp	0.000708	# Digital Audit Daemon
tacacs	49/tcp	0.000665	# Login Host Protocol (TACACS)
tacacs	49/udp	0.014020	# Login Host Protocol (TACACS)
re-mail-ck	50/tcp	0.000050	# Remote Mail Checking Protocol
re-mail-ck	50/udp	0.000428	# Remote Mail Checking Protocol
la-maint	51/tcp	0.000038	# IMP Logical Address Maintenance
la-maint	51/udp	0.000280	# IMP Logical Address Maintenance
xns-time	52/tcp	0.000063	# XNS Time Protocol
xns-time	52/udp	0.000362	# XNS Time Protocol
domain	53/tcp	0.048463	# Domain Name Server
domain	53/udp	0.213496	# Domain Name Server
xns-ch	54/tcp	0.000013	# XNS Clearinghouse
xns-ch	54/udp	0.000659	# XNS Clearinghouse
isi-gl	55/tcp	0.000125	# ISI Graphics Language
isi-gl	55/udp	0.000478	# ISI Graphics Language
xns-auth	56/tcp	0.000013	# XNS Authentication
xns-auth	56/udp	0.001285	# XNS Authentication
priv-term	57/tcp	0.000125	# any private terminal access
priv-term	57/udp	0.000774	# any private terminal access
xns-mail	58/tcp	0.000025	# XNS Mail
xns-mail	58/udp	0.000428	# XNS Mail
priv-file	59/tcp	0.000088	# any private file service
priv-file	59/udp	0.000478	# any private file service
unknown	60/tcp	0.000038
ni-mail	61/udp	0.000461	# NI MAIL
acas	62/udp	0.000264	# ACA Services
via-ftp	63/udp	0.000445	# VIA Systems - FTP & whois++
covia	64/udp	0.000593	# Communications Integrator (CI)
tacacs-ds	65/tcp	0.000013	# TACACS-Database Service
tacacs-ds	65/udp	0.000741	# TACACS-Database Service
sqlnet	66/tcp	0.000075	# Oracle SQL*NET
sqlnet	66/udp	0.000544	# Oracle SQL*NET
dhcps	67/tcp	0.000013	# DHCP/Bootstrap Protocol Server
dhcps	67/udp	0.228010	# DHCP/Bootstrap Protocol Server
dhcpc	68/tcp	0.000063	# DHCP/Bootstrap Protocol Client
dhcpc	68/udp	0.140118	# DHCP/Bootstrap Protocol Client
tftp	69/tcp	0.000038	# Trivial File Transfer
tftp	69/udp	0.102835	# Trivial File Transfer
gopher	70/tcp	0.000226
gopher	70/udp	0.000544
netrjs-1	71/tcp	0.000025	# Remote Job Service
netrjs-1	71/udp	0.000560	# Remote Job Service
netrjs-2	72/tcp	0.000013	# Remote Job Service
netrjs-2	72/udp	0.000494	# Remote Job Service
netrjs-3	73/tcp	0.000025	# Remote Job Service
netrjs-3	73/udp	0.000428	# Remote Job Service
netrjs-4	74/tcp	0.000025	# Remote Job Service
netrjs-4	74/udp	0.000478	# Remote Job Service
priv-dial	75/tcp	0.000063	# any private dial out service
priv-dial	75/udp	0.000577	# any private dial out service
deos	76/tcp	0.000063	# Distributed External Object Store
deos	76/udp	0.000675	# Distributed External Object Store
priv-rje	77/tcp	0.000113	# any private RJE service, netrjs
priv-rje	77/udp	0.000741	# any private RJE service, netjrs
vettcp	78/udp	0.000626
finger	79/tcp	0.006022
finger	79/udp	0.000956
http	80/sctp	0.000000	# World Wide Web HTTP
http	80/tcp	0.484143	# World Wide Web HTTP
http	80/udp	0.035767	# World Wide Web HTTP
hosts2-ns	81/tcp	0.012056	# HOSTS2 Name Server
hosts2-ns	81/udp	0.001005	# HOSTS2 Name Server
xfer	82/tcp	0.002923	# XFER Utility
xfer	82/udp	0.000659	# XFER Utility
mit-ml-dev	83/tcp	0.000539	# MIT ML Device
mit-ml-dev	83/udp	0.001203	# MIT ML Device
ctf	84/tcp	0.000276	# Common Trace Facility
ctf	84/udp	0.000610	# Common Trace Facility
mit-ml-dev	85/tcp	0.000690	# MIT ML Device
mit-ml-dev	85/udp	0.000610	# MIT ML Device
mfcobol	86/tcp	0.000138	# Micro Focus Cobol
mfcobol	86/udp	0.000824	# Micro Focus Cobol
priv-term-l	87/tcp	0.000125	# any private terminal link, ttylink
kerberos-sec	88/tcp	0.006072	# Kerberos (v5)
kerberos-sec	88/udp	0.013476	# Kerberos (v5)
su-mit-tg	89/tcp	0.000376	# SU/MIT Telnet Gateway
su-mit-tg	89/udp	0.000494	# SU/MIT Telnet Gateway
dnsix	90/tcp	0.000652	# DNSIX Securit Attribute Token Map
dnsix	90/udp	0.000511	# DNSIX Securit Attribute Token Map
mit-dov	91/tcp	0.000063	# MIT Dover Spooler
mit-dov	91/udp	0.000478	# MIT Dover Spooler
npp	92/tcp	0.000050	# Network Printing Protocol
npp	92/udp	0.000478	# Network Printing Protocol
dcp	93/tcp	0.000025	# Device Control Protocol
dcp	93/udp	0.000774	# Device Control Protocol
objcall	94/tcp	0.000025	# Tivoli Object Dispatcher
objcall	94/udp	0.000428	# Tivoli Object Dispatcher
supdup	95/tcp	0.000025	# BSD supdupd(8)
supdup	95/udp	0.000379
dixie	96/tcp	0.000013	# DIXIE Protocol Specification
dixie	96/udp	0.000939	# DIXIE Protocol Specification
swift-rvf	97/tcp	0.000038	# Swift Remote Virtural File Protocol
swift-rvf	97/udp	0.000362	# Swift Remote Virtural File Protocol
linuxconf	98/tcp	0.000088
tacnews	98/udp	0.000560	# TAC News
metagram	99/tcp	0.000326	# Metagram Relay
metagram	99/udp	0.000972	# Metagram Relay
newacct	100/tcp	0.002133	# [unauthorized use]
hostname	101/tcp	0.000063	# hostnames NIC Host Name Server
hostname	101/udp	0.000560	# hostnames NIC Host Name Server
iso-tsap	102/tcp	0.000138	# tsap ISO-TSAP Class 0
iso-tsap	102/udp	0.000544	# tsap ISO-TSAP Class 0
gppitnp	103/tcp	0.000038	# Genesis Point-to-Point Trans Net, or x400 ISO Email
gppitnp	103/udp	0.000527	# Genesis Point-to-Point Trans Net
acr-nema	104/tcp	0.000063	# ACR-NEMA Digital Imag. & Comm. 300
acr-nema	104/udp	0.000643	# ACR-NEMA Digital Imag. & Comm. 300
csnet-ns	105/udp	0.000478	# Mailbox Name Nameserver
pop3pw	106/tcp	0.005934	# Eudora compatible PW changer
3com-tsmux	106/udp	0.000544
rtelnet	107/udp	0.000478	# Remote Telnet Service
snagas	108/tcp	0.000013	# SNA Gateway Access Server
snagas	108/udp	0.000494	# SNA Gateway Access Server
pop2	109/tcp	0.000188	# PostOffice V.2
pop2	109/udp	0.000461	# PostOffice V.2
pop3	110/tcp	0.077142	# PostOffice V.3
pop3	110/udp	0.001104	# PostOffice V.3
rpcbind	111/tcp	0.030034	# portmapper, rpcbind
rpcbind	111/udp	0.093988	# portmapper, rpcbind
mcidas	112/tcp	0.000050	# McIDAS Data Transmission Protocol
mcidas	112/udp	0.002208	# McIDAS Data Transmission Protocol
ident	113/tcp	0.012370	# ident, tap, Authentication Service
auth	113/udp	0.003031	# ident, tap, Authentication Service
audionews	114/tcp	0.000025	# Audio News Multicast
audionews	114/udp	0.000362	# Audio News Multicast
sftp	115/tcp	0.000025	# Simple File Transfer Protocol
sftp	115/udp	0.000346	# Simple File Transfer Protocol
ansanotify	116/tcp	0.000013	# ANSA REX Notify
ansanotify	116/udp	0.000445	# ANSA REX Notify
uucp-path	117/tcp	0.000013	# UUCP Path Service
uucp-path	117/udp	0.000527	# UUCP Path Service
sqlserv	118/tcp	0.000025	# SQL Services
sqlserv	118/udp	0.000791	# SQL Services
nntp	119/tcp	0.003262	# Network News Transfer Protocol
nntp	119/udp	0.000428	# Network News Transfer Protocol
cfdptkt	120/tcp	0.000025
cfdptkt	120/udp	0.010181
erpc	121/udp	0.000675	# Encore Expedited Remote Pro.Call
smakynet	122/tcp	0.000063
smakynet	122/udp	0.000428
ntp	123/tcp	0.000138	# Network Time Protocol
ntp	123/udp	0.330879	# Network Time Protocol
ansatrader	124/tcp	0.000013	# ANSA REX Trader
ansatrader	124/udp	0.000610	# ANSA REX Trader
locus-map	125/tcp	0.000176	# Locus PC-Interface Net Map Ser
locus-map	125/udp	0.000478	# Locus PC-Interface Net Map Ser
unitary	126/udp	0.000610	# Unisys Unitary Login
locus-con	127/tcp	0.000113	# Locus PC-Interface Conn Server
locus-con	127/udp	0.000412	# Locus PC-Interface Conn Server
gss-xlicen	128/tcp	0.000013	# GSS X License Verification
gss-xlicen	128/udp	0.000494	# GSS X License Verification
pwdgen	129/tcp	0.000025	# Password Generator Protocol
pwdgen	129/udp	0.000412	# Password Generator Protocol
cisco-fna	130/tcp	0.000013	# cisco FNATIVE
cisco-fna	130/udp	0.000774	# cisco FNATIVE
cisco-tna	131/udp	0.000560	# cisco TNATIVE
cisco-sys	132/tcp	0.000013	# cisco SYSMAINT
cisco-sys	132/udp	0.000923	# cisco SYSMAINT
statsrv	133/tcp	0.000025	# Statistics Service
statsrv	133/udp	0.000758	# Statistics Service
ingres-net	134/udp	0.001203	# INGRES-NET Service
msrpc	135/tcp	0.047798	# Microsoft RPC services
msrpc	135/udp	0.244452	# Microsoft RPC services
profile	136/tcp	0.000025	# PROFILE Naming System
profile	136/udp	0.051862	# PROFILE Naming System
netbios-ns	137/tcp	0.000038	# NETBIOS Name Service
netbios-ns	137/udp	0.365163	# NETBIOS Name Service
netbios-dgm	138/tcp	0.000025	# NETBIOS Datagram Service
netbios-dgm	138/udp	0.297830	# NETBIOS Datagram Service
netbios-ssn	139/tcp	0.050809	# NETBIOS Session Service
netbios-ssn	139/udp	0.193726	# NETBIOS Session Service
emfis-data	140/udp	0.000692	# EMFIS Data Service
emfis-cntl	141/tcp	0.000013	# EMFIS Control Service
emfis-cntl	141/udp	0.000428	# EMFIS Control Service
bl-idm	142/tcp	0.000013	# Britton-Lee IDM
bl-idm	142/udp	0.000428	# Britton-Lee IDM
imap	143/tcp	0.050420	# Interim Mail Access Protocol v2
imap	143/udp	0.000659	# Interim Mail Access Protocol v2
news	144/tcp	0.004981	# NewS window system
news	144/udp	0.000346	# NewS window system
uaac	145/udp	0.001153	# UAAC Protocol
iso-tp0	146/tcp	0.000577
iso-tp0	146/udp	0.000890
iso-ip	147/udp	0.000511
cronus	148/tcp	0.000013	# CRONUS-SUPPORT
cronus	148/udp	0.000445	# CRONUS-SUPPORT
aed-512	149/tcp	0.000013	# AED 512 Emulation Service
aed-512	149/udp	0.000445	# AED 512 Emulation Service
sql-net	150/tcp	0.000013
sql-net	150/udp	0.000840
hems	151/tcp	0.000013
hems	151/udp	0.000412
bftp	152/udp	0.000988	# Background File Transfer Program
sgmp	153/udp	0.000346
netsc-prod	154/udp	0.000379
netsc-dev	155/udp	0.000659
sqlsrv	156/udp	0.000461	# SQL Service
knet-cmp	157/tcp	0.000113	# KNET/VM Command/Message Protocol
knet-cmp	157/udp	0.000247	# KNET/VM Command/Message Protocol
pcmail-srv	158/tcp	0.000063	# PCMail Server
pcmail-srv	158/udp	0.010148	# PCMail Server
nss-routing	159/udp	0.000329
sgmp-traps	160/udp	0.000824
snmp	161/tcp	0.000790
snmp	161/udp	0.433467	# Simple Net Mgmt Proto
snmptrap	162/tcp	0.000013	# snmp-trap
snmptrap	162/udp	0.103346	# snmp-trap
cmip-man	163/tcp	0.000590	# CMIP/TCP Manager
cmip-man	163/udp	0.000840	# CMIP/TCP Manager
smip-agent	164/udp	0.000626	# CMIP/TCP Agent
xns-courier	165/udp	0.000379	# Xerox
s-net	166/udp	0.000461	# Sirius Systems
namp	167/udp	0.000395
rsvd	168/tcp	0.000013
rsvd	168/udp	0.000412
send	169/udp	0.000494
print-srv	170/udp	0.001071	# Network PostScript
multiplex	171/udp	0.000412	# Network Innovations Multiplex
cl-1	172/udp	0.000494	# Network Innovations CL/1
xyplex-mux	173/tcp	0.000013
xyplex-mux	173/udp	0.000329
mailq	174/tcp	0.000013
mailq	174/udp	0.000379
vmnet	175/udp	0.000379
genrad-mux	176/tcp	0.000025
genrad-mux	176/udp	0.000313
xdmcp	177/tcp	0.000025	# X Display Mgr. Control Proto
xdmcp	177/udp	0.018551	# X Display Manager Control Protocol
nextstep	178/udp	0.000346	# NextStep Window Server
bgp	179/sctp	0.000000	# Border Gateway Protocol
bgp	179/tcp	0.010538	# Border Gateway Protocol
bgp	179/udp	0.000494	# Border Gateway Protocol
ris	180/tcp	0.000038	# Intergraph
ris	180/udp	0.000478	# Intergraph
unify	181/tcp	0.000025
unify	181/udp	0.000181
audit	182/tcp	0.000038	# Unisys Audit SITP
audit	182/udp	0.000297	# Unisys Audit SITP
ocbinder	183/udp	0.000560
ocserver	184/tcp	0.000013
ocserver	184/udp	0.000461
remote-kis	185/tcp	0.000013
remote-kis	185/udp	0.000428
kis	186/udp	0.000280	# KIS Protocol
aci	187/udp	0.000395	# Application Communication Interface
mumps	188/udp	0.000527	# Plus Five's MUMPS
qft	189/tcp	0.000013	# Queued File Transport
qft	189/udp	0.000461	# Queued File Transport
gacp	190/tcp	0.000013	# Gateway Access Control Protocol
cacp	190/udp	0.000428	# Gateway Access Control Protocol
prospero	191/tcp	0.000013	# Prospero Directory Service
prospero	191/udp	0.000857	# Prospero Directory Service
osu-nms	192/tcp	0.000013	# OSU Network Monitoring System
osu-nms	192/udp	0.004168	# OSU Network Monitoring System
srmp	193/tcp	0.000025	# Spider Remote Monitoring Protocol
srmp	193/udp	0.000412	# Spider Remote Monitoring Protocol
irc	194/tcp	0.000038	# Internet Relay Chat
irc	194/udp	0.000643	# Internet Relay Chat Protocol
dn6-nlm-aud	195/udp	0.000395	# DNSIX Network Level Module Audit
dn6-smm-red	196/tcp	0.000025	# DNSIX Session Mgt Module Audit Redir
dn6-smm-red	196/udp	0.000428	# DNSIX Session Mgt Module Audit Redir
dls	197/udp	0.000659	# Directory Location Service
dls-mon	198/udp	0.001252	# Directory Location Service Monitor
smux	199/tcp	0.015945	# SNMP Unix Multiplexer
smux	199/udp	0.004152
src	200/tcp	0.000025	# IBM System Resource Controller
src	200/udp	0.000626	# IBM System Resource Controller
at-rtmp	201/tcp	0.000038	# AppleTalk Routing Maintenance
at-rtmp	201/udp	0.000988	# AppleTalk Routing Maintenance
at-nbp	202/tcp	0.000025	# AppleTalk Name Binding
at-nbp	202/udp	0.000445	# AppleTalk Name Binding
at-3	203/udp	0.000461	# AppleTalk Unused
at-echo	204/tcp	0.000025	# AppleTalk Echo
at-echo	204/udp	0.000412	# AppleTalk Echo
at-5	205/tcp	0.000013	# AppleTalk Unused
at-5	205/udp	0.000890	# AppleTalk Unused
at-zis	206/tcp	0.000025	# AppleTalk Zone Information
at-zis	206/udp	0.000956	# AppleTalk Zone Information
at-7	207/udp	0.001351	# AppleTalk Unused
at-8	208/udp	0.000511	# AppleTalk Unused
tam	209/tcp	0.000013	# Trivial Authenticated Mail Protocol
tam	209/udp	0.000395	# Trivial Authenticated Mail Protocol
z39.50	210/tcp	0.000125	# wais, ANSI Z39.50
z39.50	210/udp	0.000511	# wais, ANSI Z39.50
914c-g	211/tcp	0.000427	# Texas Instruments 914C/G Terminal
914c-g	211/udp	0.000329	# Texas Instruments 914C/G Terminal
anet	212/tcp	0.000364	# ATEXSSTR
anet	212/udp	0.000329	# ATEXSSTR
ipx	213/tcp	0.000038
ipx	213/udp	0.000478
vmpwscs	214/tcp	0.000038
vmpwscs	214/udp	0.000445
softpc	215/udp	0.000412	# Insignia Solutions
atls	216/tcp	0.000013	# Access Technology License Server
atls	216/udp	0.000461	# Access Technology License Server
dbase	217/tcp	0.000013	# dBASE Unix
dbase	217/udp	0.001993	# dBASE Unix
mpp	218/udp	0.000593	# Netix Message Posting Protocol
uarps	219/tcp	0.000063	# Unisys ARPs
uarps	219/udp	0.000395	# Unisys ARPs
imap3	220/tcp	0.000113	# Interactive Mail Access Protocol v3
imap3	220/udp	0.000445	# Interactive Mail Access Protocol v3
fln-spx	221/tcp	0.000050	# Berkeley rlogind with SPX auth
fln-spx	221/udp	0.000577	# Berkeley rlogind with SPX auth
rsh-spx	222/tcp	0.000941	# Berkeley rshd with SPX auth
rsh-spx	222/udp	0.000774	# Berkeley rshd with SPX auth
cdc	223/tcp	0.000125	# Certificate Distribution Center
cdc	223/udp	0.000346	# Certificate Distribution Center
masqdialer	224/tcp	0.000025
unknown	225/tcp	0.000100
unknown	225/udp	0.000330
unknown	226/tcp	0.000013
unknown	228/tcp	0.000013
unknown	229/tcp	0.000013
unknown	230/tcp	0.000050
unknown	231/tcp	0.000038
unknown	233/tcp	0.000025
unknown	234/tcp	0.000013
unknown	235/tcp	0.000025
unknown	236/tcp	0.000025
unknown	236/udp	0.000330
unknown	237/tcp	0.000063
unknown	238/tcp	0.000013
unknown	238/udp	0.000330
unknown	239/udp	0.000330
direct	242/udp	0.000362
sur-meas	243/udp	0.000494	# Survey Measurement
dayna	244/udp	0.000461
link	245/udp	0.000626
dsp3270	246/udp	0.000593	# Display Systems Protocol
subntbcst_tftp	247/udp	0.000412
bhfhs	248/tcp	0.000013
bhfhs	248/udp	0.000511
unknown	249/tcp	0.000050
unknown	250/tcp	0.000138
unknown	251/tcp	0.000125
unknown	252/tcp	0.000088
unknown	253/tcp	0.000038
unknown	254/tcp	0.001832
unknown	255/tcp	0.002409
fw1-secureremote	256/tcp	0.000163	# also "rap"
rap	256/udp	0.000692
fw1-mc-fwmodule	257/tcp	0.000100	# FW1 management console for communication w/modules and also secure electronic transaction (set) port
set	257/udp	0.000511	# secure electronic transaction
fw1-mc-gui	258/tcp	0.000013	# also yak winsock personal chat
yak-chat	258/udp	0.000494	# yak winsock personal chat
esro-gen	259/tcp	0.000201	# efficient short remote operations
firewall1-rdp	259/udp	0.000840	# Firewall 1 proprietary RDP protocol http://www.inside-security.de/fw1_rdp_poc.html
openport	260/tcp	0.000025
openport	260/udp	0.000362
nsiiops	261/tcp	0.000025	# iiop name service over tls/ssl
nsiiops	261/udp	0.000659	# iiop name service over tls/ssl
arcisdms	262/tcp	0.000038
arcisdms	262/udp	0.000577
hdap	263/udp	0.000544
bgmp	264/tcp	0.001029
fw1-or-bgmp	264/udp	0.000461	# FW1 secureremote alternate
maybe-fw1	265/tcp	0.000013
td-service	267/tcp	0.000013	# Tobit David Service Layer
td-replica	268/tcp	0.000050	# Tobit David Replica
unknown	270/tcp	0.000013
unknown	271/tcp	0.000013
unknown	273/tcp	0.000025
unknown	276/tcp	0.000025
unknown	277/tcp	0.000013
http-mgmt	280/tcp	0.001844
http-mgmt	280/udp	0.000379
personal-link	281/udp	0.000544
cableport-ax	282/udp	0.000494	# cable port a/x
corerjd	284/tcp	0.000013
unknown	288/tcp	0.000013
unknown	289/tcp	0.000013
unknown	293/tcp	0.000013
unknown	294/tcp	0.000013
unknown	294/udp	0.000330
unknown	295/tcp	0.000013
unknown	300/tcp	0.000050
unknown	301/tcp	0.000213
unknown	303/tcp	0.000025
unknown	304/udp	0.000991
unknown	305/tcp	0.000013
unknown	306/tcp	0.000464
unknown	307/udp	0.000330
novastorbakcup	308/tcp	0.000025	# novastor backup
novastorbakcup	308/udp	0.000329	# novastor backup
entrusttime	309/udp	0.000527
bhmds	310/udp	0.000445
asip-webadmin	311/tcp	0.001857	# appleshare ip webadmin
asip-webadmin	311/udp	0.000494	# appleshare ip webadmin
vslmp	312/udp	0.000593
magenta-logic	313/udp	0.000297
opalis-robot	314/udp	0.000840
dpsi	315/tcp	0.000025
dpsi	315/udp	0.000379
decauth	316/tcp	0.000013
decauth	316/udp	0.000461
zannet	317/udp	0.000346
pip	321/udp	0.000593
rtsps	322/tcp	0.000013	# RTSPS
unknown	323/udp	0.000330
unknown	325/tcp	0.000025
unknown	326/tcp	0.000013
unknown	326/udp	0.000330
unknown	329/tcp	0.000013
texar	333/tcp	0.000113	# Texar Security Port
texar	333/udp	0.000330	# Texar Security Port
unknown	334/tcp	0.000050
unknown	336/tcp	0.000025
unknown	337/tcp	0.000013
unknown	340/tcp	0.000627
unknown	340/udp	0.000330
unknown	343/tcp	0.000050
pdap	344/udp	0.000445	# Prospero Data Access Protocol
pawserv	345/udp	0.000428	# Perf Analysis Workbench
zserv	346/tcp	0.000013	# Zebra server
zserv	346/udp	0.000428	# Zebra server
fatserv	347/udp	0.000708	# Fatmen Server
csi-sgwp	348/udp	0.000511	# Cabletron Management Protocol
mftp	349/udp	0.000297
matip-type-a	350/tcp	0.000025	# MATIP Type A
matip-type-a	350/udp	0.000379
matip-type-b	351/tcp	0.000013	# MATIP Type B or bhoetty also safetp
matip-type-b	351/udp	0.000313	# MATIP Type B or bhoetty
dtag-ste-sb	352/tcp	0.000013	# DTAG, or bhoedap4
dtag-ste-sb	352/udp	0.000593	# DTAG, or bhoedap4
ndsauth	353/tcp	0.000050
ndsauth	353/udp	0.000264
bh611	354/udp	0.000560
datex-asn	355/tcp	0.000025
datex-asn	355/udp	0.000774
cloanto-net-1	356/udp	0.000610
bhevent	357/udp	0.000478
shrinkwrap	358/tcp	0.000013
shrinkwrap	358/udp	0.000445
tenebris_nts	359/udp	0.000494	# Tenebris Network Trace Service
scoi2odialog	360/tcp	0.000013
scoi2odialog	360/udp	0.000560
semantix	361/tcp	0.000013
semantix	361/udp	0.000346
srssend	362/tcp	0.000025	# SRS Send
srssend	362/udp	0.000445	# SRS Send
rsvp_tunnel	363/udp	0.002125
aurora-cmgr	364/tcp	0.000013
aurora-cmgr	364/udp	0.000395
dtk	365/udp	0.000395	# Deception Tool Kit (www.all.net)
odmr	366/tcp	0.000715
odmr	366/udp	0.000478
mortgageware	367/udp	0.000445
qbikgdp	368/udp	0.000264
rpc2portmap	369/tcp	0.000013
rpc2portmap	369/udp	0.000725
codaauth2	370/tcp	0.000013
codaauth2	370/udp	0.001038
clearcase	371/udp	0.000593
ulistserv	372/udp	0.000593	# Unix Listserv
legent-1	373/tcp	0.000013	# Legent Corporation (now Computer Associates Intl.)
legent-1	373/udp	0.000395	# Legent Corporation (now Computer Associates Intl.)
legent-2	374/udp	0.000610	# Legent Corporation (now Computer Associates Intl.)
hassle	375/udp	0.000544
nip	376/udp	0.001120	# Amiga Envoy Network Inquiry Proto
tnETOS	377/udp	0.000725	# NEC Corporation
dsETOS	378/udp	0.000544	# NEC Corporation
is99c	379/udp	0.000395	# TIA/EIA/IS-99 modem client
is99s	380/tcp	0.000013	# TIA/EIA/IS-99 modem server
is99s	380/udp	0.000494	# TIA/EIA/IS-99 modem server
hp-collector	381/udp	0.000577	# hp performance data collector
hp-managed-node	382/udp	0.000346	# hp performance data managed node
hp-alarm-mgr	383/tcp	0.000013	# hp performance data alarm manager
hp-alarm-mgr	383/udp	0.000362	# hp performance data alarm manager
arns	384/udp	0.000412	# A Remote Network Server System
ibm-app	385/udp	0.000692	# IBM Application
asa	386/udp	0.000741	# ASA Message Router Object Def.
aurp	387/udp	0.001285	# Appletalk Update-Based Routing Pro.
unidata-ldm	388/tcp	0.000088	# Unidata LDM Version 4
unidata-ldm	388/udp	0.000329	# Unidata LDM Version 4
ldap	389/tcp	0.004717	# Lightweight Directory Access Protocol
ldap	389/udp	0.004300	# Lightweight Directory Access Protocol
uis	390/udp	0.000478
synotics-relay	391/tcp	0.000013	# SynOptics SNMP Relay Port
synotics-relay	391/udp	0.000988	# SynOptics SNMP Relay Port
synotics-broker	392/tcp	0.000013	# SynOptics Port Broker Port
synotics-broker	392/udp	0.000280	# SynOptics Port Broker Port
dis	393/udp	0.001302	# Data Interpretation System
embl-ndt	394/udp	0.000461	# EMBL Nucleic Data Transfer
netcp	395/udp	0.000428	# NETscout Control Protocol
netware-ip	396/udp	0.000379	# Novell Netware over IP
mptn	397/tcp	0.000025	# Multi Protocol Trans. Net.
mptn	397/udp	0.000511	# Multi Protocol Trans. Net.
kryptolan	398/udp	0.000659
iso-tsap-c2	399/tcp	0.000025	# ISO-TSAP Class 2
iso-tsap-c2	399/udp	0.000395	# ISO-TSAP Class 2
work-sol	400/tcp	0.000075	# Workstation Solutions
work-sol	400/udp	0.000643	# Workstation Solutions
ups	401/tcp	0.000025	# Uninterruptible Power Supply
ups	401/udp	0.000560	# Uninterruptible Power Supply
genie	402/tcp	0.000038	# Genie Protocol
genie	402/udp	0.001730	# Genie Protocol
decap	403/tcp	0.000025
decap	403/udp	0.001021
nced	404/tcp	0.000025
nced	404/udp	0.000478
ncld	405/udp	0.000379
imsp	406/tcp	0.000163	# Interactive Mail Support Protocol
imsp	406/udp	0.000560	# Interactive Mail Support Protocol
timbuktu	407/tcp	0.001129
timbuktu	407/udp	0.005305
prm-sm	408/tcp	0.000013	# Prospero Resource Manager Sys. Man.
prm-sm	408/udp	0.000445	# Prospero Resource Manager Sys. Man.
prm-nm	409/udp	0.000461	# Prospero Resource Manager Node Man.
decladebug	410/tcp	0.000025	# DECLadebug Remote Debug Protocol
decladebug	410/udp	0.000494	# DECLadebug Remote Debug Protocol
rmt	411/tcp	0.000088	# Remote MT Protocol
rmt	411/udp	0.000560	# Remote MT Protocol
synoptics-trap	412/tcp	0.000025	# Trap Convention Port
synoptics-trap	412/udp	0.000511	# Trap Convention Port
smsp	413/tcp	0.000013
smsp	413/udp	0.000395
infoseek	414/tcp	0.000013
infoseek	414/udp	0.000346
bnet	415/tcp	0.000025
bnet	415/udp	0.000445
silverplatter	416/tcp	0.000201
silverplatter	416/udp	0.000675
onmux	417/tcp	0.000226	# Meeting maker
onmux	417/udp	0.000774	# Meeting maker
hyper-g	418/tcp	0.000025
hyper-g	418/udp	0.000544
ariel1	419/tcp	0.000138
ariel1	419/udp	0.000544
smpte	420/tcp	0.000013
smpte	420/udp	0.000511
ariel2	421/udp	0.000428
ariel3	422/tcp	0.000025
ariel3	422/udp	0.000346
opc-job-start	423/tcp	0.000013	# IBM Operations Planning and Control Start
opc-job-start	423/udp	0.000329	# IBM Operations Planning and Control Start
opc-job-track	424/udp	0.000610	# IBM Operations Planning and Control Track
icad-el	425/tcp	0.000326
icad-el	425/udp	0.000428
smartsdp	426/udp	0.001104
svrloc	427/tcp	0.005382	# Server Location
svrloc	427/udp	0.018270	# Server Location
ocs_cmu	428/tcp	0.000013
ocs_cmu	428/udp	0.000329
ocs_amu	429/udp	0.000428
utmpsd	430/udp	0.000362
utmpcd	431/udp	0.000461
iasd	432/tcp	0.000013
iasd	432/udp	0.000577
nnsp	433/udp	0.000445
mobileip-agent	434/tcp	0.000013
mobileip-agent	434/udp	0.002257
mobilip-mn	435/tcp	0.000013
mobilip-mn	435/udp	0.000511
dna-cml	436/udp	0.000379
comscm	437/tcp	0.000025
comscm	437/udp	0.000741
dsfgw	438/tcp	0.000013
dsfgw	438/udp	0.000725
dasp	439/tcp	0.000013
dasp	439/udp	0.000412
sgcp	440/tcp	0.000063
sgcp	440/udp	0.000807
decvms-sysmgt	441/tcp	0.000138
decvms-sysmgt	441/udp	0.000395
cvc_hostd	442/tcp	0.000138
cvc_hostd	442/udp	0.000774
https	443/sctp	0.000000
https	443/tcp	0.208669	# secure http (SSL)
https	443/udp	0.010840
snpp	444/tcp	0.004466	# Simple Network Paging Protocol
snpp	444/udp	0.000873	# Simple Network Paging Protocol
microsoft-ds	445/tcp	0.056944	# SMB directly over IP
microsoft-ds	445/udp	0.253118
ddm-rdb	446/tcp	0.000075
ddm-rdb	446/udp	0.000461
ddm-dfm	447/tcp	0.000138
ddm-dfm	447/udp	0.000675
ddm-ssl	448/tcp	0.000050	# ddm-byte
ddm-ssl	448/udp	0.000511	# ddm-byte
as-servermap	449/tcp	0.000063	# AS Server Mapper
as-servermap	449/udp	0.000675	# AS Server Mapper
tserver	450/tcp	0.000050
tserver	450/udp	0.000692
sfs-smp-net	451/tcp	0.000013	# Cray Network Semaphore server
sfs-smp-net	451/udp	0.000774	# Cray Network Semaphore server
sfs-config	452/tcp	0.000013	# Cray SFS config server
sfs-config	452/udp	0.000297	# Cray SFS config server
creativeserver	453/tcp	0.000025
creativeserver	453/udp	0.000280
contentserver	454/tcp	0.000038
contentserver	454/udp	0.000329
creativepartnr	455/udp	0.000758
macon	456/tcp	0.000050
macon	456/udp	0.000494
scohelp	457/tcp	0.000013
scohelp	457/udp	0.000610
appleqtc	458/tcp	0.000314	# apple quick time
appleqtc	458/udp	0.000725	# apple quick time
ampr-rcmd	459/udp	0.000362
skronk	460/tcp	0.000013
skronk	460/udp	0.000610
datasurfsrv	461/udp	0.000379
datasurfsrvsec	462/tcp	0.000025
datasurfsrvsec	462/udp	0.000560
alpes	463/udp	0.000494
kpasswd5	464/tcp	0.001192	# Kerberos (v5)
kpasswd5	464/udp	0.004300	# Kerberos (v5)
smtps	465/tcp	0.013888	# smtp protocol over TLS/SSL (was ssmtp)
smtps	465/udp	0.000527	# smtp protocol over TLS/SSL (was ssmtp)
digital-vrc	466/tcp	0.000025
digital-vrc	466/udp	0.000297
mylex-mapd	467/udp	0.000445
photuris	468/udp	0.000560
rcp	469/udp	0.000692	# Radio Control Protocol
scx-proxy	470/tcp	0.000013
scx-proxy	470/udp	0.000395
mondex	471/udp	0.000478
ljk-login	472/tcp	0.000013
ljk-login	472/udp	0.000758
hybrid-pop	473/tcp	0.000013
hybrid-pop	473/udp	0.000445
tn-tl-w2	474/udp	0.000214
tcpnethaspsrv	475/tcp	0.000138
tcpnethaspsrv	475/udp	0.000643
tn-tl-fd1	476/udp	0.000346
ss7ns	477/udp	0.000626
spsc	478/udp	0.000610
iafserver	479/tcp	0.000013
iafserver	479/udp	0.000675
loadsrv	480/tcp	0.000013
iafdbase	480/udp	0.000461
dvs	481/tcp	0.000176
ph	481/udp	0.000445
xlog	482/udp	0.000577
ulpnet	483/udp	0.000461
integra-sme	484/udp	0.001186	# Integra Software Management Environment
powerburst	485/tcp	0.000013	# Air Soft Power Burst
powerburst	485/udp	0.000725	# Air Soft Power Burst
sstats	486/tcp	0.000025
avian	486/udp	0.000379
saft	487/tcp	0.000013	# saft Simple Asynchronous File Transfer
saft	487/udp	0.000428	# saft Simple Asynchronous File Transfer
gss-http	488/udp	0.000643
nest-protocol	489/udp	0.000544
micom-pfs	490/udp	0.000577
go-login	491/tcp	0.000050
go-login	491/udp	0.000297
ticf-1	492/tcp	0.000050	# Transport Independent Convergence for FNA
ticf-1	492/udp	0.000610	# Transport Independent Convergence for FNA
ticf-2	493/tcp	0.000025	# Transport Independent Convergence for FNA
ticf-2	493/udp	0.000560	# Transport Independent Convergence for FNA
pov-ray	494/udp	0.000478
intecourier	495/udp	0.000362
pim-rp-disc	496/tcp	0.000013
pim-rp-disc	496/udp	0.001153
retrospect	497/tcp	0.001179
retrospect	497/udp	0.017348
siam	498/udp	0.000461
iso-ill	499/udp	0.000511	# ISO ILL Protocol
isakmp	500/tcp	0.001129
isakmp	500/udp	0.163742
stmf	501/tcp	0.000063
stmf	501/udp	0.001186
asa-appl-proto	502/tcp	0.000151
asa-appl-proto	502/udp	0.001318
intrinsa	503/udp	0.000708
citadel	504/udp	0.000758
mailbox-lm	505/tcp	0.000038
mailbox-lm	505/udp	0.000807
ohimsrv	506/udp	0.000577
crs	507/tcp	0.000050
crs	507/udp	0.000593
xvttp	508/udp	0.000461
snare	509/tcp	0.000075
snare	509/udp	0.000643
fcp	510/tcp	0.000063	# FirstClass Protocol
fcp	510/udp	0.000923	# FirstClass Protocol
passgo	511/tcp	0.000038
passgo	511/udp	0.000610
exec	512/tcp	0.000841	# BSD rexecd(8)
biff	512/udp	0.002142	# comsat
login	513/tcp	0.005595	# BSD rlogind(8)
who	513/udp	0.002323	# BSD rwhod(8)
shell	514/tcp	0.011078	# BSD rshd(8)
syslog	514/udp	0.119804	# BSD syslogd(8)
printer	515/tcp	0.007214	# spooler (lpd)
printer	515/udp	0.011022	# spooler (lpd)
videotex	516/tcp	0.000013
videotex	516/udp	0.000807
talk	517/udp	0.004794	# BSD talkd(8)
ntalk	518/tcp	0.000013	# (talkd)
ntalk	518/udp	0.022208	# (talkd)
utime	519/udp	0.000560	# unixtime
route	520/udp	0.139376	# router routed -- RIP
ripng	521/udp	0.000708
ulp	522/tcp	0.000013
ulp	522/udp	0.000511
ibm-db2	523/tcp	0.000113
ibm-db2	523/udp	0.000461
ncp	524/tcp	0.000213
ncp	524/udp	0.000873
timed	525/tcp	0.000063	# timeserver
timed	525/udp	0.000890	# timeserver
tempo	526/tcp	0.000013	# newdate
tempo	526/udp	0.000346	# newdate
stx	527/udp	0.000362	# Stock IXChange
custix	528/tcp	0.000013	# Customer IXChange
custix	528/udp	0.000329	# Customer IXChange
irc	529/udp	0.000544
courier	530/tcp	0.000013	# rpc
courier	530/udp	0.000873	# rpc
conference	531/udp	0.000824	# chat
netnews	532/udp	0.000758	# readnews
netwall	533/tcp	0.000013	# for emergency broadcasts
netwall	533/udp	0.000461	# for emergency broadcasts
mm-admin	534/udp	0.000379	# MegaMedia Admin
iiop	535/tcp	0.000013
iiop	535/udp	0.000329
opalis-rdv	536/tcp	0.000025
opalis-rdv	536/udp	0.000428
nmsp	537/udp	0.000774	# Networked Media Streaming Protocol
gdomap	538/tcp	0.000063
gdomap	538/udp	0.000461
apertus-ldp	539/udp	0.002274	# Apertus Technologies Load Determination
uucp	540/tcp	0.000138	# uucpd
uucp	540/udp	0.000791	# uucpd
uucp-rlogin	541/tcp	0.000489
uucp-rlogin	541/udp	0.000807
commerce	542/tcp	0.000013
commerce	542/udp	0.000675
klogin	543/tcp	0.005282	# Kerberos (v4/v5)
klogin	543/udp	0.000610	# Kerberos (v4/v5)
kshell	544/tcp	0.005269	# krcmd Kerberos (v4/v5)
kshell	544/udp	0.000527	# krcmd Kerberos (v4/v5)
ekshell	545/tcp	0.000276	# Kerberos encrypted remote shell -kfall
appleqtcsrvr	545/udp	0.000478
dhcpv6-client	546/udp	0.000840	# DHCPv6 Client
dhcpv6-server	547/udp	0.000807	# DHCPv6 Server
afp	548/tcp	0.012395	# AFP over TCP
afp	548/udp	0.000774	# AFP over UDP
idfp	549/udp	0.000461
new-rwho	550/udp	0.001170	# new-who
cybercash	551/udp	0.000774
deviceshare	552/tcp	0.000013
deviceshare	552/udp	0.000840
pirp	553/tcp	0.000038
pirp	553/udp	0.000593
rtsp	554/tcp	0.008104	# Real Time Stream Control Protocol
rtsp	554/udp	0.000593	# Real Time Stream Control Protocol
dsf	555/tcp	0.000238
dsf	555/udp	0.000329
remotefs	556/tcp	0.000125	# rfs, rfs_server, Brunhoff remote filesystem
remotefs	556/udp	0.000428	# rfs, rfs_server, Brunhoff remote filesystem
openvms-sysipc	557/tcp	0.000113
openvms-sysipc	557/udp	0.000461
sdnskmp	558/udp	0.000461
teedtap	559/udp	0.001433
rmonitor	560/tcp	0.000038	# rmonitord
rmonitor	560/udp	0.000626	# rmonitord
monitor	561/tcp	0.000038
monitor	561/udp	0.000544
chshell	562/udp	0.000346	# chcmd
snews	563/tcp	0.000916
snews	563/udp	0.000675
9pfs	564/tcp	0.000013	# plan 9 file service
9pfs	564/udp	0.000527	# plan 9 file service
whoami	565/udp	0.000445
banyan-rpc	567/udp	0.000544
ms-shuttle	568/tcp	0.000025	# Microsoft shuttle
ms-shuttle	568/udp	0.000824	# Microsoft shuttle
ms-rome	569/tcp	0.000013	# Microsoft rome
ms-rome	569/udp	0.000758	# Microsoft rome
meter	570/tcp	0.000013	# demon
meter	570/udp	0.000461	# demon
umeter	571/tcp	0.000013	# udemon
umeter	571/udp	0.000692	# udemon
sonar	572/tcp	0.000013
sonar	572/udp	0.000297
banyan-vip	573/udp	0.000939
ftp-agent	574/udp	0.000428	# FTP Software Agent System
vemmi	575/udp	0.000379
ipcd	576/udp	0.000346
vnas	577/tcp	0.000063
vnas	577/udp	0.000972
ipdd	578/tcp	0.000075
ipdd	578/udp	0.000527
decbsrv	579/udp	0.000544
sntp-heartbeat	580/udp	0.000428
bdp	581/udp	0.000395	# Bundle Discovery Protocol
scc-security	582/tcp	0.000013
scc-security	582/udp	0.000280
philips-vc	583/tcp	0.000013	# Philips Video-Conferencing
philips-vc	583/udp	0.000544	# Philips Video-Conferencing
keyserver	584/udp	0.001005
imap4-ssl	585/udp	0.000412	# use 993 instead)
password-chg	586/udp	0.000758
submission	587/tcp	0.019721
submission	587/udp	0.000692
cal	588/udp	0.000544
eyelink	589/udp	0.000461
tns-cml	590/udp	0.000577
http-alt	591/tcp	0.000075	# FileMaker, Inc. - HTTP Alternate
http-alt	591/udp	0.000527	# FileMaker, Inc. - HTTP Alternate
eudora-set	592/udp	0.000626
http-rpc-epmap	593/tcp	0.001242	# HTTP RPC Ep Map
http-rpc-epmap	593/udp	0.022933	# HTTP RPC Ep Map
tpip	594/udp	0.000873
cab-protocol	595/udp	0.000445
smsd	596/tcp	0.000013
smsd	596/udp	0.000544
ptcnameservice	597/udp	0.000214	# PTC Name Service
sco-websrvrmg3	598/tcp	0.000013	# SCO Web Server Manager 3
sco-websrvrmg3	598/udp	0.000626	# SCO Web Server Manager 3
acp	599/tcp	0.000013	# Aeolon Core Protocol
acp	599/udp	0.000412	# Aeolon Core Protocol
ipcserver	600/tcp	0.000100	# Sun IPC server
ipcserver	600/udp	0.000741	# Sun IPC server
syslog-conn	601/tcp	0.000025	# Reliable Syslog Service
syslog-conn	601/udp	0.000330	# Reliable Syslog Service
xmlrpc-beep	602/tcp	0.000100	# XML-RPC over BEEP
mnotes	603/tcp	0.000063	# CommonTime Mnotes PDA Synchronization
idxp	603/udp	0.000991	# IDXP
tunnel	604/tcp	0.000025	# TUNNEL
soap-beep	605/tcp	0.000050	# SOAP over BEEP
soap-beep	605/udp	0.000661	# SOAP over BEEP
urm	606/tcp	0.000088	# Cray Unified Resource Manager
urm	606/udp	0.000494	# Cray Unified Resource Manager
nqs	607/tcp	0.000025
nqs	607/udp	0.000758
sift-uft	608/tcp	0.000025	# Sender-Initiated/Unsolicited File Transfer
sift-uft	608/udp	0.000544	# Sender-Initiated/Unsolicited File Transfer
npmp-trap	609/tcp	0.000050
npmp-trap	609/udp	0.000379
npmp-local	610/tcp	0.000113
npmp-local	610/udp	0.000741
npmp-gui	611/tcp	0.000038
npmp-gui	611/udp	0.000577
hmmp-ind	612/tcp	0.000013	# HMMP Indication
hmmp-op	613/tcp	0.000013	# HMMP Operation
hmmp-op	613/udp	0.000330	# HMMP Operation
sshell	614/tcp	0.000013	# SSLshell
sshell	614/udp	0.000330	# SSLshell
sco-inetmgr	615/tcp	0.000063	# Internet Configuration Manager
sco-inetmgr	615/udp	0.000330	# Internet Configuration Manager
sco-sysmgr	616/tcp	0.000289	# SCO System Administration Server
sco-sysmgr	616/udp	0.000330	# SCO System Administration Server
sco-dtmgr	617/tcp	0.000226	# SCO Desktop Administration Server or Arkeia (www.arkeia.com) backup software
sco-dtmgr	617/udp	0.001302	# SCO Desktop Administration Server
dei-icda	618/tcp	0.000013	# DEI-ICDA
compaq-evm	619/tcp	0.000025	# Compaq EVM
compaq-evm	619/udp	0.000991	# Compaq EVM
sco-websrvrmgr	620/tcp	0.000063	# SCO WebServer Manager
sco-websrvrmgr	620/udp	0.000991	# SCO WebServer Manager
escp-ip	621/tcp	0.000088	# ESCP
escp-ip	621/udp	0.000661	# ESCP
collaborator	622/tcp	0.000038	# Collaborator
oob-ws-http	623/tcp	0.000151	# DMTF out-of-band web services management protocol
asf-rmcp	623/udp	0.007929	# ASF Remote Management and Control
cryptoadmin	624/tcp	0.000038	# Crypto Admin
apple-xsrvr-admin	625/tcp	0.001869	# Apple Mac Xserver admin
apple-imap-admin	626/tcp	0.000025	# Apple IMAP mail admin
serialnumberd	626/udp	0.021473	# Mac OS X Server serial number (licensing) daemon
passgo-tivoli	627/tcp	0.000050	# PassGo Tivoli
qmqp	628/tcp	0.000038	# Qmail Quick Mail Queueing
qmqp	628/udp	0.000661	# QMQP
3com-amp3	629/tcp	0.000063	# 3Com AMP3
rda	630/tcp	0.000050	# RDA
rda	630/udp	0.000330	# RDA
ipp	631/tcp	0.006160	# Internet Printing Protocol -- for one implementation see http://www.cups.org (Common UNIX Printing System)
ipp	631/udp	0.450281	# Internet Printing Protocol
bmpp	632/tcp	0.000050
bmpp	632/udp	0.000661
servstat	633/tcp	0.000038	# Service Status update (Sterling Software)
ginad	634/tcp	0.000063
ginad	634/udp	0.000692
rlzdbase	635/tcp	0.000075	# RLZ DBase
mount	635/udp	0.000511	# NFS Mount Service
ldapssl	636/tcp	0.002083	# LDAP over SSL
ldaps	636/udp	0.000661	# ldap protocol over TLS/SSL (was sldap)
lanserver	637/tcp	0.000038
lanserver	637/udp	0.000428
mcns-sec	638/tcp	0.000050
msdp	639/tcp	0.000151	# MSDP
msdp	639/udp	0.001321	# MSDP
entrust-sps	640/tcp	0.000050
pcnfs	640/udp	0.000890	# PC-NFS DOS Authentication
repcmd	641/tcp	0.000088
repcmd	641/udp	0.000661
esro-emsdp	642/tcp	0.000075	# ESRO-EMSDP V1.3
sanity	643/tcp	0.000013	# SANity
sanity	643/udp	0.001982	# SANity
dwr	644/tcp	0.000038
dwr	644/udp	0.000991
pssc	645/tcp	0.000025	# PSSC
ldp	646/tcp	0.006549	# Label Distribution
dhcp-failover	647/tcp	0.000050	# DHCP Failover
rrp	648/tcp	0.000577	# Registry Registrar Protocol (RRP)
rrp	648/udp	0.000330	# Registry Registrar Protocol (RRP)
cadview-3d	649/tcp	0.000063	# Cadview-3d - streaming 3d models over the internet
cadview-3d	649/udp	0.000330	# Cadview-3d - streaming 3d models over the internet
bwnfs	650/udp	0.000544	# BW-NFS DOS Authentication
ieee-mms	651/tcp	0.000050	# IEEE MMS
hello-port	652/tcp	0.000013	# HELLO_PORT
hello-port	652/udp	0.000330	# HELLO_PORT
repscmd	653/tcp	0.000063	# RepCmd
repscmd	653/udp	0.000661	# RepCmd
aodv	654/tcp	0.000038	# AODV
tinc	655/tcp	0.000100	# TINC
tinc	655/udp	0.000330	# TINC
spmp	656/tcp	0.000038	# SPMP
rmc	657/tcp	0.000113	# RMC
rmc	657/udp	0.001321	# RMC
tenfold	658/tcp	0.000050	# TenFold
unknown	659/tcp	0.000100
unknown	659/udp	0.000661
mac-srvr-admin	660/tcp	0.000100	# MacOS Server Admin
mac-srvr-admin	660/udp	0.000577	# MacOS Server Admin
hap	661/tcp	0.000050	# HAP
pftp	662/tcp	0.000013	# PFTP
pftp	662/udp	0.000330	# PFTP
purenoise	663/tcp	0.000050	# PureNoise
secure-aux-bus	664/tcp	0.000063
secure-aux-bus	664/udp	0.003634
sun-dr	665/tcp	0.000063	# Sun DR
doom	666/tcp	0.000289	# Id Software Doom
doom	666/udp	0.000956	# doom Id Software
disclose	667/tcp	0.000238	# campaign contribution disclosures - SDR Technologies
disclose	667/udp	0.000330	# campaign contribution disclosures - SDR Technologies
mecomm	668/tcp	0.000213	# MeComm
meregister	669/tcp	0.000088	# MeRegister
vacdsm-sws	670/tcp	0.000038	# VACDSM-SWS
vpps-qua	672/tcp	0.000025	# VPPS-QUA
vpps-qua	672/udp	0.000991	# VPPS-QUA
cimplex	673/tcp	0.000050	# CIMPLEX
acap	674/tcp	0.000113	# ACAP server of Communigate (www.stalker.com)
acap	674/udp	0.000661	# ACAP
dctp	675/tcp	0.000038	# DCTP
dctp	675/udp	0.000330	# DCTP
vpps-via	676/tcp	0.000038	# VPPS Via
vpp	677/tcp	0.000025	# Virtual Presence Protocol
ggf-ncp	678/tcp	0.000075	# GNU Generation Foundation NCP
mrm	679/udp	0.000330	# MRM
entrust-aaas	680/tcp	0.000038
entrust-aaas	680/udp	0.000661
entrust-aams	681/tcp	0.000038
entrust-aams	681/udp	0.000991
xfr	682/tcp	0.000063	# XFR
xfr	682/udp	0.002643	# XFR
corba-iiop	683/tcp	0.000176
corba-iiop	683/udp	0.003304
corba-iiop-ssl	684/tcp	0.000113	# CORBA IIOP SSL
corba-iiop-ssl	684/udp	0.002313	# CORBA IIOP SSL
mdc-portmapper	685/tcp	0.000038	# MDC Port Mapper
mdc-portmapper	685/udp	0.002973	# MDC Port Mapper
hcp-wismar	686/tcp	0.000025	# Hardware Control Protocol Wismar
hcp-wismar	686/udp	0.002973	# Hardware Control Protocol Wismar
asipregistry	687/tcp	0.000188
asipregistry	687/udp	0.001982
realm-rusd	688/tcp	0.000025	# ApplianceWare managment protocol
realm-rusd	688/udp	0.001982	# ApplianceWare managment protocol
nmap	689/tcp	0.000038	# NMAP
nmap	689/udp	0.001321	# NMAP
vatp	690/tcp	0.000088	# Velazquez Application Transfer Protocol
vatp	690/udp	0.000330	# Velazquez Application Transfer Protocol
resvc	691/tcp	0.000376	# The Microsoft Exchange 2000 Server Routing Service
msexch-routing	691/udp	0.000330	# MS Exchange Routing
hyperwave-isp	692/tcp	0.000038	# Hyperwave-ISP
ha-cluster	694/tcp	0.000038
ha-cluster	694/udp	0.000661
ieee-mms-ssl	695/tcp	0.000063	# IEEE-MMS-SSL
rushd	696/tcp	0.000050	# RUSHD
rushd	696/udp	0.000330	# RUSHD
uuidgen	697/tcp	0.000025	# UUIDGEN
uuidgen	697/udp	0.000330	# UUIDGEN
olsr	698/tcp	0.000025	# OLSR
accessnetwork	699/tcp	0.000025	# Access Network
epp	700/tcp	0.000289	# Extensible Provisioning Protocol
epp	700/udp	0.000330	# Extensible Provisioning Protocol
lmp	701/tcp	0.000151	# Link Management Protocol (LMP)
lmp	701/udp	0.000330	# Link Management Protocol (LMP)
iris-beep	702/tcp	0.000050	# IRIS over BEEP
unknown	703/tcp	0.000038
elcsd	704/tcp	0.000038	# errlog copy/server daemon
elcsd	704/udp	0.000923	# errlog copy/server daemon
agentx	705/tcp	0.000414	# AgentX
agentx	705/udp	0.000661	# AgentX
silc	706/tcp	0.000075	# Secure Internet Live Conferencing -- http://silcnet.org
silc	706/udp	0.000330	# SILC
borland-dsj	707/tcp	0.000063	# Borland DSJ
unknown	708/tcp	0.000038
unknown	708/udp	0.000330
entrustmanager	709/tcp	0.000125	# EntrustManager - NorTel DES auth network see 389/tcp
entrustmanager	709/udp	0.000741	# EntrustManager - NorTel DES auth network see 389/tcp
entrust-ash	710/tcp	0.000151	# Entrust Administration Service Handler
entrust-ash	710/udp	0.000330	# Entrust Administration Service Handler
cisco-tdp	711/tcp	0.000401	# Cisco TDP
cisco-tdp	711/udp	0.000330	# Cisco TDP
tbrpf	712/tcp	0.000025	# TBRPF
iris-xpc	713/tcp	0.000125	# IRIS over XPC
iris-xpcs	714/tcp	0.000226	# IRIS over XPCS
iris-xpcs	714/udp	0.000330	# IRIS over XPCS
iris-lwz	715/tcp	0.000088	# IRIS-LWZ
iris-lwz	715/udp	0.000330	# IRIS-LWZ
unknown	716/tcp	0.000063
pana	716/udp	0.000330	# PANA Messages
unknown	717/tcp	0.000025
unknown	717/udp	0.000330
unknown	718/tcp	0.000038
unknown	719/tcp	0.000050
unknown	719/udp	0.000661
unknown	720/tcp	0.000238
unknown	720/udp	0.000991
unknown	721/tcp	0.000038
unknown	721/udp	0.000330
unknown	722/tcp	0.000226
unknown	722/udp	0.000661
omfs	723/tcp	0.000038	# OpenMosix File System
unknown	724/tcp	0.000050
unknown	724/udp	0.000330
unknown	725/tcp	0.000151
unknown	726/tcp	0.000188
unknown	726/udp	0.000330
unknown	727/tcp	0.000063
unknown	727/udp	0.000991
unknown	728/tcp	0.000088
unknown	728/udp	0.000661
netviewdm1	729/tcp	0.000100	# IBM NetView DM/6000 Server/Client
netviewdm1	729/udp	0.000857	# IBM NetView DM/6000 Server/Client
netviewdm2	730/tcp	0.000100	# IBM NetView DM/6000 send/tcp
netviewdm2	730/udp	0.000758	# IBM NetView DM/6000 send/tcp
netviewdm3	731/tcp	0.000100	# IBM NetView DM/6000 receive/tcp
netviewdm3	731/udp	0.000741	# IBM NetView DM/6000 receive/tcp
unknown	732/tcp	0.000113
unknown	732/udp	0.000991
unknown	733/tcp	0.000063
unknown	734/tcp	0.000038
unknown	734/udp	0.000991
unknown	735/tcp	0.000050
unknown	736/tcp	0.000050
unknown	736/udp	0.000330
unknown	737/tcp	0.000025
sometimes-rpc2	737/udp	0.000560	# Rusersd on my OpenBSD box
unknown	738/tcp	0.000025
unknown	738/udp	0.000330
unknown	739/tcp	0.000013
unknown	739/udp	0.000330
netcp	740/tcp	0.000088	# NETscout Control Protocol
netcp	740/udp	0.000873	# NETscout Control Protocol
netgw	741/tcp	0.000050
netgw	741/udp	0.000428
netrcs	742/tcp	0.000013	# Network based Rev. Cont. Sys.
netrcs	742/udp	0.000956	# Network based Rev. Cont. Sys.
unknown	743/tcp	0.000075
unknown	743/udp	0.000330
flexlm	744/tcp	0.000013	# Flexible License Manager
flexlm	744/udp	0.000659	# Flexible License Manager
unknown	745/tcp	0.000050
unknown	745/udp	0.000991
unknown	746/tcp	0.000025
unknown	746/udp	0.000330
fujitsu-dev	747/tcp	0.000025	# Fujitsu Device Control
fujitsu-dev	747/udp	0.000791	# Fujitsu Device Control
ris-cm	748/tcp	0.000113	# Russell Info Sci Calendar Manager
ris-cm	748/udp	0.001120	# Russell Info Sci Calendar Manager
kerberos-adm	749/tcp	0.000326	# Kerberos 5 admin/changepw
kerberos-adm	749/udp	0.000939	# Kerberos 5 admin/changepw
kerberos	750/tcp	0.000063	# kdc Kerberos (v4)
kerberos	750/udp	0.001269	# kdc Kerberos (v4)
kerberos_master	751/tcp	0.000038	# Kerberos `kadmin' (v4)
kerberos_master	751/udp	0.000923	# Kerberos `kadmin' (v4)
qrh	752/tcp	0.000013
qrh	752/udp	0.000725
rrh	753/tcp	0.000013
rrh	753/udp	0.000675
krb_prop	754/tcp	0.000088	# kerberos/v5 server propagation
tell	754/udp	0.000330	# send
unknown	755/tcp	0.000025
unknown	756/tcp	0.000038
unknown	756/udp	0.000330
unknown	757/tcp	0.000100
nlogin	758/tcp	0.000088
nlogin	758/udp	0.000708
con	759/tcp	0.000025
con	759/udp	0.000972
krbupdate	760/tcp	0.000050	# kreg Kerberos (v4) registration
ns	760/udp	0.001153
kpasswd	761/tcp	0.000050	# kpwd Kerberos (v4) "passwd"
rxe	761/udp	0.000956
quotad	762/tcp	0.000075
quotad	762/udp	0.000626
cycleserv	763/tcp	0.000025
cycleserv	763/udp	0.000741
omserv	764/tcp	0.000025
omserv	764/udp	0.001351
webster	765/tcp	0.000213
webster	765/udp	0.000659
unknown	766/tcp	0.000013
unknown	766/udp	0.000330
phonebook	767/tcp	0.000013	# phone
phonebook	767/udp	0.002257	# phone
unknown	768/tcp	0.000013
vid	769/tcp	0.000075
vid	769/udp	0.001252
cadlock	770/tcp	0.000038
cadlock	770/udp	0.001269
rtip	771/tcp	0.000063
rtip	771/udp	0.001219
cycleserv2	772/udp	0.001796
submit	773/tcp	0.000013
notify	773/udp	0.001713
rpasswd	774/tcp	0.000025
acmaint_dbd	774/udp	0.001664
entomb	775/tcp	0.000013
acmaint_transd	775/udp	0.001993
wpages	776/tcp	0.000025
wpages	776/udp	0.002043
multiling-http	777/tcp	0.000226	# Multiling HTTP
multiling-http	777/udp	0.000661	# Multiling HTTP
unknown	778/tcp	0.000100
unknown	779/tcp	0.000075
unknown	779/udp	0.000330
wpgs	780/tcp	0.000151
wpgs	780/udp	0.002718
hp-collector	781/tcp	0.000013	# hp performance data collector
hp-collector	781/udp	0.002636	# hp performance data collector
hp-managed-node	782/tcp	0.000100	# hp performance data managed node
hp-managed-node	782/udp	0.002933	# hp performance data managed node
spamassassin	783/tcp	0.000163	# Apache SpamAssassin spamd
unknown	784/tcp	0.000025
unknown	784/udp	0.000661
unknown	785/tcp	0.000025
unknown	785/udp	0.000330
concert	786/tcp	0.000100
concert	786/udp	0.002900
qsc	787/tcp	0.001455
unknown	787/udp	0.000330
unknown	788/tcp	0.000038
unknown	788/udp	0.000330
unknown	789/tcp	0.000075
unknown	789/udp	0.001321
unknown	790/tcp	0.000100
unknown	791/tcp	0.000050
unknown	792/tcp	0.000113
unknown	793/tcp	0.000025
unknown	794/tcp	0.000038
unknown	795/tcp	0.000100
unknown	795/udp	0.000330
unknown	796/tcp	0.000038
unknown	797/tcp	0.000038
unknown	797/udp	0.000330
unknown	798/tcp	0.000063
unknown	798/udp	0.000330
controlit	799/tcp	0.000038	# Remotely possible
mdbs_daemon	800/tcp	0.000427
mdbs_daemon	800/udp	0.004333
device	801/tcp	0.000238
device	801/udp	0.000939
unknown	802/tcp	0.000088
unknown	803/tcp	0.000151
unknown	804/tcp	0.000063
unknown	804/udp	0.000330
unknown	805/tcp	0.000088
unknown	805/udp	0.000661
unknown	806/tcp	0.000088
unknown	806/udp	0.000330
unknown	807/tcp	0.000063
unknown	807/udp	0.000330
ccproxy-http	808/tcp	0.002296	# CCProxy HTTP/Gopher/FTP (over HTTP) proxy
unknown	808/udp	0.000330
unknown	809/tcp	0.000075
unknown	809/udp	0.000661
fcp-udp	810/tcp	0.000063	# FCP
fcp-udp	810/udp	0.000661	# FCP Datagram
unknown	811/tcp	0.000075
unknown	811/udp	0.000330
unknown	812/tcp	0.000038
unknown	812/udp	0.000991
unknown	813/tcp	0.000050
unknown	814/tcp	0.000063
unknown	814/udp	0.001652
unknown	815/tcp	0.000075
unknown	815/udp	0.000661
unknown	816/tcp	0.000050
unknown	817/tcp	0.000075
unknown	818/tcp	0.000025
unknown	818/udp	0.000991
unknown	819/tcp	0.000050
unknown	819/udp	0.000991
unknown	820/tcp	0.000050
unknown	821/tcp	0.000038
unknown	821/udp	0.000661
unknown	822/tcp	0.000100
unknown	822/udp	0.000330
unknown	823/tcp	0.000100
unknown	823/udp	0.000661
unknown	824/tcp	0.000063
unknown	825/tcp	0.000113
unknown	826/tcp	0.000050
unknown	826/udp	0.001321
unknown	827/tcp	0.000025
itm-mcell-s	828/tcp	0.000063
itm-mcell-s	828/udp	0.000330
pkix-3-ca-ra	829/tcp	0.000125	# PKIX-3 CA/RA
pkix-3-ca-ra	829/udp	0.001982	# PKIX-3 CA/RA
netconf-ssh	830/tcp	0.000075	# NETCONF over SSH
netconf-beep	831/tcp	0.000050	# NETCONF over BEEP
netconf-beep	831/udp	0.000661	# NETCONF over BEEP
netconfsoaphttp	832/tcp	0.000038	# NETCONF for SOAP over HTTPS
netconfsoapbeep	833/tcp	0.000063	# NETCONF for SOAP over BEEP
netconfsoapbeep	833/udp	0.000661	# NETCONF for SOAP over BEEP
unknown	834/tcp	0.000075
unknown	835/tcp	0.000063
unknown	836/tcp	0.000050
unknown	836/udp	0.000330
unknown	837/tcp	0.000038
unknown	838/tcp	0.000025
unknown	838/udp	0.001652
unknown	839/tcp	0.000100
unknown	839/udp	0.000661
unknown	840/tcp	0.000113
unknown	840/udp	0.000330
unknown	841/tcp	0.000050
unknown	841/udp	0.000991
unknown	842/tcp	0.000025
unknown	842/udp	0.000330
unknown	843/tcp	0.000163
unknown	844/tcp	0.000075
unknown	844/udp	0.000330
unknown	845/tcp	0.000013
unknown	845/udp	0.000661
unknown	846/tcp	0.000100
unknown	846/udp	0.000330
dhcp-failover2	847/tcp	0.000063	# dhcp-failover 2
dhcp-failover2	847/udp	0.000330	# dhcp-failover 2
gdoi	848/tcp	0.000025	# GDOI
gdoi	848/udp	0.000330	# GDOI
unknown	849/tcp	0.000025
unknown	849/udp	0.000330
unknown	850/tcp	0.000050
unknown	851/tcp	0.000050
unknown	851/udp	0.000330
unknown	852/tcp	0.000025
unknown	853/tcp	0.000025
unknown	853/udp	0.000330
unknown	854/tcp	0.000038
unknown	855/tcp	0.000050
unknown	856/tcp	0.000138
unknown	857/tcp	0.000025
unknown	857/udp	0.000661
unknown	858/tcp	0.000075
unknown	859/tcp	0.000088
unknown	859/udp	0.000330
iscsi	860/tcp	0.000063	# iSCSI
owamp-control	861/tcp	0.000063	# OWAMP-Control
owamp-control	861/udp	0.000330	# OWAMP-Control
twamp-control	862/tcp	0.000100	# Two-way Active Measurement Protocol (TWAMP) Control
unknown	863/tcp	0.000075
unknown	863/udp	0.000330
unknown	864/tcp	0.000088
unknown	865/tcp	0.000025
unknown	866/tcp	0.000050
unknown	866/udp	0.000330
unknown	867/tcp	0.000038
unknown	868/tcp	0.000038
unknown	868/udp	0.000330
unknown	869/tcp	0.000038
unknown	869/udp	0.000661
unknown	870/tcp	0.000050
supfilesrv	871/tcp	0.000025	# SUP server
unknown	872/tcp	0.000050
unknown	872/udp	0.000330
rsync	873/tcp	0.003400	# Rsync server ( http://rsync.samba.org )
rsync	873/udp	0.000661
unknown	874/tcp	0.000138
unknown	875/tcp	0.000050
unknown	876/tcp	0.000025
unknown	876/udp	0.000991
unknown	877/tcp	0.000025
unknown	877/udp	0.000330
unknown	878/tcp	0.000088
unknown	879/tcp	0.000038
unknown	880/tcp	0.000464
unknown	880/udp	0.000330
unknown	881/tcp	0.000050
unknown	881/udp	0.000661
unknown	882/tcp	0.000025
unknown	883/tcp	0.000050
unknown	884/tcp	0.000025
unknown	884/udp	0.000330
unknown	885/tcp	0.000025
iclcnet-locate	886/tcp	0.000038	# ICL coNETion locate server
iclcnet-locate	886/udp	0.000330	# ICL coNETion locate server
iclcnet_svinfo	887/tcp	0.000025	# ICL coNETion server info
iclcnet_svinfo	887/udp	0.000991	# ICL coNETion server info
accessbuilder	888/tcp	0.000928	# or Audio CD Database
accessbuilder	888/udp	0.000923
unknown	889/tcp	0.000063
unknown	889/udp	0.000991
unknown	890/tcp	0.000025
unknown	890/udp	0.000330
unknown	891/tcp	0.000038
unknown	892/tcp	0.000025
unknown	893/tcp	0.000013
unknown	893/udp	0.000991
unknown	894/tcp	0.000063
unknown	895/tcp	0.000038
unknown	895/udp	0.000330
unknown	896/tcp	0.000013
unknown	897/tcp	0.000063
unknown	897/udp	0.000661
sun-manageconsole	898/tcp	0.000339	# Solaris Management Console Java listener (Solaris 8 & 9)
unknown	898/udp	0.000991
unknown	899/tcp	0.000063
unknown	899/udp	0.000330
omginitialrefs	900/tcp	0.000452	# OMG Initial Refs
omginitialrefs	900/udp	0.000661	# OMG Initial Refs
samba-swat	901/tcp	0.000552	# Samba SWAT tool.  Also used by ISS RealSecure.
smpnameres	901/udp	0.000330	# SMPNAMERES
iss-realsecure	902/tcp	0.001468	# ISS RealSecure Sensor
ideafarm-door	902/udp	0.001982	# self documenting Door: send 0x00 for info
iss-console-mgr	903/tcp	0.000176	# ISS Console Manager
ideafarm-panic	903/udp	0.001652	# self documenting Panic Door: send 0x00 for info
unknown	904/tcp	0.000113
unknown	904/udp	0.000330
unknown	905/tcp	0.000100
unknown	905/udp	0.000330
unknown	906/tcp	0.000050
unknown	907/tcp	0.000025
unknown	908/tcp	0.000025
unknown	908/udp	0.000661
unknown	909/tcp	0.000038
kink	910/tcp	0.000013	# Kerberized Internet Negotiation of Keys (KINK)
kink	910/udp	0.000330	# Kerberized Internet Negotiation of Keys (KINK)
xact-backup	911/tcp	0.000188
apex-mesh	912/tcp	0.000527	# APEX relay-relay service
apex-edge	913/tcp	0.000151	# APEX endpoint-relay service
unknown	914/tcp	0.000075
unknown	914/udp	0.000330
unknown	915/tcp	0.000025
unknown	915/udp	0.000330
unknown	916/tcp	0.000063
unknown	917/udp	0.000991
unknown	918/tcp	0.000088
unknown	919/tcp	0.000050
unknown	919/udp	0.000330
unknown	920/tcp	0.000025
unknown	921/tcp	0.000088
unknown	921/udp	0.000661
unknown	922/tcp	0.000088
unknown	922/udp	0.000661
unknown	923/tcp	0.000063
unknown	923/udp	0.000330
unknown	924/tcp	0.000088
unknown	925/tcp	0.000075
unknown	926/tcp	0.000075
unknown	927/tcp	0.000050
unknown	927/udp	0.000661
unknown	928/tcp	0.000088
unknown	929/tcp	0.000050
unknown	930/tcp	0.000151
unknown	931/tcp	0.000138
unknown	931/udp	0.000991
unknown	932/tcp	0.000013
unknown	932/udp	0.000330
unknown	933/tcp	0.000038
unknown	934/tcp	0.000025
unknown	934/udp	0.000991
unknown	935/tcp	0.000075
unknown	935/udp	0.000330
unknown	936/tcp	0.000050
unknown	937/tcp	0.000013
unknown	937/udp	0.000661
unknown	938/tcp	0.000050
unknown	938/udp	0.000330
unknown	939/tcp	0.000038
unknown	940/udp	0.000991
unknown	941/tcp	0.000050
unknown	941/udp	0.000661
unknown	942/tcp	0.000075
unknown	943/tcp	0.000113
unknown	943/udp	0.000330
unknown	944/tcp	0.000038
unknown	944/udp	0.001321
unknown	945/tcp	0.000050
unknown	945/udp	0.000330
unknown	946/tcp	0.000063
unknown	946/udp	0.000661
unknown	947/tcp	0.000038
unknown	947/udp	0.000991
unknown	948/tcp	0.000050
unknown	949/tcp	0.000063
unknown	949/udp	0.000991
oftep-rpc	950/tcp	0.000050	# Often RPC.statd (on Redhat Linux)
unknown	950/udp	0.000661
unknown	951/tcp	0.000038
unknown	951/udp	0.000661
unknown	952/tcp	0.000063
unknown	952/udp	0.000661
rndc	953/tcp	0.000138	# RNDC is used by BIND 9 (& probably other NS)
unknown	953/udp	0.000991
unknown	954/tcp	0.000013
unknown	954/udp	0.000330
unknown	955/tcp	0.000013
unknown	956/tcp	0.000025
unknown	957/tcp	0.000025
unknown	957/udp	0.000330
unknown	958/tcp	0.000063
unknown	958/udp	0.000330
unknown	959/tcp	0.000038
unknown	959/udp	0.001982
unknown	960/tcp	0.000038
unknown	960/udp	0.000661
unknown	961/tcp	0.000075
unknown	961/udp	0.000991
unknown	962/tcp	0.000050
unknown	962/udp	0.000330
unknown	963/tcp	0.000038
unknown	963/udp	0.000330
unknown	964/tcp	0.000038
unknown	965/tcp	0.000075
unknown	965/udp	0.001652
unknown	966/tcp	0.000025
unknown	966/udp	0.000661
unknown	967/tcp	0.000075
unknown	968/tcp	0.000038
unknown	968/udp	0.000330
unknown	969/tcp	0.000100
unknown	970/tcp	0.000038
unknown	970/udp	0.000330
unknown	971/tcp	0.000100
unknown	971/udp	0.000330
unknown	972/tcp	0.000025
unknown	972/udp	0.000330
unknown	973/tcp	0.000075
unknown	973/udp	0.000991
unknown	974/tcp	0.000063
securenetpro-sensor	975/tcp	0.000038
unknown	975/udp	0.000330
unknown	976/tcp	0.000013
unknown	977/tcp	0.000013
unknown	977/udp	0.000991
unknown	978/tcp	0.000025
unknown	978/udp	0.000330
unknown	979/tcp	0.000075
unknown	979/udp	0.000991
unknown	980/tcp	0.000125
unknown	981/tcp	0.000226
unknown	981/udp	0.000661
unknown	982/tcp	0.000025
unknown	982/udp	0.000991
unknown	983/tcp	0.000075
unknown	983/udp	0.002643
unknown	984/tcp	0.000063
unknown	984/udp	0.000991
unknown	985/tcp	0.000063
unknown	985/udp	0.000661
unknown	986/tcp	0.000013
unknown	986/udp	0.000661
unknown	987/tcp	0.000427
unknown	987/udp	0.000330
unknown	988/tcp	0.000050
unknown	988/udp	0.000661
ftps-data	989/tcp	0.000063	# ftp protocol, data, over TLS/SSL
ftps-data	989/udp	0.006277	# ftp protocol, data, over TLS/SSL
ftps	990/tcp	0.005570	# ftp protocol, control, over TLS/SSL
ftps	990/udp	0.004625	# ftp protocol, control, over TLS/SSL
nas	991/tcp	0.000038	# Netnews Administration System
telnets	992/tcp	0.000903	# telnet protocol over TLS/SSL
imaps	993/tcp	0.027199	# imap4 protocol over TLS/SSL
imaps	993/udp	0.000661	# imap4 protocol over TLS/SSL
ircs	994/tcp	0.000038	# irc protocol over TLS/SSL
pop3s	995/tcp	0.029921	# POP3 protocol over TLS/SSL
pop3s	995/udp	0.000991	# pop3 protocol over TLS/SSL (was spop3)
xtreelic	996/tcp	0.000100	# XTREE License Server
vsinet	996/udp	0.073362
maitrd	997/tcp	0.000038
maitrd	997/udp	0.073247
busboy	998/tcp	0.000100
puparp	998/udp	0.073395
garcon	999/tcp	0.000966
applix	999/udp	0.073230	# Applix ac
cadlock	1000/tcp	0.003149
ock	1000/udp	0.002142
unknown	1001/tcp	0.000364
unknown	1001/udp	0.004955
windows-icfw	1002/tcp	0.000690	# Windows Internet Connection Firewall or Internet Locator Server for NetMeeting.
unknown	1002/udp	0.000330
unknown	1003/tcp	0.000038
unknown	1003/udp	0.000661
unknown	1004/tcp	0.000088
unknown	1004/udp	0.000661
unknown	1005/tcp	0.000088
unknown	1005/udp	0.000330
unknown	1006/tcp	0.000113
unknown	1006/udp	0.000330
unknown	1007/tcp	0.000201
unknown	1007/udp	0.001652
ufsd	1008/tcp	0.000125	# ufsd		# UFS-aware server
ufsd	1008/udp	0.004020
unknown	1009/tcp	0.000226
unknown	1009/udp	0.000330
surf	1010/tcp	0.000188
surf	1010/udp	0.000661
unknown	1011/tcp	0.000176
unknown	1011/udp	0.000661
unknown	1012/tcp	0.000100
sometimes-rpc1	1012/udp	0.001993	# This is rstatd on my openBSD box
unknown	1013/tcp	0.000125
unknown	1013/udp	0.001321
unknown	1014/tcp	0.000100
unknown	1014/udp	0.002643
unknown	1015/tcp	0.000100
unknown	1015/udp	0.000991
unknown	1016/tcp	0.000050
unknown	1016/udp	0.000330
unknown	1017/tcp	0.000038
unknown	1018/tcp	0.000050
unknown	1018/udp	0.000991
unknown	1019/tcp	0.000075
unknown	1019/udp	0.003304
unknown	1020/tcp	0.000113
unknown	1020/udp	0.001321
exp1	1021/tcp	0.000301	# RFC3692-style Experiment 1 (*)    [RFC4727]
exp1	1021/udp	0.003634	# RFC3692-style Experiment 1 (*)    [RFC4727]
exp2	1022/tcp	0.001217	# RFC3692-style Experiment 2 (*)    [RFC4727]
exp2	1022/udp	0.007929	# RFC3692-style Experiment 2 (*)    [RFC4727]
netvenuechat	1023/tcp	0.000953	# Nortel NetVenue Notification, Chat, Intercom
unknown	1023/udp	0.016188
kdm	1024/tcp	0.002722	# K Display Manager (KDE version of xdm)
unknown	1024/udp	0.003964
NFS-or-IIS	1025/tcp	0.022406	# IIS, NFS, or listener RFS remote_file_sharing
blackjack	1025/udp	0.041813	# network blackjack
LSA-or-nterm	1026/tcp	0.010237	# nterm remote_login network_terminal
win-rpc	1026/udp	0.024777	# Commonly used to send MS Messenger spam
IIS	1027/tcp	0.006724
unknown	1027/udp	0.019822
unknown	1028/tcp	0.003421
ms-lsa	1028/udp	0.013443
ms-lsa	1029/tcp	0.003801
solid-mux	1029/udp	0.014536	# Solid Mux Server
iad1	1030/tcp	0.002860	# BBN IAD
iad1	1030/udp	0.008007	# BBN IAD
iad2	1031/tcp	0.002221	# BBN IAD
iad2	1031/udp	0.006639	# BBN IAD
iad3	1032/tcp	0.001719	# BBN IAD
iad3	1032/udp	0.006705	# BBN IAD
netinfo	1033/tcp	0.001342	# Netinfo is apparently on many OS X boxes.
netinfo-local	1033/udp	0.003964	# local netinfo port
zincite-a	1034/tcp	0.001064	# Zincite.A backdoor
activesync-notify	1034/udp	0.005173	# Windows Mobile device ActiveSync Notifications
multidropper	1035/tcp	0.001216	# A Multidropper Adware, or PhoneFree
mxxrlogin	1035/udp	0.001982	# MX-XR RPC
nsstp	1036/tcp	0.001216	# Nebula Secure Segment Transfer Protocol
nsstp	1036/udp	0.004295	# Nebula Secure Segment Transfer Protocol
ams	1037/tcp	0.001216	# AMS
ams	1037/udp	0.002313	# AMS
mtqp	1038/tcp	0.002053	# Message Tracking Query Protocol
mtqp	1038/udp	0.004295	# Message Tracking Query Protocol
sbl	1039/tcp	0.002129	# Streamlined Blackhole
sbl	1039/udp	0.004295	# Streamlined Blackhole
netsaint	1040/tcp	0.001342	# Netsaint status daemon
netarx	1040/udp	0.001982	# Netarx Netcare
danf-ak2	1041/tcp	0.002433	# AK2 Product
danf-ak2	1041/udp	0.004625	# AK2 Product
afrog	1042/tcp	0.000988	# Subnet Roaming
afrog	1042/udp	0.001982	# Subnet Roaming
boinc	1043/tcp	0.000841	# BOINC Client Control or Microsoft IIS
boinc	1043/udp	0.003493	# BOINC Client Control
dcutility	1044/tcp	0.002205	# Dev Consortium Utility
dcutility	1044/udp	0.003304	# Dev Consortium Utility
fpitp	1045/tcp	0.000380	# Fingerprint Image Transfer Protocol
fpitp	1045/udp	0.004625	# Fingerprint Image Transfer Protocol
wfremotertm	1046/tcp	0.000380	# WebFilter Remote Monitor
wfremotertm	1046/udp	0.001652	# WebFilter Remote Monitor
neod1	1047/tcp	0.000760	# Sun's NEO Object Request Broker
neod1	1047/udp	0.002973	# Sun's NEO Object Request Broker
neod2	1048/tcp	0.002357	# Sun's NEO Object Request Broker
neod2	1048/udp	0.002313	# Sun's NEO Object Request Broker
td-postman	1049/tcp	0.002357	# Tobit David Postman VPMN
td-postman	1049/udp	0.003304	# Tobit David Postman VPMN
java-or-OTGfileshare	1050/tcp	0.001669	# J2EE nameserver, also OTG, also called Disk/Application extender. Could also be MiniCommand backdoor OTGlicenseserv
cma	1050/udp	0.001652	# CORBA Management Agent
optima-vnet	1051/tcp	0.000760
optima-vnet	1051/udp	0.001321
ddt	1052/tcp	0.000760	# Dynamic DNS tools
ddt	1052/udp	0.000991	# Dynamic DNS tools
remote-as	1053/tcp	0.002357	# Remote Assistant (RA)
remote-as	1053/udp	0.001652	# Remote Assistant (RA)
brvread	1054/tcp	0.002357	# BRVREAD
brvread	1054/udp	0.002643	# BRVREAD
ansyslmd	1055/tcp	0.000760
ansyslmd	1055/udp	0.001652
vfo	1056/tcp	0.002357	# VFO
vfo	1056/udp	0.002973	# VFO
startron	1057/tcp	0.000380	# STARTRON
startron	1057/udp	0.001652	# STARTRON
nim	1058/tcp	0.001380
nim	1058/udp	0.001466
nimreg	1059/tcp	0.001342
nimreg	1059/udp	0.001647
polestar	1060/tcp	0.000760
polestar	1060/udp	0.001652
kiosk	1061/tcp	0.000380	# KIOSK
kiosk	1061/udp	0.000991	# KIOSK
veracity	1062/tcp	0.000760
veracity	1062/udp	0.000991
kyoceranetdev	1063/tcp	0.000380	# KyoceraNetDev
kyoceranetdev	1063/udp	0.000661	# KyoceraNetDev
jstel	1064/tcp	0.002357	# JSTEL
jstel	1064/udp	0.001982	# JSTEL
syscomlan	1065/tcp	0.002357	# SYSCOMLAN
syscomlan	1065/udp	0.002313	# SYSCOMLAN
fpo-fns	1066/tcp	0.001901
fpo-fns	1066/udp	0.002643
instl_boots	1067/tcp	0.000728	# Installation Bootstrap Proto. Serv.
instl_boots	1067/udp	0.001516	# Installation Bootstrap Proto. Serv.
instl_bootc	1068/tcp	0.000941	# Installation Bootstrap Proto. Cli.
instl_bootc	1068/udp	0.004778	# Installation Bootstrap Proto. Cli.
cognex-insight	1069/tcp	0.001901
cognex-insight	1069/udp	0.001982
gmrupdateserv	1070/tcp	0.000380	# GMRUpdateSERV
gmrupdateserv	1070/udp	0.001321	# GMRUpdateSERV
bsquare-voip	1071/tcp	0.002205	# BSQUARE-VOIP
bsquare-voip	1071/udp	0.000330	# BSQUARE-VOIP
cardax	1072/tcp	0.000380	# CARDAX
cardax	1072/udp	0.001321	# CARDAX
bridgecontrol	1073/tcp	0.000380	# Bridge Control
warmspotMgmt	1074/tcp	0.001216	# Warmspot Management Protocol
warmspotMgmt	1074/udp	0.000661	# Warmspot Management Protocol
rdrmshc	1075/tcp	0.000380	# RDRMSHC
rdrmshc	1075/udp	0.000330	# RDRMSHC
sns_credit	1076/tcp	0.000213	# Shared Network Services (SNS) for Canadian credit card authorizations
dab-sti-c	1076/udp	0.000661	# DAB STI-C
imgames	1077/tcp	0.000380	# IMGames
imgames	1077/udp	0.000661	# IMGames
avocent-proxy	1078/tcp	0.000380	# Avocent Proxy Protocol
avocent-proxy	1078/udp	0.000661	# Avocent Proxy Protocol
asprovatalk	1079/tcp	0.000380	# ASPROVATalk
asprovatalk	1079/udp	0.000661	# ASPROVATalk
socks	1080/tcp	0.001518
socks	1080/udp	0.002685
pvuniwien	1081/tcp	0.000380	# PVUNIWIEN
pvuniwien	1081/udp	0.001652	# PVUNIWIEN
amt-esd-prot	1082/tcp	0.000380	# AMT-ESD-PROT
amt-esd-prot	1082/udp	0.000330	# AMT-ESD-PROT
ansoft-lm-1	1083/tcp	0.000427	# Anasoft License Manager
ansoft-lm-1	1083/udp	0.001236	# Anasoft License Manager
ansoft-lm-2	1084/tcp	0.000263	# Anasoft License Manager
ansoft-lm-2	1084/udp	0.000626	# Anasoft License Manager
webobjects	1085/tcp	0.000380	# Web Objects
webobjects	1085/udp	0.000661	# Web Objects
cplscrambler-lg	1086/tcp	0.000456	# CPL Scrambler Logging
cplscrambler-lg	1086/udp	0.000330	# CPL Scrambler Logging
cplscrambler-in	1087/tcp	0.000304	# CPL Scrambler Internal
cplscrambler-in	1087/udp	0.001321	# CPL Scrambler Internal
cplscrambler-al	1088/tcp	0.000456	# CPL Scrambler Alarm Log
cplscrambler-al	1088/udp	0.001321	# CPL Scrambler Alarm Log
ff-annunc	1089/tcp	0.000304	# FF Annunciation
ff-annunc	1089/udp	0.000661	# FF Annunciation
ff-fms	1090/tcp	0.000228	# FF Fieldbus Message Specification
ff-fms	1090/udp	0.002313	# FF Fieldbus Message Specification
ff-sm	1091/tcp	0.000228	# FF System Management
obrpd	1092/tcp	0.000152	# Open Business Reporting Protocol
obrpd	1092/udp	0.000330	# Open Business Reporting Protocol
proofd	1093/tcp	0.000380	# PROOFD
proofd	1093/udp	0.000330	# PROOFD
rootd	1094/tcp	0.000380	# ROOTD
rootd	1094/udp	0.000330	# ROOTD
nicelink	1095/tcp	0.000152	# NICELink
nicelink	1095/udp	0.000661	# NICELink
cnrprotocol	1096/tcp	0.000380	# Common Name Resolution Protocol
sunclustermgr	1097/tcp	0.000456	# Sun Cluster Manager
rmiactivation	1098/tcp	0.000380	# RMI Activation
rmiactivation	1098/udp	0.000991	# RMI Activation
rmiregistry	1099/tcp	0.000380	# RMI Registry
rmiregistry	1099/udp	0.000661	# RMI Registry
mctp	1100/tcp	0.000380	# MCTP
mctp	1100/udp	0.001652	# MCTP
pt2-discover	1101/tcp	0.000076	# PT2-DISCOVER
pt2-discover	1101/udp	0.001321	# PT2-DISCOVER
adobeserver-1	1102/tcp	0.000152	# ADOBE SERVER 1
adobeserver-1	1102/udp	0.000661	# ADOBE SERVER 1
xaudio	1103/tcp	0.000151	# Xaserver	# X Audio Server
adobeserver-2	1103/udp	0.000661	# ADOBE SERVER 2
xrl	1104/tcp	0.000380	# XRL
xrl	1104/udp	0.000330	# XRL
ftranhc	1105/tcp	0.000152	# FTRANHC
ftranhc	1105/udp	0.001652	# FTRANHC
isoipsigport-1	1106/tcp	0.000380	# ISOIPSIGPORT-1
isoipsigport-1	1106/udp	0.000661	# ISOIPSIGPORT-1
isoipsigport-2	1107/tcp	0.000380	# ISOIPSIGPORT-2
isoipsigport-2	1107/udp	0.000330	# ISOIPSIGPORT-2
ratio-adp	1108/tcp	0.000380
ratio-adp	1108/udp	0.000330
kpop	1109/tcp	0.000151	# Pop with Kerberos
nfsd-status	1110/tcp	0.005809	# Cluster status info
nfsd-keepalive	1110/udp	0.000939	# Client status info
lmsocialserver	1111/tcp	0.001140	# LM Social Server
msql	1112/tcp	0.000276	# mini-sql server
icp	1112/udp	0.000330	# Intelligent Communication Protocol
ltp-deepspace	1113/tcp	0.000152	# Licklider Transmission Protocol
ltp-deepspace	1113/udp	0.000991	# Licklider Transmission Protocol
mini-sql	1114/tcp	0.000228	# Mini SQL
mini-sql	1114/udp	0.000330	# Mini SQL
ardus-cntl	1116/tcp	0.000076	# ARDUS Control
ardus-cntl	1116/udp	0.000661	# ARDUS Control
ardus-mtrns	1117/tcp	0.000228	# ARDUS Multicast Transfer
ardus-mtrns	1117/udp	0.000330	# ARDUS Multicast Transfer
sacred	1118/tcp	0.000076	# SACRED
bnetgame	1119/tcp	0.000228	# Battle.net Chat/Game Protocol
bnetgame	1119/udp	0.000330	# Battle.net Chat/Game Protocol
bnetfile	1120/udp	0.000330	# Battle.net File Transfer Protocol
rmpp	1121/tcp	0.000152	# Datalode RMPP
availant-mgr	1122/tcp	0.000228
availant-mgr	1122/udp	0.000661
murray	1123/tcp	0.000152	# Murray
hpvmmcontrol	1124/tcp	0.000304	# HP VMM Control
hpvmmcontrol	1124/udp	0.001652	# HP VMM Control
hpvmmagent	1125/tcp	0.000076	# HP VMM Agent
hpvmmagent	1125/udp	0.000330	# HP VMM Agent
hpvmmdata	1126/tcp	0.000152	# HP VMM Agent
supfiledbg	1127/tcp	0.000088	# SUP debugging
saphostctrl	1128/tcp	0.000076	# SAPHostControl over SOAP/HTTP
saphostctrls	1129/udp	0.000330	# SAPHostControl over SOAP/HTTPS
casp	1130/tcp	0.000152	# CAC App Service Protocol
casp	1130/udp	0.000330	# CAC App Service Protocol
caspssl	1131/tcp	0.000228	# CAC App Service Protocol Encripted
caspssl	1131/udp	0.000330	# CAC App Service Protocol Encripted
kvm-via-ip	1132/tcp	0.000152	# KVM-via-IP Management Service
dfn	1133/udp	0.000330	# Data Flow Network
aplx	1134/tcp	0.000076	# MicroAPL APLX
omnivision	1135/tcp	0.000076	# OmniVision Communication Service
hhb-gateway	1136/tcp	0.000076	# HHB Gateway Control
hhb-gateway	1136/udp	0.000330	# HHB Gateway Control
trim	1137/tcp	0.000152	# TRIM Workgroup Service
trim	1137/udp	0.000330	# TRIM Workgroup Service
encrypted_admin	1138/tcp	0.000228	# encrypted admin requests
cce3x	1139/tcp	0.000063	# ClearCommerce Engine 3.x ( www.clearcommerce.com)
evm	1139/udp	0.000661	# Enterprise Virtual Manager
mxomss	1141/tcp	0.000152	# User Message Service
imyx	1143/tcp	0.000076	# Infomatryx Exchange
imyx	1143/udp	0.000661	# Infomatryx Exchange
fuscript	1144/tcp	0.000076	# Fusion Script
fuscript	1144/udp	0.000330	# Fusion Script
x9-icue	1145/tcp	0.000152	# X9 iCue Show Control
x9-icue	1145/udp	0.000330	# X9 iCue Show Control
audit-transfer	1146/udp	0.000330	# audit transfer
capioverlan	1147/tcp	0.000152	# CAPIoverLAN
capioverlan	1147/udp	0.000330	# CAPIoverLAN
elfiq-repl	1148/tcp	0.000380	# Elfiq Replication Service
elfiq-repl	1148/udp	0.000661	# Elfiq Replication Service
bvtsonar	1149/tcp	0.000152	# BVT Sonar Service
bvtsonar	1149/udp	0.000330	# BVT Sonar Service
blaze	1150/tcp	0.000076	# Blaze File Server
unizensus	1151/tcp	0.000228	# Unizensus Login Server
unizensus	1151/udp	0.000330	# Unizensus Login Server
winpoplanmess	1152/tcp	0.000304	# Winpopup LAN Messenger
c1222-acse	1153/tcp	0.000076	# ANSI C12.22 Port
resacommunity	1154/tcp	0.000152	# Community Service
nfa	1155/udp	0.000890	# Network File Access
iascontrol-oms	1156/tcp	0.000076	# iasControl OMS
iascontrol	1157/tcp	0.000076	# Oracle iASControl
lsnr	1158/tcp	0.000138	# Oracle DB listener
dbcontrol-oms	1158/udp	0.000330	# dbControl OMS
oracle-oms	1159/tcp	0.000076	# Oracle OMS
health-trap	1162/tcp	0.000076	# Health Trap
health-trap	1162/udp	0.000330	# Health Trap
sddp	1163/tcp	0.000152	# SmartDialer Data Protocol
sddp	1163/udp	0.000991	# SmartDialer Data Protocol
qsm-proxy	1164/tcp	0.000152	# QSM Proxy Service
qsm-proxy	1164/udp	0.000330	# QSM Proxy Service
qsm-gui	1165/tcp	0.000152	# QSM GUI Service
qsm-remote	1166/tcp	0.000152	# QSM RemoteExec
qsm-remote	1166/udp	0.000330	# QSM RemoteExec
cisco-ipsla	1167/sctp	0.000000	# Cisco IP SLAs Control Protocol
cisco-ipsla	1167/tcp	0.000076	# Cisco IP SLAs Control Protocol
cisco-ipsla	1167/udp	0.000593	# Cisco IP SLAs Control Protocol
vchat	1168/tcp	0.000076	# VChat Conference Service
vchat	1168/udp	0.000330	# VChat Conference Service
tripwire	1169/tcp	0.000380	# TRIPWIRE
tripwire	1169/udp	0.000330	# TRIPWIRE
atc-lm	1170/udp	0.000330	# AT+C License Manager
d-cinema-rrp	1173/tcp	0.000076	# D-Cinema Request-Response
d-cinema-rrp	1173/udp	0.000330	# D-Cinema Request-Response
fnet-remote-ui	1174/tcp	0.000152	# FlashNet Remote Admin
dossier	1175/tcp	0.000228	# Dossier Server
dossier	1175/udp	0.000661	# Dossier Server
indigo-server	1176/tcp	0.000076	# Indigo Home Server
skkserv	1178/tcp	0.000050	# SKK (kanji input)
b2n	1179/tcp	0.000076	# Backup To Neighbor
mc-client	1180/tcp	0.000076	# Millicent Client Proxy
accelenet	1182/tcp	0.000076	# AcceleNet Control
llsurfup-http	1183/tcp	0.000304	# LL Surfup HTTP
llsurfup-https	1184/tcp	0.000076	# LL Surfup HTTPS
catchpole	1185/tcp	0.000152	# Catchpole port
catchpole	1185/udp	0.000330	# Catchpole port
mysql-cluster	1186/tcp	0.000304	# MySQL Cluster Manager
alias	1187/tcp	0.000152	# Alias Service
hp-webadmin	1188/tcp	0.000076	# HP Web Admin
hp-webadmin	1188/udp	0.000330	# HP Web Admin
unet	1189/udp	0.000330	# Unet Connection
commlinx-avl	1190/tcp	0.000076	# CommLinx GPS / AVL System
gpfs	1191/tcp	0.000076	# General Parallel File System
gpfs	1191/udp	0.000661	# General Parallel File System
caids-sensor	1192/tcp	0.000152	# caids sensors channel
fiveacross	1193/udp	0.000330	# Five Across Server
openvpn	1194/tcp	0.000076	# OpenVPN
openvpn	1194/udp	0.000330	# OpenVPN
rsf-1	1195/tcp	0.000076	# RSF-1 clustering
netmagic	1196/tcp	0.000076	# Network Magic
cajo-discovery	1198/tcp	0.000152	# cajo reference discovery
cajo-discovery	1198/udp	0.000330	# cajo reference discovery
dmidi	1199/tcp	0.000228	# DMIDI
scol	1200/tcp	0.000076	# SCOL
scol	1200/udp	0.001321	# SCOL
nucleus-sand	1201/tcp	0.000228	# Nucleus Sand Database Server
ssslic-mgr	1203/udp	0.000661	# License Validation
ssslog-mgr	1204/tcp	0.000076	# Log Request Listener
anthony-data	1206/udp	0.000661	# Anthony Data
metasage	1207/tcp	0.000076	# MetaSage
metasage	1207/udp	0.000330	# MetaSage
seagull-ais	1208/tcp	0.000076	# SEAGULL AIS
ipcd3	1209/tcp	0.000076	# IPCD3
eoss	1210/tcp	0.000076	# EOSS
groove-dpp	1211/tcp	0.000076	# Groove DPP
lupa	1212/tcp	0.000125
lupa	1212/udp	0.000544
mpc-lifenet	1213/tcp	0.000152	# MPC LIFENET
fasttrack	1214/tcp	0.000050	# Kazaa File Sharing
fasttrack	1214/udp	0.001796	# Kazaa File Sharing
scanstat-1	1215/tcp	0.000076	# scanSTAT 1.0
scanstat-1	1215/udp	0.000661	# scanSTAT 1.0
etebac5	1216/tcp	0.000152	# ETEBAC 5
etebac5	1216/udp	0.000330	# ETEBAC 5
hpss-ndapi	1217/tcp	0.000152	# HPSS NonDCE Gateway
aeroflight-ads	1218/tcp	0.001064	# AeroFlight ADs
quicktime	1220/tcp	0.000151	# Apple Darwin and QuickTime Streaming Administration Servers
sweetware-apps	1221/tcp	0.000076	# SweetWARE Apps
nerv	1222/tcp	0.000138	# SNI R&D network
nerv	1222/udp	0.000346	# SNI R&D network
tgp	1223/tcp	0.000076	# TrulyGlobal Protocol
vpnz	1224/udp	0.000330	# VPNz
slinkysearch	1225/udp	0.000330	# SLINKYSEARCH
stgxfws	1226/udp	0.000330	# STGXFWS
dns2go	1227/udp	0.000330	# DNS2Go
florence	1228/tcp	0.000076	# FLORENCE
zented	1229/tcp	0.000076	# ZENworks Tiered Electronic Distribution
zented	1229/udp	0.000330	# ZENworks Tiered Electronic Distribution
menandmice-lpm	1231/udp	0.000330
univ-appserver	1233/tcp	0.000152	# Universal App Server
univ-appserver	1233/udp	0.000330	# Universal App Server
hotline	1234/tcp	0.001217
search-agent	1234/udp	0.001652	# Infoseek Search Agent
bvcontrol	1236/tcp	0.000152
tsdos390	1237/udp	0.000991
nmsd	1239/tcp	0.000076	# NMSD
instantia	1240/tcp	0.000076	# Instantia
nessus	1241/tcp	0.000113	# Nessus or remote message server
nessus	1241/udp	0.000330
serialgateway	1243/tcp	0.000076	# SerialGateway
isbconference1	1244/tcp	0.000152
visionpyramid	1247/tcp	0.000304	# VisionPyramid
hermes	1248/tcp	0.000477
hermes	1248/udp	0.000412
mesavistaco	1249/tcp	0.000076	# Mesa Vista Co
mesavistaco	1249/udp	0.000330	# Mesa Vista Co
swldy-sias	1250/tcp	0.000076
servergraph	1251/tcp	0.000076
servergraph	1251/udp	0.000661
q55-pcc	1253/udp	0.000330
de-cache-query	1255/udp	0.000330
de-server	1256/udp	0.000661
shockwave2	1257/udp	0.000661	# Shockwave 2
opennl-voice	1259/tcp	0.000152	# Open Network Library Voice
opennl-voice	1259/udp	0.000330	# Open Network Library Voice
ibm-ssd	1260/udp	0.000330
mpshrsv	1261/tcp	0.000076
qnts-orb	1262/tcp	0.000076	# QNTS-ORB
prat	1264/tcp	0.000076	# PRAT
prat	1264/udp	0.000330	# PRAT
propel-msgsys	1268/tcp	0.000076	# PROPEL-MSGSYS
watilapp	1269/udp	0.000330	# WATiLaPP
ssserver	1270/tcp	0.000138	# Sun StorEdge Configuration Service
excw	1271/tcp	0.000228	# eXcW
cspmlockmgr	1272/tcp	0.000380	# CSPMLockMgr
ivmanager	1276/tcp	0.000076
miva-mqs	1277/tcp	0.000152	# mqs
dellwebadmin-2	1279/tcp	0.000076	# Dell Web Admin 2
dellwebadmin-2	1279/udp	0.000330	# Dell Web Admin 2
emperion	1282/tcp	0.000076	# Emperion
netuitive	1286/udp	0.000991
routematch	1287/tcp	0.000152	# RouteMatch Com
routematch	1287/udp	0.000991	# RouteMatch Com
winjaserver	1290/tcp	0.000076	# WinJaServer
seagulllms	1291/tcp	0.000076	# SEAGULLLMS
seagulllms	1291/udp	0.000330	# SEAGULLLMS
cmmdriver	1294/udp	0.000330	# CMMdriver
ehtp	1295/udp	0.000330	# End-by-Hop Transmission Protocol
dproxy	1296/tcp	0.000304
sdproxy	1297/tcp	0.000076
sdproxy	1297/udp	0.000330
hp-sci	1299/tcp	0.000076
hp-sci	1299/udp	0.000330
h323hostcallsc	1300/tcp	0.000152	# H323 Host Call Secure
h323hostcallsc	1300/udp	0.000330	# H323 Host Call Secure
ci3-software-1	1301/tcp	0.000152	# CI3-Software-1
ci3-software-1	1301/udp	0.000330	# CI3-Software-1
ci3-software-2	1302/tcp	0.000076	# CI3-Software-2
ci3-software-2	1302/udp	0.000661	# CI3-Software-2
sftsrv	1303/tcp	0.000076
pe-mike	1305/tcp	0.000076
re-conn-proto	1306/tcp	0.000076	# RE-Conn-Proto
pacmand	1307/tcp	0.000076	# Pacmand
odsi	1308/tcp	0.000076	# Optical Domain Service Interconnect (ODSI)
jtag-server	1309/tcp	0.000152	# JTAG server
husky	1310/tcp	0.000380	# Husky
husky	1310/udp	0.000330	# Husky
rxmon	1311/tcp	0.000760
pdps	1314/tcp	0.000076	# Photoscript Distributed Printing System
pdps	1314/udp	0.000330	# Photoscript Distributed Printing System
els	1315/tcp	0.000076	# E.L.S., Event Listener Service
els	1315/udp	0.000330	# E.L.S., Event Listener Service
exbit-escp	1316/tcp	0.000076	# Exbit-ESCP
vrts-ipcserver	1317/tcp	0.000076
vrts-ipcserver	1317/udp	0.000330
krb5gatekeeper	1318/tcp	0.000076
amx-icsp	1319/tcp	0.000076	# AMX-ICSP
pip	1321/tcp	0.000076	# PIP
novation	1322/tcp	0.000152	# Novation
delta-mcp	1324/tcp	0.000076
dx-instrument	1325/udp	0.000330	# DX-Instrument
ultrex	1327/tcp	0.000076	# Ultrex
ultrex	1327/udp	0.000330	# Ultrex
ewall	1328/tcp	0.000152	# EWALL
streetperfect	1330/tcp	0.000076	# StreetPerfect
intersan	1331/tcp	0.000076
writesrv	1334/tcp	0.000304
writesrv	1334/udp	0.000991
ischat	1336/tcp	0.000076	# Instant Service Chat
ischat	1336/udp	0.000330	# Instant Service Chat
waste	1337/tcp	0.000088	# Nullsoft WASTE encrypted P2P app
menandmice-dns	1337/udp	0.000661	# menandmice DNS
wmc-log-svc	1338/udp	0.000330	# WMC-log-svr
kjtsiteserver	1339/tcp	0.000076
naap	1340/tcp	0.000076	# NAAP
esbroker	1342/udp	0.000330	# ESBroker
icap	1344/udp	0.000330	# ICAP
vpjp	1345/udp	0.000991	# VPJP
alta-ana-lm	1346/tcp	0.000050	# Alta Analytics License Manager
alta-ana-lm	1346/udp	0.001928	# Alta Analytics License Manager
bbn-mmc	1347/tcp	0.000151	# multi media conferencing
bbn-mmc	1347/udp	0.000692	# multi media conferencing
bbn-mmx	1348/tcp	0.000038	# multi media conferencing
bbn-mmx	1348/udp	0.000988	# multi media conferencing
sbook	1349/tcp	0.000050	# Registration Network Protocol
sbook	1349/udp	0.000873	# Registration Network Protocol
editbench	1350/tcp	0.000113	# Registration Network Protocol
editbench	1350/udp	0.000577	# Registration Network Protocol
equationbuilder	1351/tcp	0.000113	# Digital Tool Works (MIT)
equationbuilder	1351/udp	0.000544	# Digital Tool Works (MIT)
lotusnotes	1352/tcp	0.001154	# Lotus Note
lotusnotes	1352/udp	0.000610	# Lotus Note
relief	1353/tcp	0.000100	# Relief Consulting
relief	1353/udp	0.000708	# Relief Consulting
rightbrain	1354/tcp	0.000038	# RightBrain Software
rightbrain	1354/udp	0.000544	# RightBrain Software
intuitive-edge	1355/tcp	0.000025	# Intuitive Edge
intuitive-edge	1355/udp	0.000527	# Intuitive Edge
cuillamartin	1356/tcp	0.000050	# CuillaMartin Company
cuillamartin	1356/udp	0.000461	# CuillaMartin Company
pegboard	1357/tcp	0.000100	# Electronic PegBoard
pegboard	1357/udp	0.000708	# Electronic PegBoard
connlcli	1358/tcp	0.000063
connlcli	1358/udp	0.000577
ftsrv	1359/tcp	0.000063
ftsrv	1359/udp	0.000824
mimer	1360/tcp	0.000013
mimer	1360/udp	0.000478
linx	1361/tcp	0.000013
linx	1361/udp	0.000610
timeflies	1362/tcp	0.000025
timeflies	1362/udp	0.000494
ndm-requester	1363/tcp	0.000013	# Network DataMover Requester
ndm-requester	1363/udp	0.000494	# Network DataMover Requester
ndm-server	1364/tcp	0.000063	# Network DataMover Server
ndm-server	1364/udp	0.000824	# Network DataMover Server
adapt-sna	1365/tcp	0.000025	# Network Software Associates
adapt-sna	1365/udp	0.000643	# Network Software Associates
netware-csp	1366/tcp	0.000063	# Novell NetWare Comm Service Platform
netware-csp	1366/udp	0.000923	# Novell NetWare Comm Service Platform
dcs	1367/tcp	0.000013
dcs	1367/udp	0.000560
screencast	1368/tcp	0.000025
screencast	1368/udp	0.000379
gv-us	1369/tcp	0.000038	# GlobalView to Unix Shell
gv-us	1369/udp	0.000461	# GlobalView to Unix Shell
us-gv	1370/tcp	0.000050	# Unix Shell to GlobalView
us-gv	1370/udp	0.000725	# Unix Shell to GlobalView
fc-cli	1371/tcp	0.000013	# Fujitsu Config Protocol
fc-cli	1371/udp	0.000692	# Fujitsu Config Protocol
fc-ser	1372/tcp	0.000038	# Fujitsu Config Protocol
fc-ser	1372/udp	0.000708	# Fujitsu Config Protocol
chromagrafx	1373/tcp	0.000038
chromagrafx	1373/udp	0.000428
molly	1374/tcp	0.000013	# EPI Software Systems
molly	1374/udp	0.000461	# EPI Software Systems
bytex	1375/udp	0.000494
ibm-pps	1376/tcp	0.000025	# IBM Person to Person Software
ibm-pps	1376/udp	0.000577	# IBM Person to Person Software
cichlid	1377/udp	0.000593	# Cichlid License Manager
elan	1378/udp	0.000560	# Elan License Manager
dbreporter	1379/tcp	0.000038	# Integrity Solutions
dbreporter	1379/udp	0.000560	# Integrity Solutions
telesis-licman	1380/udp	0.000610	# Telesis Network License Manager
apple-licman	1381/tcp	0.000038	# Apple Network License Manager
apple-licman	1381/udp	0.000560	# Apple Network License Manager
gwha	1383/tcp	0.000013	# GW Hannaway Network License Manager
gwha	1383/udp	0.000659	# GW Hannaway Network License Manager
os-licman	1384/tcp	0.000050	# Objective Solutions License Manager
os-licman	1384/udp	0.000428	# Objective Solutions License Manager
atex_elmd	1385/tcp	0.000050	# Atex Publishing License Manager
atex_elmd	1385/udp	0.000280	# Atex Publishing License Manager
checksum	1386/tcp	0.000025	# CheckSum License Manager
checksum	1386/udp	0.000511	# CheckSum License Manager
cadsi-lm	1387/tcp	0.000038	# Computer Aided Design Software Inc LM
cadsi-lm	1387/udp	0.000577	# Computer Aided Design Software Inc LM
objective-dbc	1388/tcp	0.000050	# Objective Solutions DataBase Cache
objective-dbc	1388/udp	0.000741	# Objective Solutions DataBase Cache
iclpv-dm	1389/tcp	0.000050	# Document Manager
iclpv-dm	1389/udp	0.000923	# Document Manager
iclpv-sc	1390/tcp	0.000025	# Storage Controller
iclpv-sc	1390/udp	0.000511	# Storage Controller
iclpv-sas	1391/tcp	0.000013	# Storage Access Server
iclpv-sas	1391/udp	0.000659	# Storage Access Server
iclpv-pm	1392/udp	0.000659	# Print Manager
iclpv-nls	1393/tcp	0.000025	# Network Log Server
iclpv-nls	1393/udp	0.000725	# Network Log Server
iclpv-nlc	1394/tcp	0.000025	# Network Log Client
iclpv-nlc	1394/udp	0.000445	# Network Log Client
iclpv-wsm	1395/tcp	0.000013	# PC Workstation Manager software
iclpv-wsm	1395/udp	0.000675	# PC Workstation Manager software
dvl-activemail	1396/tcp	0.000013	# DVL Active Mail
dvl-activemail	1396/udp	0.000577	# DVL Active Mail
audio-activmail	1397/tcp	0.000025	# Audio Active Mail
audio-activmail	1397/udp	0.000527	# Audio Active Mail
video-activmail	1398/tcp	0.000025	# Video Active Mail
video-activmail	1398/udp	0.000774	# Video Active Mail
cadkey-licman	1399/tcp	0.000050	# Cadkey License Manager
cadkey-licman	1399/udp	0.000643	# Cadkey License Manager
cadkey-tablet	1400/tcp	0.000050	# Cadkey Tablet Daemon
cadkey-tablet	1400/udp	0.001219	# Cadkey Tablet Daemon
goldleaf-licman	1401/tcp	0.000038	# Goldleaf License Manager
goldleaf-licman	1401/udp	0.000494	# Goldleaf License Manager
prm-sm-np	1402/tcp	0.000050	# Prospero Resource Manager
prm-sm-np	1402/udp	0.000659	# Prospero Resource Manager
prm-nm-np	1403/tcp	0.000038	# Prospero Resource Manager
prm-nm-np	1403/udp	0.000527	# Prospero Resource Manager
igi-lm	1404/tcp	0.000050	# Infinite Graphics License Manager
igi-lm	1404/udp	0.000494	# Infinite Graphics License Manager
ibm-res	1405/tcp	0.000038	# IBM Remote Execution Starter
ibm-res	1405/udp	0.000445	# IBM Remote Execution Starter
netlabs-lm	1406/udp	0.000643	# NetLabs License Manager
dbsa-lm	1407/tcp	0.000013	# DBSA License Manager
dbsa-lm	1407/udp	0.000478	# DBSA License Manager
sophia-lm	1408/tcp	0.000013	# Sophia License Manager
sophia-lm	1408/udp	0.000478	# Sophia License Manager
here-lm	1409/tcp	0.000025	# Here License Manager
here-lm	1409/udp	0.000395	# Here License Manager
hiq	1410/tcp	0.000025	# HiQ License Manager
hiq	1410/udp	0.000643	# HiQ License Manager
af	1411/tcp	0.000013	# AudioFile
af	1411/udp	0.000544	# AudioFile
innosys	1412/tcp	0.000038
innosys	1412/udp	0.000890
innosys-acl	1413/tcp	0.000088
innosys-acl	1413/udp	0.000577
ibm-mqseries	1414/tcp	0.000088	# IBM MQSeries
ibm-mqseries	1414/udp	0.000988	# IBM MQSeries
dbstar	1415/udp	0.000659
novell-lu6.2	1416/tcp	0.000013	# Novell LU6.2
novell-lu6.2	1416/udp	0.000577	# Novell LU6.2
timbuktu-srv1	1417/tcp	0.000201	# Timbuktu Service 1 Port
timbuktu-srv1	1417/udp	0.000610	# Timbuktu Service 1 Port
timbuktu-srv2	1418/tcp	0.000013	# Timbuktu Service 2 Port
timbuktu-srv2	1418/udp	0.000478	# Timbuktu Service 2 Port
timbuktu-srv3	1419/tcp	0.000013	# Timbuktu Service 3 Port
timbuktu-srv3	1419/udp	0.004267	# Timbuktu Service 3 Port
timbuktu-srv4	1420/tcp	0.000063	# Timbuktu Service 4 Port
timbuktu-srv4	1420/udp	0.000741	# Timbuktu Service 4 Port
gandalf-lm	1421/udp	0.000577	# Gandalf License Manager
autodesk-lm	1422/tcp	0.000025	# Autodesk License Manager
autodesk-lm	1422/udp	0.000906	# Autodesk License Manager
essbase	1423/tcp	0.000013	# Essbase Arbor Software
essbase	1423/udp	0.000544	# Essbase Arbor Software
hybrid	1424/tcp	0.000025	# Hybrid Encryption Protocol
hybrid	1424/udp	0.000527	# Hybrid Encryption Protocol
zion-lm	1425/udp	0.000511	# Zion Software License Manager
sas-1	1426/tcp	0.000025	# Satellite-data Acquisition System 1
sas-1	1426/udp	0.000445	# Satellite-data Acquisition System 1
mloadd	1427/tcp	0.000013	# mloadd monitoring tool
mloadd	1427/udp	0.000659	# mloadd monitoring tool
informatik-lm	1428/udp	0.000659	# Informatik License Manager
nms	1429/tcp	0.000013	# Hypercom NMS
nms	1429/udp	0.000593	# Hypercom NMS
tpdu	1430/tcp	0.000013	# Hypercom TPDU
tpdu	1430/udp	0.000478	# Hypercom TPDU
rgtp	1431/udp	0.000461	# Reverse Gossip Transport
blueberry-lm	1432/tcp	0.000025	# Blueberry Software License Manager
blueberry-lm	1432/udp	0.000840	# Blueberry Software License Manager
ms-sql-s	1433/tcp	0.007929	# Microsoft-SQL-Server
ms-sql-s	1433/udp	0.036821	# Microsoft-SQL-Server
ms-sql-m	1434/tcp	0.000201	# Microsoft-SQL-Monitor
ms-sql-m	1434/udp	0.293184	# Microsoft-SQL-Monitor
ibm-cics	1435/tcp	0.000038
ibm-cics	1435/udp	0.000774
sas-2	1436/tcp	0.000025	# Satellite-data Acquisition System 2
sas-2	1436/udp	0.000478	# Satellite-data Acquisition System 2
tabula	1437/tcp	0.000025
tabula	1437/udp	0.000610
eicon-server	1438/tcp	0.000025	# Eicon Security Agent/Server
eicon-server	1438/udp	0.000758	# Eicon Security Agent/Server
eicon-x25	1439/tcp	0.000025	# Eicon X25/SNA Gateway
eicon-x25	1439/udp	0.000297	# Eicon X25/SNA Gateway
eicon-slp	1440/tcp	0.000013	# Eicon Service Location Protocol
eicon-slp	1440/udp	0.000725	# Eicon Service Location Protocol
cadis-1	1441/tcp	0.000075	# Cadis License Management
cadis-1	1441/udp	0.000857	# Cadis License Management
cadis-2	1442/tcp	0.000025	# Cadis License Management
cadis-2	1442/udp	0.000346	# Cadis License Management
ies-lm	1443/tcp	0.000238	# Integrated Engineering Software
ies-lm	1443/udp	0.000395	# Integrated Engineering Software
marcam-lm	1444/tcp	0.000075	# Marcam License Management
marcam-lm	1444/udp	0.000379	# Marcam License Management
proxima-lm	1445/tcp	0.000050	# Proxima License Manager
proxima-lm	1445/udp	0.000692	# Proxima License Manager
ora-lm	1446/tcp	0.000025	# Optical Research Associates License Manager
ora-lm	1446/udp	0.000478	# Optical Research Associates License Manager
apri-lm	1447/udp	0.000478	# Applied Parallel Research LM
oc-lm	1448/tcp	0.000013	# OpenConnect License Manager
oc-lm	1448/udp	0.000626	# OpenConnect License Manager
peport	1449/tcp	0.000013
peport	1449/udp	0.000379
dwf	1450/udp	0.000478	# Tandem Distributed Workbench Facility
infoman	1451/tcp	0.000013	# IBM Information Management
infoman	1451/udp	0.000461	# IBM Information Management
gtegsc-lm	1452/udp	0.000445	# GTE Government Systems License Man
genie-lm	1453/tcp	0.000013	# Genie License Manager
genie-lm	1453/udp	0.000692	# Genie License Manager
interhdl_elmd	1454/tcp	0.000025	# interHDL License Manager
interhdl_elmd	1454/udp	0.000379	# interHDL License Manager
esl-lm	1455/tcp	0.000176	# ESL License Manager
esl-lm	1455/udp	0.001417	# ESL License Manager
dca	1456/tcp	0.000025
dca	1456/udp	0.000511
valisys-lm	1457/tcp	0.000013	# Valisys License Manager
valisys-lm	1457/udp	0.001334	# Valisys License Manager
nrcabq-lm	1458/tcp	0.000013	# Nichols Research Corp.
nrcabq-lm	1458/udp	0.000643	# Nichols Research Corp.
proshare1	1459/tcp	0.000013	# Proshare Notebook Application
proshare1	1459/udp	0.000610	# Proshare Notebook Application
proshare2	1460/udp	0.000610	# Proshare Notebook Application
ibm_wrless_lan	1461/tcp	0.000188	# IBM Wireless LAN
ibm_wrless_lan	1461/udp	0.000643	# IBM Wireless LAN
world-lm	1462/tcp	0.000013	# World License Manager
world-lm	1462/udp	0.000445	# World License Manager
nucleus	1463/udp	0.000297
msl_lmd	1464/tcp	0.000013	# MSL License Manager
msl_lmd	1464/udp	0.000362	# MSL License Manager
pipes	1465/tcp	0.000050	# Pipes Platform
pipes	1465/udp	0.000741
oceansoft-lm	1466/tcp	0.000038	# Ocean Software License Manager
oceansoft-lm	1466/udp	0.000395	# Ocean Software License Manager
csdmbase	1467/tcp	0.000038
csdmbase	1467/udp	0.000873
csdm	1468/udp	0.000577
aal-lm	1469/tcp	0.000013	# Active Analysis Limited License Manager
aal-lm	1469/udp	0.000873	# Active Analysis Limited License Manager
uaiact	1470/tcp	0.000013	# Universal Analytics
uaiact	1470/udp	0.000362	# Universal Analytics
csdmbase	1471/udp	0.000445
csdm	1472/tcp	0.000025
csdm	1472/udp	0.000379
openmath	1473/tcp	0.000013
openmath	1473/udp	0.000560
telefinder	1474/tcp	0.000050
telefinder	1474/udp	0.000461
taligent-lm	1475/tcp	0.000038	# Taligent License Manager
taligent-lm	1475/udp	0.000461	# Taligent License Manager
clvm-cfg	1476/tcp	0.000038
clvm-cfg	1476/udp	0.000692
ms-sna-server	1477/udp	0.000527
ms-sna-base	1478/udp	0.000577
dberegister	1479/tcp	0.000025
dberegister	1479/udp	0.000511
pacerforum	1480/tcp	0.000013
pacerforum	1480/udp	0.000527
airs	1481/udp	0.000758
miteksys-lm	1482/tcp	0.000013	# Miteksys License Manager
miteksys-lm	1482/udp	0.000708	# Miteksys License Manager
afs	1483/tcp	0.000025	# AFS License Manager
afs	1483/udp	0.000956	# AFS License Manager
confluent	1484/tcp	0.000050	# Confluent License Manager
confluent	1484/udp	0.001549	# Confluent License Manager
lansource	1485/udp	0.002323
nms_topo_serv	1486/tcp	0.000038
nms_topo_serv	1486/udp	0.000626
localinfosrvr	1487/udp	0.000428
docstor	1488/tcp	0.000013
docstor	1488/udp	0.000544
dmdocbroker	1489/udp	0.000428
insitu-conf	1490/udp	0.000577
anynetgateway	1491/tcp	0.000013
anynetgateway	1491/udp	0.000972
stone-design-1	1492/tcp	0.000075
stone-design-1	1492/udp	0.000478
netmap_lm	1493/tcp	0.000025
netmap_lm	1493/udp	0.000395
citrix-ica	1494/tcp	0.001255
citrix-ica	1494/udp	0.000494
cvc	1495/tcp	0.000075
cvc	1495/udp	0.000527
liberty-lm	1496/tcp	0.000038
liberty-lm	1496/udp	0.000412
rfx-lm	1497/tcp	0.000038
rfx-lm	1497/udp	0.000329
watcom-sql	1498/tcp	0.000025
watcom-sql	1498/udp	0.000758
fhc	1499/tcp	0.000025	# Federico Heinz Consultora
fhc	1499/udp	0.000461	# Federico Heinz Consultora
vlsi-lm	1500/tcp	0.000627	# VLSI License Manager
vlsi-lm	1500/udp	0.000461	# VLSI License Manager
sas-3	1501/tcp	0.000602	# Satellite-data Acquisition System 3
sas-3	1501/udp	0.000725	# Satellite-data Acquisition System 3
shivadiscovery	1502/tcp	0.000013	# Shiva
shivadiscovery	1502/udp	0.000626	# Shiva
imtc-mcs	1503/tcp	0.000640	# Databeam
imtc-mcs	1503/udp	0.000675	# Databeam
evb-elm	1504/udp	0.000428	# EVB Software Engineering License Manager
funkproxy	1505/tcp	0.000013	# Funk Software, Inc.
funkproxy	1505/udp	0.000675	# Funk Software, Inc.
utcd	1506/udp	0.000544	# Universal Time daemon (utcd)
symplex	1507/tcp	0.000075
symplex	1507/udp	0.000840
diagmond	1508/tcp	0.000013
diagmond	1508/udp	0.000478
robcad-lm	1509/tcp	0.000013	# Robcad, Ltd. License Manager
robcad-lm	1509/udp	0.000593	# Robcad, Ltd. License Manager
mvx-lm	1510/tcp	0.000025	# Midland Valley Exploration Ltd. Lic. Man.
mvx-lm	1510/udp	0.000511	# Midland Valley Exploration Ltd. Lic. Man.
3l-l1	1511/tcp	0.000025
3l-l1	1511/udp	0.000577
wins	1512/udp	0.000791	# Microsoft's Windows Internet Name Service
fujitsu-dtc	1513/tcp	0.000025	# Fujitsu Systems Business of America, Inc
fujitsu-dtc	1513/udp	0.000807	# Fujitsu Systems Business of America, Inc
fujitsu-dtcns	1514/udp	0.001120	# Fujitsu Systems Business of America, Inc
ifor-protocol	1515/tcp	0.000038
ifor-protocol	1515/udp	0.000758
vpad	1516/tcp	0.000113	# Virtual Places Audio data
vpad	1516/udp	0.000593	# Virtual Places Audio data
vpac	1517/tcp	0.000050	# Virtual Places Audio control
vpac	1517/udp	0.000428	# Virtual Places Audio control
vpvd	1518/tcp	0.000013	# Virtual Places Video data
vpvd	1518/udp	0.000758	# Virtual Places Video data
vpvc	1519/tcp	0.000025	# Virtual Places Video control
vpvc	1519/udp	0.000593	# Virtual Places Video control
atm-zip-office	1520/udp	0.000428	# atm zip office
oracle	1521/tcp	0.001568	# Oracle Database
ncube-lm	1521/udp	0.000873	# nCube License Manager
rna-lm	1522/tcp	0.000100	# Ricardo North America License Manager
rna-lm	1522/udp	0.000461	# Ricardo North America License Manager
cichild-lm	1523/tcp	0.000050
cichild-lm	1523/udp	0.000610
ingreslock	1524/tcp	0.000276	# ingres
ingreslock	1524/udp	0.001647	# ingres
orasrv	1525/tcp	0.000088	# oracle or Prospero Directory Service non-priv
oracle	1525/udp	0.000461
pdap-np	1526/tcp	0.000113	# Prospero Data Access Prot non-priv
pdap-np	1526/udp	0.000478	# Prospero Data Access Prot non-priv
tlisrv	1527/tcp	0.000038	# oracle
tlisrv	1527/udp	0.000758	# oracle
mciautoreg	1528/tcp	0.000025
mciautoreg	1528/udp	0.000445
support	1529/tcp	0.000025	# prmsd gnatsd	# cygnus bug tracker
coauthor	1529/udp	0.000544	# oracle
rap-service	1530/udp	0.000675
rap-listen	1531/tcp	0.000025
rap-listen	1531/udp	0.000857
miroconnect	1532/tcp	0.000013
miroconnect	1532/udp	0.000708
virtual-places	1533/tcp	0.000238	# Virtual Places Software
virtual-places	1533/udp	0.000428	# Virtual Places Software
micromuse-lm	1534/udp	0.000461
ampr-info	1535/tcp	0.000038
ampr-info	1535/udp	0.000610
ampr-inter	1536/udp	0.000593
sdsc-lm	1537/tcp	0.000025
sdsc-lm	1537/udp	0.000807
3ds-lm	1538/tcp	0.000025
3ds-lm	1538/udp	0.000346
intellistor-lm	1539/tcp	0.000038	# Intellistor License Manager
intellistor-lm	1539/udp	0.000412	# Intellistor License Manager
rds	1540/tcp	0.000013
rds	1540/udp	0.000428
rds2	1541/tcp	0.000013
rds2	1541/udp	0.000395
gridgen-elmd	1542/tcp	0.000013
gridgen-elmd	1542/udp	0.000461
simba-cs	1543/tcp	0.000013
simba-cs	1543/udp	0.000461
aspeclmd	1544/tcp	0.000025
aspeclmd	1544/udp	0.000511
vistium-share	1545/tcp	0.000025
vistium-share	1545/udp	0.000544
abbaccuray	1546/udp	0.000560
laplink	1547/tcp	0.000113
laplink	1547/udp	0.000544
axon-lm	1548/tcp	0.000025	# Axon License Manager
axon-lm	1548/udp	0.000708	# Axon License Manager
shivahose	1549/tcp	0.000025	# Shiva Hose
shivasound	1549/udp	0.000610	# Shiva Sound
3m-image-lm	1550/tcp	0.000125	# Image Storage license manager 3M Company
3m-image-lm	1550/udp	0.000362	# Image Storage license manager 3M Company
hecmtl-db	1551/tcp	0.000050
hecmtl-db	1551/udp	0.000675
pciarray	1552/tcp	0.000050
pciarray	1552/udp	0.000478
livelan	1555/udp	0.000330
veritas_pbx	1556/tcp	0.000152	# VERITAS Private Branch Exchange
xingmpeg	1558/tcp	0.000076
web2host	1559/tcp	0.000076
web2host	1559/udp	0.000330
asci-val	1560/tcp	0.000076	# ASCI-RemoteSHADOW
winddlb	1565/tcp	0.000076	# WinDD
corelvideo	1566/tcp	0.000076	# CORELVIDEO
ets	1569/tcp	0.000076
chip-lm	1572/udp	0.000330	# Chipcom License Manager
moldflow-lm	1576/udp	0.000330	# Moldflow License Manager
ioc-sea-lm	1579/udp	0.000330
tn-tl-r1	1580/tcp	0.000304
simbaexpress	1583/tcp	0.000152
tn-tl-fd2	1584/tcp	0.000076
intv	1585/udp	0.000661
pra_elmd	1587/udp	0.000330
vqp	1589/udp	0.000330	# VQP
commonspace	1592/tcp	0.000076
sixtrak	1594/tcp	0.000152
radio-bc	1596/udp	0.000330
orbplus-iiop	1597/udp	0.000330
picknfs	1598/tcp	0.000076
simbaservices	1599/udp	0.000330
issd	1600/tcp	0.000263
issd	1600/udp	0.000807
slp	1605/tcp	0.000076	# Salutation Manager (Salutation Protocol)
slp	1605/udp	0.000330	# Salutation Manager (Salutation Protocol)
slm-api	1606/udp	0.000330	# Salutation Manager (SLM-API)
stt	1607/tcp	0.000076
smart-lm	1608/udp	0.000330	# Smart Corp. License Manager
taurus-wh	1610/udp	0.000330
netbill-auth	1615/tcp	0.000076	# NetBill Authorization Server
netbill-prod	1616/udp	0.000330	# NetBill Product Server
skytelnet	1618/udp	0.000330
faxportwinport	1620/tcp	0.000076
faxportwinport	1620/udp	0.000661
softdataphone	1621/udp	0.000330
ontime	1622/tcp	0.000076
ontime	1622/udp	0.000991
jaleosnd	1623/udp	0.000330
shockwave	1626/udp	0.000330	# Shockwave
lontalk-norm	1628/udp	0.000330	# LonTalk normal
visitview	1631/udp	0.000330	# Visit view
pammratc	1632/tcp	0.000076	# PAMMRATC
pammrpc	1633/udp	0.000330	# PAMMRPC
edb-server1	1635/tcp	0.000076	# EDB Server 1
ismc	1638/tcp	0.000076	# ISP shared management control
cert-initiator	1639/udp	0.000330
cert-responder	1640/udp	0.000330
invision	1641/tcp	0.000152	# InVision
sightline	1645/tcp	0.000076	# SightLine
radius	1645/udp	0.023180	# radius authentication
radacct	1646/udp	0.023196	# radius accounting
rsap	1647/udp	0.000330
nkd	1650/tcp	0.000038
nkd	1650/udp	0.000774
shiva_confsrvr	1651/tcp	0.000050
shiva_confsrvr	1651/udp	0.000593
xnmp	1652/tcp	0.000063
xnmp	1652/udp	0.000593
sixnetudr	1658/tcp	0.000152
netview-aix-1	1661/tcp	0.000025
netview-aix-1	1661/udp	0.000445
netview-aix-2	1662/tcp	0.000025
netview-aix-2	1662/udp	0.000807
netview-aix-3	1663/tcp	0.000063
netview-aix-3	1663/udp	0.000527
netview-aix-4	1664/tcp	0.000038
netview-aix-4	1664/udp	0.000939
netview-aix-5	1665/udp	0.000362
netview-aix-6	1666/tcp	0.000577
netview-aix-6	1666/udp	0.001186
netview-aix-7	1667/tcp	0.000025
netview-aix-7	1667/udp	0.000445
netview-aix-8	1668/tcp	0.000038
netview-aix-8	1668/udp	0.000428
netview-aix-9	1669/udp	0.000412
netview-aix-10	1670/tcp	0.000013
netview-aix-10	1670/udp	0.000675
netview-aix-11	1671/tcp	0.000013
netview-aix-11	1671/udp	0.000659
netview-aix-12	1672/tcp	0.000013
netview-aix-12	1672/udp	0.000824
groupwise	1677/tcp	0.000076
groupwise	1677/udp	0.000330
prolink	1678/udp	0.000330
CarbonCopy	1680/tcp	0.000063
microcom-sbp	1680/udp	0.000330
ncpm-hip	1683/tcp	0.000076
n2nremote	1685/udp	0.000661
nsjtp-ctrl	1687/tcp	0.000380
nsjtp-ctrl	1687/udp	0.000330
nsjtp-data	1688/tcp	0.000152
nsjtp-data	1688/udp	0.000330
empire-empuma	1691/tcp	0.000076
rrimwm	1694/tcp	0.000076
rrilwm	1695/udp	0.000661
rrifmm	1696/udp	0.000330
rsvp-encap-2	1699/tcp	0.000076	# RSVP-ENCAPSULATION-2
rsvp-encap-2	1699/udp	0.000330	# RSVP-ENCAPSULATION-2
mps-raft	1700/tcp	0.000836
l2f	1701/tcp	0.000076
L2TP	1701/udp	0.076163
hb-engine	1703/tcp	0.000076
vdmplay	1707/tcp	0.000076
gat-lmd	1708/tcp	0.000076
centra	1709/tcp	0.000076
pptconference	1711/tcp	0.000076
pptconference	1711/udp	0.000330
registrar	1712/tcp	0.000076	# resource monitoring service
registrar	1712/udp	0.000330	# resource monitoring service
conferencetalk	1713/tcp	0.000076	# ConferenceTalk
houdini-lm	1715/tcp	0.000076
fj-hdnet	1717/tcp	0.000912
h323gatedisc	1718/tcp	0.000380
h225gatedisc	1718/udp	0.012554	# H.225 gatekeeper discovery
h323gatestat	1719/tcp	0.000152
h323gatestat	1719/udp	0.018500	# H.323 Gatestat
h323q931	1720/tcp	0.014277	# Interactive media
caicci	1721/tcp	0.000152
hks-lm	1722/tcp	0.000076	# HKS License Manager
pptp	1723/tcp	0.032468	# Point-to-point tunnelling protocol
csbphonemaster	1724/udp	0.000330
iberiagames	1726/udp	0.000330	# IBERIAGAMES
citynl	1729/udp	0.000330	# CityNL License Management
roketz	1730/tcp	0.000076
roketz	1730/udp	0.000330
siipat	1733/udp	0.000330	# SIMS - SIIPAT Protocol for Alarm Transmission
privatechat	1735/tcp	0.000076	# PrivateChat
street-stream	1736/tcp	0.000076
gamegen1	1738/udp	0.000661	# GameGen1
encore	1740/udp	0.000330
cinegrfx-lm	1743/udp	0.000330	# Cinema Graphics License Manager
remote-winsock	1745/tcp	0.000076
sslp	1750/tcp	0.000076	# Simple Socket Library's PortMaster
lofr-lm	1752/tcp	0.000076	# Leap of Faith Research License Manager
unknown	1753/tcp	0.000076
unknown	1753/udp	0.000661
wms	1755/tcp	0.003350	# Windows media service
ms-streaming	1755/udp	0.000661
landesk-rc	1761/tcp	0.001756	# LANDesk Remote Control
cft-0	1761/udp	0.002313
landesk-rc	1762/tcp	0.000038	# LANDesk Remote Control
landesk-rc	1763/tcp	0.000025	# LANDesk Remote Control
cft-5	1766/udp	0.000330
cft-6	1767/udp	0.000330
kmscontrol	1773/udp	0.000330	# KMSControl
pharmasoft	1779/udp	0.000330
hp-hcip	1782/tcp	0.000304
hp-hcip	1782/udp	0.004625
unknown	1783/tcp	0.000380
funk-logger	1786/udp	0.000330
ea1	1791/tcp	0.000076	# EA1
ibm-dt-2	1792/tcp	0.000076
ibm-dt-2	1792/udp	0.000661
vocaltec-admin	1796/udp	0.000330	# Vocaltec Server Administration
netrisk	1799/tcp	0.000076	# NETRISK
ansys-lm	1800/tcp	0.000076	# ANSYS-License manager
ansys-lm	1800/udp	0.000330	# ANSYS-License manager
msmq	1801/tcp	0.002585	# Microsoft Message Queuing
hp-hcip-gwy	1803/udp	0.000661	# HP-HCIP-GWY
enl	1804/udp	0.001652	# ENL
enl-name	1805/tcp	0.000152	# ENL-Name
musiconline	1806/tcp	0.000076	# Musiconline
fhsp	1807/tcp	0.000076	# Fujitsu Hot Standby Protocol
oracle-vp2	1808/tcp	0.000076	# Oracle-VP2
scientia-sdb	1811/tcp	0.000076	# Scientia-SDB
radius	1812/sctp	0.000000	# RADIUS authentication protocol (RFC 2138)
radius	1812/tcp	0.000152	# RADIUS
radius	1812/udp	0.053839	# RADIUS authentication protocol (RFC 2138)
radacct	1813/sctp	0.000000	# RADIUS accounting protocol (RFC 2139)
radacct	1813/udp	0.010429	# RADIUS accounting protocol (RFC 2139)
tdp-suite	1814/udp	0.000330	# TDP Suite
mmpft	1815/udp	0.000330	# MMPFT
etftp	1818/udp	0.000330	# Enhanced Trivial File Transfer Protocol
es-elmd	1822/udp	0.000330
unisys-lm	1823/tcp	0.000076	# Unisys Natural Language License Manager
metrics-pas	1824/udp	0.000330
direcpc-video	1825/tcp	0.000076	# DirecPC Video
ardt	1826/udp	0.000330	# ARDT
pcm	1827/tcp	0.000025	# PCM Agent (AutoSecure Policy Compliance Manager
asi	1827/udp	0.000330	# ASI
ardusuni	1834/udp	0.000661	# ARDUS Unicast
ardusmul	1835/tcp	0.000076	# ARDUS Multicast
ardusmul	1835/udp	0.000330	# ARDUS Multicast
netopia-vo1	1839/tcp	0.000152
netopia-vo2	1840/tcp	0.000380
netopia-vo2	1840/udp	0.000330
netopia-vo3	1841/udp	0.000330
fiorano-msgsvc	1856/udp	0.000330	# Fiorano MsgSvc
privateark	1858/tcp	0.000076	# PrivateArk
lecroy-vicp	1861/tcp	0.000076	# LeCroy VICP
lecroy-vicp	1861/udp	0.000661	# LeCroy VICP
mysql-cm-agent	1862/tcp	0.000228	# MySQL Cluster Manager Agent
mysql-cm-agent	1862/udp	0.000991	# MySQL Cluster Manager Agent
msnp	1863/tcp	0.000684	# MSN Messenger
paradym-31	1864/tcp	0.000684
canocentral0	1871/tcp	0.000076	# Cano Central 0
canocentral0	1871/udp	0.000330	# Cano Central 0
fjmpjps	1873/udp	0.000330	# Fjmpjps
westell-stats	1875/tcp	0.000152	# westell stats
westell-stats	1875/udp	0.000330	# westell stats
ibm-mqisdp	1883/udp	0.000330	# IBM MQSeries SCADA
idmaps	1884/udp	0.000661	# Internet Distance Map Svc
vrtstrapserver	1885/udp	0.003304	# Veritas Trap Server
leoip	1886/udp	0.002973	# Leonardo over IP
ncconfig	1888/udp	0.000330	# NC Config Port
childkey-notif	1891/udp	0.000330	# ChildKey Notification
unknown	1895/udp	0.000330
cymtec-port	1898/udp	0.000330	# Cymtec secure management
upnp	1900/tcp	0.003977	# Universal PnP
upnp	1900/udp	0.136543	# Universal PnP
fjicl-tep-a	1901/tcp	0.000076	# Fujitsu ICL Terminal Emulator Program A
fjicl-tep-a	1901/udp	0.001982	# Fujitsu ICL Terminal Emulator Program A
tpmd	1906/udp	0.000330	# TPortMapperReq
global-wlink	1909/udp	0.000661	# Global World Link
mtp	1911/tcp	0.000076	# Starlight Networks Multimedia Transport Protocol
rhp-iibp	1912/tcp	0.000076
rhp-iibp	1912/udp	0.000330
elm-momentum	1914/tcp	0.000152	# Elm-Momentum
can-nds	1918/tcp	0.000076	# IBM Tivole Directory Service - NDS
noadmin	1921/udp	0.000661	# NoAdmin
tapestry	1922/udp	0.000330	# Tapestry
xiip	1924/tcp	0.000076	# XIIP
videte-cipc	1927/tcp	0.000076	# Videte CIPC Port
amdsched	1931/udp	0.000330	# AMD SCHED
rtmp	1935/tcp	0.001179	# Macromedia FlasComm Server
sentinelsrm	1947/tcp	0.000380	# SentinelSRM
sentinelsrm	1947/udp	0.000330	# SentinelSRM
ismaeasdaqtest	1950/udp	0.000330	# ISMA Easdaq Test
abr-api	1954/tcp	0.000076	# ABR-API (diskbridge)
unix-status	1957/udp	0.000330
dxadmind	1958/tcp	0.000076	# CA Administration Daemon
dxadmind	1958/udp	0.000330	# CA Administration Daemon
simp-all	1959/udp	0.000330	# SIMP Channel
biap-mp	1962/udp	0.000330	# BIAP-MP
slush	1966/udp	0.000330	# Slush
lipsinc	1968/udp	0.000330	# LIPSinc
netop-school	1971/tcp	0.000152	# NetOp School
intersys-cache	1972/tcp	0.000152	# Cache
dlsrap	1973/tcp	0.000076	# Data Link Switching Remote Access Protocol
drp	1974/tcp	0.000152	# DRP
tcoflashagent	1975/tcp	0.000076	# TCO Flash Agent
tcoregagent	1976/tcp	0.000076	# TCO Reg Agent
p2pq	1981/tcp	0.000076	# p2pQ
p2pq	1981/udp	0.000330	# p2pQ
bigbrother	1984/tcp	0.000201	# Big Brother monitoring server - www.bb4.com
bb	1984/udp	0.000330	# BB
licensedaemon	1986/tcp	0.000025	# cisco license management
licensedaemon	1986/udp	0.000544	# cisco license management
tr-rsrb-p1	1987/tcp	0.000013	# cisco RSRB Priority 1 port
tr-rsrb-p1	1987/udp	0.000675	# cisco RSRB Priority 1 port
tr-rsrb-p2	1988/tcp	0.000050	# cisco RSRB Priority 2 port
tr-rsrb-p2	1988/udp	0.000428	# cisco RSRB Priority 2 port
tr-rsrb-p3	1989/tcp	0.000075	# cisco RSRB Priority 3 port
tr-rsrb-p3	1989/udp	0.000313	# cisco RSRB Priority 3 port
stun-p1	1990/tcp	0.000025	# cisco STUN Priority 1 port
stun-p1	1990/udp	0.000494	# cisco STUN Priority 1 port
stun-p2	1991/tcp	0.000050	# cisco STUN Priority 2 port
stun-p2	1991/udp	0.000428	# cisco STUN Priority 2 port
stun-p3	1992/tcp	0.000025	# cisco STUN Priority 3 port
stun-p3	1992/udp	0.000478	# cisco STUN Priority 3 port
snmp-tcp-port	1993/tcp	0.000013	# cisco SNMP TCP port
snmp-tcp-port	1993/udp	0.001779	# cisco SNMP TCP port
stun-port	1994/tcp	0.000025	# cisco serial tunnel port
stun-port	1994/udp	0.000313	# cisco serial tunnel port
perf-port	1995/tcp	0.000038	# cisco perf port
perf-port	1995/udp	0.000577	# cisco perf port
tr-rsrb-port	1996/tcp	0.000038	# cisco Remote SRB port
tr-rsrb-port	1996/udp	0.000626	# cisco Remote SRB port
gdp-port	1997/tcp	0.000038	# cisco Gateway Discovery Protocol
gdp-port	1997/udp	0.000494	# cisco Gateway Discovery Protocol
x25-svc-port	1998/tcp	0.001731	# cisco X.25 service (XOT)
x25-svc-port	1998/udp	0.000610	# cisco X.25 service (XOT)
tcp-id-port	1999/tcp	0.000364	# cisco identification port
tcp-id-port	1999/udp	0.000923	# cisco identification port
cisco-sccp	2000/tcp	0.010112	# cisco SCCP (Skinny Client Control Protocol)
cisco-sccp	2000/udp	0.011697	# cisco SCCP (Skinny Client Control Protocol)
dc	2001/tcp	0.007339	# or nfr20 web queries
wizard	2001/udp	0.001186	# curry
globe	2002/tcp	0.001744
globe	2002/udp	0.003740
finger	2003/tcp	0.001179	# GNU finger (cfingerd)
mailbox	2004/tcp	0.001016
emce	2004/udp	0.000988	# CCWS mm conf
deslogin	2005/tcp	0.001731	# encrypted symmetric telnet/login
oracle	2005/udp	0.000494
invokator	2006/tcp	0.001066
raid-cc	2006/udp	0.000675	# raid
dectalk	2007/tcp	0.000878
raid-am	2007/udp	0.000593
conf	2008/tcp	0.000903
terminaldb	2008/udp	0.000593
news	2009/tcp	0.000841
whosockami	2009/udp	0.000511
search	2010/tcp	0.000803	# Or nfr411
pipe_server	2010/udp	0.000560	# Also used by NFR
raid-cc	2011/tcp	0.000113	# raid
servserv	2011/udp	0.000445
ttyinfo	2012/tcp	0.000151
raid-ac	2012/udp	0.000873
raid-am	2013/tcp	0.000176
raid-cd	2013/udp	0.000659
troff	2014/tcp	0.000050
raid-sf	2014/udp	0.000478
cypress	2015/tcp	0.000038
raid-cs	2015/udp	0.000362
bootserver	2016/tcp	0.000013
bootserver	2016/udp	0.000379
bootclient	2017/udp	0.000346
terminaldb	2018/tcp	0.000050
rellpack	2018/udp	0.000972
whosockami	2019/tcp	0.000013
about	2019/udp	0.000791
xinupageserver	2020/tcp	0.000364
xinupageserver	2020/udp	0.000577
servexec	2021/tcp	0.000289
xinuexpansion1	2021/udp	0.000478
down	2022/tcp	0.000226
xinuexpansion2	2022/udp	0.000593
xinuexpansion3	2023/tcp	0.000025
xinuexpansion3	2023/udp	0.000231
xinuexpansion4	2024/tcp	0.000050
xinuexpansion4	2024/udp	0.000511
ellpack	2025/tcp	0.000100
xribs	2025/udp	0.000494
scrabble	2026/tcp	0.000038
scrabble	2026/udp	0.000824
shadowserver	2027/tcp	0.000025
shadowserver	2027/udp	0.000395
submitserver	2028/tcp	0.000013
submitserver	2028/udp	0.000445
device2	2030/tcp	0.000514
device2	2030/udp	0.000412
mobrien-chat	2031/tcp	0.000076
blackboard	2032/udp	0.000840
glogger	2033/tcp	0.000339
glogger	2033/udp	0.000560
scoremgr	2034/tcp	0.000238
scoremgr	2034/udp	0.000544
imsldoc	2035/tcp	0.000188
imsldoc	2035/udp	0.000527
e-dpnet	2036/udp	0.000330	# Ethernet WS DP network
objectmanager	2038/tcp	0.000201
objectmanager	2038/udp	0.000626
lam	2040/tcp	0.000276
lam	2040/udp	0.000725
interbase	2041/tcp	0.000213
interbase	2041/udp	0.000428
isis	2042/tcp	0.000163
isis	2042/udp	0.000379
isis-bcast	2043/tcp	0.000176
isis-bcast	2043/udp	0.000494
rimsl	2044/tcp	0.000138
rimsl	2044/udp	0.000560
cdfunc	2045/tcp	0.000163
cdfunc	2045/udp	0.000857
sdfunc	2046/tcp	0.000188
sdfunc	2046/udp	0.000511
dls	2047/tcp	0.000176
dls	2047/udp	0.000478
dls-monitor	2048/tcp	0.000263
dls-monitor	2048/udp	0.021549
nfs	2049/sctp	0.000000	# Network File System
nfs	2049/tcp	0.006110	# networked file system
nfs	2049/udp	0.044531	# networked file system
epnsdp	2051/udp	0.002643	# EPNSDP
knetd	2053/tcp	0.000025
lot105-ds-upd	2053/udp	0.000991	# Lot105 DSuper Updates
weblogin	2054/udp	0.000661	# Weblogin Port
iop	2055/udp	0.000661	# Iliad-Odyssey Protocol
newwavesearch	2058/udp	0.000661	# NewWaveSearchables RMI
bmc-messaging	2059/udp	0.000330	# BMC Messaging Service
teleniumdaemon	2060/udp	0.000661	# Telenium Daemon IF
netmount	2061/udp	0.000661	# NetMount
icg-swp	2062/tcp	0.000076	# ICG SWP Port
icg-swp	2062/udp	0.000661	# ICG SWP Port
dnet-keyproxy	2064/tcp	0.000038	# A closed-source client for solving the RSA cryptographic challenge. This is the keyblock proxy port.
dlsrpn	2065/tcp	0.000815	# Data Link Switch Read Port Number
dlsrpn	2065/udp	0.000511	# Data Link Switch Read Port Number
dlswpn	2067/tcp	0.000113	# Data Link Switch Write Port Number
dlswpn	2067/udp	0.001005	# Data Link Switch Write Port Number
avocentkvm	2068/tcp	0.000201	# Avocent KVM Server
event-port	2069/tcp	0.000076	# HTTP Event Port
ah-esp-encap	2070/tcp	0.000076	# AH and ESP Encapsulated in UDP packet
ah-esp-encap	2070/udp	0.000330	# AH and ESP Encapsulated in UDP packet
newlixengine	2075/udp	0.000330	# Newlix ServerWare Engine
newlixconfig	2076/udp	0.000330	# Newlix JSPConfig
tsrmagt	2077/udp	0.000330	# Old Tivoli Storage Manager
tpcsrvr	2078/udp	0.000661	# IBM Total Productivity Center Server
autodesk-nlm	2080/tcp	0.000076	# Autodesk NLM (FLEXlm)
autodesk-nlm	2080/udp	0.000330	# Autodesk NLM (FLEXlm)
kme-trap-port	2081/tcp	0.000076	# KME PRINTER TRAP PORT
infowave	2082/tcp	0.000076	# Infowave Mobility Server
infowave	2082/udp	0.000330	# Infowave Mobiltiy Server
radsec	2083/tcp	0.000076	# Secure Radius Service
radsec	2083/udp	0.000661	# Secure Radius Service
gnunet	2086/tcp	0.000076	# GNUnet
gnunet	2086/udp	0.000330	# GNUnet
eli	2087/tcp	0.000076	# ELI - Event Logging Integration
nbx-cc	2093/udp	0.000330	# NBX CC
nbx-ser	2095/tcp	0.000076	# NBX SER
nbx-dir	2096/tcp	0.000076	# NBX DIR
h2250-annex-g	2099/tcp	0.000152	# H.225.0 Annex G
amiganetfs	2100/tcp	0.000380	# Amiga Network Filesystem
rtcm-sc104	2101/tcp	0.000076
rtcm-sc104	2101/udp	0.000991
zephyr-srv	2102/udp	0.000330	# Zephyr server
zephyr-clt	2103/tcp	0.002661	# Zephyr serv-hm connection
zephyr-clt	2103/udp	0.000758	# Zephyr serv-hm connection
zephyr-hm	2104/tcp	0.000076	# Zephyr hostmanager
zephyr-hm	2104/udp	0.000478	# Zephyr hostmanager
eklogin	2105/tcp	0.002120	# Kerberos (v4) encrypted rlogin
eklogin	2105/udp	0.000544	# Kerberos (v4) encrypted rlogin
ekshell	2106/tcp	0.000238	# Kerberos (v4) encrypted rshell
ekshell	2106/udp	0.000972	# Kerberos (v4) encrypted rshell
msmq-mgmt	2107/tcp	0.002737	# Microsoft Message Queuing (IANA calls this bintec-admin)
rkinit	2108/tcp	0.000013	# Kerberos (v4) remote initialization
rkinit	2108/udp	0.000593	# Kerberos (v4) remote initialization
kx	2111/tcp	0.000263	# X over kerberos
dsatp	2111/udp	0.000330	# DSATP
kip	2112/tcp	0.000088	# IP over kerberos
kdm	2115/tcp	0.000076	# Key Distribution Manager
gsigatekeeper	2119/tcp	0.000380	# GSIGATEKEEPER
gsigatekeeper	2119/udp	0.000330	# GSIGATEKEEPER
kauth	2120/tcp	0.000050	# Remote kauth
ccproxy-ftp	2121/tcp	0.005834	# CCProxy FTP Proxy
scientia-ssdb	2121/udp	0.000661	# SCIENTIA-SSDB
gtp-control	2123/udp	0.000661	# GTP-Control Plane (3GPP)
elatelink	2124/tcp	0.000076	# ELATELINK
pktcable-cops	2126/tcp	0.000304	# PktCable-COPS
pktcable-cops	2126/udp	0.000330	# PktCable-COPS
index-pc-wb	2127/udp	0.000330	# INDEX-PC-WB
cs-live	2129/udp	0.000661	# cs-live.com
avantageb2b	2131/udp	0.000330	# Avantageb2b
avenue	2134/tcp	0.000076	# AVENUE
gris	2135/tcp	0.000380	# Grid Resource Information Server
appworxsrv	2136/udp	0.000330	# APPWORXSRV
unbind-cluster	2138/udp	0.000330	# UNBIND-CLUSTER
ias-reg	2140/udp	0.000661	# IAS-REG
tdmoip	2142/tcp	0.000076	# TDM OVER IP
lv-ffx	2144/tcp	0.000380	# Live Vault Fast Object Transfer
lv-ffx	2144/udp	0.000330	# Live Vault Fast Object Transfer
veritas-ucl	2148/tcp	0.000076	# Veritas Universal Communication Layer
veritas-ucl	2148/udp	0.005946	# Veritas Universal Communication Layer
dynamic3d	2150/tcp	0.000076	# DYNAMIC3D
touchnetplus	2158/udp	0.000661	# TouchNetPlus Service
apc-2160	2160/tcp	0.000380	# APC 2160
apc-2160	2160/udp	0.001982	# APC 2160
apc-agent	2161/tcp	0.001521	# American Power Conversion
apc-2161	2161/udp	0.001321	# APC 2161
navisphere	2162/udp	0.000330	# Navisphere
ddns-v3	2164/udp	0.000991	# Dynamic DNS Version 3
easy-soft-mux	2168/udp	0.000661	# easy-soft Multiplexer
brain	2169/udp	0.000330	# Backbone for Academic Information Notification (BRAIN)
eyetv	2170/tcp	0.000152	# EyeTV Server Port
eyetv	2170/udp	0.000330	# EyeTV Server Port
vmrdp	2179/tcp	0.000304	# Microsoft RDP for virtual machines
cgn-stat	2182/udp	0.000330	# CGN status
onbase-dds	2185/udp	0.000330	# OnBase Distributed Disk Services
ssmc	2187/tcp	0.000076	# Sepehr System Management Control
tivoconnect	2190/tcp	0.000380	# TiVoConnect Beacon
tvbus	2191/tcp	0.000304	# TvBus Messaging
tvbus	2191/udp	0.000330	# TvBus Messaging
unknown	2196/tcp	0.000152
mnp-exchange	2197/tcp	0.000076	# MNP data exchange
ici	2200/tcp	0.000152	# ICI
ici	2200/udp	0.000330	# ICI
ats	2201/tcp	0.000100	# Advanced Training System Program
ats	2201/udp	0.000577	# Advanced Training System Program
b2-runtime	2203/tcp	0.000076	# b2 Runtime Protocol
rpi	2214/udp	0.000330	# RDQ Protocol Interface
ipcore	2215/udp	0.000661	# IPCore.co.za GPRS
gotodevice	2217/udp	0.000330	# GoToDevice Device Management
rockwell-csp1	2221/udp	0.000330	# Rockwell CSP1
EtherNetIP-1	2222/tcp	0.000608	# EtherNet/IP I/O
msantipiracy	2222/udp	0.047902	# Microsoft Office OS X antipiracy network monitor
rockwell-csp2	2223/udp	0.010902	# Rockwell CSP2
efi-mg	2224/tcp	0.000076	# Easy Flexible Internet/Multiplayer Games
rcip-itu	2225/sctp	0.000000	# Resource Connection Initiation Protocol
di-drm	2226/udp	0.000330	# Digital Instinct DRM
ivs-video	2232/tcp	0.000151	# IVS Video default
ivs-video	2232/udp	0.000626	# IVS Video default
optech-port1-lm	2237/udp	0.000330	# Optech Port1 License Manager
imagequery	2239/udp	0.000330	# Image Query
recipe	2240/udp	0.000330	# RECIPe
ivsd	2241/tcp	0.000151	# IVS Daemon
ivsd	2241/udp	0.000659	# IVS Daemon
nmsserver	2244/udp	0.000330	# NMS Server
hao	2245/udp	0.000330	# HaO
pc-mta-addrmap	2246/udp	0.000330	# PacketCable MTA Addr Map
antidotemgrsvr	2247/udp	0.000330	# Antidote Deployment Manager Service
rfmp	2249/udp	0.000330	# RISO File Manager Protocol
remote-collab	2250/tcp	0.000076
dif-port	2251/tcp	0.000304	# Distributed Framework Port
dif-port	2251/udp	0.000330	# Distributed Framework Port
dtv-chan-req	2253/tcp	0.000076	# DTV Channel Request
rcts	2258/udp	0.000330	# Rotorcraft Communications Test System
apc-2260	2260/tcp	0.000380	# APC 2260
comotionmaster	2261/tcp	0.000076	# CoMotion Master Server
comotionback	2262/tcp	0.000076	# CoMotion Backup Server
comotionback	2262/udp	0.000330	# CoMotion Backup Server
apx500api-1	2264/udp	0.000330	# Audio Precision Apx500 API Port 1
apx500api-2	2265/tcp	0.000076	# Audio Precision Apx500 API Port 2
apx500api-2	2265/udp	0.000330	# Audio Precision Apx500 API Port 2
mfserver	2266/udp	0.000330	# M-files Server
mikey	2269/tcp	0.000076	# MIKEY
mikey	2269/udp	0.000330	# MIKEY
starschool	2270/tcp	0.000076	# starSchool
starschool	2270/udp	0.000330	# starSchool
mmcals	2271/tcp	0.000076	# Secure Meeting Maker Scheduling
mysql-im	2273/udp	0.000330	# MySQL Instance Manager
xmquery	2279/udp	0.000330
lnvpoller	2280/tcp	0.000076	# LNVPOLLER
lnvstatus	2283/udp	0.000330	# LNVSTATUS
netml	2288/tcp	0.000152	# NETML
eapsp	2291/tcp	0.000076	# EPSON Advanced Printer Share Protocol
mib-streaming	2292/tcp	0.000076	# Sonus Element Management Services
mib-streaming	2292/udp	0.000330	# Sonus Element Management Services
cvmmon	2300/tcp	0.000076	# CVMMON
compaqdiag	2301/tcp	0.001242	# Compaq remote diagnostic/management
cpq-wbem	2301/udp	0.000330	# Compaq HTTP
binderysupport	2302/tcp	0.000076	# Bindery Support
binderysupport	2302/udp	0.000661	# Bindery Support
attachmate-uts	2304/tcp	0.000076	# Attachmate UTS
pehelp	2307/tcp	0.000050
pehelp	2307/udp	0.000659
wanscaler	2312/tcp	0.000076	# WANScaler Communication Service
iapp	2313/tcp	0.000076	# IAPP (Inter Access Point Protocol)
attachmate-g32	2317/udp	0.000330	# Attachmate G32
infolibria	2319/udp	0.000330	# InfoLibria
siebel-ns	2320/udp	0.000330	# Siebel NS
3d-nfsd	2323/tcp	0.000228
cosmocall	2324/udp	0.000330	# Cosmocall
ansysli	2325/tcp	0.000076	# ANSYS Licensing Interconnect
idcp	2326/tcp	0.000076	# IDCP
idcp	2326/udp	0.000330	# IDCP
xingcsm	2327/udp	0.000330
netrix-sftm	2328/udp	0.000330	# Netrix SFTM
tscchat	2330/tcp	0.000076	# TSCCHAT
tscchat	2330/udp	0.000330	# TSCCHAT
rcc-host	2332/udp	0.000330	# RCC Host
ace-client	2334/udp	0.000330	# ACE Client Auth
ace-proxy	2335/tcp	0.000076	# ACE Proxy
ace-proxy	2335/udp	0.000330	# ACE Proxy
wrs_registry	2340/tcp	0.000076	# WRS Registry
wrs_registry	2340/udp	0.000330	# WRS Registry
manage-exec	2342/udp	0.000330	# Seagate Manage Exec
nati-logos	2343/udp	0.001652	# nati logos
dbm	2345/udp	0.001321
pslserver	2352/udp	0.000330
nexstorindltd	2360/udp	0.000330	# NexstorIndLtd
digiman	2362/udp	0.001321
oi-2000	2364/udp	0.000330	# OI-2000
qip-login	2366/tcp	0.000152
opentable	2368/udp	0.000661	# OpenTable
unknown	2369/udp	0.000330
worldwire	2371/tcp	0.000076	# Compaq WorldWire Port
worldwire	2371/udp	0.000330	# Compaq WorldWire Port
lanmessenger	2372/tcp	0.000076	# LanMessenger
lanmessenger	2372/udp	0.000330	# LanMessenger
docker	2375/tcp	0.000076	# docker.com
docker	2376/tcp	0.000076	# docker.com
unknown	2377/udp	0.000330
unknown	2379/udp	0.000330
unknown	2380/udp	0.000330
compaq-https	2381/tcp	0.000380	# Compaq HTTPS
ms-olap3	2382/tcp	0.000152
ms-olap3	2382/udp	0.000661	# Microsoft OLAP
ms-olap4	2383/tcp	0.001369	# MS OLAP 4
virtualtape	2386/udp	0.000330	# Virtual Tape
vsamredirector	2387/udp	0.000661	# VSAM Redirector
3com-net-mgmt	2391/tcp	0.000076	# 3COM Net Management
tacticalauth	2392/udp	0.000330	# Tactical Auth
ms-olap1	2393/tcp	0.000228	# SQL Server Downlevel OLAP Client Support
ms-olap2	2394/tcp	0.000228	# SQL Server Downlevel OLAP Client Support
lan900_remote	2395/udp	0.000330	# LAN900 Remote
orbiter	2398/udp	0.000661	# Orbiter
fmpro-fdal	2399/tcp	0.000380	# FileMaker, Inc. - Data Access Layer
cvspserver	2401/tcp	0.001480	# CVS network server
cvspserver	2401/udp	0.000544	# CVS network server
jediserver	2406/udp	0.000330	# JediServer
cdn	2412/udp	0.000330	# CDN
composit-server	2417/udp	0.000330	# Composit Server
cas	2418/tcp	0.000076
cas	2418/udp	0.000330
fjitsuappmgr	2425/tcp	0.000076	# Fujitsu App Manager
mgcp-gateway	2427/sctp	0.000000
ft-role	2429/udp	0.000330	# FT-ROLE
venus	2430/tcp	0.000050
venus	2430/udp	0.000478
venus-se	2431/tcp	0.000025
venus-se	2431/udp	0.000840
codasrv	2432/tcp	0.000025
codasrv	2432/udp	0.000560
codasrv-se	2433/tcp	0.000125
codasrv-se	2433/udp	0.000395
optilogic	2435/tcp	0.000076	# OptiLogic
topx	2436/tcp	0.000076	# TOP/X
msp	2438/tcp	0.000076	# MSP
sybasedbsynch	2439/tcp	0.000076	# SybaseDBSynch
dtn1	2445/udp	0.000330	# DTN1
ratl	2449/tcp	0.000076	# RATL
altav-remmgt	2456/tcp	0.000076
rapido-ip	2457/udp	0.000330	# Rapido_IP
lsi-raid-mgmt	2463/tcp	0.000076	# LSI RAID Management
lsi-raid-mgmt	2463/udp	0.000330	# LSI RAID Management
c3	2472/tcp	0.000076	# C3
vitalanalysis	2474/udp	0.000330	# Vital Analysis
pns	2487/udp	0.000330	# Policy Notice Service
tsilb	2489/udp	0.000330	# TSILB
groove	2492/tcp	0.000380	# GROOVE
groove	2492/udp	0.000330	# GROOVE
bmc-ar	2494/udp	0.000330	# BMC AR
dirgis	2496/udp	0.000661	# DIRGIS
rtsserv	2500/tcp	0.000464	# Resource Tracking system server
rtsserv	2500/udp	0.000511	# Resource Tracking system server
rtsclient	2501/tcp	0.000151	# Resource Tracking system client
rtsclient	2501/udp	0.000461	# Resource Tracking system client
nms-dpnss	2503/udp	0.000330	# NMS-DPNSS
ppcontrol	2505/tcp	0.000076	# PowerPlay Control
ppcontrol	2505/udp	0.000330	# PowerPlay Control
fjmpss	2509/udp	0.000330
fjappmgrbulk	2510/udp	0.000330
citrixima	2512/udp	0.000330	# Citrix IMA
facsys-router	2515/udp	0.000330	# Facsys Router
call-sig-trans	2517/udp	0.000661	# H.323 Annex E call signaling transport
windb	2522/tcp	0.000304	# WinDb
optiwave-lm	2524/udp	0.000330	# Optiwave License Management
ms-v-worlds	2525/tcp	0.000456	# MS V-Worlds
iqserver	2527/udp	0.000330	# IQ Server
ncr_ccl	2528/udp	0.000661	# NCR CCL
ito-e-gui	2531/tcp	0.000076	# ITO-E GUI
ovtopmd	2532/tcp	0.000076	# OVTOPMD
snifferserver	2533/udp	0.000330	# SnifferServer
vnwk-prapi	2538/udp	0.000330
vsiadmin	2539/udp	0.000330	# VSI Admin
udrawgraph	2542/udp	0.000330	# uDraw(Graph)
reftek	2543/udp	0.000330	# REFTEK
vytalvaultbrtp	2546/udp	0.000330
ads	2550/tcp	0.000076	# ADS
isg-uda-server	2551/tcp	0.000076	# ISG UDA Server
call-logging	2552/udp	0.000330	# Call Logging
compaq-wcp	2555/udp	0.000330	# Compaq WCP
nicetec-mgmt	2557/tcp	0.000152
pclemultimedia	2558/tcp	0.000076	# PCLE Multi Media
lstp	2559/udp	0.000330	# LSTP
hp-3000-telnet	2564/tcp	0.000013	# HP 3000 NS/VT block mode telnet
clp	2567/tcp	0.000076	# Cisco Line Protocol
tributary	2580/tcp	0.000076	# Tributary
argis-ds	2582/udp	0.000330	# ARGIS DS
mon	2583/tcp	0.000076	# MON
cyaserv	2584/tcp	0.000076
quartus-tcl	2589/udp	0.000330	# quartus tcl
netrek	2592/udp	0.000330
citriximaclient	2598/tcp	0.000076	# Citrix MA Client
zebrasrv	2600/tcp	0.000088	# zebra service
hpstgmgr	2600/udp	0.000330	# HPSTGMGR
zebra	2601/tcp	0.002032	# zebra vty
ripd	2602/tcp	0.000790	# RIPd vty
servicemeter	2603/udp	0.000330	# Service Meter
ospfd	2604/tcp	0.000765	# OSPFd vty
bgpd	2605/tcp	0.000514	# BGPd vty
netmon	2606/tcp	0.000076	# Dell Netmon
connection	2607/tcp	0.000380	# Dell Connection
wag-service	2608/tcp	0.000228	# Wag Service
qpasa-agent	2612/udp	0.000330	# Qpasa Agent
smntubootstrap	2613/udp	0.000330	# SMNTUBootstrap
firepower	2615/udp	0.000330
priority-e-com	2618/udp	0.000330	# Priority E-Com
metricadbc	2622/tcp	0.000076	# MetricaDBC
lmdp	2623/tcp	0.000076	# LMDP
blwnkl-port	2625/udp	0.000330	# Blwnkl Port
webster	2627/tcp	0.000025	# Network dictionary
webster	2627/udp	0.000692
dict	2628/tcp	0.000125	# Dictionary service (RFC2229)
sitaraserver	2629/udp	0.000330	# Sitara Server
sitaradir	2631/tcp	0.000076	# Sitara Dir
pk-electronics	2634/udp	0.000330	# PK Electronics
backburner	2635/udp	0.000330	# Back Burner
sybase	2638/tcp	0.000251	# Sybase database
sybaseanywhere	2638/udp	0.000330	# Sybase Anywhere
hdl-srv	2641/udp	0.000330	# HDL Server
travsoft-ipx-t	2644/tcp	0.000076	# Travsoft IPX Tunnel
and-lm	2646/udp	0.000330	# AND License Manager
vpsipport	2649/udp	0.000330	# VPSIPPORT
sns-dispatcher	2657/udp	0.000330	# SNS Dispatcher
bintec-capi	2662/udp	0.000330	# BinTec-CAPI
patrol-mq-gm	2664/udp	0.000330	# Patrol for MQ GM
extensis	2666/udp	0.000330
alarm-clock-s	2667/udp	0.000330	# Alarm Clock Server
firstcall42	2673/udp	0.000330	# First Call 42
gadgetgate1way	2677/udp	0.000330	# Gadget Gate 1 Way
gadgetgate2way	2678/udp	0.000330	# Gadget Gate 2 Way
itinternet	2691/tcp	0.000076	# ITInternet ISM Server
admins-lms	2692/udp	0.000330	# Admins LMS
vspread	2695/udp	0.000330	# VSPREAD
tqdata	2700/tcp	0.000076
sms-rcinfo	2701/tcp	0.000836
sms-xfer	2702/tcp	0.000760
sms-remctrl	2704/udp	0.000330	# SMS REMCTRL
sds-admin	2705/udp	0.000330	# SDS Admin
ncdmirroring	2706/tcp	0.000076	# NCD Mirroring
banyan-net	2708/udp	0.000330	# Banyan-Net
supermon	2709/udp	0.000330	# Supermon
sso-service	2710/tcp	0.000152	# SSO Service
sso-control	2711/tcp	0.000076	# SSO Control
aocp	2712/tcp	0.000076	# Axapta Object Communication Protocol
pn-requester	2717/tcp	0.003345	# PN REQUESTER
pn-requester2	2718/tcp	0.000380	# PN REQUESTER 2
scan-change	2719/udp	0.000330	# Scan & Change
wkars	2720/udp	0.000330
watchdog-nt	2723/tcp	0.000076	# WatchDog NT Protocol
msolap-ptp2	2725/tcp	0.000228	# SQL Analysis Server
tams	2726/udp	0.000330	# TAMS
sqdr	2728/tcp	0.000076	# SQDR
ccs-software	2734/tcp	0.000076	# CCS Software
ccs-software	2734/udp	0.000330	# CCS Software
srp-feedback	2737/udp	0.000330	# SRP Feedback
tn-timing	2739/udp	0.000330	# TN Timing
fjippol-cnsl	2749/udp	0.000330
qip-audup	2765/udp	0.000330
listen	2766/tcp	0.000013	# System V listener port
uadtc	2767/udp	0.000330	# UADTC
vergencecm	2771/udp	0.000330	# Vergence CM
rbakcup1	2773/udp	0.000330	# RBackup Remote Backup
ridgeway2	2777/udp	0.000330	# Ridgeway Systems & Software
whosells	2781/udp	0.000330
www-dev	2784/udp	0.000395	# world wide web - development
media-agent	2789/udp	0.000330	# Media Agent
mtport-regist	2791/udp	0.000330	# MT Port Registrator
esp-encap	2797/udp	0.000330
acc-raid	2800/tcp	0.000152	# ACC RAID
igcp	2801/udp	0.000330	# IGCP
btprjctrl	2803/udp	0.000330
dvr-esm	2804/tcp	0.000076	# March Networks Digital Video Recorders and Enterprise Service Manager products
dvr-esm	2804/udp	0.000330	# March Networks Digital Video Recorders and Enterprise Service Manager products
cspuni	2806/tcp	0.000076
corbaloc	2809/tcp	0.000439	# Corba
gsiftp	2811/tcp	0.000380	# GSI FTP
atmtcp	2812/tcp	0.000076	# commonly Monit httpd - http://mmonit.com/monit/documentation/monit.html#monit_httpd
llm-pass	2813/udp	0.000330
fc-faultnotify	2819/udp	0.000661	# FC Fault Notification
vrts-at-port	2821/udp	0.000661	# VERITAS Authentication Service
cqg-netlan-1	2824/udp	0.000330	# CQG Net/Lan 1
slc-systemlog	2826/udp	0.000330	# slc systemlog
silkp3	2831/udp	0.000330
repliweb	2837/udp	0.000330	# Repliweb
aimpp-port-req	2847/tcp	0.000076	# AIMPP Port Req
aimpp-port-req	2847/udp	0.000330	# AIMPP Port Req
metaconsole	2850/tcp	0.000076	# MetaConsole
msrp	2855/udp	0.000330	# MSRP
dialpad-voice1	2860/udp	0.000330	# Dialpad Voice 1
sonardata	2863/udp	0.000991	# Sonar Data
astromed-main	2864/udp	0.000330	# main 5001 cmd
pit-vpn	2865/udp	0.000330
icslap	2869/tcp	0.002129	# Universal Plug and Play Device Host, SSDP Discovery Service
icslap	2869/udp	0.000330	# ICSLAP
unknown	2873/udp	0.000330
dxmessagebase1	2874/udp	0.000330	# DX Message Base Transport Protocol
dxmessagebase2	2875/tcp	0.000380	# DX Message Base Transport Protocol
bluelance	2877/udp	0.000330	# BLUELANCE
aap	2878/udp	0.000330	# AAP
synapse	2880/udp	0.000330	# Synapse Transport
ndsp	2881/udp	0.000330	# NDSP
ndtp	2882/tcp	0.000076	# NDTP
ndnp	2883/udp	0.000330	# NDNP
flashmsg	2884/udp	0.000330	# Flash Msg
topflow	2885/udp	0.000330	# TopFlow
spcsdlobby	2888/tcp	0.000076	# SPCSDLOBBY
rsom	2889/tcp	0.000076	# RSOM
rsom	2889/udp	0.000330	# RSOM
appliance-cfg	2898/tcp	0.000076	# APPLIANCE-CFG
appliance-cfg	2898/udp	0.000330	# APPLIANCE-CFG
allstorcns	2901/tcp	0.000076	# ALLSTORCNS
allstorcns	2901/udp	0.000330	# ALLSTORCNS
netaspi	2902/tcp	0.000076	# NET ASPI
extensisportfolio	2903/tcp	0.000100	# Portfolio Server by Extensis Product Group
suitcase	2903/udp	0.000330	# SUITCASE
m2ua	2904/sctp	0.000000	# SIGTRAN M2UA
m2ua	2904/udp	0.000330	# SIGTRAN M2UA
m3ua	2905/sctp	0.000000	# SIGTRAN M3UA
mao	2908/tcp	0.000076
mao	2908/udp	0.000661
funk-dialout	2909/tcp	0.000228	# Funk Dialout
funk-dialout	2909/udp	0.000330	# Funk Dialout
tdaccess	2910/tcp	0.000152	# TDAccess
tdaccess	2910/udp	0.000330	# TDAccess
elvin_server	2916/udp	0.000330	# Elvin Server
roboer	2919/udp	0.000330	# roboER
roboeda	2920/tcp	0.000152	# roboEDA
redstone-cpss	2928/udp	0.000330	# REDSTONE-CPSS
amx-weblinx	2930/tcp	0.000076	# AMX-WEBLINX
incp	2932/udp	0.000330	# INCP
sm-pas-3	2940/udp	0.000330	# SM-PAS-3
megaco-h248	2944/sctp	0.000000	# Megaco H-248 (Text)
megaco-h248	2944/udp	0.000330	# Megaco H-248 (Text)
h248-binary	2945/sctp	0.000000	# Megaco H-248 (Binary)
wap-push	2948/udp	0.000791	# Windows Mobile devices often have this
esip	2950/udp	0.000330	# ESIP
ottp	2951/udp	0.000330	# OTTP
ovrimosdbman	2956/udp	0.000330	# OVRIMOSDBMAN
jmact5	2957/tcp	0.000076	# JAMCT5
jmact6	2958/tcp	0.000076	# JAMCT6
bullant-srap	2964/udp	0.000330	# BULLANT SRAP
symantec-av	2967/tcp	0.002357	# Symantec AntiVirus (rtvscan.exe)
symantec-av	2967/udp	0.006425	# Symantec AntiVirus (rtvscan.exe)
enpp	2968/tcp	0.000152	# ENPP
essp	2969/udp	0.000330	# ESSP
index-net	2970/udp	0.000330	# INDEX-NET
pmsm-webrctl	2972/udp	0.000330	# PMSM Webrctl
svnetworks	2973/tcp	0.000076	# SV Networks
svnetworks	2973/udp	0.000991	# SV Networks
hpidsadmin	2984/tcp	0.000076	# HPIDSADMIN
identify	2987/tcp	0.000076
identify	2987/udp	0.000330
hippad	2988/tcp	0.000076	# HIPPA Reporting Protocol
wkstn-mon	2991/tcp	0.000076	# WKSTN-MON
veritas-vis2	2994/udp	0.000330	# VERITAS VIS2
vsixml	2996/udp	0.000330
rebol	2997/tcp	0.000076	# REBOL
iss-realsec	2998/tcp	0.000351	# ISS RealSecure IDS Remote Console Admin port
ppp	3000/tcp	0.004115	# User-level ppp daemon, or chili!soft asp
nessus	3001/tcp	0.003124	# Nessus Security Scanner (www.nessus.org) Daemon or chili!soft asp
unknown	3001/udp	0.000991
exlm-agent	3002/tcp	0.000076	# EXLM Agent
exlm-agent	3002/udp	0.000661	# EXLM Agent
cgms	3003/tcp	0.000228	# CGMS
cgms	3003/udp	0.000330	# CGMS
deslogin	3005/tcp	0.000477	# encrypted symmetric telnet/login
geniuslm	3005/udp	0.000330	# Genius License Manager
deslogind	3006/tcp	0.000263
lotusmtap	3007/tcp	0.000152	# Lotus Mail Tracking Agent Protocol
trusted-web	3011/tcp	0.000304	# Trusted Web
gilatskysurfer	3013/tcp	0.000152	# Gilat Sky Surfer
broker_service	3014/tcp	0.000076	# Broker Service
event_listener	3017/tcp	0.000380	# Event Listener
magicnotes	3023/tcp	0.000076
slnp	3025/tcp	0.000125	# SLNP (Simple Library Network Protocol) by Sisis Informationssysteme GmbH
arepa-cas	3030/tcp	0.000304	# Arepa Cas
arepa-cas	3030/udp	0.000330	# Arepa Cas
eppc	3031/tcp	0.000380	# Remote AppleEvents/PPC Toolbox
hagel-dump	3036/udp	0.000330	# Hagel DUMP
slnp	3045/tcp	0.000063	# SLNP (Simple Library Network Protocol) by Sisis Informationssysteme GmbH
di-ase	3046/udp	0.000330
pctrader	3048/udp	0.000661	# Sierra Net PC Trader
cfs	3049/tcp	0.000063	# cryptographic file system (nfs) (proposed)
cfs	3049/udp	0.000675	# cryptographic file system (nfs)
gds_db	3050/tcp	0.000152
gds_db	3050/udp	0.000330
powerchute	3052/tcp	0.000966
apc-3052	3052/udp	0.003304	# APC 3052
amt-cnf-prot	3054/udp	0.000661	# AMT CNF PROT
goahead-fldup	3057/tcp	0.000076	# GoAhead FldUp
interserver	3060/udp	0.000330
cautcpd	3061/udp	0.000330
ncacn-ip-tcp	3062/tcp	0.000076
ncadg-ip-udp	3063/tcp	0.000076
dnet-tstproxy	3064/tcp	0.000063	# distributed.net (a closed source crypto-cracking project) proxy test port
netattachsdmp	3066/udp	0.000330	# NETATTACHSDMP
fjhpjp	3067/udp	0.000330	# FJHPJP
csd-mgmt-port	3071/tcp	0.000380	# ContinuStor Manager Port
orbix-locator	3075/udp	0.000330	# Orbix 2000 Locator
orbix-config	3076/udp	0.000330	# Orbix 2000 Config
orbix-loc-ssl	3077/tcp	0.000304	# Orbix 2000 Locator SSL
stm_pproc	3080/tcp	0.000076
sj3	3086/tcp	0.000050	# SJ3 (kanji input)
ptk-alink	3089/tcp	0.000076	# ParaTek Agent Linking
rapidmq-reg	3094/udp	0.000661	# Jiiva RapidMQ Registry
itu-bicc-stc	3097/sctp	0.000000	# ITU-T Q.1902.1/Q.2150.3
chmd	3099/udp	0.000330	# CHIPSY Machine Daemon
slslavemon	3102/tcp	0.000076	# SoftlinK Slave Mon Port
slslavemon	3102/udp	0.000330	# SoftlinK Slave Mon Port
autocuesmi	3103/tcp	0.000076	# Autocue SMI Protocol
autocuetime	3104/udp	0.000330	# Autocue Time Service
sim-control	3110/udp	0.000330	# simulator control port
cs-auth-svr	3113/udp	0.000330	# CS-Authenticate Svr Port
pkagent	3118/tcp	0.000076	# PKAgent
d2000kernel	3119/tcp	0.000152	# D2000 Kernel Port
unknown	3121/tcp	0.000076
squid-http	3128/tcp	0.004516
squid-ipc	3130/udp	0.006656
netbookmark	3131/udp	0.000330	# Net Book Mark
vmodem	3141/tcp	0.000038
vmodem	3141/udp	0.000560
bears-02	3146/tcp	0.000076
rfio	3147/udp	0.000330	# RFIO
nm-game-admin	3148/udp	0.000330	# NetMike Game Administrator
indura	3156/udp	0.000330	# Indura Collector
tip-app-server	3160/udp	0.000330	# TIP Application Server
sflm	3162/tcp	0.000152	# SFLM
sflm	3162/udp	0.000661	# SFLM
newgenpay	3165/udp	0.000330	# Newgenpay Engine Service
nowcontact	3167/tcp	0.000076	# Now Contact Public Server
poweronnud	3168/tcp	0.000228	# Now Up-to-Date Public Server
serverview-as	3169/udp	0.000330	# SERVERVIEW-AS
serverview-asn	3170/udp	0.000330	# SERVERVIEW-ASN
serverview-icc	3173/udp	0.000330	# SERVERVIEW-ICC
h2gf-w-2m	3179/udp	0.000330	# H2GF W.2m Handover prot.
csvr-proxy	3190/tcp	0.000076	# ConServR Proxy
tick-port	3200/tcp	0.000076	# Press-sense Tick Port
cpq-tasksmart	3201/udp	0.000330	# CPQ-TaskSmart
netwatcher-mon	3203/udp	0.000330	# Network Watcher Monitor
flamenco-proxy	3210/tcp	0.000076	# Flamenco Networks Proxy
avsecuremgmt	3211/tcp	0.000380	# Avocent Secure Management
surveyinst	3212/udp	0.000330	# Survey Instrument
xnm-ssl	3220/tcp	0.000076	# XML NM over SSL
xnm-clear-text	3221/tcp	0.000228	# XML NM over TCP
dwmsgserver	3228/udp	0.000330	# DiamondWave MSG Server
whisker	3233/udp	0.000661	# WhiskerControl main port
mdap-port	3235/udp	0.000661	# MDAP Port
triomotion	3240/tcp	0.000076	# Trio Motion Control Port
vieo-fe	3245/udp	0.000330	# VIEO Fabric Executive
kademlia	3246/udp	0.000857	# Kademlia P2P (mlnet)
pda-sys	3254/udp	0.000330	# PDA System
cpqrpm-agent	3256/udp	0.000330	# Compaq RPM Agent Port
iscsi	3260/tcp	0.001064	# iSCSI
winshadow	3261/tcp	0.000304	# winShadow
ecolor-imager	3263/tcp	0.000076	# E-Color Enterprise Imager
ecolor-imager	3263/udp	0.000330	# E-Color Enterprise Imager
ccmail	3264/tcp	0.000038	# cc:mail/lotus
ccmail	3264/udp	0.000395	# cc:mail/lotus
altav-tunnel	3265/udp	0.000330	# Altav Tunnel
globalcatLDAP	3268/tcp	0.001229	# Global Catalog LDAP
globalcatLDAPssl	3269/tcp	0.001142	# Global Catalog LDAP over ssl
user-manager	3272/udp	0.000330	# Fujitsu User Manager
sxmp	3273/udp	0.000330	# Simple Extensible Multiplexed Protocol
lkcmserver	3278/udp	0.000330	# LKCM Server
admind	3279/udp	0.000330
vs-server	3280/tcp	0.000076	# VS Server
sysopt	3281/tcp	0.000076	# SYSOPT
netassistant	3283/tcp	0.000760	# Apple Remote Desktop Net Assistant reporting feature
netassistant	3283/udp	0.066072	# Apple Remote Desktop Net Assistant reporting feature
enpc	3289/udp	0.000330	# ENPC
sah-lm	3291/tcp	0.000076	# S A Holditch & Associates - LM
sah-lm	3291/udp	0.000330	# S A Holditch & Associates - LM
meetingmaker	3292/tcp	0.000038	# Meeting maker time management software
cart-o-rama	3292/udp	0.000330	# Cart O Rama
fg-fps	3293/udp	0.000330
rib-slm	3296/udp	0.001321	# Rib License Manager
saprouter	3299/tcp	0.000125	# SAProuter
unknown	3300/tcp	0.000380
unknown	3301/tcp	0.000380
unknown	3301/udp	0.000991
opsession-srvr	3304/tcp	0.000152	# OP Session Server
opsession-srvr	3304/udp	0.000661	# OP Session Server
mysql	3306/tcp	0.045390	# mySQL
opsession-prxy	3307/tcp	0.000152	# OP Session Proxy
dyna-access	3310/tcp	0.000076	# Dyna Access
mcns-tel-ret	3311/tcp	0.000076	# MCNS Tel Ret
cdid	3315/udp	0.000330	# CDID
sdt-lmd	3319/tcp	0.000076	# SDT License Manager
vnsstr	3321/udp	0.000330	# VNSSTR
active-net	3322/tcp	0.000228	# Active Networks
active-net	3323/tcp	0.000380	# Active Networks
active-net	3324/tcp	0.000228	# Active Networks
active-net	3325/tcp	0.000380	# Active Networks
mcs-messaging	3331/udp	0.000330	# MCS Messaging
dec-notes	3333/tcp	0.000790	# DEC Notes
dec-notes	3333/udp	0.000890	# DEC Notes
directv-web	3334/tcp	0.000076	# Direct TV Webcasting
directv-web	3334/udp	0.000330	# Direct TV Webcasting
directv-soft	3335/udp	0.000330	# Direct TV Software Updates
directv-catlg	3337/udp	0.000330	# Direct TV Data Catalog
anet-l	3339/udp	0.000330	# OMF data l
ms-cluster-net	3343/udp	0.001321	# MS Cluster Net
btrieve	3351/tcp	0.000380	# Btrieve port
suitjd	3354/udp	0.000330	# SUITJD
dj-ilm	3362/tcp	0.000076	# DJ ILM
dj-ilm	3362/udp	0.000330	# DJ ILM
nati-vi-server	3363/tcp	0.000076	# NATI Vi Server
nati-vi-server	3363/udp	0.000330	# NATI Vi Server
creativeserver	3364/udp	0.000661	# Creative Server
contentserver	3365/tcp	0.000076	# Content Server
creativepartnr	3366/udp	0.000330	# Creative Partner
satvid-datalnk	3367/tcp	0.000380	# Satellite Video Data Link
satvid-datalnk	3368/tcp	0.000076	# Satellite Video Data Link
satvid-datalnk	3368/udp	0.000330	# Satellite Video Data Link
satvid-datalnk	3369/tcp	0.000304	# Satellite Video Data Link
satvid-datalnk	3370/tcp	0.000304	# Satellite Video Data Link
satvid-datalnk	3371/tcp	0.000304	# Satellite Video Data Link
msdtc	3372/tcp	0.000339	# MS distributed transaction coordinator
tip2	3372/udp	0.000661	# TIP 2
cluster-disc	3374/tcp	0.000076	# Cluster Disc
cdbroker	3376/tcp	0.000152	# CD Broker
sns-channels	3380/udp	0.000330	# SNS Channels
geneous	3381/udp	0.000330	# Geneous
esp-lm	3383/udp	0.000330	# Enterprise Software Products License Manager
hp-clic	3384/udp	0.000330	# Hardware Management
gprs-sig	3386/udp	0.000330	# GPRS SIG
cbserver	3388/tcp	0.000076	# CB Server
cbserver	3388/udp	0.000330	# CB Server
ms-wbt-server	3389/tcp	0.083904	# Microsoft Remote Display Protocol (aka ms-term-serv, microsoft-rdp)
ms-wbt-server	3389/udp	0.004955	# Microsoft Remote Display Protocol (aka ms-term-serv, microsoft-rdp)
dsc	3390/tcp	0.000228	# Distributed Service Coordinator
savant	3391/udp	0.000330	# SAVANT
efi-lm	3392/udp	0.000330	# EFI License Management
printer_agent	3396/tcp	0.000076	# Printer Agent
printer_agent	3396/udp	0.000661	# Printer Agent
saposs	3397/tcp	0.000038	# SAP Oss
sapcomm	3398/tcp	0.000063	# SAPcomm
sapeps	3399/tcp	0.000100	# SAP EPS
csms	3399/udp	0.000330	# CSMS
csms2	3400/tcp	0.000152	# CSMS2
squid-snmp	3401/udp	0.002241	# Squid proxy SNMP port
unknown	3403/udp	0.000991
unknown	3404/tcp	0.000380
nokia-ann-ch2	3406/udp	0.000330	# Nokia Announcement ch 2
BESApi	3408/udp	0.000330	# BES Api Port
networklenss	3410/tcp	0.000152	# NetworkLens SSL Event
wip-port	3414/tcp	0.000076	# BroadCloud WIP Port
bcinameservice	3415/tcp	0.000076	# BCI Name Service
softaudit	3419/tcp	0.000076	# Isogon SoftAudit
bmap	3421/tcp	0.000013	# Bull Apprise portmapper
bmap	3421/udp	0.000643	# Bull Apprise portmapper
rusb-sys-port	3422/udp	0.000330	# Remote USB System Port
xtrm	3423/udp	0.000330	# xTrade Reliable Messaging
agps-port	3425/tcp	0.000076	# AGPS Access Port
twcss	3428/udp	0.000330	# 2Wire CSS
gcsp	3429/udp	0.000330	# GCSP user port
ssdispatch	3430/tcp	0.000076	# Scott Studios Dispatch
hri-port	3439/tcp	0.000076	# HRI Interface Port
ans-console	3440/udp	0.000330	# Net Steward Mgmt Console
connect-server	3442/udp	0.000330	# OC Connect Server
ov-nnm-websrv	3443/tcp	0.000076	# OpenView Network Node Manager WEB Server
denali-server	3444/udp	0.000330	# Denali Server
3comfaxrpc	3446/udp	0.000330	# 3Com FAX RPC port
hotu-chat	3449/udp	0.000330	# HotU Chat
asam	3451/udp	0.000661	# ASAM Services
pscupd	3453/udp	0.000661	# PSC Update Port
prsvp	3455/udp	0.000527	# RSVP Port
vat	3456/tcp	0.000100	# VAT default data
IISrpc-or-vat	3456/udp	0.036607	# also VAT default data
vat-control	3457/tcp	0.000025	# VAT default control
vat-control	3457/udp	0.001433	# VAT default control
edm-std-notify	3462/udp	0.000330	# EDM STD Notify
rcst	3467/udp	0.000330	# RCST
ttntspauto	3474/udp	0.000330	# TSP Automation
nppmp	3476/tcp	0.000532	# NVIDIA Mgmt Protocol
ecomm	3477/udp	0.000661	# eComm link port
twrpc	3479/tcp	0.000076	# 2Wire RPC
plethora	3480/udp	0.000330	# Secure Virtual Workspace
vulture	3482/udp	0.000330	# Vulture Monitoring System
slim-devices	3483/tcp	0.000076	# Slim Devices Protocol
celatalk	3485/tcp	0.000076	# CelaTalk
ifsf-hb-port	3486/tcp	0.000076	# IFSF Heartbeat Port
ifsf-hb-port	3486/udp	0.000330	# IFSF Heartbeat Port
ltcudp	3487/udp	0.000330	# LISA UDP Transfer Channel
nut	3493/tcp	0.000304	# Network UPS Tools
seclayer-tcp	3495/udp	0.000661	# securitylayer over tcp
ipether232port	3497/tcp	0.000076	# ipEther232Port
sccip-media	3499/udp	0.000330	# SccIP Media
lsp-ping	3503/tcp	0.000076	# MPLS LSP-echo Port
lsp-ping	3503/udp	0.000330	# MPLS LSP-echo Port
ccmcomm	3505/tcp	0.000076	# CCM communications port
ccmcomm	3505/udp	0.000661	# CCM communications port
apc-3506	3506/tcp	0.000076	# APC 3506
apc-3506	3506/udp	0.000330	# APC 3506
nesh-broker	3507/udp	0.000330	# Nesh Broker Port
webmail-2	3511/tcp	0.000076	# WebMail/2
arcpd	3513/tcp	0.000076	# Adaptec Remote Protocol
arcpd	3513/udp	0.000330	# Adaptec Remote Protocol
must-p2p	3514/tcp	0.000152	# MUST Peer to Peer
must-backplane	3515/tcp	0.000076	# MUST Backplane
802-11-iapp	3517/tcp	0.000228	# IEEE 802.11 WLANs WG IAPP
802-11-iapp	3517/udp	0.000330	# IEEE 802.11 WLANs WG IAPP
nvmsgd	3519/tcp	0.000076	# Netvion Messenger Port
galileo	3519/udp	0.000661	# Netvion Galileo Port
galileolog	3520/tcp	0.000076	# Netvion Galileo Log Port
nssocketport	3522/udp	0.000330	# DO over NSSocketPort
starquiz-port	3526/tcp	0.000076	# starQuiz Port
beserver-msg-q	3527/tcp	0.000228	# VERITAS Backup Exec Server
beserver-msg-q	3527/udp	0.000991	# VERITAS Backup Exec Server
gf	3530/tcp	0.000076	# Grid Friendly
peerenabler	3531/tcp	0.000025	# P2PNetworking/PeerEnabler protocol
peerenabler	3531/udp	0.000890	# P2PNetworking/PeerEnabler protocol
raven-rmp	3532/tcp	0.000076	# Raven Remote Management Control
ni-visa-remote	3537/udp	0.000330	# Remote NI-VISA port
ibm-diradm	3538/udp	0.000330	# IBM Directory Server
teredo	3544/udp	0.000661	# Teredo Port
unknown	3546/tcp	0.000304
apcupsd	3551/tcp	0.000380	# Apcupsd Information Port
razor	3555/udp	0.000330	# Vipul's Razor
m2pa	3565/sctp	0.000000	# M2PA
mbg-ctrl	3569/udp	0.000991	# Meinberg Control Service
megardsvr-port	3571/udp	0.000330	# MegaRAID Server Port
tag-ups-1	3573/udp	0.000330	# Advantage Group UPS Suite
dmaf-caster	3574/udp	0.000991	# DMAF Caster
ccm-port	3575/udp	0.000330	# Coalsere CCM Port
config-port	3577/tcp	0.000076	# Configuration Port
nati-svrloc	3580/tcp	0.000380	# NATI-ServiceLocator
emprise-lsc	3586/tcp	0.000076	# License Server Console
gtrack-server	3591/udp	0.000330	# LOCANIS G-TRACK Server
mediaspace	3594/udp	0.000330	# MediaSpace
shareapp	3595/udp	0.000330	# ShareApp
quasar-server	3599/tcp	0.000076	# Quasar Accounting Server
trap-daemon	3600/tcp	0.000076	# text relay-answer
infiniswitchcl	3602/tcp	0.000076	# InfiniSwitch Mgr Client
int-rcv-cntrl	3603/tcp	0.000076	# Integrated Rcvr Control
int-rcv-cntrl	3603/udp	0.000330	# Integrated Rcvr Control
comcam-io	3605/udp	0.000330	# ComCam IO Port
splitlock	3606/udp	0.000330	# Splitlock Server
cpdi-pidas-cm	3609/udp	0.000330	# CPDI PIDAS Connection Mon
hp-dataprotect	3612/udp	0.000330	# HP Data Protector
sigma-port	3614/udp	0.000330	# Invensys Sigma Port
aairnet-2	3619/udp	0.000330	# AAIR-Network 2
ep-pcp	3620/udp	0.000330	# EPSON Projector Control Port
ep-nsp	3621/tcp	0.000076	# EPSON Network Screen Port
ff-lr-port	3622/tcp	0.000076	# FF LAN Redundancy Port
dist-upgrade	3624/udp	0.000330	# Distributed Upgrade Port
cs-services	3631/udp	0.000661	# C&S Web Services Port
distccd	3632/tcp	0.000100	# Distributed compiler daemon
servistaitsm	3636/tcp	0.000076	# SerVistaITSM
scservp	3637/tcp	0.000076	# Customer Service Port
audiojuggler	3643/udp	0.000330	# AudioJuggler
nmmp	3649/udp	0.000330	# Nishioka Miyuki Msg Protocol
prismiq-plugin	3650/udp	0.000330	# PRISMIQ VOD plug-in
vxcrnbuport	3652/tcp	0.000076	# VxCR NBU Default Port
tsp	3653/tcp	0.000076	# Tunnel Setup Protocol
tsp	3653/udp	0.000330	# Tunnel Setup Protocol
abatjss	3656/tcp	0.000076	# ActiveBatch Job Scheduler
ps-ams	3658/tcp	0.000076	# PlayStation AMS (Secure)
apple-sasl	3659/tcp	0.000380	# Apple SASL
apple-sasl	3659/udp	0.006277	# Apple SASL
dtp	3663/tcp	0.000076	# DIRECWAY Tunnel Protocol
ups-engine	3664/udp	0.001652	# UPS Engine Port
ent-engine	3665/udp	0.000330	# Enterprise Engine Port
dell-rm-port	3668/udp	0.000330	# Dell Remote Management
casanswmgmt	3669/tcp	0.000076	# CA SAN Switch Management
casanswmgmt	3669/udp	0.000330	# CA SAN Switch Management
smile	3670/tcp	0.000076	# SMILE TCP/UDP Interface
smile	3670/udp	0.000330	# SMILE TCP/UDP Interface
efcp	3671/udp	0.000330	# e Field Control (EIBnet)
lispworks-orb	3672/tcp	0.000076	# LispWorks ORB
lispworks-orb	3672/udp	0.000330	# LispWorks ORB
npds-tracker	3680/tcp	0.000076	# NPDS Tracker
bts-x73	3681/tcp	0.000076	# BTS X73 Port
bmc-ea	3683/tcp	0.000076	# BMC EDV/EA
bmc-ea	3683/udp	0.000330	# BMC EDV/EA
faxstfx-port	3684/tcp	0.000152	# FAXstfX
rendezvous	3689/tcp	0.002283	# Rendezvous Zeroconf (used by Apple/iTunes)
daap	3689/udp	0.000330	# Digital Audio Access Protocol
svn	3690/tcp	0.001597	# Subversion
intelsync	3692/udp	0.000330	# Brimstone IntelSync
nw-license	3697/tcp	0.000152	# NavisWorks License System
nw-license	3697/udp	0.000330	# NavisWorks Licnese System
sagectlpanel	3698/udp	0.000330	# SAGECTLPANEL
lrs-paging	3700/tcp	0.000152	# LRS NetPage
lrs-paging	3700/udp	0.000330	# LRS NetPage
ws-discovery	3702/udp	0.001982	# Web Service Discovery
adobeserver-3	3703/tcp	0.002357	# Adobe Server 3
adobeserver-3	3703/udp	0.009580	# Adobe Server 3
ca-idms	3709/udp	0.000330	# CA-IDMS Server
portgate-auth	3710/udp	0.000330	# PortGate Authentication
sentinel-ent	3712/tcp	0.000076	# Sentinel Enterprise
na-er-tip	3725/udp	0.000330	# Netia NA-ER Port
e-woa	3728/tcp	0.000076	# Ericsson Web on Air
smap	3731/tcp	0.000152	# Service Manager
synel-data	3734/udp	0.000330	# Synel Data Collection Port
xpanel	3737/tcp	0.000304	# XPanel Daemon
cst-port	3742/tcp	0.000076	# CST - Configuration & Service Tracker
sasg	3744/udp	0.000330	# SASG
cimtrak	3749/tcp	0.000076	# CimTrak
gprs-cube	3751/udp	0.000330	# CommLinx GPRS Cube
rtraceroute	3765/tcp	0.000076	# Remote Traceroute
unknown	3766/tcp	0.000380
haipe-otnk	3769/udp	0.000330	# HAIPE Network Keying
paging-port	3771/udp	0.000330	# RTP Paging Port
zicom	3774/udp	0.000330	# ZICOM
dvcprov-port	3776/udp	0.000330	# Device Provisioning Port
bim-pem	3783/udp	0.000330	# Impact Mgr./PEM Gateway
bfd-control	3784/tcp	0.000380	# BFD Control Protocol
bfd-control	3784/udp	0.000661	# BFD Control Protocol
fintrx	3787/tcp	0.000076	# Fintrx
isrp-port	3788/tcp	0.000076	# SPACEWAY Routing port
isrp-port	3788/udp	0.000330	# SPACEWAY Routing port
quickbooksrds	3790/tcp	0.000076	# QuickBooks RDS
sitewatch	3792/tcp	0.000152	# e-Watch Corporation SiteWatch
dcsoftware	3793/tcp	0.000076	# DataCore Software
myblast	3795/tcp	0.000076	# myBLAST Mekentosj port
spw-dialer	3796/tcp	0.000076	# Spaceway Dialer
spw-dialer	3796/udp	0.000330	# Spaceway Dialer
minilock	3798/tcp	0.000076	# Minilock
radius-dynauth	3799/tcp	0.000076	# RADIUS Dynamic Authorization
radius-dynauth	3799/udp	0.000330	# RADIUS Dynamic Authorization
pwgpsi	3800/tcp	0.000228	# Print Services Interface
ibm-mgr	3801/tcp	0.000380	# ibm manager service
soniqsync	3803/tcp	0.000076	# SoniqSync
wsmlb	3806/tcp	0.000076	# Remote System Manager
sun-as-iiops-ca	3808/tcp	0.000152	# Sun App Svr-IIOPClntAuth
apocd	3809/tcp	0.000228	# Java Desktop System Configuration Agent
wlanauth	3810/tcp	0.000076	# WLAN AS server
amp	3811/tcp	0.000076	# AMP
neto-wol-server	3812/tcp	0.000076	# netO WOL Server
rap-ip	3813/tcp	0.000076	# Rhapsody Interface Protocol
rap-ip	3813/udp	0.000330	# Rhapsody Interface Protocol
neto-dcs	3814/tcp	0.000228	# netO DCS
lansurveyorxml	3815/udp	0.000330	# LANsurveyor XML
tapeware	3817/tcp	0.000076	# Yosemite Tech Tapeware
scp	3820/tcp	0.000152	# Siemens AuD SCP
acp-conduit	3823/tcp	0.000076	# Compute Pool Conduit
acp-policy	3824/tcp	0.000152	# Compute Pool Policy
ffserver	3825/tcp	0.000076	# Antera FlowFusion Process Simulation
wormux	3826/tcp	0.000228	# Wormux server
netmpi	3827/tcp	0.000380	# Netadmin Systems MPI service
neteh	3828/tcp	0.000304	# Netadmin Systems Event Handler
cernsysmgmtagt	3830/tcp	0.000076	# Cerner System Management Agent
dvapps	3831/tcp	0.000076	# Docsvault Application Service
mkm-discovery	3837/tcp	0.000076	# MARKEM Auto-Discovery
mkm-discovery	3837/udp	0.000330	# MARKEM Auto-Discovery
amx-rms	3839/tcp	0.000076	# AMX Resource Management Suite
zfirm-shiprush3	3841/udp	0.000330	# Z-Firm ShipRush v3
nhci	3842/tcp	0.000076	# NHCI status port
an-pcp	3846/tcp	0.000152	# Astare Network PCP
msfw-control	3847/tcp	0.000076	# MS Firewall Control
item	3848/tcp	0.000152	# IT Environmental Monitor
item	3848/udp	0.000330	# IT Environmental Monitor
spw-dnspreload	3849/tcp	0.000152	# SPACEWAY DNS Preload
qtms-bootstrap	3850/tcp	0.000076	# QTMS Bootstrap Protocol
qtms-bootstrap	3850/udp	0.000330	# QTMS Bootstrap Protocol
spectraport	3851/tcp	0.000304	# SpectraTalk Port
sse-app-config	3852/tcp	0.000152	# SSE App Configuration
sscan	3853/tcp	0.000152	# SONY scanning protocol
informer	3856/tcp	0.000076	# INFORMER
nav-port	3859/tcp	0.000152	# Navini Port
sasp	3860/tcp	0.000076	# Server/Application State Protocol (SASP)
asap-sctp	3863/sctp	0.000000	# RSerPool ASAP (SCTP)
asap-tcp	3863/tcp	0.000152	# RSerPool ASAP (TCP)
asap-sctp-tls	3864/sctp	0.000000	# RSerPool ASAP/TLS (SCTP)
diameter	3868/sctp	0.000000	# DIAMETER
diameter	3868/tcp	0.000076	# DIAMETER
ovsam-mgmt	3869/tcp	0.000228	# hp OVSAM MgmtServer Disco
ovsam-mgmt	3869/udp	0.000330	# hp OVSAM MgmtServer Disco
ovsam-d-agent	3870/tcp	0.000152	# hp OVSAM HostAgent Disco
ovsam-d-agent	3870/udp	0.000330	# hp OVSAM HostAgent Disco
avocent-adsap	3871/tcp	0.000304	# Avocent DS Authorization
oem-agent	3872/tcp	0.000152	# OEM Agent
oem-agent	3872/udp	0.000330	# OEM Agent
dl_agent	3876/tcp	0.000076	# DirectoryLockdown Agent
fotogcad	3878/tcp	0.000228	# FotoG CAD interface
appss-lm	3879/tcp	0.000076	# appss license manager
igrs	3880/tcp	0.000304	# IGRS
msdts1	3882/tcp	0.000076	# DTS Service Port
msdts1	3882/udp	0.000330	# DTS Service Port
softrack-meter	3884/udp	0.000330	# SofTrack Metering
topflow-ssl	3885/udp	0.000330	# TopFlow SSL
ciphire-serv	3888/tcp	0.000152	# Ciphire Services
dandv-tester	3889/tcp	0.000228	# D and V Tester Control Port
ndsconnect	3890/tcp	0.000076	# Niche Data Server Connect
sdo-ssh	3897/tcp	0.000076	# Simple Distributed Objects over SSH
itv-control	3899/tcp	0.000076	# ITV Port
udt_os	3900/tcp	0.000050	# Unidata UDT OS
udt_os	3900/udp	0.000264	# Unidata UDT OS
nimsh	3901/tcp	0.000076	# NIM Service Handler
nimaux	3902/tcp	0.000076	# NIMsh Auxiliary Port
omnilink-port	3904/tcp	0.000076	# Arnet Omnilink Port
omnilink-port	3904/udp	0.000330	# Arnet Omnilink Port
mupdate	3905/tcp	0.000228	# Mailbox Update (MUPDATE) protocol
topovista-data	3906/tcp	0.000076	# TopoVista elevation data
imoguia-port	3907/tcp	0.000152	# Imoguia Port
imoguia-port	3907/udp	0.000330	# Imoguia Port
hppronetman	3908/tcp	0.000076	# HP Procurve NetManagement
surfcontrolcpa	3909/tcp	0.000076	# SurfControl CPA
prnrequest	3910/udp	0.000661	# Printer Request Port
prnstatus	3911/tcp	0.000076	# Printer Status Port
listcrt-port	3913/tcp	0.000076	# ListCREATOR Port
listcrt-port-2	3914/tcp	0.000228	# ListCREATOR Port 2
agcat	3915/tcp	0.000076	# Auto-Graphics Cataloging
wysdmc	3916/tcp	0.000152	# WysDM Controller
pktcablemmcops	3918/tcp	0.000304	# PacketCableMultimediaCOPS
hyperip	3919/tcp	0.000076	# HyperIP
exasoftport1	3920/tcp	0.000228	# Exasoft IP Port
sor-update	3922/tcp	0.000076	# Soronti Update Port
symb-sb-port	3923/tcp	0.000076	# Symbian Service Broker
netboot-pxe	3928/tcp	0.000076	# PXE NetBoot Manager
smauth-port	3929/tcp	0.000152	# AMS Port
syam-webserver	3930/tcp	0.000076	# Syam Web Server Port
msr-plugin-port	3931/tcp	0.000152	# MSR Plugin Port
sdp-portmapper	3935/tcp	0.000076	# SDP Port Mapper Protocol
mailprox	3936/tcp	0.000076	# Mailprox
dvbservdsc	3937/tcp	0.000076	# DVB Service Discovery
xecp-node	3940/tcp	0.000076	# XeCP Node Service
homeportal-web	3941/tcp	0.000152	# Home Portal Web Server
tig	3943/tcp	0.000076	# TetraNode Ip Gateway
sops	3944/tcp	0.000152	# S-Ops Management
sops	3944/udp	0.000330	# S-Ops Management
emcads	3945/tcp	0.000228	# EMCADS Server Port
backupedge	3946/tcp	0.000076	# BackupEDGE Server
ccp	3947/udp	0.000661	# Connect and Control Protocol for Consumer, Commercial, and Industrial Electronic Devices
apdap	3948/tcp	0.000076	# Anton Paar Device Administration Protocol
drip	3949/tcp	0.000076	# Dynamic Routing Information Protocol
namemunge	3950/udp	0.000330	# Name Munging
i3-sessionmgr	3952/tcp	0.000076	# I3 Session Manager
xmlink-connect	3953/udp	0.000330	# Eydeas XMLink Connect
p2pcommunity	3955/udp	0.000330	# p2pCommunity
gvcp	3956/tcp	0.000076	# GigE Vision Control
mqe-broker	3957/tcp	0.000152	# MQEnterprise Broker
proaxess	3961/tcp	0.000076	# ProAxess Server
sbi-agent	3962/tcp	0.000076	# SBI Agent Protocol
thrp	3963/tcp	0.000152	# Teran Hybrid Routing Protocol
sasggprs	3964/tcp	0.000076	# SASG GPRS
ppsms	3967/tcp	0.000076	# PPS Message Service
ianywhere-dbns	3968/tcp	0.000152	# iAnywhere DBNS
landmarks	3969/tcp	0.000152	# Landmark Messages
lanrevagent	3970/udp	0.000330	# LANrev Agent
lanrevserver	3971/tcp	0.000228	# LANrev Server
lanrevserver	3971/udp	0.000330	# LANrev Server
iconp	3972/tcp	0.000152	# ict-control Protocol
citysearch	3974/udp	0.000330	# Remote Applicant Tracking Service
airshot	3975/tcp	0.000076	# Air Shot
opswagent	3976/udp	0.000330	# Opsware Agent
secure-cfg-svr	3978/udp	0.000661	# Secured Configuration Server
smwan	3979/tcp	0.000076	# Smith Micro Wide Area Network Service
acms	3980/tcp	0.000076	# Aircraft Cabin Management System
starfish	3981/tcp	0.000152	# Starfish System Admin
eis	3982/tcp	0.000076	# ESRI Image Server
eisp	3983/tcp	0.000076	# ESRI Image Service
mapper-nodemgr	3984/tcp	0.000013	# MAPPER network node manager
mapper-nodemgr	3984/udp	0.000527	# MAPPER network node manager
mapper-mapethd	3985/tcp	0.000075	# MAPPER TCP/IP server
mapper-mapethd	3985/udp	0.000758	# MAPPER TCP/IP server
mapper-ws_ethd	3986/tcp	0.003977	# MAPPER workstation server
mapper-ws_ethd	3986/udp	0.000544	# MAPPER workstation server
dcs-config	3988/udp	0.000330	# DCS Configuration Port
bv-queryengine	3989/tcp	0.000076	# BindView-Query Engine
bv-is	3990/tcp	0.000152	# BindView-IS
bv-smcsrv	3991/tcp	0.000076	# BindView-SMCServer
bv-ds	3992/tcp	0.000076	# BindView-DirectoryServer
bv-ds	3992/udp	0.000330	# BindView-DirectoryServer
bv-agent	3993/tcp	0.000152	# BindView-Agent
unknown	3994/tcp	0.000152
unknown	3994/udp	0.000330
iss-mgmt-ssl	3995/tcp	0.000304	# ISS Management Svcs SSL
abcsoftware	3996/tcp	0.000076	# abcsoftware-01
remoteanything	3996/udp	0.000478	# neoworx remote-anything slave daemon
agentsease-db	3997/tcp	0.000076	# aes_db
remoteanything	3997/udp	0.000544	# neoworx remote-anything master daemon
dnx	3998/tcp	0.000380	# Distributed Nagios Executor Service
remoteanything	3998/udp	0.000610	# neoworx remote-anything reserved
remoteanything	3999/tcp	0.000088	# neoworx remote-anything slave file browser
nvcnet	3999/udp	0.000330	# Norman distributes scanning service
remoteanything	4000/tcp	0.001794	# neoworx remote-anything slave remote control
icq	4000/udp	0.006392	# AOL ICQ instant messaging clent-server communication
newoak	4001/tcp	0.002129	# NewOak
mlchat-proxy	4002/tcp	0.000765	# mlnet - MLChat P2P chat proxy
pxc-spvr-ft	4002/udp	0.000330
pxc-splr-ft	4003/tcp	0.000380
pxc-roid	4004/tcp	0.000228
pxc-pin	4005/tcp	0.000228
pxc-pin	4005/udp	0.000330
pxc-spvr	4006/tcp	0.000304
pxc-spvr	4006/udp	0.000330
pxc-splr	4007/tcp	0.000076
netcheque	4008/tcp	0.000075	# NetCheque accounting
netcheque	4008/udp	0.001367	# NetCheque accounting
chimera-hwm	4009/tcp	0.000152	# Chimera HWM
samsung-unidex	4010/tcp	0.000076	# Samsung Unidex
samsung-unidex	4010/udp	0.000330	# Samsung Unidex
pda-gate	4012/udp	0.000330	# PDA Gate
talarian-mcast1	4015/udp	0.000330	# Talarian Mcast
talarian-mcast2	4016/tcp	0.000076	# Talarian Mcast
talarian-mcast2	4016/udp	0.000330	# Talarian Mcast
talarian-mcast3	4017/udp	0.000330	# Talarian Mcast
trap	4020/tcp	0.000076	# TRAP Port
nexus-portal	4021/udp	0.000330	# Nexus Portal
dnox	4022/tcp	0.000076	# DNOX
tnp1-port	4024/tcp	0.000076	# TNP1 User Port
partimage	4025/tcp	0.000076	# Partition Image Port
as-debug	4026/udp	0.000330	# Graphical Debug Server
ip-qsig	4029/tcp	0.000076	# IP Q signaling protocol
jdmn-port	4030/udp	0.000330	# Accell/JSP Daemon Port
sanavigator	4033/udp	0.000330	# SANavigator Peer Port
wap-push-http	4035/tcp	0.000076	# WAP Push OTA-HTTP port
wap-push-https	4036/tcp	0.000076	# WAP Push OTA-HTTP secure
fazzt-admin	4039/tcp	0.000076	# Fazzt Administration
fazzt-admin	4039/udp	0.000991	# Fazzt Administration
yo-main	4040/tcp	0.000152	# Yo.net main service
ldxp	4042/udp	0.000330	# LDXP
lockd	4045/tcp	0.001468
lockd	4045/udp	0.006656	# NFS lock daemon/manager
acp-proto	4046/udp	0.000661	# Accounting Protocol
ctp-state	4047/udp	0.000991	# Context Transfer Protocol
unknown	4048/udp	0.000330
wafs	4049/udp	0.000661	# Wide Area File Services
cppdp	4051/udp	0.000330	# Cisco Peer to Peer Distribution Protocol
lms	4056/tcp	0.000076	# Location Message Service
kingfisher	4058/tcp	0.000076	# Kingfisher protocol
ice-location	4061/udp	0.000661	# Ice Location Service (TCP)
avanti_cdp	4065/tcp	0.000076	# Avanti Common Data
idp	4067/udp	0.000330	# Information Distribution Protocol
minger	4069/udp	0.000330	# Minger Email Address Validation Service
aibkup	4071/udp	0.000330	# Automatically Incremental Backup
iRAPP	4073/udp	0.000330	# iRAPP Server Protocol
ascomalarm	4077/udp	0.000330	# Ascom IP Alarming
santools	4079/udp	0.000330	# SANtools Diagnostic Server
lorica-in	4080/tcp	0.000152	# Lorica inside facing
lorica-in-sec	4081/udp	0.000330	# Lorica inside facing (SSL)
lorica-out	4082/udp	0.000330	# Lorica outside facing
applusservice	4087/tcp	0.000076	# APplus Service
omasgport	4090/tcp	0.000076	# OMA BCAST Service Guide
pvxpluscs	4093/udp	0.000330	# Pvx Plus CS Host
bre	4096/tcp	0.000152	# BRE (Bridge Relay Element)
bre	4096/udp	0.000330	# BRE (Bridge Relay Element)
patrolview	4097/udp	0.000330	# Patrol View
igo-incognito	4100/tcp	0.000076	# IGo Incognito Data Port
brlp-0	4101/tcp	0.000076	# Braille protocol
brlp-2	4103/udp	0.000330	# Braille protocol
izm	4109/udp	0.000330	# Instantiated Zero-control Messaging
xgrid	4111/tcp	0.000304	# Xgrid
apple-vpns-rp	4112/tcp	0.000076	# Apple VPN Server Reporting Protocol
apple-vpns-rp	4112/udp	0.000330	# Apple VPN Server Reporting Protocol
aipn-reg	4113/tcp	0.000076	# AIPN LS Registration
netscript	4118/tcp	0.000076	# Netadmin Systems NETscript service
assuria-slm	4119/tcp	0.000076	# Assuria Log Manager
unknown	4120/tcp	0.000076
e-builder	4121/tcp	0.000076	# e-Builder Application Communication
rww	4125/tcp	0.000188	# Microsoft Remote Web Workplace on Small Business Server
ddrepl	4126/tcp	0.000380	# Data Domain Replication Service
unikeypro	4127/udp	0.000330	# NetUniKeyServer
nufw	4128/udp	0.000330	# NuFW decision delegation protocol
nuauth	4129/tcp	0.000380	# NuFW authentication protocol
nuts_dem	4132/tcp	0.000025	# NUTS Daemon
nuts_dem	4132/udp	0.000692	# NUTS Daemon
nuts_bootp	4133/tcp	0.000013	# NUTS Bootp Server
nuts_bootp	4133/udp	0.000692	# NUTS Bootp Server
cl-db-attach	4135/tcp	0.000076	# Classic Line Database Server Attach
cl-db-attach	4135/udp	0.000330	# Classic Line Database Server Attach
cedros_fds	4140/udp	0.000330	# Cedros Fraud Detection System
oirtgsvc	4141/tcp	0.000076	# Workflow Server
oidsr	4143/tcp	0.000152	# Document Replication
wincim	4144/tcp	0.000025	# pc windows compuserve.com protocol
vrxpservman	4147/tcp	0.000152	# Multum Service Manager
stat-scanner	4157/udp	0.000330	# STAT Scanner Control
stat-cc	4158/tcp	0.000076	# STAT Command Center
stat-cc	4158/udp	0.000330	# STAT Command Center
nss	4159/udp	0.000330	# Network Security Service
jini-discovery	4160/udp	0.000330	# Jini Discovery
omscontact	4161/tcp	0.000076	# OMS Contact
silverpeakcomm	4164/tcp	0.000152	# Silver Peak Communication Protocol
silverpeakcomm	4164/udp	0.000330	# Silver Peak Communication Protocol
altcp	4165/udp	0.000330	# ArcLink over Ethernet
joost	4166/udp	0.000330	# Joost Peer to Peer Protocol
unknown	4171/udp	0.000330
unknown	4173/udp	0.000330
unknown	4174/tcp	0.000076
unknown	4175/udp	0.000661
MaxumSP	4179/udp	0.000330	# Maxum Services
sieve	4190/tcp	0.000076	# ManageSieve Protocol
dsmipv6	4191/udp	0.000330	# Dual Stack MIPv6 NAT Traversal
azeti	4192/tcp	0.000076	# Azeti Agent Service
unknown	4194/udp	0.000330
unknown	4195/udp	0.000330
unknown	4197/udp	0.000330
unknown	4198/udp	0.000661
eims-admin	4199/tcp	0.000063	# Eudora Internet Mail Service (EIMS) admin
vrml-multi-use	4200/tcp	0.000152	# VRML Multi User Systems
vrml-multi-use	4200/udp	0.000330	# VRML Multi User Systems
vrml-multi-use	4202/udp	0.000330	# VRML Multi User Systems
vrml-multi-use	4206/tcp	0.000076	# VRML Multi User Systems
vrml-multi-use	4207/udp	0.000330	# VRML Multi User Systems
vrml-multi-use	4208/udp	0.000330	# VRML Multi User Systems
vrml-multi-use	4220/tcp	0.000076	# VRML Multi User Systems
xtell	4224/tcp	0.000226	# Xtell messenging server
vrml-multi-use	4224/udp	0.000330	# VRML Multi User Systems
vrml-multi-use	4225/udp	0.000330	# VRML Multi User Systems
vrml-multi-use	4232/udp	0.000661	# VRML Multi User Systems
vrml-multi-use	4234/tcp	0.000076	# VRML Multi User Systems
vrml-multi-use	4242/tcp	0.000456	# VRML Multi User Systems or CrashPlan http://support.code42.com/CrashPlan/Latest/Configuring/Network#Networking_FAQs
vrml-multi-use	4243/tcp	0.000076	# VRML Multi User Systems or CrashPlan http://support.code42.com/CrashPlan/Latest/Configuring/Network#Networking_FAQs
vrml-multi-use	4247/udp	0.000330	# VRML Multi User Systems
vrml-multi-use	4252/tcp	0.000152	# VRML Multi User Systems
vrml-multi-use	4260/udp	0.000330	# VRML Multi User Systems
vrml-multi-use	4262/tcp	0.000076	# VRML Multi User Systems
vrml-multi-use	4262/udp	0.000661	# VRML Multi User Systems
vrml-multi-use	4274/udp	0.000330	# VRML Multi User Systems
vrml-multi-use	4279/tcp	0.000228	# VRML Multi User Systems
vrml-multi-use	4279/udp	0.000330	# VRML Multi User Systems
vrml-multi-use	4282/udp	0.000330	# VRML Multi User Systems
vrml-multi-use	4285/udp	0.000330	# VRML Multi User Systems
vrml-multi-use	4293/udp	0.000330	# VRML Multi User Systems
vrml-multi-use	4294/tcp	0.000076	# VRML Multi User Systems
vrml-multi-use	4297/tcp	0.000076	# VRML Multi User Systems
vrml-multi-use	4298/tcp	0.000076	# VRML Multi User Systems
vrml-multi-use	4299/udp	0.000330	# VRML Multi User Systems
corelccam	4300/tcp	0.000076	# Corel CCam
d-data	4301/udp	0.000330	# Diagnostic Data
d-data-control	4302/tcp	0.000076	# Diagnostic Data Control
compx-lockview	4308/udp	0.000330	# CompX-LockView
unknown	4318/udp	0.000330
rwhois	4321/tcp	0.000276	# Remote Who Is
rwhois	4321/udp	0.001021	# Remote Who Is
geognosisman	4325/tcp	0.000076	# Cadcorp GeognoSIS Manager Service
jaxer-manager	4328/tcp	0.000076	# Jaxer Manager Command Protocol
jaxer-manager	4328/udp	0.000330	# Jaxer Manager Command Protocol
unknown	4329/udp	0.000330
unknown	4331/udp	0.000330
msql	4333/tcp	0.000113	# mini-sql server
unknown	4336/udp	0.000330
unknown	4337/udp	0.000330
lisp-data	4341/udp	0.000330	# LISP Data Packets
lisp-cons	4342/tcp	0.000076	# LISP-CONS Control
unicall	4343/tcp	0.000201
unicall	4343/udp	0.000511
vinainstall	4344/udp	0.000330	# VinaInstall
qsnet-trans	4354/udp	0.000330	# QSNet Transmitter
qsnet-workst	4355/tcp	0.000076	# QSNet Workstation
qsnet-workst	4355/udp	0.000330	# QSNet Workstation
qsnet-assist	4356/tcp	0.000076	# QSNet Assistant
qsnet-cond	4357/tcp	0.000076	# QSNet Conductor
qsnet-cond	4357/udp	0.000330	# QSNet Conductor
qsnet-nucl	4358/tcp	0.000076	# QSNet Nucleus
qsnet-nucl	4358/udp	0.000330	# QSNet Nucleus
omabcastltkm	4359/udp	0.000330	# OMA BCAST Long-Term Key Messages
nacnl	4361/udp	0.000661	# NavCom Discovery and Control Port
unknown	4362/udp	0.000661
epmd	4369/tcp	0.000076	# Erlang Port Mapper Daemon
epmd	4369/udp	0.000330	# Erlang Port Mapper Daemon
elpro_tunnel	4370/udp	0.000330	# ELPRO V2 Protocol Tunnel
psi-ptt	4374/tcp	0.000076	# PSI Push-to-Talk Protocol
tolteces	4375/tcp	0.000076	# Toltec EasyShare
bip	4376/tcp	0.000076	# BioAPI Interworking
cp-spxdpy	4378/udp	0.000661	# Cambridge Pixel SPx Display
unknown	4380/udp	0.000330
unknown	4384/tcp	0.000076
unknown	4386/udp	0.000330
unknown	4387/udp	0.000330
unknown	4388/tcp	0.000076
unknown	4391/udp	0.000330
apwi-disc	4394/udp	0.000330	# American Printware Discovery
ds-srvr	4401/tcp	0.000076	# ASIGRA Televaulting DS-System Service
ds-srvr	4401/udp	0.000661	# ASIGRA Televaulting DS-System Service
ds-admin	4404/udp	0.000661	# ASIGRA Televaulting DS-System Monitoring/Management
nacagent	4407/tcp	0.000076	# Network Access Control Agent
unknown	4408/udp	0.000661
unknown	4411/udp	0.000330
unknown	4413/udp	0.000330
unknown	4414/tcp	0.000076
unknown	4415/tcp	0.000076
unknown	4418/tcp	0.000076
unknown	4423/udp	0.000330
unknown	4428/udp	0.000330
rsqlserver	4430/tcp	0.000152	# REAL SQL Server
rsqlserver	4430/udp	0.000330	# REAL SQL Server
unknown	4433/tcp	0.000076
unknown	4435/udp	0.000330
unknown	4440/udp	0.000330
saris	4442/tcp	0.000076	# Saris
pharos	4443/tcp	0.000760
krb524	4444/tcp	0.001041	# Kerberos 5 to 4 ticket xlator
krb524	4444/udp	0.016343
upnotifyp	4445/tcp	0.000228	# UPNOTIFYP
n1-fwp	4446/tcp	0.000304	# N1-FWP
n1-rmgmt	4447/tcp	0.000076	# N1-RMGMT
n1-rmgmt	4447/udp	0.000661	# N1-RMGMT
privatewire	4449/tcp	0.000380	# PrivateWire
nssagentmgr	4454/tcp	0.000076	# NSS Agent Manager
unknown	4459/udp	0.000330
unknown	4462/udp	0.000330
unknown	4464/tcp	0.000076
unknown	4468/udp	0.000330
unknown	4471/tcp	0.000076
unknown	4476/tcp	0.000076
proxy-plus	4480/tcp	0.000038	# Proxy+ HTTP proxy port
unknown	4483/udp	0.000330
unknown	4491/udp	0.000330
unknown	4497/udp	0.000330
unknown	4499/udp	0.000330
sae-urn	4500/tcp	0.000038
nat-t-ike	4500/udp	0.124467	# IKE Nat Traversal negotiation (RFC3947)
unknown	4501/udp	0.000330
unknown	4506/udp	0.000330
unknown	4507/udp	0.000330
unknown	4508/udp	0.000330
unknown	4512/udp	0.000330
unknown	4516/tcp	0.000076
unknown	4517/tcp	0.000076
unknown	4523/udp	0.000330
unknown	4524/udp	0.000330
unknown	4530/tcp	0.000076
unknown	4533/udp	0.000330
unknown	4534/tcp	0.000076
ehs-ssl	4536/udp	0.000661	# Event Heap Server SSL
wssauthsvc	4537/udp	0.000330	# WSS Security Service
unknown	4540/udp	0.000330
unknown	4541/udp	0.000330
worldscores	4545/tcp	0.000076	# WorldScores
aegate	4549/udp	0.000330	# Aegate PMR Service
gds-adppiw-db	4550/tcp	0.000228	# Perman I Interbase Server
ieee-mih	4551/udp	0.000330	# MIH Services
menandmice-mon	4552/udp	0.000330	# Men and Mice Monitoring
unknown	4553/udp	0.000330
msfrs	4554/udp	0.000330	# MS FRS Replication
rsip	4555/tcp	0.000152	# RSIP Port
fax	4557/tcp	0.000050	# FlexFax FAX transmission service
unknown	4558/tcp	0.000076
hylafax	4559/tcp	0.000151	# HylaFAX client-server protocol
unknown	4560/udp	0.000330
unknown	4562/udp	0.000330
unknown	4563/udp	0.000330
unknown	4565/udp	0.000661
tram	4567/tcp	0.000228	# TRAM
unknown	4570/tcp	0.000076
unknown	4571/udp	0.000330
unknown	4579/udp	0.000330
unknown	4585/udp	0.000330
unknown	4586/udp	0.000330
unknown	4587/udp	0.000330
unknown	4588/udp	0.000330
ipt-anri-anri	4593/udp	0.000661	# IPT (ANRI-ANRI)
ias-neighbor	4596/udp	0.000330	# IAS-Neighbor (ANRI-ANRI)
a17-an-an	4599/tcp	0.000076	# A17 (AN-AN)
piranha1	4600/tcp	0.000152	# Piranha1
piranha2	4601/tcp	0.000076	# Piranha2
mtsserver	4602/tcp	0.000076	# EAX MTS Server
unknown	4606/tcp	0.000076
unknown	4609/tcp	0.000076
unknown	4610/udp	0.000330
unknown	4611/udp	0.000330
unknown	4622/udp	0.000330
unknown	4629/udp	0.000330
unknown	4634/udp	0.000330
unknown	4644/tcp	0.000076
unknown	4646/udp	0.000330
unknown	4649/tcp	0.000076
playsta2-app	4658/tcp	0.000152	# PlayStation2 App Port
playsta2-lob	4659/udp	0.000330	# PlayStation2 Lobby Port
mosmig	4660/tcp	0.000050	# OpenMOSix MIGrates local processes
edonkey	4662/tcp	0.000828	# eDonkey file sharing (Donkey)
noteit	4663/udp	0.000330	# Note It! Message Service
contclientms	4665/tcp	0.000076	# Container Client Message Service
edonkey	4666/udp	0.001450	# eDonkey file sharing (Donkey)
rfa	4672/tcp	0.000013	# remote file access server
rfa	4672/udp	0.006227	# remote file access server
cxws	4673/udp	0.000330	# CXWS Operations
nst	4687/tcp	0.000076	# Network Scanner Tool FTP
altovacentral	4689/tcp	0.000076	# Altova DatabaseCentral
mtn	4691/udp	0.000991	# monotone Netsync Protocol
conspiracy	4692/udp	0.000661	# Conspiracy messaging
unknown	4693/udp	0.000330
unknown	4695/udp	0.000661
netxms-agent	4700/tcp	0.000076	# NetXMS Agent
netxms-mgmt	4701/udp	0.000330	# NetXMS Management
netxms-sync	4702/udp	0.000330	# NetXMS Server Synchronization
unknown	4706/udp	0.000330
unknown	4709/udp	0.000330
unknown	4712/tcp	0.000076
pulseaudio	4713/tcp	0.000076	# Pulse Audio UNIX sound framework
unknown	4713/udp	0.000330
a26-fap-fgw	4726/udp	0.000330	# A26 (FAP-FGW)
unknown	4734/udp	0.000330
ipfix	4739/sctp	0.000000	# IP Flow Info Export
ipfixs	4740/sctp	0.000000	# IP Flow Info Export over DTLS
lumimgrd	4741/udp	0.000330	# Luminizer Manager
openhpid	4743/udp	0.000330	# openhpi HPI service
fmp	4745/tcp	0.000076	# Funambol Mobile Push
fmp	4745/udp	0.000330	# Funambol Mobile Push
unknown	4746/udp	0.000330
snap	4752/udp	0.000330	# Simple Network Audio Protocol
unknown	4757/udp	0.000330
unknown	4760/tcp	0.000076
unknown	4761/udp	0.000330
unknown	4767/tcp	0.000076
unknown	4769/udp	0.000330
unknown	4770/tcp	0.000076
unknown	4771/tcp	0.000076
unknown	4773/udp	0.000330
unknown	4777/udp	0.000330
unknown	4778/tcp	0.000076
unknown	4778/udp	0.000991
unknown	4783/udp	0.000330
bfd-multi-ctl	4784/udp	0.000330	# BFD Multihop Control
unknown	4793/tcp	0.000076
unknown	4794/udp	0.000330
unknown	4797/udp	0.000330
unknown	4798/udp	0.000330
iims	4800/tcp	0.000076	# Icona Instant Messenging System
iims	4800/udp	0.000330	# Icona Instant Messenging System
iwec	4801/udp	0.000330	# Icona Web Embedded Chat
unknown	4807/udp	0.000330
unknown	4812/udp	0.000330
unknown	4819/tcp	0.000076
squid-htcp	4827/udp	0.000923	# Squid proxy HTCP port
unknown	4829/udp	0.000330
unknown	4833/udp	0.000330
unknown	4835/udp	0.000330
unknown	4836/udp	0.000661
varadero-1	4838/udp	0.000330	# Varadero-1
varadero-2	4839/udp	0.000330	# Varadero-2
opcua-udp	4840/udp	0.000330	# OPC UA TCP Protocol
gw-log	4844/udp	0.000330	# nCode ICE-flow Library LogServer
contamac_icm	4846/udp	0.000330	# Contamac ICM Service
appserv-http	4848/tcp	0.000228	# App Server - Admin HTTP
derby-repli	4851/udp	0.000330	# Apache Derby Replication
unknown	4854/udp	0.000330
unknown	4859/tcp	0.000076
unknown	4859/udp	0.000330
unknown	4860/tcp	0.000076
phrelay	4868/udp	0.000330	# Photon Relay
unknown	4875/tcp	0.000152
unknown	4875/udp	0.000330
unknown	4876/tcp	0.000076
unknown	4877/tcp	0.000076
unknown	4879/udp	0.000330
unknown	4881/tcp	0.000076
hivestor	4884/udp	0.000330	# HiveStor Distributed File System
unknown	4888/udp	0.000330
unknown	4890/udp	0.000330
unknown	4896/udp	0.000330
radmin	4899/tcp	0.003337	# Radmin (www.radmin.com) remote PC control software
hfcs	4900/tcp	0.000228	# HyperFileSQL Client/Server Database Engine
unknown	4903/tcp	0.000076
unknown	4907/udp	0.000330
unknown	4910/udp	0.000330
lutap	4912/tcp	0.000076	# Technicolor LUT Access Protocol
unknown	4916/udp	0.000330
unknown	4918/udp	0.000330
unknown	4919/udp	0.000330
unknown	4923/udp	0.000330
unknown	4931/tcp	0.000076
unknown	4934/udp	0.000661
unknown	4938/udp	0.000330
eq-office-4940	4940/udp	0.000330	# Equitrac Office
eq-office-4941	4941/udp	0.000330	# Equitrac Office
unknown	4943/udp	0.000330
unknown	4948/udp	0.000330
munin	4949/tcp	0.000152	# Munin Graphing Framework
unknown	4953/udp	0.000330
unknown	4955/udp	0.000330
unknown	4961/udp	0.000330
unknown	4962/udp	0.000330
unknown	4963/udp	0.000330
unknown	4972/udp	0.000330
unknown	4973/udp	0.000330
maybe-veritas	4987/tcp	0.000013
vrt	4991/udp	0.000330	# VITA Radio Transport
maybe-veritas	4998/tcp	0.000226
hfcs-manager	4999/tcp	0.000076	# HyperFileSQL Client/Server Database Engine Manager
upnp	5000/tcp	0.006423	# Universal PnP, also Free Internet Chess Server
upnp	5000/udp	0.008913	# also complex-main
commplex-link	5001/tcp	0.003023
commplex-link	5001/udp	0.007018
rfe	5002/tcp	0.000765	# Radio Free Ethernet
rfe	5002/udp	0.002504	# Radio Free Ethernet
filemaker	5003/tcp	0.001756	# Filemaker Server - http://www.filemaker.com/ti/104289.html
filemaker	5003/udp	0.002356	# Filemaker Server - http://www.filemaker.com/ti/104289.html
avt-profile-1	5004/tcp	0.000532	# RTP media data [RFC 3551][RFC 4571]
avt-profile-1	5004/udp	0.000330	# RTP media data [RFC 3551]
avt-profile-2	5005/tcp	0.000076	# RTP control protocol [RFC 3551][RFC 4571]
avt-profile-2	5005/udp	0.000330	# RTP control protocol [RFC 3551]
airport-admin	5009/tcp	0.004416	# Apple AirPort WAP Administration
telelpathstart	5010/tcp	0.000138
telelpathstart	5010/udp	0.001582
telelpathattack	5011/tcp	0.000088
telelpathattack	5011/udp	0.001120
nsp	5012/tcp	0.000076	# NetOnTap Service
nsp	5012/udp	0.000330	# NetOnTap Service
fmpro-v6	5013/tcp	0.000076	# FileMaker, Inc. - Proprietary transport
fmpro-v6	5013/udp	0.000330	# FileMaker, Inc. - Proprietary transport
unknown	5014/tcp	0.000076
fmwp	5015/tcp	0.000076	# FileMaker, Inc. - Web publishing
unknown	5016/tcp	0.000076
unknown	5017/tcp	0.000076
unknown	5018/udp	0.000991
zenginkyo-1	5020/tcp	0.000076
zenginkyo-2	5021/tcp	0.000076
zenginkyo-2	5021/udp	0.000330
htuilsrv	5023/tcp	0.000076	# Htuil Server for PLD2
scpi-raw	5025/udp	0.000330	# SCPI-RAW
surfpass	5030/tcp	0.000380	# SurfPass
unknown	5033/tcp	0.000228
unknown	5034/udp	0.000661
unknown	5040/tcp	0.000152
asnaacceler8db	5042/udp	0.000330
swxadmin	5043/udp	0.000330	# ShopWorX Administration
unknown	5048/udp	0.000661
mmcc	5050/tcp	0.002584	# multimedia conference control tool
mmcc	5050/udp	0.002636	# multimedia conference control tool
ida-agent	5051/tcp	0.003649	# Symantec Intruder Alert
ita-agent	5051/udp	0.000330	# ITA Agent
ita-manager	5052/tcp	0.000076	# ITA Manager
rlm	5053/tcp	0.000076	# RLM License Server
rlm-admin	5054/tcp	0.000304	# RLM administrative interface
unot	5055/tcp	0.000076	# UNOT
unot	5055/udp	0.000330	# UNOT
intecom-ps1	5056/udp	0.000330	# Intecom Pointspan 1
sds	5059/udp	0.000330	# SIP Directory Services
sip	5060/sctp	0.000000	# Session Initiation Protocol (SIP)
sip	5060/tcp	0.010613	# Session Initiation Protocol (SIP)
sip	5060/udp	0.044350	# Session Initiation Protocol (SIP)
sip-tls	5061/sctp	0.000000	# SIP-TLS
sip-tls	5061/tcp	0.000228	# SIP-TLS
sip-tls	5061/udp	0.000330	# SIP-TLS
csrpc	5063/tcp	0.000152	# centrify secure RPC
stanag-5066	5066/tcp	0.000076	# STANAG-5066-SUBNET-INTF
unknown	5068/udp	0.000330
i-net-2000-npr	5069/udp	0.000330	# I/Net 2000-NPR
vtsas	5070/tcp	0.000076	# VersaTrans Server Agent Service
powerschool	5071/udp	0.000330	# PowerSchool
alesquery	5074/tcp	0.000152	# ALES Query
unknown	5077/udp	0.000661
onscreen	5080/tcp	0.000228	# OnScreen Data Collection Service
sdl-ets	5081/tcp	0.000152	# SDL - Ent Trans Server
sdl-ets	5081/udp	0.000330	# SDL - Ent Trans Server
qcp	5082/udp	0.000661	# Qpur Communication Protocol
unknown	5087/tcp	0.000228
unknown	5088/tcp	0.000076
car	5090/sctp	0.000000	# Candidate AR
unknown	5090/tcp	0.000076
unknown	5090/udp	0.000330
cxtp	5091/sctp	0.000000	# Context Transfer Protocol
sentinel-lm	5093/udp	0.003304	# Sentinel LM
hart-ip	5094/udp	0.000330	# HART-IP
unknown	5095/tcp	0.000076
unknown	5096/tcp	0.000076
unknown	5096/udp	0.000330
unknown	5098/tcp	0.000076
admd	5100/tcp	0.000778	# (chili!soft asp admin port) or Yahoo pager
socalia	5100/udp	0.000330	# Socalia service mux
admdog	5101/tcp	0.005156	# (chili!soft asp)
admeng	5102/tcp	0.000602	# (chili!soft asp)
unknown	5109/udp	0.000330
unknown	5110/udp	0.000661
taep-as-svc	5111/tcp	0.000076	# TAEP AS service
unknown	5113/udp	0.000330
ev-services	5114/tcp	0.000076	# Enterprise Vault Services
emb-proj-cmd	5116/udp	0.000330	# EPSON Projecter Image Transfer
unknown	5118/udp	0.000330
unknown	5119/udp	0.000661
unknown	5120/tcp	0.002129
unknown	5120/udp	0.000330
unknown	5121/tcp	0.000076
unknown	5122/tcp	0.000076
unknown	5122/udp	0.000330
unknown	5125/tcp	0.000076
nbt-pc	5133/tcp	0.000076	# Policy Commander
ctsd	5137/tcp	0.000076	# MyCTS server port
unknown	5139/udp	0.000661
rmonitor_secure	5145/tcp	0.000050
rmonitor_secure	5145/udp	0.000610
unknown	5147/tcp	0.000076
esri_sde	5151/tcp	0.000152	# ESRI SDE Instance
sde-discovery	5152/tcp	0.000076	# ESRI SDE Instance Discovery
sde-discovery	5152/udp	0.000330	# ESRI SDE Instance Discovery
unknown	5161/udp	0.000330
unknown	5162/udp	0.000330
winpcs	5166/udp	0.000330	# WinPCS Service Connection
scte30	5168/udp	0.000661	# SCTE30 Connection
unknown	5174/udp	0.000330
unknown	5185/udp	0.000330
unknown	5187/udp	0.000330
aol	5190/tcp	0.004190	# America-Online.  Also can be used by ICQ
aol	5190/udp	0.000692	# America-Online.
aol-1	5191/tcp	0.000050	# AmericaOnline1
aol-1	5191/udp	0.000593	# AmericaOnline1
aol-2	5192/udp	0.000494	# AmericaOnline2
aol-3	5193/tcp	0.000013	# AmericaOnline3
aol-3	5193/udp	0.000511	# AmericaOnline3
unknown	5196/udp	0.000330
targus-getdata	5200/tcp	0.000304	# TARGUS GetData
targus-getdata1	5201/tcp	0.000076	# TARGUS GetData 1
targus-getdata2	5202/tcp	0.000076	# TARGUS GetData 2
unknown	5204/udp	0.000330
unknown	5207/udp	0.000330
unknown	5208/udp	0.000330
unknown	5210/udp	0.000661
unknown	5212/tcp	0.000152
unknown	5214/tcp	0.000532
unknown	5219/tcp	0.000076
3exmp	5221/tcp	0.000228	# 3eTI Extensible Management Protocol for OAMP
xmpp-client	5222/tcp	0.000380	# XMPP Client Connection
hpvirtgrp	5223/tcp	0.000152	# HP Virtual Machine Group Management
hp-server	5225/tcp	0.000760	# HP Server
hp-server	5225/udp	0.000330	# HP Server
hp-status	5226/tcp	0.000760	# HP Status
perfd	5227/udp	0.000330	# HP System Performance Metric Service
unknown	5228/udp	0.000330
unknown	5229/udp	0.000330
unknown	5230/udp	0.000330
sgi-dgl	5232/tcp	0.000050	# SGI Distributed Graphics
unknown	5233/tcp	0.000076
eenet	5234/tcp	0.000076	# EEnet communications
eenet	5234/udp	0.000330	# EEnet communications
galaxy-network	5235/tcp	0.000076	# Galaxy Network Service
padl2sim	5236/udp	0.000577
unknown	5242/tcp	0.000152
unknown	5242/udp	0.000330
downtools-disc	5245/udp	0.000330	# DownTools Discovery Protocol
capwap-control	5246/udp	0.000330	# CAPWAP Control Protocol
soagateway	5250/tcp	0.000076	# soaGateway
movaz-ssc	5252/tcp	0.000076	# Movaz SSC
unknown	5254/udp	0.000330
unknown	5259/tcp	0.000076
unknown	5260/udp	0.000330
unknown	5261/tcp	0.000076
3com-njack-1	5264/udp	0.000330	# 3Com Network Jack Port 1
unknown	5267/udp	0.000330
xmpp-server	5269/tcp	0.000380	# XMPP Server Connection
xmpp-server	5269/udp	0.000330	# XMPP Server Connection
cuelink-disc	5271/udp	0.000330	# StageSoft CueLink discovery
pk	5272/udp	0.000330	# PK
unknown	5277/udp	0.000330
unknown	5279/tcp	0.000152
unknown	5279/udp	0.000661
xmpp-bosh	5280/tcp	0.000304	# Bidirectional-streams Over Synchronous HTTP (BOSH)
unknown	5281/udp	0.000330
unknown	5285/udp	0.000330
unknown	5291/tcp	0.000076
unknown	5291/udp	0.000330
unknown	5293/udp	0.000330
unknown	5297/udp	0.000330
presence	5298/tcp	0.000304	# XMPP Link-Local Messaging
hacl-hb	5300/tcp	0.000050	# HA cluster heartbeat
hacl-hb	5300/udp	0.000412	# HA cluster heartbeat
hacl-gs	5301/tcp	0.000025	# HA cluster general services
hacl-gs	5301/udp	0.000511	# HA cluster general services
hacl-cfg	5302/tcp	0.000025	# HA cluster configuration
hacl-cfg	5302/udp	0.000511	# HA cluster configuration
hacl-probe	5303/tcp	0.000013	# HA cluster probing
hacl-probe	5303/udp	0.000395	# HA cluster probing
hacl-local	5304/udp	0.000692
hacl-test	5305/udp	0.000412
cfengine	5308/tcp	0.000075
cfengine	5308/udp	0.001021
jprinter	5309/udp	0.000330	# J Printer
unknown	5318/udp	0.000661
unknown	5320/udp	0.000661
unknown	5323/udp	0.000330
unknown	5324/udp	0.000330
unknown	5333/udp	0.000330
unknown	5337/udp	0.000330
unknown	5339/tcp	0.000152
kfserver	5343/udp	0.000330	# Sculptor Database Server
unknown	5345/udp	0.000330
unknown	5347/tcp	0.000076
unknown	5347/udp	0.000991
nat-pmp	5351/udp	0.003304
dns-llq	5352/udp	0.000330	# DNS Long-Lived Queries
mdns	5353/tcp	0.000152	# Multicast DNS
zeroconf	5353/udp	0.100166	# Mac OS X Bonjour/Zeroconf port
mdnsresponder	5354/udp	0.000661	# Multicast DNS Responder IPC
llmnr	5355/udp	0.006938	# LLMNR
wsdapi	5357/tcp	0.005474	# Web Services for Devices
wsdapi	5357/udp	0.000661	# Web Services for Devices
unknown	5366/udp	0.000661
unknown	5370/tcp	0.000076
unknown	5374/udp	0.000330
unknown	5377/tcp	0.000076
unknown	5382/udp	0.000330
elektron-admin	5398/udp	0.000330	# Elektron Administration
pcduo-old	5400/tcp	0.000050	# RemCon PC-Duo - old port
excerpt	5400/udp	0.000330	# Excerpt Search
pcduo	5405/tcp	0.000314	# RemCon PC-Duo - new port
foresyte-sec	5408/udp	0.000330	# Foresyte-Sec
statusd	5414/tcp	0.000380	# StatusD
virtualuser	5423/tcp	0.000076	# VIRTUALUSER
virtualuser	5423/udp	0.000330	# VIRTUALUSER
beyond-remote	5424/udp	0.000330	# Beyond Remote
omid	5428/udp	0.000527	# OpenMosix Info Dissemination
park-agent	5431/tcp	0.000684
postgresql	5432/tcp	0.004090	# PostgreSQL database server
pyrrho	5433/tcp	0.000076	# Pyrrho DBMS
sceanics	5435/udp	0.000661	# SCEANICS situation and action notification
unknown	5439/udp	0.000661
unknown	5440/tcp	0.000228
unknown	5440/udp	0.000330
unknown	5441/tcp	0.000076
unknown	5442/tcp	0.000076
spss	5443/udp	0.000330	# Pearson HTTPS
unknown	5444/tcp	0.000076
unknown	5444/udp	0.000661
unknown	5446/udp	0.000330
unknown	5452/udp	0.000330
unknown	5457/tcp	0.000076
unknown	5458/tcp	0.000076
unknown	5472/udp	0.000330
unknown	5473/tcp	0.000076
unknown	5475/tcp	0.000076
unknown	5476/udp	0.000330
unknown	5477/udp	0.000330
unknown	5478/udp	0.000330
unknown	5479/udp	0.000330
connect-proxy	5490/tcp	0.000013	# Many HTTP CONNECT proxies
unknown	5496/udp	0.000330
hotline	5500/tcp	0.000690	# Hotline file sharing client/server
securid	5500/udp	0.003295	# SecurID
fcp-addr-srvr2	5501/tcp	0.000152
fcp-srvr-inst1	5502/tcp	0.000076
unknown	5509/udp	0.000661
secureidprop	5510/tcp	0.000339	# ACE/Server services
unknown	5518/udp	0.000330
unknown	5519/udp	0.000330
sdlog	5520/tcp	0.000125	# ACE/Server services
sdserv	5530/tcp	0.000038	# ACE/Server services
unknown	5532/udp	0.000330
unknown	5533/udp	0.000330
unknown	5537/udp	0.000330
unknown	5538/udp	0.000330
sdxauthd	5540/udp	0.000445	# ACE/Server services
unknown	5541/udp	0.000330
unknown	5544/tcp	0.000228
unknown	5545/udp	0.000330
unknown	5547/udp	0.000330
sdadmind	5550/tcp	0.000853	# ACE/Server services
unknown	5552/tcp	0.000076
unknown	5552/udp	0.000661
sgi-eventmond	5553/tcp	0.000076	# SGI Eventmond Port
sgi-esphttp	5554/tcp	0.000076	# SGI ESP HTTP
freeciv	5555/tcp	0.001305
rplay	5555/udp	0.001615
farenet	5557/tcp	0.000076	# Sandlab FARENET
isqlplus	5560/tcp	0.000238	# Oracle web enabled SQL interface (version 10g+)
westec-connect	5566/tcp	0.000608	# Westec Connect
unknown	5577/udp	0.000330
tmosms0	5580/tcp	0.000076	# T-Mobile SMS Protocol Message 0
tmosms0	5580/udp	0.000330	# T-Mobile SMS Protocol Message 0
tmosms1	5581/tcp	0.000076	# T-Mobile SMS Protocol Message 1
tmo-icon-sync	5583/udp	0.000330	# T-Mobile SMS Protocol Message 2
unknown	5587/udp	0.000330
unknown	5589/udp	0.000661
unknown	5611/tcp	0.000076
unknown	5612/tcp	0.000076
unknown	5613/udp	0.000330
unknown	5614/udp	0.000330
unknown	5616/udp	0.000330
unknown	5620/tcp	0.000076
unknown	5621/tcp	0.000076
unknown	5622/tcp	0.000076
symantec-sfdb	5629/udp	0.000661	# Symantec Storage Foundation for Database
precise-comm	5630/udp	0.000330	# PreciseCommunication
pcanywheredata	5631/tcp	0.006248
pcanywherestat	5632/tcp	0.000075
pcanywherestat	5632/udp	0.007694
beorl	5633/tcp	0.000380	# BE Operations Request Listener
beorl	5633/udp	0.000330	# BE Operations Request Listener
xprtld	5634/udp	0.000330	# SF Message Service
unknown	5648/udp	0.000661
unknown	5652/udp	0.000330
unknown	5660/udp	0.000330
unknown	5663/udp	0.000330
unknown	5665/tcp	0.000076
nrpe	5666/tcp	0.006614	# Nagios NRPE
unknown	5667/tcp	0.000076
unknown	5667/udp	0.000330
amqp	5672/sctp	0.000000	# AMQP
amqp	5672/tcp	0.000076	# AMQP
v5ua	5675/sctp	0.000000	# V5UA application port
rrac	5678/tcp	0.000228	# Remote Replication Agent Connection
activesync	5679/tcp	0.000590	# Microsoft ActiveSync PDY synchronization
canna	5680/tcp	0.000151	# Canna (Japanese Input)
brightcore	5682/udp	0.000330	# BrightCore control & data transfer exchange
qmvideo	5689/udp	0.000330	# QM video network management protocol
unknown	5693/udp	0.000330
unknown	5699/udp	0.000330
unknown	5704/udp	0.000661
unknown	5709/udp	0.000330
unknown	5711/tcp	0.000076
proshareaudio	5713/tcp	0.000013	# proshare conf audio
proshareaudio	5713/udp	0.000511	# proshare conf audio
prosharevideo	5714/tcp	0.000013	# proshare conf video
prosharevideo	5714/udp	0.000297	# proshare conf video
prosharedata	5715/udp	0.000395	# proshare conf data
prosharerequest	5716/udp	0.000445	# proshare conf request
prosharenotify	5717/tcp	0.000013	# proshare conf notify
prosharenotify	5717/udp	0.000593	# proshare conf notify
dpm	5718/tcp	0.000380	# DPM Communication Server
dpm	5718/udp	0.000330	# DPM Communication Server
dtpt	5721/tcp	0.000076	# Desktop Passthru Service
msdfsr	5722/tcp	0.000076	# Microsoft DFS Replication Service
omhs	5723/tcp	0.000076	# Operations Manager - Health Service
unieng	5730/tcp	0.000228	# Steltor's calendar access
unknown	5732/tcp	0.000076
unknown	5734/tcp	0.000076
unknown	5737/tcp	0.000076
unknown	5749/udp	0.000661
unknown	5753/udp	0.000330
unknown	5756/udp	0.000330
unknown	5758/udp	0.000330
unknown	5764/udp	0.000330
spramsd	5770/udp	0.000330	# x509solutions Secure Data
xtreamx	5793/udp	0.000330	# XtreamX Supervised Peer message
spdp	5794/udp	0.000330	# Simple Peered Discovery Protocol
vnc-http	5800/tcp	0.005947	# Virtual Network Computer HTTP Access, display 0
unknown	5800/udp	0.000330
vnc-http-1	5801/tcp	0.000841	# Virtual Network Computer HTTP Access, display 1
vnc-http-2	5802/tcp	0.000276	# Virtual Network Computer HTTP Access, display 2
vnc-http-3	5803/tcp	0.000125	# Virtual Network Computer HTTP Access, display 3
unknown	5804/tcp	0.000076
unknown	5804/udp	0.000330
unknown	5806/tcp	0.000076
unknown	5806/udp	0.000330
unknown	5807/tcp	0.000152
unknown	5808/tcp	0.000076
unknown	5810/tcp	0.000380
unknown	5810/udp	0.000330
unknown	5811/tcp	0.000228
unknown	5811/udp	0.000330
unknown	5812/tcp	0.000152
unknown	5812/udp	0.000330
spt-automation	5814/tcp	0.000076	# Support Automation
unknown	5815/tcp	0.000228
unknown	5815/udp	0.000330
unknown	5817/tcp	0.000076
unknown	5817/udp	0.000661
unknown	5818/tcp	0.000152
unknown	5819/udp	0.000330
unknown	5820/tcp	0.000076
unknown	5821/tcp	0.000076
unknown	5822/tcp	0.000304
unknown	5823/tcp	0.000152
unknown	5824/tcp	0.000076
unknown	5825/tcp	0.000380
unknown	5826/tcp	0.000076
unknown	5827/tcp	0.000076
unknown	5831/tcp	0.000076
unknown	5834/tcp	0.000076
unknown	5836/tcp	0.000076
unknown	5838/tcp	0.000076
unknown	5839/tcp	0.000076
unknown	5840/tcp	0.000076
unknown	5841/udp	0.000330
unknown	5845/tcp	0.000076
unknown	5848/tcp	0.000076
unknown	5849/tcp	0.000076
unknown	5850/tcp	0.000228
unknown	5851/udp	0.000330
unknown	5852/tcp	0.000076
unknown	5853/tcp	0.000076
unknown	5854/tcp	0.000076
unknown	5858/tcp	0.000076
wherehoo	5859/tcp	0.000304	# WHEREHOO
unknown	5860/tcp	0.000076
unknown	5862/tcp	0.000228
unknown	5864/udp	0.000330
unknown	5865/udp	0.000330
unknown	5868/tcp	0.000152
unknown	5869/tcp	0.000152
unknown	5869/udp	0.000330
unknown	5871/tcp	0.000076
unknown	5873/udp	0.000661
unknown	5874/tcp	0.000076
unknown	5875/tcp	0.000076
unknown	5877/tcp	0.000380
unknown	5878/tcp	0.000076
unknown	5881/tcp	0.000076
unknown	5882/udp	0.000330
unknown	5883/udp	0.000330
unknown	5887/tcp	0.000076
unknown	5888/tcp	0.000076
unknown	5899/tcp	0.000152
vnc	5900/tcp	0.023560	# Virtual Network Computer display 0
rfb	5900/udp	0.000661	# Remote Framebuffer
vnc-1	5901/tcp	0.002145	# Virtual Network Computer display 1
vnc-2	5902/tcp	0.000715	# Virtual Network Computer display 2
unknown	5902/udp	0.000330
vnc-3	5903/tcp	0.000326	# Virtual Network Computer display 3
unknown	5904/tcp	0.000304
unknown	5905/tcp	0.000152
unknown	5905/udp	0.000330
unknown	5906/tcp	0.000228
unknown	5906/udp	0.000330
unknown	5907/tcp	0.000228
unknown	5908/tcp	0.000076
unknown	5908/udp	0.000330
unknown	5909/tcp	0.000152
cm	5910/tcp	0.000380	# Context Management
cpdlc	5911/tcp	0.000380	# Controller Pilot Data Link Communication
fis	5912/tcp	0.000076	# Flight Information Services
unknown	5914/tcp	0.000152
unknown	5915/tcp	0.000304
unknown	5915/udp	0.000330
unknown	5917/tcp	0.000076
unknown	5918/tcp	0.000152
unknown	5920/tcp	0.000076
unknown	5921/tcp	0.000076
unknown	5921/udp	0.000330
unknown	5922/tcp	0.000304
unknown	5923/tcp	0.000076
unknown	5924/tcp	0.000076
unknown	5925/tcp	0.000380
unknown	5926/tcp	0.000076
unknown	5927/tcp	0.000076
unknown	5930/udp	0.000330
unknown	5931/tcp	0.000076
unknown	5934/tcp	0.000076
unknown	5936/tcp	0.000076
teamviewer	5938/tcp	0.000152	# teamviewer - http://www.teamviewer.com/en/help/334-Which-ports-are-used-by-TeamViewer.aspx
unknown	5939/tcp	0.000076
unknown	5940/tcp	0.000152
unknown	5945/tcp	0.000076
unknown	5946/udp	0.000330
unknown	5948/tcp	0.000076
unknown	5949/tcp	0.000076
unknown	5950/tcp	0.000228
unknown	5952/tcp	0.000228
unknown	5953/tcp	0.000076
unknown	5953/udp	0.000330
unknown	5954/tcp	0.000076
unknown	5958/tcp	0.000076
unknown	5959/tcp	0.000380
unknown	5960/tcp	0.000380
unknown	5961/tcp	0.000380
unknown	5962/tcp	0.000380
indy	5963/tcp	0.000304	# Indy Application Server
unknown	5964/udp	0.000330
unknown	5966/tcp	0.000076
mppolicy-v5	5968/tcp	0.000152
mppolicy-mgr	5969/tcp	0.000076
unknown	5971/tcp	0.000076
unknown	5974/tcp	0.000076
unknown	5975/tcp	0.000076
unknown	5976/udp	0.000330
ncd-pref-tcp	5977/tcp	0.000075	# NCD preferences tcp port
ncd-diag-tcp	5978/tcp	0.000050	# NCD diagnostic tcp port
unknown	5981/tcp	0.000152
unknown	5981/udp	0.000330
wsman	5985/tcp	0.000076	# WBEM WS-Management HTTP
wsmans	5986/tcp	0.000076	# WBEM WS-Management HTTP over TLS/SSL
wbem-rmi	5987/tcp	0.000380	# WBEM RMI
wbem-http	5988/tcp	0.000380	# WBEM CIM-XML (HTTP)
wbem-https	5989/tcp	0.000380	# WBEM CIM-XML (HTTPS)
unknown	5994/udp	0.000330
ncd-pref	5997/tcp	0.000025	# NCD preferences telnet port
ncd-diag	5998/tcp	0.000163	# NCD diagnostic telnet port
ncd-conf	5999/tcp	0.000213	# NCD configuration telnet port
X11	6000/tcp	0.005683	# X Window server
X11	6000/udp	0.003304
X11:1	6001/tcp	0.011730	# X Window server
X11:1	6001/udp	0.004625
X11:2	6002/tcp	0.001518	# X Window server
X11:2	6002/udp	0.001652
X11:3	6003/tcp	0.000351	# X Window server
X11:4	6004/tcp	0.002597	# X Window server
X11:4	6004/udp	0.002973
X11:5	6005/tcp	0.000602	# X Window server
X11:6	6006/tcp	0.000188	# X Window server
X11:7	6007/tcp	0.000238	# X Window server
X11:8	6008/tcp	0.000125	# X Window server
X11:9	6009/tcp	0.000201	# X Window server
x11	6010/tcp	0.000076	# X Window System
x11	6015/tcp	0.000076	# X Window System
xmail-ctrl	6017/tcp	0.000088	# XMail CTRL server
x11	6017/udp	0.000330	# X Window System
x11	6020/udp	0.000330	# X Window System
x11	6021/tcp	0.000076	# X Window System
x11	6022/udp	0.000330	# X Window System
x11	6025/tcp	0.000228	# X Window System
x11	6026/udp	0.000330	# X Window System
x11	6030/tcp	0.000076	# X Window System
x11	6030/udp	0.000330	# X Window System
x11	6033/udp	0.000661	# X Window System
x11	6038/udp	0.000330	# X Window System
x11	6042/udp	0.000330	# X Window System
x11	6048/udp	0.000330	# X Window System
arcserve	6050/tcp	0.000100	# ARCserve agent
x11	6050/udp	0.001652	# X Window System
x11	6051/tcp	0.000152	# X Window System
x11	6052/tcp	0.000076	# X Window System
x11	6055/tcp	0.000076	# X Window System
x11	6057/udp	0.000330	# X Window System
X11:59	6059/tcp	0.000760	# X Window server
x11	6060/tcp	0.000152	# X Window System
x11	6061/udp	0.000330	# X Window System
x11	6062/tcp	0.000076	# X Window System
x11	6062/udp	0.000330	# X Window System
x11	6063/tcp	0.000076	# X Window System
winpharaoh	6065/tcp	0.000076	# WinPharaoh
unknown	6067/tcp	0.000076
gsmp	6068/tcp	0.000152	# GSMP
diagnose-proc	6072/udp	0.000330	# DIAGNOSE-PROC
unknown	6077/tcp	0.000076
unknown	6077/udp	0.000330
unknown	6078/udp	0.000330
konspire2b	6085/tcp	0.000076	# konspire2b p2p network
pdtp	6086/udp	0.000330	# PDTP P2P
unknown	6090/tcp	0.000076
unknown	6090/udp	0.000330
unknown	6091/tcp	0.000076
unknown	6095/udp	0.000330
synchronet-db	6100/tcp	0.000228	# SynchroNet-db
synchronet-db	6100/udp	0.000330	# SynchroNet-db
backupexec	6101/tcp	0.000452	# Backup Exec UNIX and 95/98/ME Aent
RETS-or-BackupExec	6103/tcp	0.000125	# Backup Exec Agent Accelerator and Remote Agent also sql server and cisco works blue
dbdb	6104/udp	0.000330	# DBDB
isdninfo	6105/tcp	0.000075
primaserver	6105/udp	0.000661	# Prima Server
isdninfo	6106/tcp	0.000314	# i4lmond
softcm	6110/tcp	0.000063	# HP SoftBench CM
softcm	6110/udp	0.000824	# HP SoftBench CM
spc	6111/tcp	0.000025	# HP SoftBench Sub-Process Control
spc	6111/udp	0.001203	# HP SoftBench Sub-Process Control
dtspc	6112/tcp	0.001656	# CDE subprocess control
dayliteserver	6113/tcp	0.000076	# Daylite Server
unknown	6113/udp	0.000330
xic	6115/tcp	0.000076	# Xic IPC Service
unknown	6117/udp	0.000330
unknown	6119/udp	0.000661
unknown	6120/tcp	0.000076
bex-webadmin	6122/udp	0.000330	# Backup Express Web Server
backup-express	6123/tcp	0.000380	# Backup Express
backup-express	6123/udp	0.000330	# Backup Express
unknown	6125/udp	0.000330
unknown	6126/tcp	0.000076
unknown	6128/udp	0.000330
unknown	6129/tcp	0.000380
meta-corp	6141/tcp	0.000013	# Meta Corporation License Manager
meta-corp	6141/udp	0.000577	# Meta Corporation License Manager
aspentec-lm	6142/tcp	0.000025	# Aspen Technology License Manager
aspentec-lm	6142/udp	0.000527	# Aspen Technology License Manager
watershed-lm	6143/tcp	0.000038	# Watershed License Manager
watershed-lm	6143/udp	0.000643	# Watershed License Manager
statsci1-lm	6144/udp	0.000923	# StatSci License Manager - 1
statsci2-lm	6145/tcp	0.000025	# StatSci License Manager - 2
statsci2-lm	6145/udp	0.000807	# StatSci License Manager - 2
lonewolf-lm	6146/tcp	0.000025	# Lone Wolf Systems License Manager
lonewolf-lm	6146/udp	0.001071	# Lone Wolf Systems License Manager
montage-lm	6147/tcp	0.000025	# Montage License Manager
montage-lm	6147/udp	0.000774	# Montage License Manager
ricardo-lm	6148/udp	0.000643	# Ricardo North America License Manager
unknown	6156/tcp	0.000380
unknown	6158/udp	0.000330
patrol-ism	6161/tcp	0.000076	# PATROL Internet Srv Mgr
unknown	6169/udp	0.000330
unknown	6170/udp	0.000330
unknown	6171/udp	0.000330
unknown	6189/udp	0.000330
unknown	6197/udp	0.000330
unknown	6201/udp	0.000330
unknown	6203/tcp	0.000152
unknown	6203/udp	0.000330
unknown	6204/udp	0.000330
unknown	6211/udp	0.000330
unknown	6212/udp	0.000661
radmind	6222/tcp	0.000151	# Radmind protocol
unknown	6226/udp	0.000330
unknown	6237/udp	0.000661
unknown	6238/udp	0.000330
jeol-nsddp-3	6243/udp	0.000330	# JEOL Network Services Dynamic Discovery Protocol 3
jeol-nsddp-4	6244/udp	0.000330	# JEOL Network Services Dynamic Discovery Protocol 4
unknown	6247/tcp	0.000152
unknown	6247/udp	0.000330
unknown	6250/tcp	0.000076
unknown	6250/udp	0.000661
tl1-raw-ssl	6251/tcp	0.000076	# TL1 Raw Over SSL/TLS
unknown	6256/udp	0.000330
unknown	6259/tcp	0.000076
unknown	6273/tcp	0.000076
unknown	6274/tcp	0.000076
unknown	6275/udp	0.000330
unknown	6277/udp	0.000330
unknown	6284/udp	0.000330
unknown	6297/udp	0.000330
unknown	6299/udp	0.000330
ufmp	6306/udp	0.000330	# Unified Fabric Management Protocol
unknown	6309/tcp	0.000076
unknown	6310/tcp	0.000076
unknown	6319/udp	0.000330
repsvc	6320/udp	0.000330	# Double-Take Replication Service
unknown	6323/tcp	0.000076
unknown	6324/tcp	0.000076
unknown	6325/udp	0.000330
unknown	6330/udp	0.000330
unknown	6331/udp	0.000330
unknown	6344/udp	0.000330
gnutella	6346/tcp	0.000226	# Gnutella file sharing protocol
gnutella	6346/udp	0.004893	# Gnutella file sharing protocol
gnutella2	6347/tcp	0.000050	# Gnutella2 file sharing protocol
gnutella2	6347/udp	0.002142	# Gnutella2 file sharing protocol
unknown	6349/tcp	0.000076
unknown	6349/udp	0.000330
adap	6350/tcp	0.000076	# App Discovery and Access Protocol
unknown	6353/udp	0.000661
unknown	6372/udp	0.000661
unknown	6386/udp	0.000330
clariion-evr01	6389/tcp	0.000380
unknown	6395/udp	0.000661
crystalreports	6400/tcp	0.000025	# Seagate Crystal Reports
crystalenterprise	6401/tcp	0.000050	# Seagate Crystal Enterprise
boe-pagesvr	6405/udp	0.000330	# Business Objects Enterprise internal server
boe-processsvr	6406/udp	0.000330	# Business Objects Enterprise internal server
unknown	6411/udp	0.000330
unknown	6412/tcp	0.000076
unknown	6416/udp	0.000330
unknown	6427/udp	0.000330
unknown	6430/udp	0.000991
unknown	6435/udp	0.000330
unknown	6441/udp	0.000330
sge_qmaster	6444/udp	0.000330	# Grid Engine Qmaster Service
mysql-proxy	6446/udp	0.000330	# MySQL Proxy
unknown	6451/udp	0.000661
unknown	6457/udp	0.000330
unknown	6461/udp	0.000330
unknown	6463/udp	0.000661
unknown	6467/udp	0.000330
unknown	6468/udp	0.000661
unknown	6475/udp	0.000330
servicetags	6481/tcp	0.000152	# Service Tags
sun-sr-jmx	6488/udp	0.000330	# Service Registry Default JMX Domain
unknown	6491/udp	0.000330
boks	6500/tcp	0.000152	# BoKS Master
boks	6500/udp	0.000330	# BoKS Master
netop-rc	6502/tcp	0.000314	# NetOp Remote Control (by Danware Data A/S)
netop-rc	6502/udp	0.000741	# NetOp Remote Control (by Danware Data A/S)
boks_clntd	6503/tcp	0.000076	# BoKS Clntd
boks_clntd	6503/udp	0.000991	# BoKS Clntd
unknown	6504/tcp	0.000152
mcer-port	6510/tcp	0.000228	# MCER Port
unknown	6520/tcp	0.000152
unknown	6520/udp	0.000661
unknown	6529/udp	0.000330
unknown	6533/udp	0.000330
unknown	6535/tcp	0.000076
unknown	6535/udp	0.000330
unknown	6538/udp	0.000330
unknown	6540/udp	0.000330
unknown	6542/udp	0.000330
mythtv	6543/tcp	0.001167
mythtv	6544/tcp	0.000025
powerchuteplus	6547/tcp	0.000251
powerchuteplus	6548/tcp	0.000013
powerchuteplus	6549/udp	0.000511
fg-sysupdate	6550/tcp	0.000152
fg-sysupdate	6550/udp	0.000330
xdsxdm	6558/udp	0.000478
unknown	6565/tcp	0.000228
sane-port	6566/tcp	0.000228	# SANE Control Port
esp	6567/tcp	0.000228	# eSilo Storage Protocol
unknown	6572/udp	0.000330
affiliate	6579/tcp	0.000076	# Affiliate
parsec-master	6580/tcp	0.000380	# Parsec Masterserver
joaJewelSuite	6583/udp	0.000330	# JOA Jewel Suite
unknown	6584/udp	0.000330
analogx	6588/tcp	0.000038	# AnalogX HTTP proxy port
unknown	6592/udp	0.000330
unknown	6598/udp	0.000330
mshvlm	6600/tcp	0.000152	# Microsoft Hyper-V Live Migration
unknown	6606/tcp	0.000076
unknown	6607/udp	0.000330
unknown	6610/udp	0.000330
unknown	6616/udp	0.000330
unknown	6625/udp	0.000661
nexgen	6627/udp	0.000661	# Allied Electronics NeXGen
afesc-mc	6628/tcp	0.000076	# AFE Stock Channel M/C
unknown	6633/udp	0.000330
unknown	6639/udp	0.000330
unknown	6644/tcp	0.000076
unknown	6646/tcp	0.003649
unknown	6647/tcp	0.000076
unknown	6650/tcp	0.000076
unknown	6652/udp	0.000330
unknown	6660/udp	0.000330
radmind	6662/tcp	0.000100	# Radmind protocol (deprecated)
unknown	6664/udp	0.000330
irc	6665/tcp	0.000050	# Internet Relay Chat
irc	6666/tcp	0.001179	# internet relay chat server
ircu	6666/udp	0.000330	# IRCU
irc	6667/tcp	0.000652	# Internet Relay Chat
irc	6668/tcp	0.000176	# Internet Relay Chat
irc	6669/tcp	0.000176	# Internet Relay Chat
irc	6670/tcp	0.000088	# Internet Relay Chat
unknown	6686/udp	0.000330
tsa	6689/tcp	0.000228	# Tofino Security Appliance
unknown	6692/tcp	0.000228
babel	6697/udp	0.000330	# Babel Routing Protocol
napster	6699/tcp	0.000251	# Napster File (MP3) sharing  software
unknown	6699/udp	0.000330
carracho	6700/tcp	0.000025	# Carracho file sharing
carracho	6701/tcp	0.000038	# Carracho file sharing
e-design-web	6703/udp	0.000330	# e-Design web
frc-hp	6704/sctp	0.000000	# ForCES HP (High Priority) channel
frc-mp	6705/sctp	0.000000	# ForCES MP (Medium Priority) channel
frc-lp	6706/sctp	0.000000	# ForCES LP (Low priority) channel
unknown	6709/tcp	0.000076
unknown	6710/tcp	0.000076
unknown	6711/tcp	0.000152
unknown	6725/tcp	0.000076
unknown	6727/udp	0.000330
unknown	6732/tcp	0.000152
unknown	6734/tcp	0.000076
unknown	6741/udp	0.000330
unknown	6746/udp	0.000330
unknown	6750/udp	0.000330
unknown	6752/udp	0.000330
unknown	6753/udp	0.000330
bmc-perf-agent	6767/udp	0.000330	# BMC PERFORM AGENT
unknown	6776/udp	0.000330
unknown	6779/tcp	0.000228
unknown	6780/tcp	0.000076
unknown	6784/udp	0.000991
smc-http	6788/tcp	0.000380	# SMC-HTTP
ibm-db2-admin	6789/tcp	0.000760	# IBM DB2
smc-https	6789/udp	0.000330	# SMC-HTTPS
unknown	6792/tcp	0.000228
unknown	6800/udp	0.000330
unknown	6811/udp	0.000661
unknown	6816/udp	0.000330
unknown	6820/udp	0.000330
unknown	6824/udp	0.000330
unknown	6829/udp	0.000330
unknown	6833/udp	0.000330
unknown	6837/udp	0.000330
unknown	6839/tcp	0.000228
unknown	6839/udp	0.000330
netmo-http	6842/udp	0.000330	# Netmo HTTP
unknown	6843/udp	0.000330
unknown	6847/udp	0.000330
iccrushmore	6850/udp	0.000330	# ICCRUSHMORE
unknown	6855/udp	0.000330
unknown	6857/udp	0.000330
unknown	6860/udp	0.000330
unknown	6864/udp	0.000330
unknown	6877/tcp	0.000076
unknown	6877/udp	0.000330
bittorrent-tracker	6881/tcp	0.000640	# BitTorrent tracker
muse	6888/tcp	0.000076	# MUSE
unknown	6895/udp	0.000330
unknown	6896/tcp	0.000152
unknown	6897/tcp	0.000076
jetstream	6901/tcp	0.000380	# Novell Jetstream messaging protocol
unknown	6905/udp	0.000991
unknown	6909/udp	0.000330
unknown	6912/udp	0.000330
unknown	6918/udp	0.000330
unknown	6920/tcp	0.000076
unknown	6922/tcp	0.000076
unknown	6925/udp	0.000661
unknown	6927/udp	0.000330
unknown	6932/udp	0.000330
unknown	6942/tcp	0.000076
unknown	6942/udp	0.000330
unknown	6943/udp	0.000330
unknown	6944/udp	0.000330
unknown	6945/udp	0.000330
unknown	6956/tcp	0.000076
unknown	6956/udp	0.000330
unknown	6957/udp	0.000330
unknown	6959/udp	0.000330
jmact3	6961/udp	0.000661	# JMACT3
acmsoda	6969/tcp	0.000389
acmsoda	6969/udp	0.001104
unknown	6970/udp	0.002643
unknown	6971/udp	0.002643
unknown	6972/tcp	0.000076
unknown	6972/udp	0.000661
unknown	6973/tcp	0.000076
unknown	6973/udp	0.000330
unknown	6976/udp	0.000661
unknown	6978/udp	0.000330
unknown	6984/udp	0.000661
unknown	6991/udp	0.000330
unknown	6996/udp	0.000330
iatp-highpri	6998/udp	0.000330	# IATP-highPri
afs3-fileserver	7000/tcp	0.001995	# file server itself, msdos
afs3-fileserver	7000/udp	0.002339	# file server itself
afs3-callback	7001/tcp	0.000891	# callbacks to cache managers
afs3-callback	7001/udp	0.001005	# callbacks to cache managers
afs3-prserver	7002/tcp	0.000351	# users & groups database
afs3-prserver	7002/udp	0.000560	# users & groups database
afs3-vlserver	7003/tcp	0.000125	# volume location database
afs3-vlserver	7003/udp	0.000610	# volume location database
afs3-kaserver	7004/tcp	0.000201	# AFS/Kerberos authentication service
afs3-kaserver	7004/udp	0.000445	# AFS/Kerberos authentication service
afs3-volser	7005/tcp	0.000075	# volume managment server
afs3-volser	7005/udp	0.000972	# volume managment server
afs3-errors	7006/tcp	0.000025	# error interpretation service
afs3-errors	7006/udp	0.000494	# error interpretation service
afs3-bos	7007/tcp	0.000314	# basic overseer process
afs3-bos	7007/udp	0.000610	# basic overseer process
afs3-update	7008/tcp	0.000025	# server-to-server updater
afs3-update	7008/udp	0.000708	# server-to-server updater
afs3-rmtsys	7009/tcp	0.000038	# remote cache manager service
afs3-rmtsys	7009/udp	0.001021	# remote cache manager service
ups-onlinet	7010/tcp	0.000113	# onlinet uninterruptable power supplies
ups-onlinet	7010/udp	0.000643	# onlinet uninterruptable power supplies
talon-engine	7012/udp	0.000661	# Talon Engine
unknown	7019/tcp	0.000836
vmsvc	7024/tcp	0.000152	# Vormetric service
vmsvc-2	7025/tcp	0.000228	# Vormetric Service II
unknown	7026/udp	0.000330
unknown	7027/udp	0.000330
unknown	7028/udp	0.000330
unknown	7029/udp	0.000330
unknown	7033/tcp	0.000076
unknown	7033/udp	0.000330
unknown	7039/udp	0.000330
unknown	7043/tcp	0.000076
unknown	7050/tcp	0.000152
unknown	7051/tcp	0.000152
unknown	7051/udp	0.000661
unknown	7055/udp	0.000330
unknown	7060/udp	0.000330
unknown	7065/udp	0.000330
unknown	7067/tcp	0.000076
unknown	7068/tcp	0.000076
unknown	7069/udp	0.000330
realserver	7070/tcp	0.004328
iwg1	7071/tcp	0.000076	# IWGADTS Aircraft Housekeeping Message
unknown	7072/tcp	0.000076
unknown	7074/udp	0.000661
unknown	7079/udp	0.000330
empowerid	7080/tcp	0.000152	# EmpowerID Communication
empowerid	7080/udp	0.000330	# EmpowerID Communication
unknown	7081/udp	0.000330
unknown	7085/udp	0.000330
unknown	7089/udp	0.000330
unknown	7092/tcp	0.000076
lazy-ptop	7099/tcp	0.000076
font-service	7100/tcp	0.000928	# X Font Service
font-service	7100/udp	0.001170	# X Font Service
elcn	7101/tcp	0.000076	# Embedded Light Control Network
unknown	7102/tcp	0.000076
unknown	7103/tcp	0.000304
unknown	7104/tcp	0.000076
unknown	7106/tcp	0.000380
unknown	7108/udp	0.000330
unknown	7109/udp	0.000330
unknown	7113/udp	0.000330
unknown	7114/udp	0.000330
unknown	7119/tcp	0.000076
unknown	7120/udp	0.000330
virprot-lm	7121/tcp	0.000076	# Virtual Prototypes License Manager
unknown	7123/tcp	0.000152
unknown	7132/udp	0.000330
unknown	7133/udp	0.000330
unknown	7139/udp	0.000330
unknown	7140/udp	0.000330
unknown	7148/udp	0.000330
unknown	7156/udp	0.000330
unknown	7159/udp	0.000330
unknown	7160/udp	0.000330
unknown	7167/udp	0.000330
unknown	7173/udp	0.000330
unknown	7178/udp	0.000330
unknown	7180/udp	0.000330
unknown	7182/udp	0.000330
unknown	7184/tcp	0.000076
unknown	7187/udp	0.000330
fodms	7200/tcp	0.000439	# FODMS FLIP
fodms	7200/udp	0.000346	# FODMS FLIP
dlip	7201/tcp	0.000188
dlip	7201/udp	0.000527
unknown	7205/udp	0.000330
unknown	7218/tcp	0.000076
unknown	7224/udp	0.000330
unknown	7225/udp	0.000330
unknown	7230/udp	0.000330
unknown	7231/tcp	0.000076
unknown	7231/udp	0.000330
unknown	7237/udp	0.000330
unknown	7238/udp	0.000330
unknown	7241/tcp	0.000152
unknown	7242/udp	0.000330
unknown	7243/udp	0.000330
unknown	7247/udp	0.000330
unknown	7250/udp	0.000330
unknown	7257/udp	0.000330
unknown	7259/udp	0.000330
unknown	7260/udp	0.000330
unknown	7263/udp	0.000330
unknown	7267/udp	0.000661
watchme-7272	7272/tcp	0.000152	# WatchMe Monitoring 7272
openmanage	7273/tcp	0.000050	# Dell OpenManage
oma-rlp-s	7274/udp	0.000661	# OMA Roaming Location SEC
oma-ulp	7275/udp	0.000330	# OMA UserPlane Location
oma-dcdocbs	7278/tcp	0.000152	# OMA Dynamic Content Delivery over CBS
oma-dcdocbs	7278/udp	0.000330	# OMA Dynamic Content Delivery over CBS
itactionserver2	7281/tcp	0.000152	# ITACTIONSERVER 2
unknown	7285/udp	0.000330
unknown	7287/udp	0.000330
unknown	7294/udp	0.000330
unknown	7298/udp	0.000661
swx	7300/tcp	0.000076	# The Swiss Exchange
swx	7301/udp	0.000330	# The Swiss Exchange
swx	7303/udp	0.000661	# The Swiss Exchange
swx	7305/udp	0.000330	# The Swiss Exchange
swx	7307/udp	0.000330	# The Swiss Exchange
swx	7309/udp	0.000330	# The Swiss Exchange
swx	7310/udp	0.000330	# The Swiss Exchange
swx	7314/udp	0.000330	# The Swiss Exchange
swx	7316/udp	0.000330	# The Swiss Exchange
swx	7318/udp	0.000330	# The Swiss Exchange
swx	7320/tcp	0.000076	# The Swiss Exchange
swx	7325/tcp	0.000076	# The Swiss Exchange
icb	7326/tcp	0.000013	# Internet Citizen's Band
swx	7329/udp	0.000330	# The Swiss Exchange
swx	7336/udp	0.000330	# The Swiss Exchange
swx	7338/udp	0.000330	# The Swiss Exchange
swx	7345/tcp	0.000076	# The Swiss Exchange
swx	7345/udp	0.000330	# The Swiss Exchange
swx	7346/udp	0.000330	# The Swiss Exchange
swx	7354/udp	0.000661	# The Swiss Exchange
unknown	7373/udp	0.000330
unknown	7376/udp	0.000330
unknown	7380/udp	0.000330
unknown	7382/udp	0.000330
unknown	7387/udp	0.000330
rtps-discovery	7400/tcp	0.000076	# RTPS Discovery
rtps-dd-mt	7402/tcp	0.000304	# RTPS Data-Distribution Meta-Traffic
unknown	7405/udp	0.000330
unknown	7407/udp	0.000330
ionixnetmon	7410/udp	0.000330	# Ionix Network Monitor
unknown	7423/udp	0.000330
unknown	7425/udp	0.000330
oveadmgr	7427/udp	0.000330	# OpenView DM Event Agent Manager
unknown	7432/udp	0.000330
unknown	7435/tcp	0.000304
unknown	7438/tcp	0.000152
unknown	7438/udp	0.000330
oracleas-https	7443/tcp	0.000304	# Oracle Application Server HTTPS
unknown	7445/udp	0.000330
unknown	7446/udp	0.000330
unknown	7451/tcp	0.000076
unknown	7456/tcp	0.000076
unknown	7458/udp	0.000330
pythonds	7464/tcp	0.000013	# Python Documentation Server
unknown	7465/udp	0.000330
unknown	7466/udp	0.000330
unknown	7467/udp	0.000330
unknown	7471/udp	0.000330
unknown	7486/udp	0.000330
unknown	7496/tcp	0.000228
silhouette	7500/tcp	0.000076	# Silhouette User
silhouette	7500/udp	0.000330	# Silhouette User
ovbus	7501/tcp	0.000076	# HP OpenView Bus Daemon
unknown	7509/udp	0.000330
unknown	7512/tcp	0.000304
unknown	7516/udp	0.000991
unknown	7517/udp	0.000330
unknown	7521/udp	0.000330
unknown	7524/udp	0.000661
unknown	7526/udp	0.000330
unknown	7533/udp	0.000330
unknown	7536/udp	0.000661
unknown	7553/tcp	0.000076
unknown	7554/udp	0.000330
unknown	7555/tcp	0.000076
unknown	7563/udp	0.000330
unknown	7578/udp	0.000330
unknown	7584/udp	0.000330
unknown	7587/udp	0.000330
unknown	7591/udp	0.000330
unknown	7596/udp	0.000330
qaz	7597/tcp	0.000050	# Quaz trojan worm
unknown	7600/tcp	0.000076
unknown	7604/udp	0.000330
unknown	7609/udp	0.000330
unknown	7613/udp	0.000661
unknown	7617/udp	0.000330
unknown	7625/tcp	0.000380
simco	7626/sctp	0.000000	# SImple Middlebox COnfiguration (SIMCO)
soap-http	7627/tcp	0.000380	# SOAP Service Port
zen-pawn	7628/tcp	0.000076	# Primary Agent Work Notification
unknown	7630/udp	0.000330
pmdfmgt	7633/udp	0.000330	# PMDF Management
hddtemp	7634/tcp	0.000025	# A cross-platform hard disk temperature monitoring daemon
unknown	7637/tcp	0.000076
unknown	7638/udp	0.000330
unknown	7639/udp	0.000330
cucme-1	7648/udp	0.000923	# cucme live video/audio server
cucme-2	7649/udp	0.000379	# cucme live video/audio server
cucme-3	7650/udp	0.000395	# cucme live video/audio server
cucme-4	7651/udp	0.000988	# cucme live video/audio server
unknown	7654/tcp	0.000076
unknown	7660/udp	0.000330
unknown	7667/udp	0.000330
imqbrokerd	7676/tcp	0.000228	# iMQ Broker Rendezvous
sun-user-https	7677/udp	0.000991	# Sun App Server - HTTPS
unknown	7679/udp	0.000330
pando-pub	7680/udp	0.000330	# Pando Media Public Distribution
unknown	7684/udp	0.000330
unknown	7685/tcp	0.000076
unknown	7688/tcp	0.000076
unknown	7688/udp	0.000330
unknown	7696/udp	0.000330
klio	7697/udp	0.000330	# KLIO communications
unknown	7704/udp	0.000330
unknown	7710/udp	0.000330
unknown	7714/udp	0.000330
unknown	7716/udp	0.000330
medimageportal	7720/udp	0.000330	# MedImage Portal
unknown	7723/udp	0.000330
nitrogen	7725/tcp	0.000152	# Nitrogen Service
nitrogen	7725/udp	0.000330	# Nitrogen Service
trident-data	7727/udp	0.000330	# Trident Systems Data
unknown	7728/udp	0.000330
unknown	7737/udp	0.000330
aiagent	7738/udp	0.000330	# HP Enterprise Discovery Agent
unknown	7739/udp	0.000330
scriptview	7741/tcp	0.000380	# ScriptView Network
scriptview	7741/udp	0.000330	# ScriptView Network
raqmon-pdu	7744/tcp	0.000152	# RAQMON PDU
unknown	7746/udp	0.000330
prgp	7747/udp	0.000330	# Put/Run/Get Protocol
unknown	7749/tcp	0.000152
unknown	7751/udp	0.000330
unknown	7753/udp	0.000330
unknown	7759/udp	0.000330
unknown	7763/udp	0.000330
unknown	7770/tcp	0.000152
unknown	7771/tcp	0.000076
unknown	7772/tcp	0.000076
unknown	7773/udp	0.000330
unknown	7775/udp	0.000330
cbt	7777/tcp	0.000380
interwise	7778/tcp	0.000380	# Interwise
interwise	7778/udp	0.000330	# Interwise
vstat	7779/udp	0.000330	# VSTAT
unknown	7780/tcp	0.000076
popup-reminders	7787/udp	0.000330	# Popup Reminders Receive
unknown	7788/tcp	0.000076
unknown	7788/udp	0.000330
office-tools	7789/tcp	0.000076	# Office Tools Pro Receive
unknown	7792/udp	0.000330
unknown	7793/udp	0.000330
unknown	7795/udp	0.000330
altbsdp	7799/udp	0.000330	# Alternate BSDP Service
asr	7800/tcp	0.000228	# Apple Software Restore
ssp-client	7801/udp	0.000330	# Secure Server Protocol - client
unknown	7804/udp	0.000661
unknown	7813/tcp	0.000076
unknown	7830/tcp	0.000076
unknown	7832/udp	0.000330
unknown	7836/udp	0.000330
unknown	7842/udp	0.000330
apc-7846	7846/udp	0.000991	# APC 7846
unknown	7852/tcp	0.000076
unknown	7853/tcp	0.000076
unknown	7854/tcp	0.000076
unknown	7854/udp	0.000330
unknown	7855/udp	0.000330
unknown	7857/udp	0.000330
unknown	7867/udp	0.000661
unknown	7869/udp	0.000330
unknown	7873/udp	0.000330
unknown	7874/udp	0.000330
unknown	7878/tcp	0.000152
unknown	7884/udp	0.000330
ubroker	7887/udp	0.000330	# Universal Broker
unknown	7894/udp	0.000330
unknown	7895/tcp	0.000076
unknown	7895/udp	0.000330
unknown	7898/udp	0.000330
mevent	7900/tcp	0.000152	# Multicast Event
unknown	7907/udp	0.000330
unknown	7908/udp	0.000330
unknown	7911/tcp	0.000380
qo-secure	7913/tcp	0.000152	# QuickObjects secure port
unknown	7918/udp	0.000330
unknown	7919/udp	0.000330
unknown	7920/tcp	0.000228
unknown	7920/udp	0.000330
unknown	7921/tcp	0.000228
unknown	7923/udp	0.000330
unknown	7929/tcp	0.000152
unknown	7931/udp	0.000330
t2-brm	7933/udp	0.000330	# Tier 2 Business Rules Manager
nsrexecd	7937/tcp	0.001455	# Legato NetWorker
lgtomapper	7938/tcp	0.001229	# Legato portmapper
unknown	7938/udp	0.003304
unknown	7946/udp	0.000661
unknown	7948/udp	0.000330
unknown	7949/udp	0.000330
unknown	7953/udp	0.000330
unknown	7963/udp	0.000661
unknown	7965/udp	0.000330
unknown	7969/udp	0.000330
unknown	7975/tcp	0.000076
unknown	7976/udp	0.000330
unknown	7977/udp	0.000330
quest-vista	7980/udp	0.000330	# Quest Vista
unknown	7985/udp	0.000330
unknown	7988/udp	0.000330
unknown	7991/udp	0.000330
unknown	7993/udp	0.000330
unknown	7994/udp	0.000330
unknown	7998/tcp	0.000076
irdmi2	7999/tcp	0.000228	# iRDMI2
http-alt	8000/tcp	0.009710	# A common alternative http port
irdmi	8000/udp	0.001652	# iRDMI
vcom-tunnel	8001/tcp	0.000532	# VCOM Tunnel
vcom-tunnel	8001/udp	0.001982	# VCOM Tunnel
teradataordbms	8002/tcp	0.001216	# Teradata ORDBMS
mcreport	8003/tcp	0.000076	# Mulberry Connect Reporting Service
mxi	8005/tcp	0.000076	# MXI Generation II for z/OS
unknown	8006/tcp	0.000076
ajp12	8007/tcp	0.000477	# Apache JServ Protocol 1.x
http	8008/tcp	0.006843	# IBM HTTP server
http-alt	8008/udp	0.000330	# HTTP Alternate
ajp13	8009/tcp	0.004642	# Apache JServ Protocol 1.3
xmpp	8010/tcp	0.002129	# XMPP File Transfer
unknown	8010/udp	0.001652
unknown	8011/tcp	0.000304
unknown	8014/tcp	0.000076
unknown	8015/tcp	0.000152
unknown	8016/tcp	0.000152
unknown	8018/tcp	0.000076
qbdb	8019/tcp	0.000152	# QB DB Dynamic Port
ftp-proxy	8021/tcp	0.000627	# Common FTP proxy port
oa-system	8022/tcp	0.000228
unknown	8023/tcp	0.000076
unknown	8023/udp	0.000330
ca-audit-da	8025/tcp	0.000076	# CA Audit Distribution Agent
ca-audit-ds	8026/udp	0.000330	# CA Audit Distribution Server
unknown	8029/tcp	0.000076
unknown	8031/tcp	0.002509
unknown	8035/udp	0.000330
unknown	8037/tcp	0.000076
unknown	8037/udp	0.000330
ampify	8040/udp	0.000661	# Ampify Messaging Protocol
fs-agent	8042/tcp	0.000228	# FireScope Agent
unknown	8045/tcp	0.000228
unknown	8048/udp	0.000330
unknown	8050/tcp	0.000152
senomix01	8052/tcp	0.000076	# Senomix Timesheets Server
unknown	8060/tcp	0.000076
unknown	8064/tcp	0.000076
unknown	8064/udp	0.000330
unknown	8066/udp	0.000330
slnp	8076/tcp	0.000050	# SLNP (Simple Library Network Protocol) by Sisis Informationssysteme GmbH
unknown	8079/udp	0.000330
http-proxy	8080/tcp	0.042052	# Common HTTP proxy/second web server port
blackice-icecap	8081/tcp	0.006147	# ICECap user console
blackice-alerts	8082/tcp	0.000878	# BlackIce Alerts sent to this port
us-srv	8083/tcp	0.000532	# Utilistor (Server)
unknown	8084/tcp	0.000532
unknown	8085/tcp	0.000684
d-s-n	8086/tcp	0.000380	# Distributed SCADA Networking Rendezvous Port
simplifymedia	8087/tcp	0.000380	# Simplify Media SPP Protocol
radan-http	8088/tcp	0.000608	# Radan HTTP
unknown	8089/tcp	0.000760
unknown	8090/tcp	0.000304
unknown	8092/tcp	0.000076
unknown	8093/tcp	0.000228
unknown	8095/tcp	0.000152
sac	8097/tcp	0.000152	# SAC Port Id
unknown	8098/tcp	0.000152
unknown	8099/tcp	0.000228
xprint-server	8100/tcp	0.000304	# Xprint Server
unknown	8110/tcp	0.000076
unknown	8112/udp	0.000330
mtl8000-matrix	8115/udp	0.000330	# MTL8000 Matrix
cp-cluster	8116/tcp	0.000076	# Check Point Clustering
privoxy	8118/tcp	0.000138	# Privoxy, www.privoxy.org
polipo	8123/tcp	0.000038	# Polipo open source web proxy cache
unknown	8133/tcp	0.000076
unknown	8136/udp	0.000330
unknown	8143/udp	0.000330
unknown	8144/tcp	0.000076
unknown	8144/udp	0.000330
unknown	8145/udp	0.000330
unknown	8146/udp	0.000330
unknown	8162/udp	0.000330
unknown	8168/udp	0.000330
unknown	8171/udp	0.000330
unknown	8180/tcp	0.000304
unknown	8181/tcp	0.000380
unknown	8181/udp	0.001982
vmware-fdm	8182/udp	0.000330	# VMware Fault Domain Manager
unknown	8185/udp	0.000330
unknown	8189/tcp	0.000152
sophos	8192/tcp	0.000760	# Sophos Remote Management System
sophos	8193/tcp	0.000760	# Sophos Remote Management System
sophos	8193/udp	0.002973	# Sophos Remote Management System
sophos	8194/tcp	0.000760	# Sophos Remote Management System
vvr-data	8199/udp	0.000330	# VVR DATA
trivnet1	8200/tcp	0.000228	# TRIVNET
trivnet2	8201/tcp	0.000076	# TRIVNET
trivnet2	8201/udp	0.000661	# TRIVNET
unknown	8202/tcp	0.000076
lm-sserver	8207/udp	0.000991	# LM SServer
unknown	8215/udp	0.000330
unknown	8216/udp	0.000330
unknown	8221/udp	0.000330
unknown	8222/tcp	0.000380
unknown	8228/udp	0.000330
unknown	8232/tcp	0.000076
unknown	8235/udp	0.000330
unknown	8245/tcp	0.000076
unknown	8248/tcp	0.000076
unknown	8254/tcp	0.000304
unknown	8255/tcp	0.000076
unknown	8255/udp	0.000330
unknown	8262/udp	0.000330
unknown	8265/udp	0.000330
unknown	8268/tcp	0.000076
unknown	8271/udp	0.000330
unknown	8273/tcp	0.000076
unknown	8282/tcp	0.000076
unknown	8282/udp	0.000330
unknown	8284/udp	0.000661
unknown	8289/udp	0.000330
unknown	8290/tcp	0.000228
unknown	8291/tcp	0.000456
blp3	8292/tcp	0.000228	# Bloomberg professional
blp3	8292/udp	0.000330	# Bloomberg professional
hiperscan-id	8293/tcp	0.000152	# Hiperscan Identification Service
blp4	8294/tcp	0.000152	# Bloomberg intelligent client
unknown	8295/tcp	0.000076
tmi	8300/tcp	0.000228	# Transport Management Interface
unknown	8308/tcp	0.000076
unknown	8310/udp	0.000330
unknown	8312/udp	0.000330
unknown	8316/udp	0.000330
unknown	8319/udp	0.000330
tnp	8321/udp	0.000330	# Thin(ium) Network Protocol
unknown	8329/udp	0.000330
bitcoin	8333/tcp	0.000380	# Bitcoin crypto currency - https://en.bitcoin.it/wiki/Running_Bitcoin
unknown	8336/udp	0.000661
unknown	8338/udp	0.000330
unknown	8339/tcp	0.000076
unknown	8343/udp	0.000661
unknown	8347/udp	0.000330
unknown	8359/udp	0.000330
unknown	8361/udp	0.000330
unknown	8363/udp	0.000330
unknown	8371/udp	0.000330
unknown	8374/udp	0.000330
unknown	8382/udp	0.000330
m2mservices	8383/tcp	0.000228	# M2m Services
unknown	8385/tcp	0.000152
unknown	8386/udp	0.000330
unknown	8388/udp	0.000330
unknown	8393/udp	0.000330
cvd	8400/tcp	0.000380
sabarsd	8401/tcp	0.000076
abarsd	8402/tcp	0.000380
abarsd	8402/udp	0.000661
admind	8403/tcp	0.000076
admind	8403/udp	0.000330
unknown	8409/tcp	0.000076
unknown	8409/udp	0.000330
unknown	8411/udp	0.000330
unknown	8424/udp	0.000330
unknown	8429/udp	0.000330
unknown	8431/udp	0.000330
unknown	8435/udp	0.000991
cybro-a-bus	8442/udp	0.000330	# CyBro A-bus Protocol
https-alt	8443/tcp	0.009986	# Common alternative https port
unknown	8445/tcp	0.000076
unknown	8447/udp	0.000330
unknown	8451/tcp	0.000076
unknown	8452/tcp	0.000076
unknown	8453/tcp	0.000076
unknown	8454/tcp	0.000076
unknown	8455/tcp	0.000076
unknown	8455/udp	0.000330
unknown	8458/udp	0.000330
unknown	8468/udp	0.000330
cisco-avp	8470/tcp	0.000076	# Cisco Address Validation Protocol
pim-port	8471/sctp	0.000000	# PIM over Reliable Transport
pim-port	8471/tcp	0.000076	# PIM over Reliable Transport
pim-port	8471/udp	0.000330	# PIM over Reliable Transport
otv	8472/tcp	0.000076	# Overlay Transport Virtualization (OTV)
vp2p	8473/udp	0.000330	# Virtual Point to Point
noteshare	8474/tcp	0.000076	# AquaMinds NoteShare
unknown	8475/udp	0.000330
unknown	8477/tcp	0.000076
unknown	8479/tcp	0.000076
unknown	8481/tcp	0.000152
unknown	8482/udp	0.000330
unknown	8484/tcp	0.000076
fmtp	8500/tcp	0.000304	# Flight Message Transfer Protocol
unknown	8508/udp	0.000330
unknown	8515/tcp	0.000076
unknown	8520/udp	0.000330
unknown	8530/tcp	0.000076
unknown	8531/tcp	0.000076
unknown	8531/udp	0.000330
unknown	8538/udp	0.000330
unknown	8539/tcp	0.000076
unknown	8540/tcp	0.000152
unknown	8548/udp	0.000330
unknown	8556/udp	0.000661
unknown	8562/tcp	0.000076
unknown	8569/udp	0.000330
unknown	8573/udp	0.000330
unknown	8576/udp	0.000330
unknown	8577/udp	0.000330
unknown	8578/udp	0.000330
unknown	8585/udp	0.000330
unknown	8591/udp	0.000661
unknown	8597/udp	0.000330
asterix	8600/tcp	0.000380	# Surveillance Data
unknown	8601/tcp	0.000076
canon-bjnp1	8611/udp	0.000330	# Canon BJNP Port 1
canon-bjnp2	8612/udp	0.000330	# Canon BJNP Port 2
canon-bjnp3	8613/udp	0.000330	# Canon BJNP Port 3
canon-bjnp4	8614/udp	0.000330	# Canon BJNP Port 4
unknown	8621/tcp	0.000076
unknown	8632/udp	0.000330
unknown	8635/udp	0.000330
unknown	8640/tcp	0.000076
unknown	8644/tcp	0.000076
unknown	8648/tcp	0.000152
unknown	8649/tcp	0.000380
unknown	8651/tcp	0.000760
unknown	8652/tcp	0.000760
unknown	8652/udp	0.000330
unknown	8654/tcp	0.000304
unknown	8655/tcp	0.000076
unknown	8655/udp	0.000330
unknown	8658/tcp	0.000076
unknown	8661/udp	0.000661
unknown	8666/udp	0.000330
unknown	8667/udp	0.000330
unknown	8673/tcp	0.000076
unknown	8674/udp	0.000330
unknown	8675/tcp	0.000152
unknown	8676/tcp	0.000152
unknown	8679/udp	0.000330
unknown	8680/tcp	0.000076
unknown	8684/udp	0.000661
sun-as-jmxrmi	8686/tcp	0.000152	# Sun App Server - JMX/RMI
unknown	8692/udp	0.000330
unknown	8694/udp	0.000330
unknown	8701/tcp	0.000760
unknown	8701/udp	0.000330
unknown	8715/udp	0.000330
unknown	8719/udp	0.000661
unknown	8720/udp	0.000330
unknown	8724/udp	0.000330
unknown	8726/udp	0.000330
unknown	8736/tcp	0.000076
unknown	8742/udp	0.000661
unknown	8748/udp	0.000330
unknown	8752/tcp	0.000076
unknown	8752/udp	0.000330
unknown	8756/tcp	0.000076
unknown	8760/udp	0.000330
ultraseek-http	8765/tcp	0.000152	# Ultraseek HTTP
unknown	8766/tcp	0.000152
apple-iphoto	8770/tcp	0.000025	# Apple iPhoto sharing
unknown	8772/tcp	0.000076
unknown	8777/udp	0.000330
unknown	8780/udp	0.000330
unknown	8790/tcp	0.000076
unknown	8793/udp	0.000661
unknown	8798/tcp	0.000076
unknown	8798/udp	0.000330
sunwebadmin	8800/tcp	0.000228	# Sun Web Server Admin Service
unknown	8801/tcp	0.000076
unknown	8805/udp	0.000330
unknown	8806/udp	0.000330
unknown	8807/udp	0.000330
unknown	8814/udp	0.000330
unknown	8818/udp	0.000330
unknown	8819/udp	0.000330
unknown	8820/udp	0.000661
unknown	8828/udp	0.000330
unknown	8831/udp	0.000330
unknown	8832/udp	0.000330
unknown	8837/udp	0.000330
unknown	8841/udp	0.000330
unknown	8843/tcp	0.000076
unknown	8848/udp	0.000330
unknown	8853/udp	0.000330
unknown	8865/tcp	0.000076
unknown	8865/udp	0.000330
unknown	8867/udp	0.000330
dxspider	8873/tcp	0.000380	# dxspider linking protocol
unknown	8877/tcp	0.000152
unknown	8878/tcp	0.000076
unknown	8879/tcp	0.000076
cddbp-alt	8880/tcp	0.000076	# CDDBP
unknown	8882/tcp	0.000076
unknown	8885/udp	0.000330
unknown	8886/udp	0.000330
unknown	8887/tcp	0.000076
sun-answerbook	8888/tcp	0.016522	# Sun Answerbook HTTP server.  Or gnump3d streaming music server
ddi-tcp-2	8889/tcp	0.000152	# Desktop Data TCP 1
seosload	8892/tcp	0.000038	# From the new Computer Associates eTrust ACX
unknown	8896/udp	0.000330
unknown	8898/tcp	0.000076
ospf-lite	8899/tcp	0.000608
ospf-lite	8899/udp	0.000330
jmb-cds1	8900/tcp	0.000076	# JMB-CDS 1
jmb-cds1	8900/udp	0.001321	# JMB-CDS 1
jmb-cds2	8901/udp	0.000330	# JMB-CDS 2
unknown	8907/udp	0.000330
manyone-http	8910/udp	0.000330
unknown	8919/udp	0.000330
unknown	8924/udp	0.000661
unknown	8925/tcp	0.000076
unknown	8929/udp	0.000330
unknown	8933/udp	0.000330
unknown	8934/udp	0.000661
unknown	8938/udp	0.000330
unknown	8939/udp	0.000330
cumulus-admin	8954/tcp	0.000076	# Cumulus Admin Port
unknown	8959/udp	0.000330
unknown	8964/udp	0.000330
unknown	8966/udp	0.000330
unknown	8971/udp	0.000330
unknown	8976/udp	0.000330
unknown	8979/udp	0.000661
unknown	8980/tcp	0.000076
unknown	8987/tcp	0.000152
unknown	8994/tcp	0.000380
unknown	8996/tcp	0.000152
unknown	8998/udp	0.000661
bctp	8999/tcp	0.000076	# Brodos Crypto Trade Protocol
cslistener	9000/tcp	0.002129	# CSlistener
cslistener	9000/udp	0.001652	# CSlistener
tor-orport	9001/tcp	0.001216	# Tor ORPort
etlservicemgr	9001/udp	0.001652	# ETL Service Manager
dynamid	9002/tcp	0.000380	# DynamID authentication
dynamid	9002/udp	0.000661	# DynamID authentication
unknown	9003/tcp	0.000228
unknown	9004/tcp	0.000076
unknown	9005/tcp	0.000076
unknown	9006/udp	0.000330
pichat	9009/tcp	0.000456	# Pichat Server
sdr	9010/tcp	0.000380	# Secure Data Replicator Protocol
unknown	9011/tcp	0.000380
unknown	9011/udp	0.000330
unknown	9013/tcp	0.000076
unknown	9017/udp	0.000330
tambora	9020/tcp	0.000076	# TAMBORA
tambora	9020/udp	0.001982	# TAMBORA
panagolin-ident	9021/tcp	0.000076	# Pangolin Identification
paragent	9022/tcp	0.000076	# PrivateArk Remote Agent
unknown	9027/udp	0.000330
unknown	9028/udp	0.000330
unknown	9034/udp	0.000330
unknown	9037/tcp	0.000076
tor-trans	9040/tcp	0.000301	# Tor TransPort, www.torproject.org
unknown	9041/udp	0.000330
unknown	9044/tcp	0.000076
tor-socks	9050/tcp	0.000703	# Tor SocksPort, www.torproject.org
tor-control	9051/tcp	0.000025	# Tor ControlPort, www.torproject.org
unknown	9053/udp	0.000991
unknown	9055/udp	0.000330
unknown	9061/tcp	0.000076
unknown	9061/udp	0.000330
unknown	9064/udp	0.000330
unknown	9065/tcp	0.000076
unknown	9070/udp	0.000330
unknown	9071/tcp	0.000608
unknown	9079/udp	0.000661
glrpc	9080/tcp	0.000380	# Groove GLRPC
glrpc	9080/udp	0.000330	# Groove GLRPC
unknown	9081/tcp	0.000228
lcs-ap	9082/sctp	0.000000	# LCS Application Protocol
aurora	9084/sctp	0.000000	# IBM AURORA Performance Visualizer
aurora	9084/tcp	0.000076	# IBM AURORA Performance Visualizer
ibm-rsyscon	9085/udp	0.000330	# IBM Remote System Console
net2display	9086/udp	0.000330	# Vesa Net2Display
sqlexec	9088/udp	0.000330	# IBM Informix SQL Interface
sqlexec-ssl	9089/udp	0.000330	# IBM Informix SQL Interface - Encrypted
zeus-admin	9090/tcp	0.002747	# Zeus admin server
xmltec-xmlmail	9091/tcp	0.000304
xmltec-xmlmail	9091/udp	0.000330
unknown	9098/tcp	0.000152
unknown	9098/udp	0.000330
unknown	9099/tcp	0.000228
jetdirect	9100/tcp	0.003287	# HP JetDirect card
jetdirect	9101/tcp	0.000602	# HP JetDirect card
bacula-dir	9101/udp	0.000330	# Bacula Director
jetdirect	9102/tcp	0.002133	# HP JetDirect card. Also used (and officially registered for) Bacula File Daemon (an open source backup system)
jetdirect	9103/tcp	0.000188	# HP JetDirect card
bacula-sd	9103/udp	0.002313	# Bacula Storage Daemon
jetdirect	9104/tcp	0.000050	# HP JetDirect card
jetdirect	9105/tcp	0.000038	# HP JetDirect card
jetdirect	9106/tcp	0.000038	# HP JetDirect card
jetdirect	9107/tcp	0.000038	# HP JetDirect card
unknown	9110/tcp	0.000304
unknown	9110/udp	0.000661
DragonIDSConsole	9111/tcp	0.000251	# Dragon IDS Console
unknown	9114/udp	0.000330
unknown	9124/udp	0.000330
unknown	9125/tcp	0.000076
unknown	9128/tcp	0.000076
unknown	9129/udp	0.000330
unknown	9130/tcp	0.000076
dddp	9131/tcp	0.000076	# Dynamic Device Discovery
dddp	9131/udp	0.000330	# Dynamic Device Discovery
unknown	9133/tcp	0.000076
unknown	9136/udp	0.000330
unknown	9140/udp	0.000330
unknown	9146/udp	0.000330
ms-sql2000	9152/tcp	0.000125
unknown	9154/udp	0.000661
unknown	9156/udp	0.000661
unknown	9159/udp	0.000330
apani1	9160/tcp	0.000076
apani2	9161/tcp	0.000076
apani5	9164/udp	0.000330
unknown	9168/udp	0.000330
unknown	9170/tcp	0.000076
unknown	9170/udp	0.000661
unknown	9176/udp	0.000330
unknown	9183/tcp	0.000076
unknown	9184/udp	0.000330
unknown	9186/udp	0.000330
sun-as-jpda	9191/tcp	0.000152	# Sun AppSvr JPDA
unknown	9196/udp	0.000330
unknown	9197/tcp	0.000152
unknown	9198/tcp	0.000152
unknown	9199/udp	0.001982
wap-wsp	9200/tcp	0.000228	# WAP connectionless session services
wap-wsp	9200/udp	0.007268	# WAP connectionless session services
wap-wsp-s	9202/tcp	0.000076	# WAP secure connectionless session service
wap-vcard-s	9206/udp	0.000661	# WAP vCard Secure
wap-vcal-s	9207/tcp	0.000532	# WAP vCal Secure
wap-vcal-s	9207/udp	0.000330	# WAP vCal Secure
oma-mlp	9210/tcp	0.000076	# OMA Mobile Location Protocol
oma-mlp-s	9211/tcp	0.000076	# OMA Mobile Location Protocol Secure
oma-mlp-s	9211/udp	0.000330	# OMA Mobile Location Protocol Secure
ipdcesgbs	9214/udp	0.000330	# IPDC ESG BootstrapService
unknown	9218/udp	0.000330
unknown	9220/tcp	0.000380
teamcoherence	9222/udp	0.000330	# QSC Team Coherence
unknown	9226/udp	0.000330
unknown	9227/udp	0.000330
unknown	9228/udp	0.000330
unknown	9229/udp	0.000661
unknown	9232/udp	0.000330
unknown	9234/udp	0.000330
unknown	9238/udp	0.000330
unknown	9245/udp	0.000330
unknown	9251/udp	0.000330
unknown	9258/udp	0.000330
unknown	9261/udp	0.000330
unknown	9268/udp	0.000330
unknown	9269/udp	0.000330
unknown	9271/udp	0.000330
n2h2server	9285/udp	0.000330	# N2H2 Filter Service Port
cumulus	9287/tcp	0.000076	# Cumulus
unknown	9288/udp	0.000330
unknown	9289/udp	0.000330
unknown	9290/tcp	0.000380
unknown	9290/udp	0.000330
vrace	9300/tcp	0.000076	# Virtual Racing Service
vrace	9300/udp	0.000330	# Virtual Racing Service
unknown	9301/udp	0.000330
unknown	9302/udp	0.000330
unknown	9310/udp	0.000661
unknown	9314/udp	0.000330
unknown	9322/udp	0.000330
unknown	9326/udp	0.000330
litecoin	9333/tcp	0.000076	# Litecoin crypto currency - https://litecoin.info/Litecoin.conf
unknown	9336/udp	0.000330
unknown	9338/udp	0.000330
mpidcmgr	9343/tcp	0.000076	# MpIdcMgr
unknown	9349/udp	0.000330
unknown	9351/tcp	0.000076
unknown	9351/udp	0.000330
unknown	9352/udp	0.000330
unknown	9354/udp	0.000330
unknown	9361/udp	0.000330
unknown	9364/tcp	0.000076
unknown	9364/udp	0.000330
unknown	9365/udp	0.000330
unknown	9366/udp	0.000330
unknown	9370/udp	0.001321
unknown	9372/udp	0.000330
unknown	9383/udp	0.000330
unknown	9388/udp	0.000330
unknown	9391/udp	0.000330
fjinvmgr	9396/udp	0.000330
mpidcagt	9397/udp	0.000330	# MpIdcAgt
sec-t4net-srv	9400/tcp	0.000076	# Samsung Twain for Network Server
unknown	9407/udp	0.000330
unknown	9409/tcp	0.000152
unknown	9415/tcp	0.000760
unknown	9416/udp	0.000661
git	9418/tcp	0.000228	# Git revision control system
unknown	9420/udp	0.000330
unknown	9424/udp	0.000330
unknown	9431/udp	0.000330
unknown	9432/udp	0.000330
unknown	9433/udp	0.000330
tungsten-https	9443/tcp	0.000152	# WSO2 Tungsten HTTPS
wso2esb-console	9444/tcp	0.000152	# WSO2 ESB Administration Console HTTPS
unknown	9453/udp	0.000330
unknown	9454/tcp	0.000076
unknown	9462/udp	0.000330
unknown	9464/tcp	0.000076
unknown	9471/udp	0.000330
unknown	9478/tcp	0.000076
unknown	9485/tcp	0.000380
unknown	9493/tcp	0.000076
unknown	9497/udp	0.000330
ismserver	9500/tcp	0.000380
unknown	9501/tcp	0.000152
unknown	9502/tcp	0.000380
unknown	9502/udp	0.000330
unknown	9503/tcp	0.000380
unknown	9513/tcp	0.000076
unknown	9513/udp	0.000330
unknown	9519/udp	0.000330
unknown	9521/udp	0.000330
unknown	9524/udp	0.000330
unknown	9527/tcp	0.000076
unknown	9528/udp	0.000330
unknown	9534/udp	0.000330
man	9535/tcp	0.000790
man	9535/udp	0.000560
unknown	9538/udp	0.000330
unknown	9547/udp	0.000330
unknown	9559/udp	0.000330
unknown	9560/udp	0.000330
unknown	9565/udp	0.000330
unknown	9567/udp	0.000330
unknown	9575/tcp	0.000228
unknown	9578/udp	0.000330
unknown	9583/tcp	0.000076
unknown	9589/udp	0.000661
ldgateway	9592/tcp	0.000076	# LANDesk Gateway
cba8	9593/tcp	0.000760	# LANDesk Management Agent (cba8)
cba8	9593/udp	0.000330	# LANDesk Management Agent (cba8)
msgsys	9594/tcp	0.000760	# Message System
pds	9595/tcp	0.000760	# Ping Discovery System
pds	9595/udp	0.000991	# Ping Discovery System
vscp	9598/udp	0.000330	# Very Simple Ctrl Protocol
robix	9599/udp	0.000661	# Robix
micromuse-ncpw	9600/tcp	0.000152	# MICROMUSE-NCPW
unknown	9605/udp	0.000330
unknown	9613/tcp	0.000076
erunbook_agent	9616/tcp	0.000076	# eRunbook Agent
unknown	9617/udp	0.000330
condor	9618/tcp	0.000380	# Condor Collector Service
unknown	9619/tcp	0.000076
unknown	9620/tcp	0.000076
unknown	9620/udp	0.000661
unknown	9621/tcp	0.000152
unknown	9622/udp	0.000330
unknown	9627/udp	0.000330
odbcpathway	9628/tcp	0.000076	# ODBC Pathway Service
unknown	9637/udp	0.000330
unknown	9638/udp	0.000661
unknown	9643/tcp	0.000152
unknown	9645/udp	0.000330
unknown	9648/tcp	0.000076
unknown	9651/udp	0.000330
unknown	9654/tcp	0.000076
unknown	9654/udp	0.000330
unknown	9657/udp	0.000330
unknown	9661/tcp	0.000076
unknown	9665/tcp	0.000076
unknown	9666/tcp	0.000304
xmms2	9667/tcp	0.000076	# Cross-platform Music Multiplexing System
unknown	9670/udp	0.000330
unknown	9673/tcp	0.000152
unknown	9674/tcp	0.000076
unknown	9679/tcp	0.000076
unknown	9680/tcp	0.000076
unknown	9683/tcp	0.000076
unknown	9687/udp	0.000330
unknown	9688/udp	0.000330
unknown	9692/udp	0.000330
client-wakeup	9694/tcp	0.000076	# T-Mobile Client Wakeup Message
ccnx	9695/udp	0.000661	# Content Centric Networking
unknown	9699/udp	0.000330
board-roar	9700/tcp	0.000076	# Board M.I.T. Service
unknown	9716/udp	0.000661
unknown	9722/udp	0.000330
unknown	9725/udp	0.000330
unknown	9726/udp	0.000330
unknown	9729/udp	0.000330
unknown	9730/udp	0.000330
unknown	9735/udp	0.000330
unknown	9740/udp	0.000991
unknown	9744/udp	0.000330
unknown	9745/tcp	0.000076
board-voip	9750/udp	0.000661	# Board M.I.T. Synchronous Collaboration
unknown	9751/udp	0.000330
unknown	9769/udp	0.000330
unknown	9771/udp	0.000330
unknown	9777/tcp	0.000076
unknown	9779/udp	0.000330
unknown	9782/udp	0.000330
unknown	9783/udp	0.000330
unknown	9790/udp	0.000330
unknown	9797/udp	0.000330
davsrcs	9802/udp	0.000330	# WebDAV Source TLS/SSL
unknown	9804/udp	0.000330
unknown	9812/tcp	0.000076
unknown	9814/tcp	0.000076
unknown	9814/udp	0.000330
unknown	9815/tcp	0.000152
unknown	9815/udp	0.000330
unknown	9818/udp	0.000330
unknown	9823/tcp	0.000076
unknown	9823/udp	0.000330
unknown	9825/tcp	0.000076
unknown	9825/udp	0.000330
unknown	9826/tcp	0.000076
unknown	9827/udp	0.000330
unknown	9830/tcp	0.000076
unknown	9834/udp	0.000330
unknown	9842/udp	0.000330
unknown	9844/tcp	0.000076
unknown	9847/udp	0.000330
unknown	9849/udp	0.000330
unknown	9851/udp	0.000330
unknown	9859/udp	0.000330
unknown	9869/udp	0.000661
sapv1	9875/tcp	0.000076	# Session Announcement v1
sd	9876/tcp	0.000602	# Session Director
sd	9876/udp	0.004498	# Session Director
unknown	9877/tcp	0.000304
unknown	9877/udp	0.001652
unknown	9878/tcp	0.000228
unknown	9884/udp	0.000330
unknown	9887/udp	0.000330
unknown	9890/udp	0.000991
unknown	9893/udp	0.000330
unknown	9894/udp	0.000330
unknown	9897/udp	0.000661
monkeycom	9898/tcp	0.000228	# MonkeyCom
sctp-tunneling	9899/sctp	0.000000	# SCTP Tunneling (misconfiguration)
iua	9900/sctp	0.000000	# IUA
iua	9900/tcp	0.000380	# IUA
enrp-sctp	9901/sctp	0.000000	# ENRP server channel
unknown	9901/tcp	0.000076
enrp-sctp-tls	9902/sctp	0.000000	# ENRP/TLS server channel
unknown	9908/tcp	0.000076
domaintime	9909/tcp	0.000076
unknown	9910/tcp	0.000076
sype-transport	9911/tcp	0.000076	# SYPECom Transport Protocol
unknown	9912/tcp	0.000076
unknown	9912/udp	0.000330
unknown	9914/tcp	0.000152
unknown	9915/tcp	0.000076
unknown	9917/tcp	0.000228
unknown	9919/tcp	0.000076
unknown	9921/udp	0.000661
nping-echo	9929/tcp	0.000163	# Nping echo server mode - http://nmap.org/book/nping-man-echo-mode.html - The port frequency is made up to keep it (barely) in top 1000 TCP
unknown	9941/tcp	0.000152
unknown	9943/tcp	0.000304
unknown	9944/tcp	0.000304
unknown	9945/udp	0.000330
unknown	9947/udp	0.000330
apc-9950	9950/tcp	0.000076	# APC 9950
apc-9950	9950/udp	0.002643	# APC 9950
apc-9952	9952/udp	0.000330	# APC 9952
unknown	9968/tcp	0.000380
unknown	9971/tcp	0.000076
unknown	9975/tcp	0.000076
unknown	9975/udp	0.000330
unknown	9979/tcp	0.000076
nsesrvr	9988/tcp	0.000152	# Software Essentials Secure HTTP server
osm-appsrvr	9990/tcp	0.000076	# OSM Applet Server
issa	9991/tcp	0.000063	# ISS System Scanner Agent
issc	9992/tcp	0.000138	# ISS System Scanner Console
palace-4	9995/tcp	0.000076	# Palace-4
distinct32	9998/tcp	0.000304	# Distinct32
distinct32	9998/udp	0.000330	# Distinct32
abyss	9999/tcp	0.004441	# Abyss web server remote web management interface
distinct	9999/udp	0.000330
snet-sensor-mgmt	10000/tcp	0.011692	# SecureNet Pro Sensor https management server or apple airport admin
ndmp	10000/udp	0.007598	# Network Data Management Protocol
scp-config	10001/tcp	0.001292	# SCP Configuration
documentum	10002/tcp	0.000380	# EMC-Documentum Content Server Product
documentum_s	10003/tcp	0.000228	# EMC-Documentum Content Server Product
emcrmirccd	10004/tcp	0.000304	# EMC Replication Manager Client
stel	10005/tcp	0.000151	# Secure telnet
unknown	10006/tcp	0.000076
mvs-capacity	10007/tcp	0.000076	# MVS Capacity
mvs-capacity	10007/udp	0.000661	# MVS Capacity
octopus	10008/tcp	0.000152	# Octopus Multiplexer
swdtp-sv	10009/tcp	0.000228	# Systemwalker Desktop Patrol
rxapi	10010/tcp	0.002889	# ooRexx rxapi services
unknown	10011/tcp	0.000152
unknown	10011/udp	0.000661
unknown	10012/tcp	0.000380
unknown	10018/tcp	0.000076
unknown	10018/udp	0.000330
unknown	10019/tcp	0.000076
unknown	10020/tcp	0.000076
unknown	10021/udp	0.000330
unknown	10022/tcp	0.000152
unknown	10023/tcp	0.000152
unknown	10024/tcp	0.000380
unknown	10025/tcp	0.000380
unknown	10028/udp	0.000330
unknown	10031/udp	0.000330
unknown	10034/tcp	0.000152
unknown	10035/tcp	0.000076
unknown	10040/udp	0.000330
unknown	10042/tcp	0.000076
unknown	10045/tcp	0.000076
unknown	10053/udp	0.000330
unknown	10056/udp	0.000330
unknown	10058/tcp	0.000152
unknown	10058/udp	0.000330
unknown	10061/udp	0.000330
unknown	10064/tcp	0.000076
unknown	10066/udp	0.000661
unknown	10076/udp	0.000661
unknown	10077/udp	0.000330
amanda	10080/udp	0.005585	# Amanda Backup Util
famdc	10081/udp	0.000991	# FAM Archive Server
amandaidx	10082/tcp	0.000213	# Amanda indexing
amidxtape	10083/tcp	0.000125	# Amanda tape indexing
unknown	10084/udp	0.000330
unknown	10089/udp	0.000330
unknown	10093/tcp	0.000076
unknown	10099/udp	0.000330
ezmeeting-2	10101/tcp	0.000076	# eZmeeting
nmea-0183	10110/udp	0.000330	# NMEA-0183 Navigational Data
unknown	10112/udp	0.000330
netiq-qcheck	10114/udp	0.000330	# NetIQ Qcheck
netiq-endpt	10115/tcp	0.000076	# NetIQ Endpoint
unknown	10131/udp	0.000330
unknown	10143/udp	0.000330
unknown	10152/udp	0.000330
qb-db-server	10160/tcp	0.000152	# QB Database Server
snmpdtls-trap	10162/udp	0.000330	# SNMP-Trap-DTLS
unknown	10169/udp	0.000330
unknown	10180/tcp	0.000228
unknown	10185/udp	0.000330
unknown	10186/udp	0.000330
unknown	10189/udp	0.000330
unknown	10194/udp	0.000330
unknown	10212/udp	0.000330
unknown	10214/udp	0.000330
unknown	10215/tcp	0.000228
unknown	10218/udp	0.000330
unknown	10219/udp	0.000330
unknown	10227/udp	0.000330
unknown	10238/tcp	0.000076
unknown	10239/udp	0.000330
unknown	10243/tcp	0.000684
unknown	10245/tcp	0.000076
unknown	10246/tcp	0.000076
unknown	10248/udp	0.000330
unknown	10255/tcp	0.000076
axis-wimp-port	10260/udp	0.000330	# Axis WIMP Port
unknown	10261/udp	0.000330
unknown	10268/udp	0.000661
unknown	10280/tcp	0.000076
unknown	10284/udp	0.000330
unknown	10286/udp	0.000330
unknown	10289/udp	0.000330
unknown	10290/udp	0.000330
unknown	10302/udp	0.000991
unknown	10303/udp	0.000330
unknown	10309/udp	0.000330
unknown	10310/udp	0.000330
unknown	10312/udp	0.000330
unknown	10313/udp	0.000330
unknown	10316/udp	0.000330
unknown	10317/udp	0.000330
unknown	10322/udp	0.000330
unknown	10324/udp	0.000330
unknown	10337/udp	0.000330
unknown	10338/tcp	0.000076
unknown	10339/udp	0.000330
unknown	10341/udp	0.000330
unknown	10343/udp	0.000661
unknown	10347/tcp	0.000076
unknown	10355/udp	0.000330
unknown	10357/tcp	0.000076
unknown	10363/udp	0.000330
unknown	10369/udp	0.000661
unknown	10374/udp	0.000330
unknown	10378/udp	0.000330
unknown	10381/udp	0.000330
unknown	10386/udp	0.000330
unknown	10387/tcp	0.000076
unknown	10390/udp	0.000330
unknown	10397/udp	0.000330
unknown	10399/udp	0.000330
unknown	10409/udp	0.000661
unknown	10412/udp	0.000330
unknown	10414/tcp	0.000076
unknown	10416/udp	0.000330
unknown	10420/udp	0.000330
unknown	10431/udp	0.000330
unknown	10433/udp	0.000330
unknown	10439/udp	0.000330
unknown	10443/tcp	0.000076
unknown	10445/udp	0.000661
unknown	10450/udp	0.000330
unknown	10454/udp	0.000330
unknown	10477/udp	0.000330
unknown	10484/udp	0.000991
unknown	10490/udp	0.000661
unknown	10492/udp	0.000330
unknown	10494/tcp	0.000076
unknown	10498/udp	0.000330
unknown	10499/udp	0.000330
unknown	10500/tcp	0.000076
unknown	10503/udp	0.000330
unknown	10506/udp	0.000330
unknown	10509/tcp	0.000076
unknown	10510/udp	0.000330
unknown	10511/udp	0.000330
unknown	10517/udp	0.000661
unknown	10525/udp	0.000661
unknown	10529/tcp	0.000076
unknown	10529/udp	0.000330
unknown	10535/tcp	0.000076
unknown	10536/udp	0.000330
unknown	10538/udp	0.000330
MOS-lower	10540/udp	0.000330	# MOS Media Object Metadata Port
MOS-soap	10543/udp	0.000330	# MOS SOAP Default Port
unknown	10545/udp	0.000330
unknown	10550/tcp	0.000076
unknown	10551/tcp	0.000076
unknown	10552/tcp	0.000076
unknown	10553/tcp	0.000076
unknown	10553/udp	0.000330
unknown	10554/tcp	0.000076
unknown	10554/udp	0.000330
unknown	10555/tcp	0.000076
unknown	10556/tcp	0.000076
unknown	10562/udp	0.000330
unknown	10564/udp	0.000330
unknown	10565/tcp	0.000076
unknown	10566/tcp	0.000380
unknown	10567/tcp	0.000076
unknown	10575/udp	0.000330
unknown	10581/udp	0.000330
unknown	10582/udp	0.000330
unknown	10583/udp	0.000991
unknown	10584/udp	0.000330
unknown	10587/udp	0.000330
unknown	10593/udp	0.000330
unknown	10601/tcp	0.000076
unknown	10602/tcp	0.000076
unknown	10613/udp	0.000330
unknown	10615/udp	0.000330
unknown	10616/tcp	0.000380
unknown	10617/tcp	0.000380
unknown	10621/tcp	0.000380
unknown	10621/udp	0.000330
unknown	10626/tcp	0.000380
unknown	10628/tcp	0.000380
unknown	10628/udp	0.000661
unknown	10629/tcp	0.000380
unknown	10633/udp	0.000330
unknown	10635/udp	0.000330
unknown	10639/udp	0.000330
unknown	10640/udp	0.000330
unknown	10641/udp	0.000330
unknown	10645/udp	0.000330
unknown	10650/udp	0.000330
unknown	10653/udp	0.000661
unknown	10660/udp	0.000330
unknown	10666/udp	0.000661
unknown	10671/udp	0.000330
unknown	10694/udp	0.000330
unknown	10699/tcp	0.000076
unknown	10715/udp	0.000330
unknown	10718/udp	0.000330
unknown	10733/udp	0.000330
unknown	10738/udp	0.000330
unknown	10744/udp	0.000330
unknown	10754/tcp	0.000076
unknown	10754/udp	0.000330
unknown	10760/udp	0.000330
unknown	10767/udp	0.000330
unknown	10776/udp	0.000330
unknown	10778/tcp	0.000304
unknown	10784/udp	0.000330
unknown	10790/udp	0.000330
unknown	10795/udp	0.000330
unknown	10804/udp	0.000330
unknown	10806/udp	0.000330
unknown	10809/udp	0.000330
nmc-disc	10810/udp	0.000330	# Nuance Mobile Care Discovery
unknown	10812/udp	0.000330
unknown	10815/udp	0.000330
unknown	10823/udp	0.000330
unknown	10825/udp	0.000991
unknown	10827/udp	0.000661
unknown	10835/udp	0.000330
unknown	10836/udp	0.000330
unknown	10842/tcp	0.000076
unknown	10845/udp	0.000661
unknown	10851/udp	0.000330
unknown	10852/tcp	0.000076
helix	10860/udp	0.000330	# Helix Client/Server
unknown	10862/udp	0.000661
unknown	10872/udp	0.000330
unknown	10873/tcp	0.000152
unknown	10876/udp	0.000330
unknown	10878/tcp	0.000076
unknown	10887/udp	0.000330
unknown	10893/udp	0.000330
unknown	10900/tcp	0.000076
unknown	10900/udp	0.000330
unknown	10903/udp	0.000330
unknown	10906/udp	0.000330
unknown	10916/udp	0.000330
unknown	10923/udp	0.000330
unknown	10942/udp	0.000330
unknown	10963/udp	0.000330
unknown	10967/udp	0.000330
unknown	10971/udp	0.000330
unknown	10981/udp	0.000330
rmiaux	10990/udp	0.000330	# Auxiliary RMI Port
unknown	10991/udp	0.000330
unknown	10995/udp	0.000330
unknown	10998/udp	0.000330
irisa	11000/tcp	0.000076	# IRISA
metasys	11001/tcp	0.000076	# Metasys
unknown	11002/udp	0.000330
unknown	11003/tcp	0.000076
unknown	11003/udp	0.000330
unknown	11007/tcp	0.000076
unknown	11019/tcp	0.000076
unknown	11026/tcp	0.000076
unknown	11030/udp	0.000330
unknown	11031/tcp	0.000076
unknown	11032/tcp	0.000076
unknown	11032/udp	0.000330
unknown	11033/tcp	0.000076
unknown	11033/udp	0.000330
unknown	11034/udp	0.000330
unknown	11039/udp	0.000330
unknown	11054/udp	0.000330
unknown	11063/udp	0.000661
unknown	11064/udp	0.000330
unknown	11068/udp	0.000330
unknown	11069/udp	0.000330
unknown	11074/udp	0.000330
unknown	11084/udp	0.000330
unknown	11089/tcp	0.000076
unknown	11093/udp	0.000330
unknown	11100/tcp	0.000076
unknown	11103/udp	0.000330
unknown	11110/tcp	0.000380
vce	11111/tcp	0.000228	# Viral Computing Environment (VCE)
unknown	11120/udp	0.000330
unknown	11124/udp	0.000330
unknown	11131/udp	0.000330
unknown	11137/udp	0.000661
unknown	11138/udp	0.000661
unknown	11139/udp	0.000330
unknown	11149/udp	0.000330
unknown	11156/udp	0.000661
unknown	11157/udp	0.000661
suncacao-jmxmp	11162/udp	0.000330	# sun cacao JMX-remoting access point
unknown	11174/udp	0.000330
unknown	11175/udp	0.000330
unknown	11179/udp	0.000330
unknown	11180/tcp	0.000076
unknown	11181/udp	0.000330
unknown	11182/udp	0.000661
unknown	11183/udp	0.000330
unknown	11200/tcp	0.000076
unknown	11205/udp	0.000330
unknown	11214/udp	0.000330
unknown	11222/udp	0.000330
unknown	11223/udp	0.000330
unknown	11224/tcp	0.000076
unknown	11225/udp	0.000330
unknown	11226/udp	0.000330
unknown	11228/udp	0.000330
unknown	11232/udp	0.000330
unknown	11236/udp	0.000330
unknown	11238/udp	0.000330
unknown	11241/udp	0.000330
unknown	11249/udp	0.000330
unknown	11250/tcp	0.000076
unknown	11251/udp	0.000330
unknown	11255/udp	0.000330
unknown	11271/udp	0.000991
unknown	11277/udp	0.000330
unknown	11285/udp	0.000330
unknown	11287/udp	0.000991
unknown	11288/tcp	0.000076
unknown	11296/tcp	0.000076
unknown	11297/udp	0.000330
unknown	11302/udp	0.000330
unknown	11342/udp	0.000330
unknown	11346/udp	0.000330
unknown	11354/udp	0.000330
unknown	11361/udp	0.000330
unknown	11364/udp	0.000661
pksd	11371/tcp	0.000038	# PGP Public Key Server
unknown	11373/udp	0.000330
unknown	11375/udp	0.000330
unknown	11389/udp	0.000330
unknown	11400/udp	0.000330
unknown	11401/tcp	0.000076
unknown	11406/udp	0.000330
unknown	11412/udp	0.000330
unknown	11421/udp	0.000330
unknown	11423/udp	0.000330
unknown	11425/udp	0.000661
unknown	11449/udp	0.000661
unknown	11452/udp	0.000330
unknown	11455/udp	0.000330
unknown	11468/udp	0.000330
unknown	11487/udp	0.003634
unknown	11490/udp	0.000330
unknown	11494/udp	0.000330
unknown	11496/udp	0.000330
unknown	11503/udp	0.000330
unknown	11504/udp	0.000330
unknown	11506/udp	0.000330
unknown	11519/udp	0.000330
unknown	11523/udp	0.000330
unknown	11528/udp	0.000330
unknown	11536/udp	0.000330
unknown	11540/udp	0.000330
unknown	11543/udp	0.000330
unknown	11546/udp	0.000330
unknown	11552/tcp	0.000076
unknown	11567/udp	0.000661
unknown	11568/udp	0.000330
unknown	11571/udp	0.000330
unknown	11574/udp	0.000330
unknown	11579/udp	0.000330
unknown	11587/udp	0.000330
unknown	11590/udp	0.000330
unknown	11593/udp	0.000330
unknown	11599/udp	0.000330
unknown	11603/udp	0.000330
unknown	11605/udp	0.000330
unknown	11606/udp	0.000330
unknown	11611/udp	0.000330
unknown	11613/udp	0.000330
unknown	11616/udp	0.000330
unknown	11618/udp	0.000991
unknown	11620/udp	0.000330
unknown	11625/udp	0.000330
unknown	11628/udp	0.000330
unknown	11634/udp	0.000330
unknown	11635/udp	0.000330
unknown	11641/udp	0.000330
unknown	11648/udp	0.000330
unknown	11649/udp	0.000330
unknown	11661/udp	0.000330
unknown	11666/udp	0.000330
unknown	11681/udp	0.000330
unknown	11688/udp	0.000330
unknown	11689/udp	0.000330
unknown	11696/udp	0.000330
unknown	11697/tcp	0.000076
unknown	11698/udp	0.000330
unknown	11701/udp	0.000330
unknown	11710/udp	0.000330
unknown	11711/udp	0.000330
h323callsigalt	11720/udp	0.000661	# h323 Call Signal Alternate
unknown	11721/udp	0.000330
unknown	11723/udp	0.000661
unknown	11735/tcp	0.000076
unknown	11739/udp	0.000330
unknown	11761/udp	0.000330
unknown	11767/udp	0.000330
unknown	11774/udp	0.000330
unknown	11777/udp	0.000330
unknown	11779/udp	0.000330
unknown	11785/udp	0.000661
unknown	11788/udp	0.000330
unknown	11800/udp	0.000330
unknown	11810/udp	0.000330
unknown	11813/tcp	0.000076
unknown	11820/udp	0.000330
unknown	11822/udp	0.000330
unknown	11835/udp	0.000330
unknown	11837/udp	0.000330
unknown	11839/udp	0.000330
unknown	11860/udp	0.000330
unknown	11862/tcp	0.000076
unknown	11862/udp	0.000330
unknown	11863/tcp	0.000076
unknown	11863/udp	0.000330
unknown	11872/udp	0.000661
unknown	11875/udp	0.000330
unknown	11878/udp	0.000661
unknown	11891/udp	0.000330
unknown	11892/udp	0.000330
unknown	11898/udp	0.000330
unknown	11900/udp	0.000330
unknown	11906/udp	0.000330
unknown	11907/udp	0.000330
unknown	11914/udp	0.000330
unknown	11917/udp	0.000330
unknown	11921/udp	0.000330
unknown	11929/udp	0.000330
unknown	11940/tcp	0.000076
unknown	11940/udp	0.000330
unknown	11945/udp	0.000330
unknown	11947/udp	0.000330
unknown	11948/udp	0.000330
unknown	11953/udp	0.000330
unknown	11962/udp	0.000330
unknown	11963/udp	0.000330
sysinfo-sp	11967/tcp	0.000380	# SysInfo Service Protocol
unknown	11970/udp	0.000661
unknown	11973/udp	0.000330
unknown	11978/udp	0.000330
unknown	11982/udp	0.000330
unknown	11988/udp	0.000330
unknown	11991/udp	0.000330
wmereceiving	11997/sctp	0.000000	# WorldMailExpress
unknown	11997/udp	0.000330
wmedistribution	11998/sctp	0.000000	# WorldMailExpress
unknown	11998/udp	0.000330
wmereporting	11999/sctp	0.000000	# WorldMailExpress
unknown	11999/udp	0.000330
cce4x	12000/tcp	0.000427	# ClearCommerce Engine 4.x (www.clearcommerce.com)
entextxid	12000/udp	0.000661	# IBM Enterprise Extender SNA XID Exchange
entextnetwk	12001/tcp	0.000076	# IBM Enterprise Extender SNA COS Network Priority
entextnetwk	12001/udp	0.000661	# IBM Enterprise Extender SNA COS Network Priority
entexthigh	12002/tcp	0.000076	# IBM Enterprise Extender SNA COS High Priority
entexthigh	12002/udp	0.000661	# IBM Enterprise Extender SNA COS High Priority
entextmed	12003/udp	0.000991	# IBM Enterprise Extender SNA COS Medium Priority
entextlow	12004/udp	0.000661	# IBM Enterprise Extender SNA COS Low Priority
dbisamserver1	12005/tcp	0.000076	# DBISAM Database Server - Regular
dbisamserver2	12006/tcp	0.000152	# DBISAM Database Server - Admin
accuracer	12007/udp	0.000330	# Accuracer Database System ñ Server
unknown	12009/tcp	0.000076
unknown	12017/udp	0.000330
unknown	12019/tcp	0.000076
unknown	12021/tcp	0.000152
unknown	12026/udp	0.000330
unknown	12031/tcp	0.000076
unknown	12034/tcp	0.000076
unknown	12034/udp	0.000661
unknown	12041/udp	0.000330
unknown	12048/udp	0.000330
unknown	12059/tcp	0.000152
unknown	12059/udp	0.000330
unknown	12060/udp	0.000330
unknown	12063/udp	0.000330
unknown	12066/udp	0.000330
unknown	12074/udp	0.000330
unknown	12077/tcp	0.000076
unknown	12080/tcp	0.000076
unknown	12088/udp	0.000330
unknown	12090/tcp	0.000076
unknown	12090/udp	0.000330
unknown	12096/tcp	0.000076
unknown	12096/udp	0.000330
unknown	12097/tcp	0.000076
unknown	12099/udp	0.000330
unknown	12101/udp	0.000330
unknown	12108/udp	0.000330
unknown	12111/udp	0.000330
unknown	12115/udp	0.000330
nupaper-ss	12121/tcp	0.000076	# NuPaper Session Service
unknown	12128/udp	0.000330
unknown	12132/tcp	0.000076
unknown	12137/tcp	0.000076
unknown	12140/udp	0.000330
unknown	12146/tcp	0.000076
unknown	12146/udp	0.000330
unknown	12149/udp	0.000330
unknown	12156/tcp	0.000076
unknown	12162/udp	0.000330
unknown	12166/udp	0.000330
unknown	12170/udp	0.000330
unknown	12171/tcp	0.000076
unknown	12173/udp	0.000661
unknown	12174/tcp	0.000228
unknown	12185/udp	0.000330
unknown	12190/udp	0.000330
unknown	12192/tcp	0.000076
unknown	12195/udp	0.000661
unknown	12199/udp	0.000330
unknown	12200/udp	0.000330
unknown	12205/udp	0.000330
unknown	12208/udp	0.000991
unknown	12210/udp	0.000330
unknown	12215/tcp	0.000152
unknown	12218/udp	0.000330
unknown	12222/udp	0.000330
unknown	12225/tcp	0.000076
unknown	12239/udp	0.000330
unknown	12240/tcp	0.000076
unknown	12240/udp	0.000330
unknown	12243/tcp	0.000076
unknown	12247/udp	0.000330
unknown	12250/udp	0.000330
unknown	12251/tcp	0.000076
unknown	12259/udp	0.000330
unknown	12262/tcp	0.000152
unknown	12265/tcp	0.000228
unknown	12267/udp	0.000330
unknown	12268/udp	0.000661
unknown	12271/tcp	0.000076
unknown	12274/udp	0.000330
unknown	12275/tcp	0.000076
unknown	12282/udp	0.000330
unknown	12287/udp	0.000330
unknown	12296/tcp	0.000076
unknown	12302/udp	0.000330
unknown	12304/udp	0.000661
unknown	12306/udp	0.000661
unknown	12313/udp	0.000330
warehouse-sss	12321/udp	0.000661	# Warehouse Monitoring Syst SSS
unknown	12340/tcp	0.000076
unknown	12342/udp	0.000330
netbus	12345/tcp	0.000527	# NetBus backdoor trojan or Trend Micro Office Scan
netbus	12346/tcp	0.000088	# NetBus backdoor trojan
unknown	12346/udp	0.000330
unknown	12352/udp	0.000330
unknown	12357/udp	0.000330
unknown	12361/udp	0.000330
unknown	12369/udp	0.000330
unknown	12374/udp	0.000330
unknown	12375/udp	0.000330
unknown	12376/udp	0.000330
unknown	12378/udp	0.000330
unknown	12380/tcp	0.000152
unknown	12397/udp	0.000330
unknown	12400/udp	0.000330
unknown	12401/udp	0.000330
unknown	12406/udp	0.000330
unknown	12414/tcp	0.000076
unknown	12432/udp	0.000330
unknown	12434/udp	0.000330
unknown	12435/udp	0.000330
unknown	12444/udp	0.000330
unknown	12447/udp	0.000661
unknown	12449/udp	0.000330
unknown	12452/tcp	0.000152
unknown	12459/udp	0.000330
unknown	12469/udp	0.000661
unknown	12472/udp	0.000661
unknown	12473/udp	0.000330
unknown	12478/udp	0.000330
unknown	12480/udp	0.000330
unknown	12484/udp	0.000330
unknown	12496/udp	0.000330
unknown	12504/udp	0.000330
unknown	12517/udp	0.000330
unknown	12525/udp	0.000661
unknown	12534/udp	0.000330
unknown	12535/udp	0.000330
unknown	12537/udp	0.000330
unknown	12562/udp	0.000330
unknown	12568/udp	0.000330
unknown	12571/udp	0.000330
unknown	12578/udp	0.000661
unknown	12592/udp	0.000330
unknown	12593/udp	0.000330
unknown	12599/udp	0.000330
unknown	12601/udp	0.000330
unknown	12602/udp	0.000661
unknown	12604/udp	0.000330
unknown	12613/udp	0.000330
unknown	12616/udp	0.000330
unknown	12618/udp	0.000330
unknown	12622/udp	0.000330
unknown	12623/udp	0.000330
unknown	12625/udp	0.000330
unknown	12639/udp	0.000330
unknown	12640/udp	0.000330
unknown	12641/udp	0.000330
unknown	12650/udp	0.000661
unknown	12672/udp	0.000330
unknown	12682/udp	0.000330
unknown	12699/tcp	0.000076
unknown	12700/udp	0.000330
unknown	12702/tcp	0.000076
unknown	12706/udp	0.000330
unknown	12708/udp	0.000330
unknown	12712/udp	0.000330
unknown	12714/udp	0.000330
unknown	12718/udp	0.000330
unknown	12720/udp	0.000330
unknown	12730/udp	0.000330
unknown	12748/udp	0.000330
unknown	12764/udp	0.000330
unknown	12766/tcp	0.000076
unknown	12774/udp	0.000330
unknown	12775/udp	0.000330
unknown	12786/udp	0.000330
unknown	12789/udp	0.000330
unknown	12793/udp	0.000330
unknown	12796/udp	0.000330
unknown	12800/udp	0.000330
unknown	12804/udp	0.000330
unknown	12805/udp	0.000330
unknown	12807/udp	0.000330
unknown	12814/udp	0.000330
unknown	12825/udp	0.000330
unknown	12828/udp	0.000330
unknown	12836/udp	0.000330
unknown	12838/udp	0.000330
unknown	12839/udp	0.000330
unknown	12845/udp	0.000330
unknown	12854/udp	0.000661
unknown	12858/udp	0.000330
unknown	12865/tcp	0.000076
unknown	12873/udp	0.000661
unknown	12883/udp	0.000330
unknown	12889/udp	0.000330
unknown	12890/udp	0.000330
unknown	12891/tcp	0.000076
unknown	12892/tcp	0.000076
unknown	12902/udp	0.000330
unknown	12905/udp	0.000330
unknown	12906/udp	0.000330
unknown	12918/udp	0.000330
unknown	12924/udp	0.000330
unknown	12931/udp	0.000330
unknown	12933/udp	0.000661
unknown	12940/udp	0.000330
unknown	12953/udp	0.000330
unknown	12955/tcp	0.000076
unknown	12961/udp	0.000330
unknown	12962/tcp	0.000076
unknown	12964/udp	0.000330
unknown	12966/udp	0.000330
unknown	12967/udp	0.000330
unknown	12970/udp	0.000330
unknown	12972/udp	0.000330
unknown	12974/udp	0.000330
unknown	12977/udp	0.000330
unknown	12986/udp	0.000661
unknown	12991/udp	0.000661
unknown	12993/udp	0.000330
unknown	12994/udp	0.000330
unknown	12999/udp	0.000330
unknown	13000/udp	0.000330
unknown	13001/udp	0.000330
unknown	13002/udp	0.000661
unknown	13005/udp	0.000330
unknown	13010/udp	0.000330
unknown	13013/udp	0.000330
unknown	13017/tcp	0.000076
unknown	13020/udp	0.000330
unknown	13027/udp	0.000330
unknown	13046/udp	0.000330
unknown	13058/udp	0.000330
unknown	13059/udp	0.000330
unknown	13063/udp	0.000330
unknown	13064/udp	0.000330
unknown	13071/udp	0.000330
unknown	13092/udp	0.000330
unknown	13093/tcp	0.000076
unknown	13095/udp	0.000330
unknown	13098/udp	0.000330
unknown	13102/udp	0.000330
unknown	13109/udp	0.000330
unknown	13123/udp	0.000330
unknown	13130/tcp	0.000076
unknown	13132/tcp	0.000076
unknown	13134/udp	0.000330
unknown	13140/tcp	0.000076
unknown	13140/udp	0.000330
unknown	13142/tcp	0.000076
unknown	13149/tcp	0.000076
unknown	13149/udp	0.000330
unknown	13151/udp	0.000330
unknown	13155/udp	0.000661
i-zipqd	13160/udp	0.000330	# I-ZIPQD
unknown	13164/udp	0.000661
unknown	13167/tcp	0.000076
unknown	13171/udp	0.000330
unknown	13173/udp	0.000330
unknown	13188/tcp	0.000076
unknown	13189/udp	0.000330
unknown	13192/tcp	0.000076
unknown	13192/udp	0.000330
unknown	13193/tcp	0.000076
unknown	13194/tcp	0.000076
unknown	13194/udp	0.000330
unknown	13203/udp	0.000330
bcslogc	13216/udp	0.000330	# Black Crow Software application logging
unknown	13220/udp	0.000330
unknown	13222/udp	0.000330
unknown	13227/udp	0.000330
unknown	13229/tcp	0.000076
unknown	13231/udp	0.000330
unknown	13237/udp	0.000330
unknown	13238/udp	0.000330
unknown	13248/udp	0.000330
unknown	13250/tcp	0.000076
unknown	13250/udp	0.000330
unknown	13254/udp	0.000330
unknown	13261/tcp	0.000076
unknown	13264/tcp	0.000076
unknown	13265/tcp	0.000076
unknown	13265/udp	0.000330
unknown	13266/udp	0.000661
unknown	13273/udp	0.000330
unknown	13277/udp	0.000330
unknown	13280/udp	0.000330
unknown	13291/udp	0.000661
unknown	13295/udp	0.000330
unknown	13298/udp	0.000330
unknown	13299/udp	0.000661
unknown	13306/tcp	0.000076
unknown	13307/udp	0.000330
unknown	13312/udp	0.000661
unknown	13318/tcp	0.000076
unknown	13319/udp	0.000330
unknown	13323/udp	0.000330
unknown	13330/udp	0.000330
unknown	13340/tcp	0.000076
unknown	13344/udp	0.000330
unknown	13345/udp	0.000330
unknown	13347/udp	0.000330
unknown	13359/tcp	0.000076
unknown	13366/udp	0.000330
unknown	13378/udp	0.000661
unknown	13384/udp	0.000330
unknown	13387/udp	0.000330
unknown	13396/udp	0.000330
unknown	13402/udp	0.000661
unknown	13419/udp	0.000661
unknown	13420/udp	0.000330
unknown	13424/udp	0.000330
unknown	13428/udp	0.000330
unknown	13429/udp	0.000991
unknown	13445/udp	0.000330
unknown	13451/udp	0.000330
unknown	13454/udp	0.000330
unknown	13456/tcp	0.000380
unknown	13466/udp	0.000330
unknown	13469/udp	0.000330
unknown	13474/udp	0.000661
unknown	13476/udp	0.000661
unknown	13495/udp	0.000330
unknown	13499/udp	0.000330
unknown	13501/udp	0.000330
unknown	13502/tcp	0.000076
unknown	13511/udp	0.000330
unknown	13517/udp	0.000330
unknown	13520/udp	0.000330
unknown	13524/udp	0.000330
unknown	13526/udp	0.000330
unknown	13528/udp	0.000330
unknown	13534/udp	0.000330
unknown	13539/udp	0.000661
unknown	13540/udp	0.000330
unknown	13543/udp	0.000661
unknown	13552/udp	0.000661
unknown	13557/udp	0.000991
unknown	13558/udp	0.000330
unknown	13564/udp	0.000330
unknown	13565/udp	0.000330
unknown	13570/udp	0.000661
unknown	13571/udp	0.000661
unknown	13580/tcp	0.000076
unknown	13583/udp	0.000330
unknown	13584/udp	0.000330
unknown	13591/udp	0.000330
unknown	13612/udp	0.000330
unknown	13614/udp	0.000330
unknown	13620/udp	0.000330
unknown	13623/udp	0.000330
unknown	13627/udp	0.000661
unknown	13630/udp	0.000330
unknown	13641/udp	0.000330
unknown	13648/udp	0.000330
unknown	13653/udp	0.000330
unknown	13659/udp	0.000330
unknown	13661/udp	0.000330
unknown	13663/udp	0.000661
unknown	13664/udp	0.000330
unknown	13666/udp	0.000330
unknown	13667/udp	0.000330
unknown	13668/udp	0.000330
unknown	13686/udp	0.000661
unknown	13688/udp	0.000330
unknown	13691/udp	0.000330
unknown	13695/tcp	0.000076
unknown	13699/udp	0.000661
netbackup	13701/tcp	0.000013	# vmd           server
unknown	13701/udp	0.000661
unknown	13707/udp	0.000330
unknown	13712/udp	0.000330
netbackup	13713/tcp	0.000025	# tl4d          server
unknown	13713/udp	0.000330
netbackup	13714/tcp	0.000013	# tsdd          server
netbackup	13715/tcp	0.000013	# tshd          server
unknown	13716/udp	0.000330
netbackup	13718/tcp	0.000013	# lmfcd         server
netbackup	13720/tcp	0.000038	# bprd          server
netbackup	13721/tcp	0.000013	# bpdbm         server
netbackup	13722/tcp	0.000314	# bpjava-msvc   client
bpjava-msvc	13722/udp	0.000330	# BP Java MSVC Protocol
unknown	13723/tcp	0.000076
vnetd	13724/tcp	0.000152	# Veritas Network Utility
unknown	13727/udp	0.000330
unknown	13730/tcp	0.000076
unknown	13734/udp	0.000330
unknown	13742/udp	0.000330
unknown	13743/udp	0.000330
unknown	13747/udp	0.000661
unknown	13757/udp	0.000330
unknown	13760/udp	0.000330
unknown	13762/udp	0.000330
unknown	13766/tcp	0.000076
unknown	13770/udp	0.000330
unknown	13773/udp	0.000330
netbackup	13782/tcp	0.000728	# bpcd          client
netbackup	13783/tcp	0.000389	# vopied        client
unknown	13784/tcp	0.000076
unknown	13790/udp	0.000330
unknown	13799/udp	0.000661
unknown	13806/udp	0.000330
unknown	13808/udp	0.000330
unknown	13814/udp	0.000330
unknown	13835/udp	0.000330
unknown	13846/tcp	0.000076
unknown	13850/udp	0.000330
unknown	13851/udp	0.000330
unknown	13855/udp	0.000330
unknown	13856/udp	0.000661
unknown	13862/udp	0.000330
unknown	13865/udp	0.000661
unknown	13876/udp	0.000661
unknown	13881/udp	0.000330
unknown	13883/udp	0.000330
unknown	13890/udp	0.000330
unknown	13892/udp	0.000330
unknown	13899/tcp	0.000076
unknown	13900/udp	0.000330
unknown	13905/udp	0.000661
unknown	13910/udp	0.000330
unknown	13911/udp	0.000330
unknown	13913/udp	0.000330
unknown	13914/udp	0.000661
unknown	13923/udp	0.000330
unknown	13925/udp	0.000661
unknown	13931/udp	0.000330
unknown	13935/udp	0.000330
unknown	13943/udp	0.000330
unknown	13944/udp	0.000330
unknown	13950/udp	0.000330
unknown	13957/udp	0.000330
unknown	13962/udp	0.000330
unknown	13965/udp	0.000330
unknown	13967/udp	0.000330
unknown	13971/udp	0.000330
unknown	13974/udp	0.000330
unknown	13976/udp	0.000330
unknown	13977/udp	0.000330
unknown	13986/udp	0.000330
unknown	13989/udp	0.000330
unknown	13992/udp	0.000330
unknown	13996/udp	0.000330
scotty-ft	14000/tcp	0.000380	# SCOTTY High-Speed Filetransfer
sua	14001/sctp	0.000000	# SUA
sua	14001/tcp	0.000076	# SUA
unknown	14006/udp	0.000330
sage-best-com2	14034/udp	0.000330	# sage Best! Config Server 2
unknown	14035/udp	0.000330
unknown	14047/udp	0.000330
unknown	14052/udp	0.000330
unknown	14062/udp	0.000330
unknown	14063/udp	0.000330
unknown	14070/udp	0.000330
unknown	14085/udp	0.000330
unknown	14087/udp	0.000330
unknown	14094/udp	0.000330
unknown	14134/udp	0.000330
unknown	14135/udp	0.000330
bo2k	14141/tcp	0.000038	# Back Orifice 2K BoPeep mouse/keyboard input
unknown	14144/udp	0.000330
unknown	14146/udp	0.000330
unknown	14147/tcp	0.000076
unknown	14150/udp	0.000330
unknown	14151/udp	0.000330
unknown	14156/udp	0.000330
unknown	14158/udp	0.000330
unknown	14159/udp	0.000330
unknown	14162/udp	0.000330
unknown	14169/udp	0.000661
unknown	14181/udp	0.000991
unknown	14183/udp	0.000330
unknown	14188/udp	0.000330
unknown	14189/udp	0.000330
unknown	14195/udp	0.000661
unknown	14197/udp	0.000330
unknown	14202/udp	0.000661
unknown	14203/udp	0.000330
unknown	14210/udp	0.000330
unknown	14212/udp	0.000330
unknown	14215/udp	0.000330
unknown	14216/udp	0.000330
unknown	14218/tcp	0.000076
unknown	14219/udp	0.000330
unknown	14220/udp	0.000661
unknown	14229/udp	0.000330
unknown	14232/udp	0.000330
unknown	14233/udp	0.000330
unknown	14235/udp	0.000330
unknown	14237/tcp	0.000076
unknown	14238/tcp	0.000532
unknown	14241/udp	0.000661
unknown	14245/udp	0.000330
unknown	14246/udp	0.000330
unknown	14247/udp	0.000330
unknown	14252/udp	0.000330
unknown	14254/tcp	0.000076
unknown	14281/udp	0.000661
unknown	14284/udp	0.000330
unknown	14286/udp	0.000661
unknown	14290/udp	0.000661
unknown	14295/udp	0.000330
unknown	14305/udp	0.000330
unknown	14309/udp	0.000330
unknown	14310/udp	0.000330
unknown	14327/udp	0.000330
unknown	14334/udp	0.000330
unknown	14339/udp	0.000330
unknown	14341/udp	0.000661
unknown	14343/udp	0.000330
unknown	14346/udp	0.000330
unknown	14356/udp	0.000661
unknown	14360/udp	0.000330
unknown	14361/udp	0.000330
unknown	14368/udp	0.000330
unknown	14370/udp	0.000330
unknown	14373/udp	0.000330
unknown	14385/udp	0.000330
unknown	14388/udp	0.000661
unknown	14395/udp	0.000330
unknown	14403/udp	0.000330
unknown	14404/udp	0.000330
unknown	14405/udp	0.000330
unknown	14413/udp	0.000330
unknown	14418/tcp	0.000076
unknown	14425/udp	0.000330
unknown	14428/udp	0.000330
unknown	14429/udp	0.000330
unknown	14441/tcp	0.000228
unknown	14442/tcp	0.000380
unknown	14443/tcp	0.000076
unknown	14444/tcp	0.000076
unknown	14446/udp	0.000330
unknown	14457/udp	0.000330
unknown	14458/udp	0.000330
unknown	14472/udp	0.000330
unknown	14476/udp	0.000330
unknown	14481/udp	0.000330
unknown	14487/udp	0.000661
unknown	14488/udp	0.000330
unknown	14494/udp	0.000330
unknown	14499/udp	0.000991
unknown	14507/udp	0.000330
unknown	14512/udp	0.000330
unknown	14513/udp	0.000330
unknown	14524/udp	0.000330
unknown	14527/udp	0.000330
unknown	14532/udp	0.000330
unknown	14534/tcp	0.000076
unknown	14535/udp	0.000330
unknown	14536/udp	0.000330
unknown	14538/udp	0.000330
unknown	14545/tcp	0.000076
unknown	14570/udp	0.000330
unknown	14575/udp	0.000330
unknown	14578/udp	0.000330
unknown	14589/udp	0.000330
unknown	14595/udp	0.000330
unknown	14600/udp	0.000330
unknown	14604/udp	0.000330
unknown	14614/udp	0.000330
unknown	14616/udp	0.000330
unknown	14622/udp	0.000330
unknown	14632/udp	0.000330
unknown	14634/udp	0.000330
unknown	14637/udp	0.000330
unknown	14644/udp	0.000330
unknown	14651/udp	0.000330
unknown	14664/udp	0.000330
unknown	14665/udp	0.000330
unknown	14668/udp	0.000330
unknown	14670/udp	0.000330
unknown	14671/udp	0.000330
unknown	14672/udp	0.000330
unknown	14679/udp	0.000661
unknown	14687/udp	0.000330
unknown	14693/tcp	0.000076
unknown	14693/udp	0.000330
unknown	14700/udp	0.000330
unknown	14701/udp	0.000330
unknown	14719/udp	0.000330
unknown	14720/udp	0.000330
unknown	14725/udp	0.000330
unknown	14726/udp	0.000330
unknown	14732/udp	0.000330
unknown	14733/tcp	0.000076
unknown	14749/udp	0.000330
unknown	14753/udp	0.000330
unknown	14756/udp	0.000330
unknown	14771/udp	0.000661
unknown	14777/udp	0.000330
unknown	14783/udp	0.000330
unknown	14790/udp	0.000330
unknown	14799/udp	0.000330
unknown	14808/udp	0.000661
unknown	14822/udp	0.000330
unknown	14827/tcp	0.000076
unknown	14834/udp	0.000330
unknown	14837/udp	0.000330
unknown	14858/udp	0.000330
unknown	14864/udp	0.000330
unknown	14875/udp	0.000330
unknown	14882/udp	0.000330
unknown	14888/udp	0.000330
unknown	14889/udp	0.000661
unknown	14891/tcp	0.000076
unknown	14892/udp	0.000330
unknown	14916/tcp	0.000076
unknown	14916/udp	0.000330
unknown	14922/udp	0.000661
unknown	14928/udp	0.000330
unknown	14934/udp	0.000330
hde-lcesrvr-2	14937/udp	0.000661
unknown	14944/udp	0.000330
unknown	14946/udp	0.000661
unknown	14959/udp	0.000330
unknown	14964/udp	0.000330
unknown	14966/udp	0.000330
unknown	14972/udp	0.000330
unknown	14978/udp	0.000330
unknown	14982/udp	0.000330
unknown	14991/udp	0.000661
unknown	14998/udp	0.000330
hydap	15000/tcp	0.001064	# Hypack Hydrographic Software Packages Data Acquisition
unknown	15001/tcp	0.000152
unknown	15002/tcp	0.000380
unknown	15003/tcp	0.000380
unknown	15003/udp	0.000330
unknown	15004/tcp	0.000228
unknown	15005/tcp	0.000076
unknown	15006/udp	0.000330
unknown	15009/udp	0.000330
unknown	15015/udp	0.000330
unknown	15022/udp	0.000330
unknown	15041/udp	0.000661
unknown	15044/udp	0.000330
unknown	15050/tcp	0.000076
unknown	15053/udp	0.000991
unknown	15055/udp	0.000661
unknown	15057/udp	0.000330
unknown	15058/udp	0.000330
unknown	15067/udp	0.000661
unknown	15085/udp	0.000330
unknown	15086/udp	0.000661
unknown	15093/udp	0.000330
unknown	15100/udp	0.000330
unknown	15107/udp	0.000330
unknown	15109/udp	0.000330
unknown	15117/udp	0.000330
unknown	15118/udp	0.000330
unknown	15122/udp	0.000330
unknown	15123/udp	0.000661
unknown	15124/udp	0.000661
unknown	15125/udp	0.000330
unknown	15131/udp	0.000330
unknown	15133/udp	0.000330
unknown	15138/udp	0.000991
unknown	15141/udp	0.000330
unknown	15145/tcp	0.000076
unknown	15147/udp	0.000330
unknown	15149/udp	0.000661
bo2k	15151/tcp	0.000013	# Back Orifice 2K BoPeep video output
unknown	15172/udp	0.000330
unknown	15173/udp	0.000330
unknown	15179/udp	0.000330
unknown	15184/udp	0.000330
unknown	15186/udp	0.000661
unknown	15189/udp	0.000330
unknown	15190/tcp	0.000076
unknown	15191/tcp	0.000076
unknown	15199/udp	0.000330
unknown	15200/udp	0.000330
unknown	15214/udp	0.000330
unknown	15220/udp	0.000330
unknown	15222/udp	0.000330
unknown	15230/udp	0.000330
unknown	15239/udp	0.000330
unknown	15240/udp	0.000330
unknown	15242/udp	0.000330
unknown	15243/udp	0.000330
unknown	15251/udp	0.000330
unknown	15260/udp	0.000330
unknown	15265/udp	0.000330
unknown	15267/udp	0.000661
unknown	15274/udp	0.000330
unknown	15275/tcp	0.000076
unknown	15277/udp	0.000330
unknown	15283/udp	0.000330
unknown	15284/udp	0.000330
unknown	15286/udp	0.000330
unknown	15288/udp	0.000330
unknown	15290/udp	0.000661
unknown	15293/udp	0.000330
unknown	15295/udp	0.000330
unknown	15298/udp	0.000330
unknown	15300/udp	0.000330
unknown	15302/udp	0.000330
unknown	15308/udp	0.000330
unknown	15311/udp	0.000330
unknown	15317/tcp	0.000076
unknown	15328/udp	0.000330
unknown	15336/udp	0.000330
unknown	15344/tcp	0.000076
unknown	15350/udp	0.000330
unknown	15359/udp	0.000330
unknown	15360/udp	0.000661
unknown	15361/udp	0.000661
3link	15363/udp	0.000330	# 3Link Negotiation
unknown	15367/udp	0.000330
unknown	15374/udp	0.000330
unknown	15375/udp	0.000330
unknown	15377/udp	0.000330
unknown	15381/udp	0.000661
unknown	15389/udp	0.000330
unknown	15395/udp	0.000330
unknown	15402/tcp	0.000152
unknown	15419/udp	0.000330
unknown	15422/udp	0.000330
unknown	15444/udp	0.000330
unknown	15448/tcp	0.000076
unknown	15448/udp	0.000330
unknown	15449/udp	0.000661
unknown	15468/udp	0.000330
unknown	15473/udp	0.000330
unknown	15477/udp	0.000330
unknown	15479/udp	0.000330
unknown	15483/udp	0.000330
unknown	15491/udp	0.000330
unknown	15506/udp	0.000330
unknown	15507/udp	0.000330
unknown	15509/udp	0.000330
unknown	15514/udp	0.000661
unknown	15519/udp	0.000330
unknown	15524/udp	0.000330
unknown	15529/udp	0.000330
unknown	15536/udp	0.000330
unknown	15540/udp	0.000330
unknown	15549/udp	0.000330
unknown	15550/tcp	0.000076
unknown	15559/udp	0.000330
unknown	15563/udp	0.000330
unknown	15572/udp	0.000330
unknown	15589/udp	0.000330
unknown	15606/udp	0.000330
unknown	15610/udp	0.000330
unknown	15616/udp	0.000330
unknown	15617/udp	0.000330
unknown	15621/udp	0.000661
unknown	15625/udp	0.000330
unknown	15631/tcp	0.000076
unknown	15635/udp	0.000330
unknown	15645/tcp	0.000076
unknown	15646/tcp	0.000076
unknown	15648/udp	0.000661
unknown	15649/udp	0.000330
unknown	15657/udp	0.000330
bex-xr	15660/tcp	0.000380	# Backup Express Restore Server
unknown	15670/tcp	0.000076
unknown	15670/udp	0.000330
unknown	15677/tcp	0.000076
unknown	15677/udp	0.000330
unknown	15687/udp	0.000330
unknown	15696/udp	0.000330
unknown	15698/udp	0.000330
unknown	15701/udp	0.000330
unknown	15704/udp	0.000330
unknown	15711/udp	0.000330
unknown	15718/udp	0.000330
unknown	15722/tcp	0.000076
unknown	15722/udp	0.000330
unknown	15730/tcp	0.000076
unknown	15733/udp	0.000661
unknown	15735/udp	0.000330
unknown	15742/tcp	0.000304
unknown	15749/udp	0.000330
unknown	15752/udp	0.000330
unknown	15754/udp	0.000661
unknown	15758/tcp	0.000076
unknown	15777/udp	0.000330
unknown	15782/udp	0.000330
unknown	15785/udp	0.000330
unknown	15798/udp	0.000330
unknown	15803/udp	0.000661
unknown	15804/udp	0.000330
unknown	15811/udp	0.000330
unknown	15814/udp	0.000661
unknown	15816/udp	0.000330
unknown	15829/udp	0.000330
unknown	15831/udp	0.000661
unknown	15833/udp	0.000330
unknown	15840/udp	0.000330
unknown	15846/udp	0.000330
unknown	15854/udp	0.000330
unknown	15871/udp	0.000330
unknown	15888/udp	0.000330
unknown	15891/udp	0.000330
unknown	15894/udp	0.000330
unknown	15895/udp	0.000330
unknown	15900/udp	0.000330
unknown	15915/tcp	0.000076
unknown	15916/udp	0.000330
unknown	15917/udp	0.000330
unknown	15934/udp	0.000330
unknown	15950/udp	0.000330
unknown	15953/udp	0.000330
unknown	15955/udp	0.000330
unknown	15960/udp	0.000330
unknown	15966/udp	0.000661
unknown	15969/udp	0.000661
unknown	15999/udp	0.000330
fmsas	16000/tcp	0.000228	# Administration Server Access
fmsascon	16001/tcp	0.000380	# Administration Server Connector
unknown	16012/tcp	0.000304
unknown	16013/udp	0.000330
unknown	16016/tcp	0.000380
unknown	16018/tcp	0.000380
unknown	16023/udp	0.000330
unknown	16027/udp	0.000330
unknown	16030/udp	0.000330
unknown	16031/udp	0.000330
unknown	16035/udp	0.000330
unknown	16045/udp	0.000330
unknown	16046/udp	0.000330
unknown	16048/tcp	0.000076
unknown	16055/udp	0.000330
unknown	16057/udp	0.000330
unknown	16062/udp	0.000330
unknown	16066/udp	0.000661
unknown	16067/udp	0.000330
unknown	16072/udp	0.000330
osxwebadmin	16080/tcp	0.000251	# Apple OS X WebAdmin
unknown	16080/udp	0.000330
unknown	16085/udp	0.000330
unknown	16086/udp	0.001321
unknown	16094/udp	0.000330
unknown	16098/udp	0.000330
unknown	16100/udp	0.000330
unknown	16103/udp	0.000330
unknown	16108/udp	0.000661
unknown	16109/udp	0.000330
unknown	16113/tcp	0.000228
unknown	16113/udp	0.000330
unknown	16115/udp	0.000330
unknown	16116/udp	0.000330
unknown	16121/udp	0.000330
unknown	16122/udp	0.000330
unknown	16130/udp	0.000330
unknown	16134/udp	0.000330
unknown	16139/udp	0.000330
unknown	16141/udp	0.000330
unknown	16155/udp	0.000661
unknown	16159/udp	0.000661
sun-sea-port	16161/tcp	0.000076	# Solaris SEA Port
unknown	16163/udp	0.000330
unknown	16178/udp	0.000330
unknown	16187/udp	0.000330
unknown	16189/udp	0.000330
unknown	16195/udp	0.000330
unknown	16208/udp	0.000330
unknown	16209/udp	0.000330
unknown	16210/udp	0.000330
unknown	16212/udp	0.000330
unknown	16222/udp	0.000330
unknown	16226/udp	0.000661
unknown	16228/udp	0.000330
unknown	16231/udp	0.000330
unknown	16233/udp	0.000330
unknown	16241/udp	0.000330
unknown	16242/udp	0.000330
unknown	16257/udp	0.000330
unknown	16262/udp	0.000330
unknown	16263/udp	0.000661
unknown	16268/udp	0.000330
unknown	16270/tcp	0.000076
unknown	16273/tcp	0.000076
unknown	16273/udp	0.000330
unknown	16283/tcp	0.000076
unknown	16283/udp	0.000330
unknown	16286/tcp	0.000076
unknown	16289/udp	0.000330
unknown	16297/tcp	0.000076
unknown	16297/udp	0.000330
unknown	16298/udp	0.000330
unknown	16306/udp	0.000330
unknown	16312/udp	0.000661
unknown	16316/udp	0.000330
unknown	16326/udp	0.000330
unknown	16327/udp	0.000330
unknown	16331/udp	0.000330
unknown	16334/udp	0.000661
unknown	16342/udp	0.000330
unknown	16349/tcp	0.000076
unknown	16355/udp	0.000330
unknown	16359/udp	0.000330
netserialext2	16361/udp	0.000330	# Network Serial Extension Ports Two
unknown	16372/tcp	0.000076
unknown	16376/udp	0.000330
unknown	16378/udp	0.000330
unknown	16382/udp	0.000330
unknown	16386/udp	0.000654
unknown	16387/udp	0.000654
unknown	16390/udp	0.000654
unknown	16392/udp	0.000654
unknown	16395/udp	0.000654
unknown	16398/udp	0.000654
unknown	16400/udp	0.000654
unknown	16402/udp	0.001961
unknown	16403/udp	0.000654
unknown	16405/udp	0.000654
unknown	16410/udp	0.000654
unknown	16413/udp	0.000654
unknown	16416/udp	0.000654
unknown	16420/udp	0.001307
unknown	16421/udp	0.000654
unknown	16424/udp	0.000654
unknown	16429/udp	0.000654
unknown	16430/udp	0.001961
unknown	16431/udp	0.000654
unknown	16433/udp	0.001307
unknown	16435/udp	0.000654
unknown	16439/udp	0.000654
unknown	16441/udp	0.000654
overnet	16444/tcp	0.000025	# Overnet file sharing
overnet	16444/udp	0.000726	# Overnet file sharing
unknown	16449/udp	0.001307
unknown	16452/udp	0.000654
unknown	16453/udp	0.000654
unknown	16455/udp	0.000654
unknown	16462/udp	0.000654
unknown	16463/udp	0.000654
unknown	16464/tcp	0.000076
unknown	16464/udp	0.000654
unknown	16465/udp	0.000654
unknown	16469/udp	0.000654
unknown	16470/udp	0.000654
unknown	16475/udp	0.000654
unknown	16476/udp	0.000654
unknown	16480/udp	0.000654
unknown	16482/udp	0.000654
unknown	16484/udp	0.000654
unknown	16496/udp	0.000654
unknown	16497/udp	0.000654
unknown	16498/udp	0.001307
unknown	16502/udp	0.000654
unknown	16503/udp	0.001307
unknown	16512/udp	0.000654
unknown	16518/udp	0.000654
unknown	16521/udp	0.000654
unknown	16527/udp	0.000654
unknown	16532/udp	0.000654
unknown	16536/udp	0.000654
unknown	16537/udp	0.000654
unknown	16540/udp	0.000654
unknown	16541/udp	0.000654
unknown	16542/udp	0.000654
unknown	16545/udp	0.001307
unknown	16548/udp	0.001307
unknown	16552/udp	0.000654
unknown	16555/udp	0.000654
unknown	16556/udp	0.000654
unknown	16557/udp	0.000654
unknown	16562/udp	0.000654
unknown	16564/udp	0.000654
unknown	16565/udp	0.000654
unknown	16570/udp	0.000654
unknown	16573/udp	0.001307
unknown	16577/udp	0.000654
unknown	16578/udp	0.000654
unknown	16581/udp	0.000654
unknown	16582/udp	0.000654
unknown	16585/udp	0.000654
unknown	16596/udp	0.000654
unknown	16597/udp	0.000654
unknown	16601/udp	0.000654
unknown	16606/udp	0.000654
unknown	16607/udp	0.000654
unknown	16609/udp	0.000654
unknown	16611/udp	0.000654
unknown	16613/udp	0.000654
unknown	16618/udp	0.000654
unknown	16619/udp	0.000654
unknown	16620/udp	0.000654
unknown	16623/udp	0.000654
unknown	16624/udp	0.000654
unknown	16633/udp	0.000654
unknown	16641/udp	0.000654
unknown	16648/udp	0.000654
unknown	16649/udp	0.000654
unknown	16654/udp	0.000654
unknown	16669/udp	0.000654
unknown	16671/udp	0.000654
unknown	16673/udp	0.000654
unknown	16674/udp	0.001307
unknown	16676/udp	0.000654
unknown	16680/udp	0.003268
unknown	16684/udp	0.000654
unknown	16686/udp	0.000654
unknown	16696/udp	0.000654
unknown	16697/udp	0.001307
unknown	16700/udp	0.001307
unknown	16704/udp	0.000654
unknown	16705/tcp	0.000152
unknown	16708/udp	0.001307
unknown	16709/udp	0.000654
unknown	16711/udp	0.001307
unknown	16714/udp	0.000654
unknown	16716/udp	0.000654
unknown	16719/udp	0.000654
unknown	16723/tcp	0.000076
unknown	16723/udp	0.000654
unknown	16724/tcp	0.000076
unknown	16725/tcp	0.000076
unknown	16728/udp	0.000654
unknown	16731/udp	0.000654
unknown	16732/udp	0.000654
unknown	16736/udp	0.000654
unknown	16739/udp	0.001307
unknown	16742/udp	0.000654
unknown	16743/udp	0.000654
unknown	16746/udp	0.000654
unknown	16747/udp	0.000654
unknown	16748/udp	0.000654
unknown	16749/udp	0.000654
unknown	16754/udp	0.000654
unknown	16761/udp	0.000654
unknown	16762/udp	0.000654
unknown	16766/udp	0.001307
unknown	16768/udp	0.000654
unknown	16779/udp	0.001307
unknown	16786/udp	0.001307
unknown	16787/udp	0.000654
unknown	16788/udp	0.000654
unknown	16789/udp	0.000654
unknown	16791/udp	0.000654
unknown	16795/udp	0.000654
unknown	16797/tcp	0.000076
unknown	16797/udp	0.000654
unknown	16800/tcp	0.000152
unknown	16806/udp	0.000654
unknown	16816/udp	0.001307
unknown	16824/udp	0.000654
unknown	16828/udp	0.000654
unknown	16829/udp	0.001307
unknown	16832/udp	0.002614
unknown	16838/udp	0.001307
unknown	16839/udp	0.001307
unknown	16845/tcp	0.000076
unknown	16849/udp	0.000654
unknown	16851/tcp	0.000152
unknown	16851/udp	0.000654
unknown	16862/udp	0.001307
unknown	16864/udp	0.000654
unknown	16875/udp	0.000654
unknown	16877/udp	0.000654
unknown	16879/udp	0.000654
unknown	16888/udp	0.000654
unknown	16890/udp	0.000654
unknown	16892/udp	0.000654
unknown	16896/udp	0.001307
unknown	16897/udp	0.000654
newbay-snc-mc	16900/tcp	0.000076	# Newbay Mobile Client Update Service
unknown	16901/tcp	0.000076
unknown	16908/udp	0.000654
unknown	16912/udp	0.001307
unknown	16913/udp	0.000654
unknown	16918/udp	0.001961
unknown	16919/udp	0.001307
unknown	16921/udp	0.000654
unknown	16924/udp	0.000654
unknown	16926/udp	0.000654
unknown	16937/udp	0.000654
unknown	16938/udp	0.001307
unknown	16939/udp	0.001307
unknown	16944/udp	0.000654
unknown	16946/udp	0.000654
unknown	16947/udp	0.002614
unknown	16948/udp	0.001307
unknown	16951/udp	0.000654
unknown	16954/udp	0.000654
unknown	16955/udp	0.000654
unknown	16957/udp	0.000654
unknown	16968/udp	0.000654
unknown	16970/udp	0.001307
unknown	16971/udp	0.000654
unknown	16972/udp	0.001307
unknown	16974/udp	0.001307
unknown	16976/udp	0.000654
unknown	16985/udp	0.000654
unknown	16990/udp	0.000654
amt-soap-http	16992/tcp	0.000760	# Intel(R) AMT SOAP/HTTP
amt-soap-https	16993/tcp	0.000760	# Intel(R) AMT SOAP/HTTPS
unknown	16997/udp	0.000654
unknown	17001/udp	0.000654
unknown	17003/udp	0.000654
unknown	17005/udp	0.000654
unknown	17006/udp	0.001307
isode-dua	17007/tcp	0.000013
isode-dua	17007/udp	0.000591
unknown	17010/udp	0.000654
unknown	17011/udp	0.000654
unknown	17012/udp	0.000654
unknown	17016/tcp	0.000076
unknown	17017/tcp	0.000076
unknown	17018/udp	0.001307
unknown	17023/udp	0.000654
unknown	17028/udp	0.000654
unknown	17032/udp	0.000654
unknown	17046/udp	0.000654
unknown	17048/udp	0.000654
unknown	17049/udp	0.000654
unknown	17053/udp	0.000654
unknown	17054/udp	0.000654
unknown	17061/udp	0.000654
unknown	17063/udp	0.000654
unknown	17064/udp	0.000654
unknown	17065/udp	0.000654
unknown	17068/udp	0.000654
unknown	17070/tcp	0.000076
unknown	17077/udp	0.001307
unknown	17082/udp	0.000654
unknown	17083/udp	0.000654
unknown	17089/tcp	0.000076
unknown	17091/udp	0.001961
unknown	17093/udp	0.000654
unknown	17095/udp	0.000654
unknown	17101/udp	0.001307
unknown	17108/udp	0.000654
unknown	17115/udp	0.000654
unknown	17126/udp	0.000654
unknown	17129/tcp	0.000076
unknown	17133/udp	0.000654
unknown	17137/udp	0.000654
unknown	17143/udp	0.000654
unknown	17145/udp	0.000654
unknown	17146/udp	0.001307
unknown	17147/udp	0.000654
unknown	17151/udp	0.000654
unknown	17153/udp	0.000654
unknown	17161/udp	0.000654
unknown	17172/udp	0.000654
unknown	17174/udp	0.000654
unknown	17179/udp	0.000654
unknown	17182/udp	0.000654
unknown	17184/udp	0.001307
wdbrpc	17185/udp	0.013395	# vxWorks WDB remote debugging ONCRPC
unknown	17188/udp	0.000654
unknown	17189/udp	0.000654
unknown	17190/udp	0.000654
unknown	17195/udp	0.000654
unknown	17199/udp	0.000654
unknown	17203/udp	0.000654
unknown	17205/udp	0.001307
unknown	17207/udp	0.001307
unknown	17212/udp	0.000654
unknown	17213/udp	0.000654
unknown	17216/udp	0.000654
chipper	17219/udp	0.001307	# Chipper
unknown	17220/udp	0.000654
unknown	17224/udp	0.000654
unknown	17225/udp	0.000654
unknown	17229/udp	0.000654
ssh-mgmt	17235/udp	0.000654	# SSH Tectia Manager
unknown	17236/udp	0.001307
unknown	17237/udp	0.001307
unknown	17245/udp	0.000654
unknown	17246/udp	0.000654
unknown	17249/udp	0.000654
unknown	17251/tcp	0.000076
unknown	17252/udp	0.000654
unknown	17255/tcp	0.000076
unknown	17263/udp	0.000654
unknown	17264/udp	0.000654
unknown	17265/udp	0.000654
unknown	17269/udp	0.000654
unknown	17272/udp	0.000654
unknown	17273/udp	0.000654
unknown	17275/udp	0.000654
unknown	17281/udp	0.000654
unknown	17282/udp	0.001307
unknown	17284/udp	0.000654
unknown	17286/udp	0.000654
unknown	17295/udp	0.000654
unknown	17297/udp	0.000654
unknown	17299/udp	0.000654
kuang2	17300/tcp	0.000013	# Kuang2 backdoor
unknown	17300/udp	0.000654
unknown	17302/udp	0.001307
unknown	17313/udp	0.000654
unknown	17320/udp	0.000654
unknown	17321/udp	0.001307
unknown	17324/udp	0.000654
unknown	17331/udp	0.001307
unknown	17332/udp	0.001307
unknown	17336/udp	0.000654
unknown	17338/udp	0.001307
unknown	17340/udp	0.000654
unknown	17341/udp	0.000654
unknown	17342/udp	0.000654
unknown	17343/udp	0.000654
unknown	17344/udp	0.000654
unknown	17348/udp	0.000654
unknown	17350/udp	0.000654
unknown	17354/udp	0.000654
unknown	17359/udp	0.001307
unknown	17372/udp	0.000654
unknown	17376/udp	0.000654
unknown	17378/udp	0.000654
unknown	17389/udp	0.000654
unknown	17393/udp	0.000654
unknown	17394/udp	0.000654
unknown	17396/udp	0.000654
unknown	17397/udp	0.000654
unknown	17401/udp	0.000654
unknown	17406/udp	0.000654
unknown	17407/udp	0.000654
unknown	17409/tcp	0.000076
unknown	17409/udp	0.000654
unknown	17412/udp	0.000654
unknown	17413/tcp	0.000076
unknown	17417/udp	0.001307
unknown	17418/udp	0.000654
unknown	17423/udp	0.001307
unknown	17424/udp	0.001307
unknown	17444/udp	0.000654
unknown	17445/udp	0.000654
unknown	17449/udp	0.000654
unknown	17455/udp	0.001961
unknown	17459/udp	0.001961
unknown	17468/udp	0.001307
unknown	17475/udp	0.000654
unknown	17477/udp	0.000654
unknown	17479/udp	0.000654
unknown	17482/udp	0.000654
unknown	17484/udp	0.000654
unknown	17487/udp	0.001307
unknown	17488/udp	0.000654
unknown	17490/udp	0.001307
unknown	17491/udp	0.000654
unknown	17492/udp	0.000654
unknown	17493/udp	0.000654
unknown	17494/udp	0.001307
unknown	17495/udp	0.000654
unknown	17499/udp	0.000654
db-lsp	17500/tcp	0.000076	# Dropbox LanSync Protocol
unknown	17501/udp	0.000654
unknown	17505/udp	0.001307
unknown	17511/udp	0.000654
unknown	17514/udp	0.000654
unknown	17519/udp	0.000654
unknown	17520/udp	0.000654
unknown	17526/udp	0.000654
unknown	17528/udp	0.000654
unknown	17533/udp	0.001307
unknown	17534/udp	0.000654
unknown	17546/udp	0.000654
unknown	17548/udp	0.000654
unknown	17549/udp	0.001307
unknown	17550/udp	0.000654
unknown	17553/udp	0.000654
unknown	17559/udp	0.000654
unknown	17563/udp	0.000654
unknown	17566/udp	0.000654
unknown	17567/udp	0.000654
unknown	17573/udp	0.001961
unknown	17580/udp	0.001307
unknown	17585/udp	0.001307
unknown	17586/udp	0.000654
unknown	17587/udp	0.000654
unknown	17592/udp	0.001307
unknown	17594/udp	0.000654
unknown	17595/tcp	0.000152
unknown	17599/udp	0.000654
unknown	17605/udp	0.001307
unknown	17607/udp	0.000654
unknown	17609/udp	0.000654
unknown	17610/udp	0.000654
unknown	17614/udp	0.000654
unknown	17615/udp	0.001961
unknown	17616/udp	0.001961
unknown	17618/udp	0.000654
unknown	17627/udp	0.000654
unknown	17629/udp	0.001307
unknown	17635/udp	0.000654
unknown	17638/udp	0.001307
unknown	17644/udp	0.000654
unknown	17645/udp	0.000654
unknown	17650/udp	0.000654
unknown	17654/udp	0.000654
unknown	17658/udp	0.000654
unknown	17663/udp	0.001307
unknown	17667/udp	0.000654
unknown	17668/udp	0.000654
unknown	17669/udp	0.000654
unknown	17673/udp	0.001307
unknown	17674/udp	0.001307
unknown	17675/udp	0.000654
unknown	17679/udp	0.000654
unknown	17680/udp	0.000654
unknown	17682/udp	0.000654
unknown	17683/udp	0.001307
unknown	17688/udp	0.000654
unknown	17693/udp	0.000654
unknown	17696/udp	0.000654
unknown	17698/udp	0.000654
unknown	17700/tcp	0.000076
unknown	17700/udp	0.000654
unknown	17701/tcp	0.000076
unknown	17701/udp	0.000654
unknown	17702/tcp	0.000076
unknown	17707/udp	0.000654
unknown	17712/udp	0.000654
unknown	17713/udp	0.000654
unknown	17715/tcp	0.000076
unknown	17720/udp	0.000654
unknown	17726/udp	0.001307
unknown	17731/udp	0.000654
unknown	17734/udp	0.000654
unknown	17735/udp	0.000654
unknown	17737/udp	0.000654
unknown	17739/udp	0.000654
unknown	17740/udp	0.000654
unknown	17748/udp	0.000654
zep	17754/udp	0.001307	# Encap. ZigBee Packets
zigbee-ip	17755/udp	0.000654	# ZigBee IP Transport Service
zigbee-ips	17756/udp	0.000654	# ZigBee IP Transport Secure Service
unknown	17757/udp	0.000654
unknown	17762/udp	0.001307
unknown	17766/udp	0.000654
unknown	17769/udp	0.000654
unknown	17770/udp	0.000654
unknown	17775/udp	0.000654
unknown	17778/udp	0.000654
unknown	17787/udp	0.001307
unknown	17788/udp	0.000654
unknown	17796/udp	0.000654
unknown	17798/udp	0.000654
unknown	17800/udp	0.000654
unknown	17801/tcp	0.000076
unknown	17802/tcp	0.000076
unknown	17814/udp	0.001307
unknown	17816/udp	0.000654
unknown	17818/udp	0.000654
unknown	17820/udp	0.000654
unknown	17823/udp	0.001307
unknown	17824/udp	0.001307
unknown	17828/udp	0.000654
unknown	17836/udp	0.001307
unknown	17837/udp	0.000654
unknown	17845/udp	0.001307
unknown	17848/udp	0.000654
unknown	17849/udp	0.000654
unknown	17852/udp	0.000654
unknown	17860/tcp	0.000076
unknown	17863/udp	0.000654
unknown	17865/udp	0.000654
unknown	17866/udp	0.000654
unknown	17867/tcp	0.000076
unknown	17867/udp	0.000654
unknown	17877/tcp	0.000228
unknown	17880/udp	0.000654
unknown	17883/udp	0.000654
unknown	17885/udp	0.000654
unknown	17886/udp	0.000654
unknown	17887/udp	0.000654
unknown	17888/udp	0.001961
unknown	17889/udp	0.000654
unknown	17893/udp	0.000654
unknown	17895/udp	0.000654
unknown	17899/udp	0.000654
unknown	17900/udp	0.000654
unknown	17901/udp	0.000654
unknown	17903/udp	0.000654
unknown	17905/udp	0.000654
unknown	17924/udp	0.000654
unknown	17931/udp	0.000654
unknown	17939/udp	0.001961
unknown	17943/udp	0.000654
unknown	17946/udp	0.001307
unknown	17950/udp	0.000654
unknown	17953/udp	0.000654
unknown	17964/udp	0.000654
unknown	17966/udp	0.000654
unknown	17969/tcp	0.000076
unknown	17982/udp	0.000654
unknown	17985/tcp	0.000076
unknown	17987/udp	0.000654
unknown	17988/tcp	0.000380
unknown	17988/udp	0.000654
unknown	17989/udp	0.001961
unknown	17993/udp	0.000654
unknown	17996/udp	0.000654
unknown	17997/tcp	0.000076
biimenu	18000/tcp	0.000138	# Beckman Instruments, Inc.
biimenu	18000/udp	0.000541	# Beckman Instruments, Inc.
unknown	18003/udp	0.000654
unknown	18004/udp	0.001961
unknown	18005/udp	0.000654
unknown	18012/tcp	0.000076
unknown	18012/udp	0.000654
unknown	18013/udp	0.000654
unknown	18015/tcp	0.000076
unknown	18018/tcp	0.000152
unknown	18021/udp	0.000654
unknown	18023/udp	0.000654
unknown	18025/udp	0.000654
unknown	18038/udp	0.000654
unknown	18040/tcp	0.000228
unknown	18042/udp	0.000654
unknown	18052/udp	0.000654
unknown	18053/udp	0.000654
unknown	18066/udp	0.000654
unknown	18069/udp	0.000654
unknown	18074/udp	0.000654
unknown	18075/udp	0.000654
unknown	18080/tcp	0.000076
unknown	18081/udp	0.001307
unknown	18088/udp	0.000654
unknown	18089/udp	0.000654
unknown	18093/udp	0.000654
unknown	18097/udp	0.000654
unknown	18098/udp	0.000654
unknown	18100/udp	0.000654
unknown	18101/tcp	0.000228
unknown	18103/udp	0.000654
unknown	18113/udp	0.001307
unknown	18117/udp	0.000654
unknown	18120/udp	0.000654
unknown	18130/udp	0.000654
unknown	18131/udp	0.000654
unknown	18134/udp	0.001307
unknown	18136/udp	0.000654
unknown	18145/udp	0.000654
unknown	18148/tcp	0.000076
unknown	18150/udp	0.000654
unknown	18154/udp	0.000654
unknown	18156/udp	0.001307
unknown	18161/udp	0.000654
unknown	18163/udp	0.000654
unknown	18164/udp	0.000654
unknown	18165/udp	0.000654
unknown	18166/udp	0.000654
unknown	18174/udp	0.000654
unknown	18179/udp	0.000654
opsec-cvp	18181/tcp	0.000025	# Check Point OPSEC
opsec-ufp	18182/tcp	0.000038	# Check Point OPSEC
opsec-ufp	18182/udp	0.000654	# OPSEC UFP
opsec-sam	18183/tcp	0.000025	# Check Point OPSEC
opsec-sam	18183/udp	0.000654	# OPSEC SAM
opsec-lea	18184/tcp	0.000038	# Check Point OPSEC
opsec-ela	18187/tcp	0.000013	# Check Point OPSEC
unknown	18189/udp	0.000654
unknown	18193/udp	0.000654
unknown	18202/udp	0.000654
unknown	18203/udp	0.000654
unknown	18208/udp	0.000654
unknown	18214/udp	0.000654
unknown	18215/udp	0.000654
unknown	18225/udp	0.000654
unknown	18228/udp	0.001307
unknown	18231/tcp	0.000076
unknown	18231/udp	0.000654
unknown	18234/udp	0.001961
unknown	18236/udp	0.000654
unknown	18240/udp	0.000654
unknown	18250/udp	0.001307
unknown	18252/udp	0.000654
unknown	18255/udp	0.001307
unknown	18256/udp	0.000654
unknown	18258/udp	0.001307
unknown	18259/udp	0.000654
unknown	18261/udp	0.000654
gv-pf	18262/udp	0.000654	# GV NetConfig Service
unknown	18264/tcp	0.000152
unknown	18273/udp	0.000654
unknown	18275/udp	0.000654
unknown	18284/udp	0.000654
unknown	18287/udp	0.000654
unknown	18289/udp	0.000654
unknown	18296/udp	0.000654
unknown	18297/udp	0.000654
unknown	18301/udp	0.000654
unknown	18306/udp	0.000654
unknown	18308/udp	0.000654
unknown	18309/udp	0.000654
unknown	18318/udp	0.000654
unknown	18319/udp	0.001307
unknown	18323/udp	0.000654
unknown	18324/udp	0.000654
unknown	18327/udp	0.000654
unknown	18328/udp	0.000654
unknown	18331/udp	0.001961
bitcoin	18333/tcp	0.000076	# Bitcoin crypto currency - https://en.bitcoin.it/wiki/Running_Bitcoin
unknown	18336/tcp	0.000076
unknown	18337/tcp	0.000076
unknown	18343/udp	0.000654
unknown	18344/udp	0.000654
unknown	18346/udp	0.000654
unknown	18348/udp	0.000654
unknown	18354/udp	0.000654
unknown	18355/udp	0.000654
unknown	18360/udp	0.001961
unknown	18362/udp	0.000654
unknown	18365/udp	0.000654
unknown	18369/udp	0.000654
unknown	18373/udp	0.001307
unknown	18380/tcp	0.000076
unknown	18384/udp	0.000654
unknown	18393/udp	0.000654
unknown	18396/udp	0.000654
unknown	18398/udp	0.000654
unknown	18402/udp	0.000654
unknown	18415/udp	0.000654
unknown	18417/udp	0.000654
unknown	18420/udp	0.000654
unknown	18423/udp	0.000654
unknown	18428/udp	0.000654
unknown	18433/udp	0.000654
unknown	18438/udp	0.000654
unknown	18439/tcp	0.000076
unknown	18440/udp	0.000654
unknown	18446/udp	0.000654
unknown	18447/udp	0.000654
unknown	18448/udp	0.000654
unknown	18449/udp	0.002614
unknown	18456/udp	0.000654
unknown	18462/udp	0.000654
unknown	18471/udp	0.000654
unknown	18476/udp	0.000654
unknown	18477/udp	0.000654
unknown	18485/udp	0.001307
unknown	18487/udp	0.000654
unknown	18488/udp	0.000654
unknown	18493/udp	0.000654
unknown	18495/udp	0.000654
unknown	18497/udp	0.000654
unknown	18498/udp	0.000654
unknown	18501/udp	0.000654
unknown	18503/udp	0.000654
unknown	18505/tcp	0.000076
unknown	18508/udp	0.000654
unknown	18517/tcp	0.000076
unknown	18517/udp	0.000654
unknown	18525/udp	0.000654
unknown	18529/udp	0.000654
unknown	18531/udp	0.000654
unknown	18536/udp	0.000654
unknown	18543/udp	0.001307
unknown	18551/udp	0.000654
unknown	18560/udp	0.000654
unknown	18561/udp	0.000654
unknown	18564/udp	0.000654
unknown	18566/udp	0.000654
unknown	18569/tcp	0.000076
unknown	18572/udp	0.000654
unknown	18573/udp	0.000654
unknown	18577/udp	0.000654
unknown	18581/udp	0.000654
unknown	18582/udp	0.001961
unknown	18593/udp	0.000654
unknown	18605/udp	0.001307
unknown	18606/udp	0.000654
unknown	18611/udp	0.000654
unknown	18612/udp	0.000654
unknown	18615/udp	0.000654
unknown	18617/udp	0.001307
unknown	18621/udp	0.000654
unknown	18622/udp	0.000654
unknown	18623/udp	0.000654
unknown	18625/udp	0.000654
unknown	18626/udp	0.000654
unknown	18628/udp	0.000654
unknown	18630/udp	0.000654
unknown	18632/udp	0.000654
unknown	18640/udp	0.000654
unknown	18651/udp	0.000654
unknown	18652/udp	0.000654
unknown	18654/udp	0.000654
unknown	18655/udp	0.000654
unknown	18656/udp	0.000654
unknown	18666/udp	0.001307
unknown	18668/udp	0.000654
unknown	18669/tcp	0.000076
unknown	18669/udp	0.001307
unknown	18674/udp	0.000654
unknown	18676/udp	0.001307
unknown	18677/udp	0.000654
unknown	18679/udp	0.000654
unknown	18683/udp	0.001307
unknown	18684/udp	0.000654
unknown	18685/udp	0.000654
unknown	18686/udp	0.000654
unknown	18692/udp	0.000654
unknown	18701/udp	0.000654
unknown	18703/udp	0.000654
unknown	18705/udp	0.000654
unknown	18709/udp	0.000654
unknown	18715/udp	0.000654
unknown	18717/udp	0.000654
unknown	18720/udp	0.000654
unknown	18723/udp	0.000654
unknown	18725/udp	0.000654
unknown	18730/udp	0.000654
unknown	18735/udp	0.000654
unknown	18739/udp	0.000654
unknown	18746/udp	0.000654
unknown	18754/udp	0.000654
unknown	18758/udp	0.000654
unknown	18759/udp	0.000654
unknown	18762/udp	0.000654
unknown	18763/udp	0.000654
unknown	18764/udp	0.000654
unknown	18766/udp	0.000654
ique	18769/udp	0.000654	# IQue Protocol
unknown	18772/udp	0.000654
unknown	18791/udp	0.000654
unknown	18796/udp	0.000654
unknown	18797/udp	0.000654
unknown	18801/udp	0.000654
unknown	18806/udp	0.000654
unknown	18807/udp	0.001307
unknown	18812/udp	0.000654
unknown	18817/udp	0.000654
unknown	18818/udp	0.001307
unknown	18821/udp	0.001307
unknown	18826/udp	0.000654
unknown	18828/udp	0.000654
unknown	18830/udp	0.001307
unknown	18831/udp	0.000654
unknown	18832/udp	0.001307
unknown	18834/udp	0.000654
unknown	18835/udp	0.001961
unknown	18836/udp	0.000654
unknown	18846/udp	0.000654
unknown	18851/udp	0.000654
unknown	18855/udp	0.000654
unknown	18856/udp	0.000654
unknown	18857/udp	0.000654
unknown	18862/udp	0.000654
unknown	18864/udp	0.000654
unknown	18865/udp	0.000654
unknown	18869/udp	0.001307
unknown	18872/udp	0.000654
unknown	18874/tcp	0.000076
unknown	18877/udp	0.000654
unknown	18883/udp	0.001307
unknown	18884/udp	0.000654
unknown	18887/tcp	0.000076
unknown	18887/udp	0.000654
apc-necmp	18888/udp	0.001307	# APCNECMP
unknown	18894/udp	0.000654
unknown	18898/udp	0.000654
unknown	18901/udp	0.000654
unknown	18903/udp	0.000654
unknown	18905/udp	0.000654
unknown	18907/udp	0.000654
unknown	18909/udp	0.000654
unknown	18910/tcp	0.000076
unknown	18915/udp	0.000654
unknown	18924/udp	0.000654
unknown	18926/udp	0.000654
unknown	18928/udp	0.000654
unknown	18929/udp	0.000654
unknown	18935/udp	0.000654
unknown	18944/udp	0.000654
unknown	18949/udp	0.000654
unknown	18954/udp	0.000654
unknown	18958/udp	0.001307
unknown	18959/udp	0.000654
unknown	18962/tcp	0.000076
unknown	18966/udp	0.000654
unknown	18968/udp	0.000654
unknown	18971/udp	0.000654
unknown	18973/udp	0.000654
unknown	18976/udp	0.000654
unknown	18980/udp	0.001961
unknown	18985/udp	0.001307
unknown	18986/udp	0.000654
unknown	18987/udp	0.001307
unknown	18988/tcp	0.000304
unknown	18991/udp	0.001307
unknown	18994/udp	0.001307
unknown	18995/udp	0.000654
unknown	18996/udp	0.001307
unknown	18997/udp	0.000654
unknown	19003/udp	0.000654
unknown	19007/udp	0.000654
unknown	19010/tcp	0.000076
unknown	19010/udp	0.000654
unknown	19015/udp	0.000654
unknown	19017/udp	0.001961
unknown	19018/udp	0.000654
unknown	19020/udp	0.000654
unknown	19021/udp	0.000654
unknown	19022/udp	0.001307
unknown	19024/udp	0.000654
unknown	19037/udp	0.000654
unknown	19038/udp	0.000654
unknown	19039/udp	0.001961
unknown	19042/udp	0.000654
unknown	19047/udp	0.001307
unknown	19050/udp	0.000654
unknown	19056/udp	0.000654
unknown	19060/udp	0.000654
unknown	19061/udp	0.000654
unknown	19063/udp	0.000654
unknown	19065/udp	0.000654
unknown	19074/udp	0.000654
unknown	19075/udp	0.001307
unknown	19078/udp	0.000654
unknown	19083/udp	0.000654
unknown	19084/udp	0.000654
unknown	19092/udp	0.000654
unknown	19096/udp	0.001307
unknown	19097/udp	0.000654
unknown	19101/tcp	0.000380
unknown	19106/udp	0.000654
unknown	19111/udp	0.000654
unknown	19113/udp	0.000654
unknown	19117/udp	0.000654
unknown	19119/udp	0.000654
unknown	19120/udp	0.002614
unknown	19128/udp	0.000654
unknown	19130/tcp	0.000076
unknown	19130/udp	0.001961
unknown	19133/udp	0.000654
unknown	19137/udp	0.000654
unknown	19139/udp	0.000654
unknown	19140/udp	0.001307
unknown	19141/udp	0.001307
unknown	19145/udp	0.000654
unknown	19147/udp	0.000654
gkrellm	19150/tcp	0.000013	# GKrellM remote system activity meter daemon
unknown	19154/udp	0.001307
unknown	19161/udp	0.001307
unknown	19163/udp	0.000654
unknown	19165/udp	0.001961
unknown	19166/udp	0.000654
unknown	19171/udp	0.000654
unknown	19175/udp	0.000654
unknown	19181/udp	0.001307
unknown	19183/udp	0.000654
unknown	19184/udp	0.000654
unknown	19185/udp	0.000654
unknown	19190/udp	0.000654
unknown	19193/udp	0.001307
unknown	19195/udp	0.000654
unknown	19197/udp	0.001961
unknown	19200/tcp	0.000076
unknown	19200/udp	0.000654
unknown	19201/tcp	0.000076
unknown	19202/udp	0.000654
unknown	19207/udp	0.000654
unknown	19208/udp	0.000654
unknown	19209/udp	0.000654
unknown	19210/udp	0.000654
unknown	19219/udp	0.000654
unknown	19220/udp	0.000654
unknown	19222/udp	0.001307
unknown	19227/udp	0.001307
unknown	19229/udp	0.000654
unknown	19233/udp	0.000654
unknown	19234/udp	0.000654
unknown	19236/udp	0.000654
unknown	19239/udp	0.000654
unknown	19246/udp	0.000654
unknown	19255/udp	0.000654
unknown	19260/udp	0.000654
unknown	19263/udp	0.000654
unknown	19269/udp	0.000654
unknown	19273/udp	0.001307
unknown	19279/udp	0.000654
unknown	19281/udp	0.000654
keysrvr	19283/tcp	0.000304	# Key Server for SASSAFRAS
keysrvr	19283/udp	0.004575	# Key Server for SASSAFRAS
unknown	19284/udp	0.000654
unknown	19289/udp	0.000654
unknown	19293/udp	0.000654
unknown	19294/udp	0.001961
unknown	19300/udp	0.000654
unknown	19310/udp	0.000654
unknown	19313/udp	0.000654
keyshadow	19315/tcp	0.000304	# Key Shadow for SASSAFRAS
keyshadow	19315/udp	0.001307	# Key Shadow for SASSAFRAS
unknown	19316/udp	0.000654
unknown	19322/udp	0.001961
unknown	19328/udp	0.000654
unknown	19331/udp	0.000654
unknown	19332/udp	0.001961
litecoin	19333/tcp	0.000076	# Litecoin crypto currency testnet - https://litecoin.info/Litecoin.conf
unknown	19333/udp	0.000654
unknown	19336/udp	0.000654
unknown	19340/udp	0.000654
unknown	19341/udp	0.000654
unknown	19350/tcp	0.000228
unknown	19350/udp	0.000654
unknown	19351/udp	0.000654
unknown	19352/udp	0.000654
unknown	19353/tcp	0.000076
unknown	19364/udp	0.000654
unknown	19367/udp	0.000654
unknown	19371/udp	0.000654
unknown	19374/udp	0.001307
unknown	19378/udp	0.000654
unknown	19383/udp	0.000654
unknown	19384/udp	0.000654
unknown	19385/udp	0.000654
unknown	19391/udp	0.000654
unknown	19394/udp	0.000654
unknown	19403/tcp	0.000076
unknown	19413/udp	0.000654
unknown	19415/udp	0.001307
unknown	19416/udp	0.000654
unknown	19424/udp	0.000654
unknown	19425/udp	0.000654
unknown	19427/udp	0.000654
unknown	19429/udp	0.000654
unknown	19433/udp	0.000654
unknown	19434/udp	0.000654
unknown	19440/udp	0.000654
unknown	19442/udp	0.000654
unknown	19446/udp	0.000654
unknown	19447/udp	0.000654
unknown	19451/udp	0.000654
unknown	19459/udp	0.000654
unknown	19462/udp	0.000654
unknown	19464/tcp	0.000076
unknown	19464/udp	0.000654
unknown	19479/udp	0.000654
unknown	19482/udp	0.001307
unknown	19489/udp	0.001961
unknown	19499/udp	0.000654
unknown	19500/udp	0.001307
unknown	19501/tcp	0.000076
unknown	19501/udp	0.000654
unknown	19503/udp	0.002614
unknown	19504/udp	0.001307
unknown	19505/udp	0.000654
unknown	19506/udp	0.000654
unknown	19508/udp	0.000654
unknown	19514/udp	0.000654
unknown	19522/udp	0.000654
unknown	19524/udp	0.000654
unknown	19529/udp	0.000654
unknown	19530/udp	0.000654
fxuptp	19539/udp	0.000654	# FXUPTP
jcp	19541/udp	0.001307	# JCP Client
unknown	19542/udp	0.000654
unknown	19544/udp	0.000654
unknown	19545/udp	0.000654
unknown	19561/udp	0.000654
unknown	19578/udp	0.000654
unknown	19582/udp	0.000654
unknown	19584/udp	0.000654
unknown	19587/udp	0.000654
unknown	19591/udp	0.000654
unknown	19595/udp	0.000654
unknown	19600/udp	0.001961
unknown	19605/udp	0.001307
unknown	19607/udp	0.000654
unknown	19610/udp	0.000654
unknown	19612/tcp	0.000076
unknown	19613/udp	0.000654
unknown	19614/udp	0.000654
unknown	19616/udp	0.002614
unknown	19617/udp	0.000654
unknown	19618/udp	0.000654
unknown	19624/udp	0.001307
unknown	19625/udp	0.001307
unknown	19627/udp	0.000654
unknown	19629/udp	0.000654
unknown	19632/udp	0.001307
unknown	19634/tcp	0.000076
unknown	19637/udp	0.000654
unknown	19639/udp	0.001307
unknown	19641/udp	0.000654
unknown	19642/udp	0.000654
unknown	19644/udp	0.000654
unknown	19647/udp	0.001307
unknown	19648/udp	0.000654
unknown	19650/udp	0.001307
unknown	19652/udp	0.000654
unknown	19658/udp	0.000654
unknown	19659/udp	0.000654
unknown	19660/udp	0.001307
unknown	19662/udp	0.001307
unknown	19663/udp	0.001307
unknown	19664/udp	0.000654
unknown	19667/udp	0.000654
unknown	19672/udp	0.000654
unknown	19678/udp	0.000654
unknown	19682/udp	0.003922
unknown	19683/udp	0.001307
unknown	19685/udp	0.000654
unknown	19687/udp	0.001961
unknown	19688/udp	0.000654
unknown	19695/udp	0.001307
unknown	19701/udp	0.000654
unknown	19704/udp	0.000654
unknown	19707/udp	0.001307
unknown	19711/udp	0.000654
unknown	19715/tcp	0.000076
unknown	19717/udp	0.001307
unknown	19718/udp	0.001307
unknown	19719/udp	0.001307
unknown	19722/udp	0.001307
unknown	19724/udp	0.000654
unknown	19728/udp	0.001307
unknown	19730/udp	0.000654
unknown	19734/udp	0.000654
unknown	19736/udp	0.000654
unknown	19739/udp	0.000654
unknown	19747/udp	0.000654
unknown	19753/udp	0.000654
unknown	19754/udp	0.000654
unknown	19756/udp	0.000654
unknown	19757/udp	0.000654
unknown	19761/udp	0.000654
unknown	19764/udp	0.000654
unknown	19773/udp	0.000654
unknown	19780/tcp	0.000304
unknown	19780/udp	0.000654
unknown	19781/udp	0.000654
unknown	19783/udp	0.000654
unknown	19789/udp	0.001307
unknown	19790/udp	0.000654
unknown	19791/udp	0.000654
unknown	19792/udp	0.001307
unknown	19797/udp	0.000654
unknown	19799/udp	0.000654
unknown	19801/tcp	0.000380
unknown	19808/udp	0.000654
unknown	19816/udp	0.000654
unknown	19817/udp	0.000654
unknown	19819/udp	0.000654
unknown	19823/udp	0.000654
unknown	19827/udp	0.000654
unknown	19829/udp	0.000654
unknown	19836/udp	0.000654
unknown	19837/udp	0.000654
unknown	19842/tcp	0.000380
unknown	19850/udp	0.000654
unknown	19851/udp	0.000654
unknown	19852/tcp	0.000076
unknown	19852/udp	0.000654
unknown	19856/udp	0.000654
unknown	19859/udp	0.000654
unknown	19860/udp	0.000654
unknown	19868/udp	0.000654
unknown	19869/udp	0.000654
unknown	19870/udp	0.000654
unknown	19873/udp	0.000654
unknown	19875/udp	0.000654
unknown	19880/udp	0.000654
unknown	19882/udp	0.000654
unknown	19887/udp	0.000654
unknown	19892/udp	0.000654
unknown	19897/udp	0.000654
unknown	19900/tcp	0.000152
unknown	19903/udp	0.000654
unknown	19906/udp	0.000654
unknown	19911/udp	0.000654
unknown	19912/udp	0.000654
unknown	19917/udp	0.000654
unknown	19921/udp	0.000654
unknown	19926/udp	0.000654
unknown	19933/udp	0.001961
unknown	19935/udp	0.001307
unknown	19936/udp	0.001307
unknown	19940/udp	0.000654
unknown	19954/udp	0.000654
unknown	19956/udp	0.001307
unknown	19959/udp	0.000654
unknown	19966/udp	0.000654
unknown	19967/udp	0.000654
unknown	19968/udp	0.000654
unknown	19977/udp	0.000654
unknown	19984/udp	0.000654
unknown	19988/udp	0.000654
unknown	19989/udp	0.000654
unknown	19995/tcp	0.000076
unknown	19995/udp	0.001307
unknown	19996/tcp	0.000076
unknown	19997/udp	0.000654
unknown	19998/udp	0.001307
dnp	20000/tcp	0.000380	# DNP
microsan	20001/tcp	0.000076	# MicroSAN
commtact-http	20002/tcp	0.000152	# Commtact HTTP
commtact-https	20003/udp	0.001307	# Commtact HTTPS
unknown	20004/udp	0.001961
btx	20005/tcp	0.000401	# xcept4 (Interacts with German Telekom's CEPT videotext service)
openwebnet	20005/udp	0.000654	# OpenWebNet protocol for electric network
unknown	20006/udp	0.000654
unknown	20008/udp	0.000654
unknown	20011/tcp	0.000076
unknown	20015/udp	0.000654
unknown	20017/tcp	0.000076
unknown	20019/udp	0.002614
unknown	20021/tcp	0.000076
unknown	20022/udp	0.000654
unknown	20024/udp	0.000654
unknown	20027/udp	0.000654
unknown	20031/tcp	0.000380
bakbonenetvault	20031/udp	0.025490	# BakBone NetVault primary communications port
unknown	20032/tcp	0.000076
nburn_id	20034/udp	0.000654	# NetBurner ID Port
unknown	20039/tcp	0.000076
unknown	20039/udp	0.000654
unknown	20041/udp	0.000654
unknown	20045/udp	0.000654
mountd	20048/udp	0.000654	# NFS mount protocol
nfsrdma	20049/sctp	0.000000	# Network File System (NFS) over RDMA
unknown	20052/tcp	0.000076
unknown	20055/udp	0.000654
unknown	20056/udp	0.000654
unknown	20062/udp	0.000654
unknown	20065/udp	0.000654
unknown	20069/udp	0.000654
unknown	20071/udp	0.000654
unknown	20076/tcp	0.000076
unknown	20076/udp	0.000654
unknown	20079/udp	0.000654
unknown	20080/tcp	0.000076
unknown	20081/udp	0.000654
unknown	20082/udp	0.001307
unknown	20083/udp	0.000654
unknown	20085/tcp	0.000076
unknown	20085/udp	0.000654
unknown	20089/tcp	0.000076
unknown	20089/udp	0.000654
unknown	20091/udp	0.000654
unknown	20095/udp	0.000654
unknown	20099/udp	0.000654
unknown	20102/tcp	0.000076
unknown	20103/udp	0.000654
unknown	20104/udp	0.000654
unknown	20106/tcp	0.000076
unknown	20107/udp	0.000654
unknown	20110/udp	0.000654
unknown	20111/tcp	0.000076
unknown	20117/udp	0.001307
unknown	20118/tcp	0.000076
unknown	20120/udp	0.001307
unknown	20125/tcp	0.000076
unknown	20125/udp	0.000654
unknown	20126/udp	0.002614
unknown	20127/tcp	0.000076
unknown	20129/udp	0.001307
unknown	20132/udp	0.000654
unknown	20133/udp	0.000654
unknown	20146/udp	0.001307
unknown	20147/tcp	0.000076
unknown	20150/udp	0.000654
unknown	20154/udp	0.001307
unknown	20156/udp	0.000654
unknown	20158/udp	0.000654
unknown	20160/udp	0.000654
unknown	20161/udp	0.000654
unknown	20162/udp	0.000654
unknown	20164/udp	0.001307
unknown	20165/udp	0.000654
unknown	20169/udp	0.000654
unknown	20171/udp	0.000654
unknown	20173/udp	0.000654
unknown	20175/udp	0.000654
unknown	20176/udp	0.000654
unknown	20179/tcp	0.000076
unknown	20180/tcp	0.000076
unknown	20181/udp	0.000654
unknown	20184/udp	0.000654
unknown	20190/udp	0.000654
unknown	20194/udp	0.000654
unknown	20197/udp	0.000654
unknown	20204/udp	0.000654
unknown	20206/udp	0.001307
unknown	20217/udp	0.001307
unknown	20221/tcp	0.000380
unknown	20221/udp	0.000654
ipulse-ics	20222/tcp	0.000380	# iPulse-ICS
ipulse-ics	20222/udp	0.000654	# iPulse-ICS
unknown	20223/tcp	0.000076
unknown	20223/udp	0.000654
unknown	20224/tcp	0.000076
unknown	20224/udp	0.000654
unknown	20225/tcp	0.000076
unknown	20226/tcp	0.000076
unknown	20226/udp	0.000654
unknown	20227/tcp	0.000076
unknown	20228/tcp	0.000076
unknown	20228/udp	0.000654
unknown	20229/udp	0.000654
unknown	20239/udp	0.000654
unknown	20243/udp	0.000654
unknown	20244/udp	0.000654
unknown	20249/udp	0.001307
unknown	20253/udp	0.000654
unknown	20254/udp	0.000654
unknown	20258/udp	0.000654
unknown	20260/udp	0.000654
unknown	20262/udp	0.001307
unknown	20276/udp	0.000654
unknown	20279/udp	0.001307
unknown	20280/tcp	0.000076
unknown	20280/udp	0.000654
unknown	20281/udp	0.000654
unknown	20284/udp	0.000654
unknown	20287/udp	0.000654
unknown	20288/udp	0.001307
unknown	20292/udp	0.000654
unknown	20297/udp	0.000654
unknown	20300/udp	0.000654
unknown	20306/udp	0.000654
unknown	20309/udp	0.001307
unknown	20313/udp	0.001307
unknown	20316/udp	0.000654
unknown	20326/udp	0.001307
unknown	20339/udp	0.000654
unknown	20340/udp	0.000654
unknown	20353/udp	0.000654
unknown	20355/udp	0.000654
unknown	20357/udp	0.000654
unknown	20358/udp	0.000654
unknown	20359/udp	0.001961
unknown	20360/udp	0.001307
unknown	20364/udp	0.000654
unknown	20366/udp	0.001307
unknown	20369/udp	0.000654
unknown	20370/udp	0.000654
unknown	20380/udp	0.001307
unknown	20381/udp	0.000654
unknown	20389/udp	0.002614
unknown	20392/udp	0.000654
unknown	20396/udp	0.000654
unknown	20409/udp	0.001307
unknown	20411/udp	0.001307
unknown	20423/udp	0.001307
unknown	20424/udp	0.001307
unknown	20425/udp	0.001307
unknown	20426/udp	0.000654
unknown	20432/udp	0.000654
unknown	20437/udp	0.000654
unknown	20439/udp	0.000654
unknown	20443/udp	0.000654
unknown	20444/udp	0.000654
unknown	20445/udp	0.001307
unknown	20449/udp	0.001307
unknown	20450/udp	0.000654
unknown	20452/udp	0.000654
unknown	20453/udp	0.000654
unknown	20464/udp	0.001307
unknown	20465/udp	0.001307
unknown	20469/udp	0.000654
unknown	20470/udp	0.000654
unknown	20473/tcp	0.000076
unknown	20473/udp	0.000654
unknown	20475/udp	0.000654
unknown	20481/udp	0.000654
unknown	20483/udp	0.000654
unknown	20485/udp	0.000654
unknown	20487/udp	0.000654
unknown	20488/udp	0.000654
unknown	20489/udp	0.000654
unknown	20497/udp	0.000654
unknown	20500/udp	0.000654
unknown	20506/udp	0.000654
unknown	20513/udp	0.000654
unknown	20516/udp	0.000654
unknown	20517/udp	0.000654
unknown	20518/udp	0.001307
unknown	20522/udp	0.001307
unknown	20525/udp	0.001307
unknown	20526/udp	0.000654
unknown	20527/udp	0.000654
unknown	20530/udp	0.000654
unknown	20533/udp	0.000654
unknown	20537/udp	0.000654
unknown	20540/udp	0.001307
unknown	20541/udp	0.000654
unknown	20543/udp	0.000654
unknown	20544/udp	0.000654
unknown	20545/udp	0.000654
unknown	20548/udp	0.000654
unknown	20551/udp	0.000654
unknown	20555/udp	0.000654
unknown	20560/udp	0.001307
unknown	20561/udp	0.000654
unknown	20563/udp	0.000654
unknown	20564/udp	0.000654
unknown	20569/udp	0.000654
unknown	20584/udp	0.000654
unknown	20585/udp	0.000654
unknown	20590/udp	0.000654
unknown	20591/udp	0.000654
unknown	20608/udp	0.000654
unknown	20611/udp	0.000654
unknown	20619/udp	0.000654
unknown	20621/udp	0.000654
unknown	20625/udp	0.000654
unknown	20626/udp	0.000654
unknown	20635/udp	0.000654
unknown	20641/udp	0.000654
unknown	20646/udp	0.000654
unknown	20660/udp	0.000654
unknown	20665/udp	0.001307
unknown	20671/udp	0.000654
unknown	20673/udp	0.000654
unknown	20675/udp	0.000654
unknown	20677/udp	0.000654
unknown	20678/udp	0.001307
unknown	20679/udp	0.001307
unknown	20680/udp	0.000654
unknown	20681/udp	0.000654
unknown	20687/udp	0.000654
unknown	20688/udp	0.000654
unknown	20689/udp	0.000654
unknown	20691/udp	0.000654
unknown	20696/udp	0.000654
unknown	20700/udp	0.000654
unknown	20702/udp	0.000654
unknown	20710/udp	0.001307
unknown	20712/udp	0.000654
unknown	20713/udp	0.000654
unknown	20717/udp	0.001307
unknown	20719/udp	0.000654
unknown	20723/udp	0.000654
unknown	20725/udp	0.000654
unknown	20733/udp	0.000654
unknown	20734/tcp	0.000076
unknown	20734/udp	0.000654
unknown	20736/udp	0.000654
unknown	20739/udp	0.000654
unknown	20741/udp	0.000654
unknown	20742/udp	0.001307
unknown	20743/udp	0.000654
unknown	20747/udp	0.000654
unknown	20748/udp	0.000654
unknown	20749/udp	0.000654
unknown	20752/udp	0.001307
unknown	20758/udp	0.000654
unknown	20759/udp	0.000654
unknown	20762/udp	0.001307
unknown	20765/udp	0.000654
unknown	20771/udp	0.000654
unknown	20780/udp	0.000654
unknown	20785/udp	0.000654
unknown	20791/udp	0.001307
unknown	20795/udp	0.000654
unknown	20796/udp	0.000654
unknown	20805/udp	0.000654
unknown	20812/udp	0.000654
unknown	20815/udp	0.000654
unknown	20816/udp	0.000654
unknown	20817/udp	0.001307
unknown	20819/udp	0.000654
unknown	20822/udp	0.000654
unknown	20825/udp	0.000654
unknown	20826/udp	0.000654
unknown	20828/tcp	0.000760
unknown	20830/udp	0.000654
unknown	20831/udp	0.000654
unknown	20833/udp	0.000654
unknown	20842/udp	0.001307
unknown	20848/udp	0.001307
unknown	20851/udp	0.001307
unknown	20852/udp	0.000654
unknown	20858/udp	0.000654
unknown	20861/udp	0.000654
unknown	20863/udp	0.000654
unknown	20865/udp	0.001307
unknown	20868/udp	0.000654
unknown	20872/udp	0.001307
unknown	20876/udp	0.001307
unknown	20878/udp	0.000654
unknown	20880/udp	0.000654
unknown	20881/udp	0.000654
unknown	20882/udp	0.000654
unknown	20883/tcp	0.000076
unknown	20884/udp	0.001307
unknown	20892/udp	0.000654
unknown	20896/udp	0.000654
unknown	20897/udp	0.000654
unknown	20905/udp	0.000654
unknown	20908/udp	0.000654
unknown	20913/udp	0.000654
unknown	20915/udp	0.000654
unknown	20919/udp	0.001307
unknown	20921/udp	0.000654
unknown	20924/udp	0.000654
unknown	20926/udp	0.000654
unknown	20927/udp	0.000654
unknown	20932/udp	0.000654
unknown	20934/tcp	0.000076
unknown	20940/tcp	0.000076
unknown	20940/udp	0.000654
unknown	20942/udp	0.000654
unknown	20959/udp	0.000654
unknown	20966/udp	0.000654
unknown	20970/udp	0.000654
unknown	20974/udp	0.000654
unknown	20983/udp	0.000654
unknown	20987/udp	0.000654
unknown	20989/udp	0.000654
unknown	20990/tcp	0.000076
unknown	20990/udp	0.000654
unknown	20994/udp	0.000654
irtrans	21000/udp	0.001307	# IRTrans Control
unknown	21007/udp	0.000654
unknown	21011/tcp	0.000076
unknown	21016/udp	0.001307
unknown	21019/udp	0.000654
unknown	21030/udp	0.000654
unknown	21060/udp	0.001307
unknown	21062/udp	0.000654
unknown	21071/udp	0.000654
unknown	21077/udp	0.000654
unknown	21078/tcp	0.000076
unknown	21083/udp	0.001307
unknown	21084/udp	0.000654
unknown	21103/udp	0.000654
unknown	21104/udp	0.001307
unknown	21105/udp	0.000654
unknown	21111/udp	0.001307
unknown	21117/udp	0.000654
unknown	21121/udp	0.000654
unknown	21123/udp	0.000654
unknown	21124/udp	0.000654
unknown	21128/udp	0.000654
unknown	21131/udp	0.001961
unknown	21152/udp	0.000654
unknown	21157/udp	0.000654
unknown	21159/udp	0.000654
unknown	21166/udp	0.000654
unknown	21167/udp	0.001307
unknown	21168/udp	0.000654
unknown	21170/udp	0.000654
unknown	21180/udp	0.000654
unknown	21185/udp	0.000654
unknown	21186/udp	0.001307
unknown	21187/udp	0.000654
unknown	21188/udp	0.000654
unknown	21192/udp	0.000654
unknown	21193/udp	0.000654
unknown	21194/udp	0.000654
unknown	21195/udp	0.000654
memcachedb	21201/tcp	0.000076
unknown	21201/udp	0.000654
unknown	21202/udp	0.000654
unknown	21204/udp	0.000654
unknown	21206/udp	0.001307
unknown	21207/udp	0.001307
unknown	21209/udp	0.000654
unknown	21212/udp	0.001961
unknown	21214/udp	0.000654
unknown	21215/udp	0.000654
unknown	21225/udp	0.000654
unknown	21231/udp	0.000654
unknown	21233/udp	0.000654
unknown	21235/udp	0.000654
unknown	21239/udp	0.000654
unknown	21241/udp	0.000654
unknown	21244/udp	0.000654
unknown	21247/udp	0.001307
unknown	21253/udp	0.000654
unknown	21261/udp	0.001961
unknown	21270/udp	0.000654
unknown	21280/udp	0.000654
unknown	21282/udp	0.001307
unknown	21284/udp	0.000654
unknown	21292/udp	0.000654
unknown	21297/udp	0.000654
unknown	21298/udp	0.001961
unknown	21299/udp	0.000654
unknown	21303/udp	0.001307
unknown	21304/udp	0.000654
unknown	21310/udp	0.000654
unknown	21312/udp	0.000654
unknown	21313/udp	0.000654
unknown	21318/udp	0.001307
unknown	21320/udp	0.001307
unknown	21331/udp	0.000654
unknown	21333/udp	0.001307
unknown	21334/udp	0.000654
unknown	21337/udp	0.000654
unknown	21344/udp	0.001307
unknown	21347/udp	0.000654
unknown	21350/udp	0.000654
unknown	21354/udp	0.001961
unknown	21358/udp	0.001307
unknown	21360/udp	0.001307
unknown	21364/udp	0.001307
unknown	21366/udp	0.001307
unknown	21368/udp	0.000654
unknown	21372/udp	0.000654
unknown	21375/udp	0.000654
unknown	21376/udp	0.000654
unknown	21377/udp	0.000654
unknown	21383/udp	0.002614
unknown	21385/udp	0.000654
unknown	21387/udp	0.000654
unknown	21393/udp	0.000654
unknown	21395/udp	0.000654
unknown	21397/udp	0.000654
unknown	21399/udp	0.000654
unknown	21405/udp	0.001307
unknown	21407/udp	0.000654
unknown	21434/udp	0.000654
unknown	21440/udp	0.000654
unknown	21446/udp	0.000654
unknown	21452/udp	0.000654
unknown	21454/udp	0.001307
unknown	21456/udp	0.000654
unknown	21461/udp	0.000654
unknown	21468/udp	0.001307
unknown	21469/udp	0.000654
unknown	21471/udp	0.000654
unknown	21472/udp	0.000654
unknown	21473/tcp	0.000076
unknown	21473/udp	0.000654
unknown	21476/udp	0.001307
unknown	21478/udp	0.000654
unknown	21483/udp	0.000654
unknown	21498/udp	0.000654
unknown	21501/udp	0.000654
unknown	21506/udp	0.000654
unknown	21507/udp	0.000654
unknown	21511/udp	0.000654
unknown	21514/udp	0.001307
unknown	21521/udp	0.000654
unknown	21524/udp	0.001307
unknown	21525/udp	0.001307
unknown	21547/udp	0.000654
unknown	21550/udp	0.000654
unknown	21553/udp	0.000654
unknown	21556/udp	0.001307
unknown	21564/udp	0.000654
unknown	21566/udp	0.001307
unknown	21567/udp	0.000654
unknown	21568/udp	0.001307
unknown	21571/tcp	0.000380
unknown	21572/udp	0.000654
unknown	21576/udp	0.001307
unknown	21588/udp	0.000654
unknown	21599/udp	0.000654
unknown	21609/udp	0.001307
unknown	21611/udp	0.000654
unknown	21616/udp	0.000654
unknown	21620/udp	0.000654
unknown	21621/udp	0.001961
unknown	21624/udp	0.000654
unknown	21625/udp	0.001307
unknown	21629/udp	0.000654
unknown	21631/tcp	0.000076
unknown	21634/tcp	0.000076
unknown	21640/udp	0.000654
unknown	21644/udp	0.001307
unknown	21647/udp	0.000654
unknown	21649/udp	0.001307
unknown	21654/udp	0.000654
unknown	21655/udp	0.001307
unknown	21662/udp	0.000654
unknown	21663/udp	0.001307
unknown	21665/udp	0.000654
unknown	21666/udp	0.000654
unknown	21667/udp	0.000654
unknown	21669/udp	0.000654
unknown	21671/udp	0.000654
unknown	21674/udp	0.001307
unknown	21679/udp	0.000654
unknown	21680/udp	0.000654
unknown	21682/udp	0.000654
unknown	21684/udp	0.000654
unknown	21685/udp	0.000654
unknown	21686/udp	0.000654
unknown	21689/udp	0.000654
unknown	21698/udp	0.001307
unknown	21702/udp	0.001307
unknown	21703/udp	0.000654
unknown	21706/udp	0.000654
unknown	21708/udp	0.000654
unknown	21710/udp	0.001307
unknown	21716/udp	0.000654
unknown	21726/udp	0.000654
unknown	21728/tcp	0.000076
unknown	21738/udp	0.000654
unknown	21742/udp	0.001307
unknown	21752/udp	0.000654
unknown	21756/udp	0.000654
unknown	21759/udp	0.000654
unknown	21765/udp	0.000654
unknown	21768/udp	0.000654
unknown	21771/udp	0.000654
unknown	21775/udp	0.000654
unknown	21780/udp	0.001307
unknown	21784/udp	0.001307
unknown	21785/udp	0.000654
unknown	21786/udp	0.000654
unknown	21792/tcp	0.000152
unknown	21794/udp	0.000654
tvpm	21800/udp	0.001307	# TVNC Pro Multiplexing
unknown	21803/udp	0.001961
unknown	21804/udp	0.000654
unknown	21805/udp	0.000654
unknown	21806/udp	0.000654
unknown	21814/udp	0.000654
unknown	21819/udp	0.000654
unknown	21825/udp	0.000654
unknown	21830/udp	0.000654
unknown	21834/udp	0.001307
unknown	21835/udp	0.000654
unknown	21842/udp	0.001307
netspeak-cs	21847/udp	0.001307	# NetSpeak Corp. Connection Services
unknown	21851/udp	0.000654
unknown	21852/udp	0.000654
unknown	21854/udp	0.000654
unknown	21858/udp	0.000654
unknown	21865/udp	0.000654
unknown	21868/udp	0.001307
unknown	21880/udp	0.000654
unknown	21881/udp	0.000654
unknown	21885/udp	0.000654
unknown	21888/udp	0.000654
unknown	21891/tcp	0.000076
unknown	21892/udp	0.000654
unknown	21895/udp	0.000654
unknown	21898/udp	0.001307
unknown	21899/udp	0.000654
unknown	21900/udp	0.000654
unknown	21902/udp	0.001961
unknown	21908/udp	0.000654
unknown	21915/tcp	0.000076
unknown	21919/udp	0.000654
unknown	21920/udp	0.000654
unknown	21923/udp	0.001307
unknown	21927/udp	0.000654
unknown	21930/udp	0.000654
unknown	21934/udp	0.000654
unknown	21935/udp	0.000654
unknown	21936/udp	0.000654
unknown	21939/udp	0.000654
unknown	21940/udp	0.000654
unknown	21941/udp	0.000654
unknown	21946/udp	0.000654
unknown	21948/udp	0.001307
unknown	21964/udp	0.000654
unknown	21967/udp	0.001307
unknown	21968/udp	0.000654
unknown	21974/udp	0.000654
unknown	21978/udp	0.000654
unknown	21982/udp	0.000654
unknown	21994/udp	0.000654
unknown	21995/udp	0.000654
unknown	21996/udp	0.000654
unknown	21999/udp	0.000654
unknown	22006/udp	0.000654
unknown	22007/udp	0.000654
unknown	22011/udp	0.000654
unknown	22014/udp	0.000654
unknown	22016/udp	0.000654
unknown	22017/udp	0.000654
unknown	22019/udp	0.000654
unknown	22022/tcp	0.000076
unknown	22027/udp	0.000654
unknown	22029/udp	0.001307
unknown	22031/udp	0.000654
unknown	22032/udp	0.000654
unknown	22035/udp	0.000654
unknown	22041/udp	0.000654
unknown	22042/udp	0.000654
unknown	22043/udp	0.001307
unknown	22045/udp	0.001307
unknown	22053/udp	0.001307
unknown	22055/udp	0.001961
unknown	22062/udp	0.000654
unknown	22063/tcp	0.000076
unknown	22063/udp	0.000654
unknown	22068/udp	0.000654
unknown	22069/udp	0.000654
unknown	22072/udp	0.000654
unknown	22079/udp	0.000654
unknown	22084/udp	0.000654
unknown	22090/udp	0.000654
unknown	22092/udp	0.000654
unknown	22094/udp	0.000654
unknown	22098/udp	0.000654
unknown	22099/udp	0.000654
unknown	22100/tcp	0.000076
unknown	22102/udp	0.000654
unknown	22104/udp	0.000654
unknown	22105/udp	0.001307
unknown	22109/udp	0.001307
unknown	22111/udp	0.000654
unknown	22112/udp	0.000654
unknown	22115/udp	0.000654
unknown	22123/udp	0.001307
unknown	22124/udp	0.001307
dcap	22125/tcp	0.000076	# dCache Access Protocol
gsidcap	22128/tcp	0.000076	# GSI dCache Access Protocol
unknown	22130/udp	0.000654
unknown	22131/udp	0.000654
unknown	22146/udp	0.001307
unknown	22147/udp	0.000654
unknown	22148/udp	0.000654
unknown	22159/udp	0.000654
unknown	22163/udp	0.000654
unknown	22169/udp	0.000654
unknown	22171/udp	0.000654
unknown	22172/udp	0.000654
unknown	22174/udp	0.000654
unknown	22176/udp	0.000654
unknown	22177/tcp	0.000076
unknown	22178/udp	0.000654
unknown	22190/udp	0.000654
unknown	22200/tcp	0.000076
unknown	22203/udp	0.000654
unknown	22215/udp	0.001307
unknown	22218/udp	0.000654
unknown	22221/udp	0.000654
unknown	22222/tcp	0.000152
unknown	22223/tcp	0.000076
unknown	22227/udp	0.000654
unknown	22230/udp	0.000654
unknown	22232/udp	0.000654
unknown	22233/udp	0.000654
unknown	22239/udp	0.000654
unknown	22242/udp	0.000654
unknown	22248/udp	0.000654
unknown	22249/udp	0.000654
unknown	22252/udp	0.001307
unknown	22256/udp	0.000654
unknown	22260/udp	0.000654
unknown	22261/udp	0.000654
unknown	22266/udp	0.000654
unknown	22267/udp	0.000654
unknown	22268/udp	0.000654
wnn6	22273/tcp	0.000075	# Wnn6 (Japanese input)
unknown	22275/udp	0.000654
unknown	22277/udp	0.000654
unknown	22278/udp	0.000654
unknown	22279/udp	0.000654
unknown	22287/udp	0.000654
unknown	22288/udp	0.001307
unknown	22290/tcp	0.000076
unknown	22290/udp	0.000654
unknown	22291/udp	0.000654
unknown	22292/udp	0.001307
unknown	22293/udp	0.000654
unknown	22294/udp	0.000654
unknown	22296/udp	0.000654
unknown	22297/udp	0.000654
unknown	22300/udp	0.000654
unknown	22304/udp	0.000654
unknown	22316/udp	0.000654
unknown	22318/udp	0.000654
unknown	22324/udp	0.001307
unknown	22333/udp	0.000654
unknown	22339/udp	0.000654
unknown	22340/udp	0.000654
unknown	22341/tcp	0.000076
unknown	22341/udp	0.001961
unknown	22344/udp	0.000654
WibuKey	22347/udp	0.000654	# WibuKey Standard WkLan
CodeMeter	22350/tcp	0.000076	# CodeMeter Standard
CodeMeter	22350/udp	0.000654	# CodeMeter Standard
unknown	22356/udp	0.001307
unknown	22360/udp	0.000654
unknown	22362/udp	0.000654
unknown	22366/udp	0.000654
unknown	22368/udp	0.000654
hpnpd	22370/udp	0.000726	# Hewlett-Packard Network Printer daemon
unknown	22371/udp	0.000654
unknown	22373/udp	0.000654
unknown	22374/udp	0.000654
unknown	22375/udp	0.000654
unknown	22376/udp	0.001307
unknown	22377/udp	0.001307
unknown	22380/udp	0.000654
unknown	22381/udp	0.001307
unknown	22382/udp	0.000654
unknown	22386/udp	0.000654
unknown	22388/udp	0.000654
unknown	22406/udp	0.000654
unknown	22408/udp	0.000654
unknown	22412/udp	0.000654
unknown	22413/udp	0.000654
unknown	22415/udp	0.000654
unknown	22417/udp	0.001307
unknown	22418/udp	0.000654
unknown	22422/udp	0.000654
unknown	22430/udp	0.000654
unknown	22435/udp	0.000654
unknown	22438/udp	0.001307
unknown	22440/udp	0.000654
unknown	22441/udp	0.000654
unknown	22444/udp	0.000654
unknown	22445/udp	0.000654
unknown	22450/udp	0.000654
unknown	22454/udp	0.000654
unknown	22458/udp	0.000654
unknown	22459/udp	0.000654
unknown	22461/udp	0.000654
unknown	22467/udp	0.000654
unknown	22471/udp	0.000654
unknown	22475/udp	0.000654
unknown	22481/udp	0.001307
unknown	22492/udp	0.000654
unknown	22494/udp	0.001307
unknown	22495/udp	0.001307
unknown	22499/udp	0.000654
unknown	22502/udp	0.000654
unknown	22505/udp	0.001307
unknown	22506/udp	0.000654
unknown	22507/udp	0.000654
unknown	22518/udp	0.000654
unknown	22519/udp	0.000654
unknown	22522/udp	0.001307
unknown	22526/udp	0.001307
unknown	22528/udp	0.000654
unknown	22539/udp	0.000654
unknown	22540/udp	0.000654
unknown	22542/udp	0.000654
unknown	22543/udp	0.000654
unknown	22544/udp	0.000654
unknown	22547/udp	0.001307
unknown	22549/udp	0.000654
unknown	22554/udp	0.000654
vocaltec-wconf	22555/tcp	0.000076	# Vocaltec Web Conference
unknown	22556/udp	0.000654
unknown	22558/udp	0.000654
unknown	22563/tcp	0.000076
unknown	22564/udp	0.000654
unknown	22565/udp	0.000654
unknown	22571/udp	0.001307
unknown	22574/udp	0.000654
unknown	22585/udp	0.001307
unknown	22586/udp	0.000654
unknown	22589/udp	0.000654
unknown	22590/udp	0.000654
unknown	22593/udp	0.001307
unknown	22595/udp	0.000654
unknown	22596/udp	0.000654
unknown	22597/udp	0.001307
unknown	22600/udp	0.000654
unknown	22609/udp	0.000654
unknown	22611/udp	0.001307
unknown	22617/udp	0.000654
unknown	22618/udp	0.000654
unknown	22619/udp	0.000654
unknown	22626/udp	0.001307
unknown	22633/udp	0.000654
unknown	22639/udp	0.000654
unknown	22640/udp	0.000654
unknown	22643/udp	0.000654
unknown	22647/udp	0.000654
unknown	22662/udp	0.000654
unknown	22667/udp	0.000654
unknown	22677/udp	0.001307
unknown	22684/udp	0.000654
unknown	22691/udp	0.000654
unknown	22692/udp	0.001961
unknown	22695/udp	0.001961
unknown	22701/udp	0.000654
unknown	22703/udp	0.000654
unknown	22710/udp	0.000654
unknown	22711/tcp	0.000076
unknown	22711/udp	0.000654
unknown	22713/udp	0.000654
unknown	22714/udp	0.000654
unknown	22719/tcp	0.000076
unknown	22720/udp	0.000654
unknown	22721/udp	0.000654
unknown	22724/udp	0.000654
unknown	22725/udp	0.000654
unknown	22726/udp	0.000654
unknown	22727/tcp	0.000076
unknown	22732/udp	0.001307
unknown	22733/udp	0.000654
unknown	22735/udp	0.000654
unknown	22736/udp	0.001307
unknown	22739/udp	0.001961
unknown	22740/udp	0.000654
unknown	22746/udp	0.000654
unknown	22747/udp	0.000654
unknown	22748/udp	0.000654
unknown	22750/udp	0.000654
unknown	22758/udp	0.000654
unknown	22762/udp	0.001307
unknown	22764/udp	0.000654
unknown	22766/udp	0.000654
unknown	22769/tcp	0.000076
unknown	22773/udp	0.000654
unknown	22776/udp	0.001307
unknown	22779/udp	0.000654
unknown	22784/udp	0.000654
unknown	22785/udp	0.000654
unknown	22787/udp	0.000654
unknown	22793/udp	0.000654
unknown	22799/udp	0.001961
unknown	22806/udp	0.000654
unknown	22807/udp	0.000654
unknown	22810/udp	0.000654
unknown	22811/udp	0.000654
unknown	22815/udp	0.000654
unknown	22825/udp	0.000654
unknown	22828/udp	0.000654
unknown	22832/udp	0.000654
unknown	22839/udp	0.000654
unknown	22843/udp	0.001307
unknown	22844/udp	0.000654
unknown	22846/udp	0.002614
unknown	22847/udp	0.000654
unknown	22852/udp	0.001307
unknown	22853/udp	0.001307
unknown	22855/udp	0.000654
unknown	22857/udp	0.000654
unknown	22862/udp	0.001307
unknown	22864/udp	0.000654
unknown	22872/udp	0.000654
unknown	22876/udp	0.000654
unknown	22879/udp	0.000654
unknown	22881/udp	0.000654
unknown	22882/tcp	0.000076
unknown	22883/udp	0.000654
unknown	22886/udp	0.000654
unknown	22891/udp	0.000654
unknown	22894/udp	0.000654
unknown	22898/udp	0.000654
unknown	22902/udp	0.001307
unknown	22903/udp	0.000654
unknown	22909/udp	0.000654
unknown	22914/udp	0.001961
unknown	22928/udp	0.000654
unknown	22931/udp	0.000654
unknown	22934/udp	0.000654
unknown	22935/udp	0.000654
unknown	22936/udp	0.000654
unknown	22939/tcp	0.000380
unknown	22939/udp	0.000654
unknown	22940/udp	0.000654
unknown	22945/udp	0.001307
unknown	22947/udp	0.000654
unknown	22949/udp	0.000654
unknown	22954/udp	0.000654
unknown	22955/udp	0.000654
unknown	22959/tcp	0.000076
unknown	22959/udp	0.000654
unknown	22962/udp	0.000654
unknown	22964/udp	0.000654
unknown	22968/udp	0.000654
unknown	22969/tcp	0.000076
unknown	22969/udp	0.000654
unknown	22978/udp	0.000654
unknown	22979/udp	0.000654
unknown	22982/udp	0.000654
unknown	22986/udp	0.003922
unknown	22988/udp	0.000654
unknown	22991/udp	0.001307
unknown	22994/udp	0.000654
unknown	22996/udp	0.002614
inovaport1	23000/udp	0.000654	# Inova LightLink Server Type 1
unknown	23006/udp	0.000654
unknown	23008/udp	0.000654
unknown	23013/udp	0.000654
unknown	23017/tcp	0.000076
unknown	23017/udp	0.000654
unknown	23021/udp	0.000654
unknown	23022/udp	0.000654
unknown	23027/udp	0.001307
unknown	23033/udp	0.000654
unknown	23040/tcp	0.000076
unknown	23040/udp	0.001961
unknown	23041/udp	0.000654
unknown	23042/udp	0.000654
unknown	23045/udp	0.000654
unknown	23052/tcp	0.000152
unknown	23055/udp	0.000654
unknown	23059/udp	0.001307
unknown	23066/udp	0.000654
unknown	23073/udp	0.001307
unknown	23074/udp	0.000654
unknown	23076/udp	0.000654
unknown	23077/udp	0.000654
unknown	23080/udp	0.000654
unknown	23082/udp	0.000654
unknown	23084/udp	0.000654
unknown	23088/udp	0.000654
unknown	23089/udp	0.000654
unknown	23092/udp	0.000654
unknown	23093/udp	0.000654
unknown	23095/udp	0.000654
unknown	23102/udp	0.000654
unknown	23108/udp	0.001307
unknown	23111/udp	0.000654
unknown	23116/udp	0.000654
unknown	23117/udp	0.000654
unknown	23123/udp	0.000654
unknown	23131/udp	0.000654
unknown	23139/udp	0.000654
unknown	23143/udp	0.000654
unknown	23146/udp	0.000654
unknown	23147/udp	0.000654
unknown	23148/udp	0.000654
unknown	23150/udp	0.000654
unknown	23152/udp	0.001307
unknown	23153/udp	0.000654
unknown	23161/udp	0.001307
unknown	23162/udp	0.001307
unknown	23170/udp	0.001307
unknown	23172/udp	0.000654
unknown	23176/udp	0.001961
unknown	23177/udp	0.000654
unknown	23179/udp	0.000654
unknown	23180/udp	0.000654
unknown	23182/udp	0.000654
unknown	23183/udp	0.000654
unknown	23184/udp	0.001307
unknown	23186/udp	0.000654
unknown	23189/udp	0.000654
unknown	23193/udp	0.000654
unknown	23202/udp	0.001307
unknown	23203/udp	0.000654
unknown	23209/udp	0.000654
unknown	23219/tcp	0.000076
unknown	23223/udp	0.000654
unknown	23228/tcp	0.000076
unknown	23230/udp	0.001307
unknown	23236/udp	0.000654
unknown	23238/udp	0.000654
unknown	23256/udp	0.001307
unknown	23257/udp	0.000654
unknown	23258/udp	0.000654
unknown	23262/udp	0.000654
unknown	23265/udp	0.000654
unknown	23268/udp	0.000654
unknown	23270/tcp	0.000076
unknown	23280/udp	0.000654
unknown	23281/udp	0.000654
unknown	23283/udp	0.000654
unknown	23289/udp	0.000654
unknown	23296/tcp	0.000076
unknown	23298/udp	0.000654
unknown	23307/udp	0.000654
unknown	23320/udp	0.000654
unknown	23322/udp	0.001307
unknown	23323/udp	0.000654
unknown	23324/udp	0.000654
unknown	23327/udp	0.001307
unknown	23330/udp	0.000654
unknown	23334/udp	0.000654
unknown	23337/udp	0.001307
unknown	23341/udp	0.001307
unknown	23342/tcp	0.000076
unknown	23344/udp	0.000654
unknown	23347/udp	0.000654
unknown	23350/udp	0.000654
unknown	23351/udp	0.000654
unknown	23352/udp	0.000654
unknown	23354/udp	0.001961
unknown	23356/udp	0.000654
unknown	23360/udp	0.000654
unknown	23363/udp	0.001307
unknown	23374/udp	0.001307
unknown	23378/udp	0.000654
unknown	23380/udp	0.000654
unknown	23382/tcp	0.000076
unknown	23386/udp	0.000654
unknown	23390/udp	0.000654
unknown	23393/udp	0.000654
unknown	23394/udp	0.000654
unknown	23395/udp	0.000654
unknown	23396/udp	0.000654
unknown	23399/udp	0.001307
novar-dbase	23400/udp	0.000654	# Novar Data
unknown	23406/udp	0.000654
unknown	23419/udp	0.000654
unknown	23421/udp	0.001307
unknown	23423/udp	0.000654
unknown	23425/udp	0.000654
unknown	23426/udp	0.001307
unknown	23428/udp	0.001307
unknown	23430/tcp	0.000076
unknown	23430/udp	0.001307
unknown	23436/udp	0.000654
unknown	23438/udp	0.000654
unknown	23440/udp	0.000654
unknown	23441/udp	0.000654
unknown	23445/udp	0.000654
unknown	23451/tcp	0.000076
unknown	23455/udp	0.000654
unknown	23456/udp	0.000654
unknown	23468/udp	0.000654
unknown	23469/udp	0.000654
unknown	23470/udp	0.000654
unknown	23471/udp	0.000654
unknown	23477/udp	0.000654
unknown	23480/udp	0.000654
unknown	23495/udp	0.001307
unknown	23497/udp	0.000654
unknown	23502/tcp	0.000760
unknown	23504/udp	0.001307
unknown	23509/udp	0.000654
unknown	23513/udp	0.000654
unknown	23519/udp	0.000654
unknown	23522/udp	0.001307
unknown	23524/udp	0.000654
unknown	23526/udp	0.000654
unknown	23529/udp	0.000654
unknown	23531/udp	0.001961
unknown	23532/udp	0.000654
unknown	23536/udp	0.000654
unknown	23537/udp	0.000654
unknown	23542/udp	0.000654
unknown	23547/udp	0.001307
unknown	23550/udp	0.000654
unknown	23552/udp	0.000654
unknown	23553/udp	0.000654
unknown	23557/udp	0.001961
unknown	23563/udp	0.000654
unknown	23567/udp	0.000654
unknown	23568/udp	0.000654
unknown	23571/udp	0.000654
unknown	23575/udp	0.000654
unknown	23578/udp	0.000654
unknown	23583/udp	0.000654
unknown	23585/udp	0.001307
unknown	23586/udp	0.001307
unknown	23592/udp	0.000654
unknown	23595/udp	0.000654
unknown	23602/udp	0.000654
unknown	23606/udp	0.000654
unknown	23608/udp	0.001961
unknown	23610/udp	0.000654
unknown	23615/udp	0.000654
unknown	23619/udp	0.000654
unknown	23624/udp	0.000654
unknown	23632/udp	0.000654
unknown	23633/udp	0.001307
unknown	23635/udp	0.000654
unknown	23638/udp	0.001307
unknown	23648/udp	0.000654
unknown	23649/udp	0.000654
unknown	23651/udp	0.000654
unknown	23657/udp	0.000654
unknown	23663/udp	0.000654
unknown	23675/udp	0.000654
unknown	23678/udp	0.000654
unknown	23679/udp	0.001961
unknown	23682/udp	0.000654
unknown	23689/udp	0.000654
unknown	23691/udp	0.000654
unknown	23693/udp	0.000654
unknown	23694/udp	0.000654
unknown	23695/udp	0.000654
unknown	23696/udp	0.000654
unknown	23698/udp	0.001307
unknown	23704/udp	0.001307
unknown	23709/udp	0.000654
unknown	23714/udp	0.001307
unknown	23715/udp	0.000654
unknown	23718/udp	0.000654
unknown	23719/udp	0.000654
unknown	23723/tcp	0.000076
unknown	23726/udp	0.000654
unknown	23728/udp	0.000654
unknown	23730/udp	0.000654
unknown	23734/udp	0.000654
unknown	23739/udp	0.000654
unknown	23740/udp	0.000654
unknown	23745/udp	0.001307
unknown	23746/udp	0.000654
unknown	23752/udp	0.000654
unknown	23755/udp	0.001307
unknown	23757/udp	0.000654
unknown	23758/udp	0.001307
unknown	23761/udp	0.000654
unknown	23768/udp	0.000654
unknown	23770/udp	0.000654
unknown	23771/udp	0.000654
unknown	23778/udp	0.000654
unknown	23781/udp	0.001961
unknown	23783/udp	0.000654
unknown	23786/udp	0.000654
unknown	23789/udp	0.000654
unknown	23791/udp	0.000654
unknown	23792/udp	0.000654
unknown	23794/udp	0.000654
unknown	23796/tcp	0.000152
unknown	23796/udp	0.000654
unknown	23807/udp	0.000654
unknown	23813/udp	0.000654
unknown	23814/udp	0.000654
unknown	23816/udp	0.000654
unknown	23835/udp	0.000654
unknown	23837/udp	0.000654
unknown	23840/udp	0.000654
unknown	23841/udp	0.000654
unknown	23854/udp	0.000654
unknown	23856/udp	0.000654
unknown	23857/udp	0.000654
unknown	23859/udp	0.000654
unknown	23863/udp	0.000654
unknown	23865/udp	0.001307
unknown	23875/udp	0.000654
unknown	23877/udp	0.000654
unknown	23884/udp	0.000654
unknown	23885/udp	0.000654
unknown	23887/tcp	0.000076
unknown	23888/udp	0.000654
unknown	23891/udp	0.000654
unknown	23904/udp	0.000654
unknown	23907/udp	0.000654
unknown	23909/udp	0.000654
unknown	23916/udp	0.000654
unknown	23930/udp	0.000654
unknown	23936/udp	0.000654
unknown	23940/udp	0.001307
unknown	23945/udp	0.000654
unknown	23946/udp	0.001307
unknown	23949/udp	0.000654
unknown	23951/udp	0.001307
unknown	23953/tcp	0.000076
unknown	23953/udp	0.000654
unknown	23963/udp	0.000654
unknown	23964/udp	0.000654
unknown	23965/udp	0.001961
unknown	23969/udp	0.000654
unknown	23980/udp	0.001961
unknown	23981/udp	0.000654
unknown	23983/udp	0.000654
unknown	23985/udp	0.000654
unknown	23986/udp	0.000654
unknown	23987/udp	0.000654
unknown	23988/udp	0.000654
unknown	23989/udp	0.000654
unknown	23990/udp	0.000654
unknown	23993/udp	0.000654
med-ovw	24004/udp	0.000654
med-ci	24005/udp	0.000654
unknown	24007/udp	0.001961
unknown	24008/udp	0.001307
unknown	24012/udp	0.000654
unknown	24013/udp	0.001307
unknown	24014/udp	0.000654
unknown	24016/udp	0.000654
unknown	24021/udp	0.001307
unknown	24022/udp	0.000654
unknown	24029/udp	0.000654
unknown	24031/udp	0.000654
unknown	24032/udp	0.001307
unknown	24033/udp	0.000654
unknown	24042/udp	0.000654
unknown	24056/udp	0.000654
unknown	24061/udp	0.000654
unknown	24063/udp	0.001307
unknown	24066/udp	0.000654
unknown	24069/udp	0.000654
unknown	24070/udp	0.000654
unknown	24075/udp	0.000654
unknown	24076/udp	0.000654
unknown	24092/udp	0.000654
unknown	24093/udp	0.001307
unknown	24096/udp	0.000654
unknown	24098/udp	0.001307
unknown	24104/udp	0.001307
unknown	24105/udp	0.000654
unknown	24107/udp	0.001307
unknown	24108/udp	0.000654
unknown	24111/udp	0.000654
unknown	24113/udp	0.001307
unknown	24121/udp	0.000654
unknown	24127/udp	0.000654
unknown	24129/udp	0.000654
unknown	24134/udp	0.000654
unknown	24139/udp	0.000654
unknown	24148/udp	0.000654
unknown	24151/udp	0.000654
unknown	24154/udp	0.000654
unknown	24155/udp	0.001307
unknown	24157/udp	0.000654
unknown	24158/udp	0.001307
unknown	24159/udp	0.000654
unknown	24160/udp	0.000654
unknown	24162/udp	0.000654
unknown	24165/udp	0.000654
unknown	24168/udp	0.000654
unknown	24172/udp	0.001307
unknown	24181/udp	0.000654
unknown	24187/udp	0.000654
unknown	24188/udp	0.000654
unknown	24201/udp	0.000654
unknown	24207/udp	0.000654
unknown	24212/udp	0.001307
unknown	24216/udp	0.000654
unknown	24218/tcp	0.000076
unknown	24226/udp	0.000654
unknown	24232/udp	0.000654
unknown	24233/udp	0.000654
unknown	24234/udp	0.000654
unknown	24236/udp	0.000654
unknown	24241/udp	0.000654
filesphere	24242/udp	0.001307	# fileSphere
unknown	24245/udp	0.000654
unknown	24247/udp	0.000654
unknown	24250/udp	0.000654
unknown	24257/udp	0.000654
unknown	24262/udp	0.000654
unknown	24263/udp	0.000654
unknown	24265/udp	0.001307
unknown	24266/udp	0.000654
unknown	24268/udp	0.000654
unknown	24271/udp	0.001307
unknown	24272/udp	0.000654
unknown	24273/udp	0.000654
unknown	24274/udp	0.000654
unknown	24276/udp	0.000654
unknown	24277/udp	0.000654
unknown	24279/udp	0.001961
unknown	24291/udp	0.000654
unknown	24300/udp	0.000654
unknown	24302/udp	0.000654
unknown	24306/udp	0.001307
unknown	24309/udp	0.000654
unknown	24323/udp	0.000654
unknown	24324/udp	0.000654
unknown	24326/udp	0.000654
unknown	24342/udp	0.000654
unknown	24346/udp	0.000654
unknown	24353/udp	0.000654
unknown	24355/udp	0.000654
unknown	24356/udp	0.000654
unknown	24360/udp	0.000654
unknown	24362/udp	0.000654
unknown	24363/udp	0.000654
unknown	24366/udp	0.000654
unknown	24373/udp	0.000654
unknown	24374/udp	0.000654
unknown	24388/udp	0.001307
unknown	24392/tcp	0.000076
unknown	24394/udp	0.000654
unknown	24397/udp	0.000654
unknown	24398/udp	0.000654
unknown	24404/udp	0.000654
unknown	24406/udp	0.000654
unknown	24409/udp	0.000654
unknown	24412/udp	0.000654
unknown	24413/udp	0.000654
unknown	24416/tcp	0.000076
unknown	24418/udp	0.001307
unknown	24419/udp	0.001307
unknown	24420/udp	0.000654
unknown	24427/udp	0.000654
unknown	24428/udp	0.000654
unknown	24431/udp	0.000654
unknown	24432/udp	0.000654
unknown	24433/udp	0.000654
unknown	24440/udp	0.000654
unknown	24443/udp	0.000654
unknown	24444/tcp	0.000304
unknown	24444/udp	0.001307
unknown	24449/udp	0.000654
unknown	24452/udp	0.000654
unknown	24456/udp	0.000654
unknown	24460/udp	0.000654
unknown	24462/udp	0.000654
unknown	24463/udp	0.000654
unknown	24466/udp	0.000654
unknown	24467/udp	0.000654
unknown	24482/udp	0.000654
unknown	24489/udp	0.000654
unknown	24490/udp	0.000654
unknown	24496/udp	0.001307
unknown	24497/udp	0.000654
unknown	24500/udp	0.000654
unknown	24505/udp	0.000654
unknown	24508/udp	0.000654
unknown	24509/udp	0.000654
unknown	24511/udp	0.001961
unknown	24512/udp	0.000654
unknown	24518/udp	0.000654
unknown	24524/udp	0.000654
unknown	24527/udp	0.000654
unknown	24528/udp	0.001307
unknown	24538/udp	0.000654
unknown	24539/udp	0.001307
unknown	24552/tcp	0.000076
binkp	24554/tcp	0.000076	# BINKP
unknown	24555/udp	0.000654
unknown	24560/udp	0.000654
unknown	24562/udp	0.000654
unknown	24564/udp	0.000654
unknown	24567/udp	0.000654
unknown	24573/udp	0.000654
unknown	24580/udp	0.000654
unknown	24582/udp	0.000654
unknown	24584/udp	0.000654
unknown	24594/udp	0.001961
unknown	24595/udp	0.000654
unknown	24606/udp	0.001961
unknown	24610/udp	0.000654
unknown	24611/udp	0.000654
unknown	24616/tcp	0.000076
unknown	24616/udp	0.000654
unknown	24620/udp	0.000654
unknown	24622/udp	0.000654
unknown	24626/udp	0.000654
unknown	24627/udp	0.000654
unknown	24636/udp	0.000654
unknown	24639/udp	0.001307
unknown	24642/udp	0.000654
unknown	24644/udp	0.001961
unknown	24645/udp	0.000654
unknown	24650/udp	0.000654
unknown	24652/udp	0.000654
unknown	24655/udp	0.001307
unknown	24656/udp	0.000654
unknown	24657/udp	0.000654
unknown	24658/udp	0.001307
unknown	24665/udp	0.001307
unknown	24668/udp	0.000654
flashfiler	24677/udp	0.000654	# FlashFiler
unknown	24679/udp	0.000654
tcc-http	24680/udp	0.000654	# TCC User HTTP Service
unknown	24681/udp	0.000654
unknown	24684/udp	0.000654
unknown	24685/udp	0.000654
unknown	24686/udp	0.000654
unknown	24689/udp	0.001307
unknown	24692/udp	0.000654
unknown	24693/udp	0.001307
unknown	24696/udp	0.000654
unknown	24705/udp	0.000654
unknown	24706/udp	0.001307
unknown	24716/udp	0.000654
unknown	24722/udp	0.000654
unknown	24723/udp	0.000654
unknown	24725/udp	0.001307
unknown	24731/udp	0.001307
unknown	24732/udp	0.000654
unknown	24735/udp	0.000654
unknown	24737/udp	0.000654
unknown	24739/udp	0.000654
unknown	24740/udp	0.000654
unknown	24741/udp	0.001307
unknown	24756/udp	0.001307
unknown	24761/udp	0.000654
unknown	24763/udp	0.000654
unknown	24767/udp	0.000654
unknown	24773/udp	0.000654
unknown	24779/udp	0.000654
unknown	24781/udp	0.000654
unknown	24782/udp	0.000654
unknown	24783/udp	0.000654
unknown	24790/udp	0.000654
unknown	24794/udp	0.000654
unknown	24795/udp	0.000654
unknown	24796/udp	0.000654
unknown	24798/udp	0.000654
unknown	24800/tcp	0.000380
unknown	24800/udp	0.001307
unknown	24802/udp	0.000654
unknown	24805/udp	0.000654
unknown	24811/udp	0.000654
unknown	24818/udp	0.001307
unknown	24822/udp	0.000654
unknown	24824/udp	0.000654
unknown	24825/udp	0.000654
unknown	24828/udp	0.000654
unknown	24831/udp	0.000654
unknown	24837/udp	0.001307
unknown	24840/udp	0.000654
unknown	24841/udp	0.000654
unknown	24843/udp	0.000654
unknown	24844/udp	0.000654
unknown	24848/udp	0.000654
unknown	24852/udp	0.000654
unknown	24854/udp	0.001961
unknown	24862/udp	0.000654
unknown	24865/udp	0.000654
unknown	24867/udp	0.000654
unknown	24869/udp	0.000654
unknown	24870/udp	0.000654
unknown	24871/udp	0.000654
unknown	24874/udp	0.000654
unknown	24875/udp	0.001307
unknown	24878/udp	0.000654
unknown	24882/udp	0.000654
unknown	24883/udp	0.000654
unknown	24890/udp	0.000654
unknown	24893/udp	0.000654
unknown	24899/udp	0.000654
unknown	24905/udp	0.000654
unknown	24910/udp	0.001961
unknown	24911/udp	0.001307
unknown	24916/udp	0.001307
unknown	24926/udp	0.000654
unknown	24932/udp	0.000654
unknown	24936/udp	0.000654
unknown	24939/udp	0.000654
unknown	24941/udp	0.001307
unknown	24943/udp	0.000654
unknown	24945/udp	0.001307
unknown	24946/udp	0.000654
unknown	24950/udp	0.001307
unknown	24956/udp	0.000654
unknown	24957/udp	0.000654
unknown	24958/udp	0.000654
unknown	24963/udp	0.000654
unknown	24973/udp	0.000654
unknown	24980/udp	0.000654
unknown	24982/udp	0.000654
unknown	24983/udp	0.000654
unknown	24993/udp	0.000654
unknown	24995/udp	0.000654
unknown	24999/tcp	0.000076
icl-twobase1	25000/tcp	0.000076
icl-twobase2	25001/tcp	0.000076
icl-twobase4	25003/udp	0.001961
unknown	25011/udp	0.000654
unknown	25017/udp	0.000654
unknown	25018/udp	0.000654
unknown	25019/udp	0.000654
unknown	25020/udp	0.000654
unknown	25025/udp	0.000654
unknown	25028/udp	0.000654
unknown	25029/udp	0.000654
unknown	25030/udp	0.000654
unknown	25036/udp	0.001307
unknown	25040/udp	0.001307
unknown	25043/udp	0.000654
unknown	25052/udp	0.000654
unknown	25067/udp	0.000654
unknown	25069/udp	0.000654
unknown	25074/udp	0.000654
unknown	25078/udp	0.000654
unknown	25080/udp	0.000654
unknown	25081/udp	0.000654
unknown	25082/udp	0.000654
unknown	25086/udp	0.000654
unknown	25091/udp	0.000654
unknown	25093/udp	0.000654
unknown	25102/udp	0.000654
unknown	25103/udp	0.000654
unknown	25104/udp	0.000654
unknown	25107/udp	0.000654
unknown	25115/udp	0.000654
unknown	25127/udp	0.000654
unknown	25129/udp	0.000654
unknown	25135/udp	0.001307
unknown	25137/udp	0.000654
unknown	25147/udp	0.000654
unknown	25150/udp	0.000654
unknown	25153/udp	0.000654
unknown	25155/udp	0.000654
unknown	25157/udp	0.001961
unknown	25158/udp	0.000654
unknown	25159/udp	0.000654
unknown	25160/udp	0.000654
unknown	25163/udp	0.000654
unknown	25168/udp	0.000654
unknown	25169/udp	0.001307
unknown	25170/udp	0.001307
unknown	25173/udp	0.000654
unknown	25174/tcp	0.000076
unknown	25180/udp	0.000654
unknown	25183/udp	0.000654
unknown	25184/udp	0.000654
unknown	25185/udp	0.000654
unknown	25191/udp	0.000654
unknown	25192/udp	0.000654
unknown	25197/udp	0.000654
unknown	25202/udp	0.000654
unknown	25204/udp	0.000654
unknown	25205/udp	0.000654
unknown	25211/udp	0.000654
unknown	25212/udp	0.001307
unknown	25214/udp	0.000654
unknown	25215/udp	0.000654
unknown	25217/udp	0.000654
unknown	25228/udp	0.000654
unknown	25230/udp	0.000654
unknown	25235/udp	0.000654
unknown	25237/udp	0.000654
unknown	25240/udp	0.001961
unknown	25241/udp	0.000654
unknown	25243/udp	0.000654
unknown	25244/udp	0.000654
unknown	25248/udp	0.001307
unknown	25249/udp	0.001307
unknown	25251/udp	0.000654
unknown	25258/udp	0.000654
unknown	25260/tcp	0.000076
unknown	25262/tcp	0.000076
unknown	25266/udp	0.001307
unknown	25267/udp	0.000654
unknown	25268/udp	0.000654
unknown	25271/udp	0.001307
unknown	25274/udp	0.000654
unknown	25280/udp	0.001961
unknown	25286/udp	0.000654
unknown	25288/tcp	0.000076
unknown	25288/udp	0.000654
unknown	25290/udp	0.001307
unknown	25301/udp	0.000654
unknown	25302/udp	0.000654
unknown	25304/udp	0.000654
unknown	25309/udp	0.000654
unknown	25314/udp	0.000654
unknown	25321/udp	0.000654
unknown	25327/tcp	0.000076
unknown	25331/udp	0.001307
unknown	25332/udp	0.001307
unknown	25337/udp	0.001961
unknown	25338/udp	0.000654
unknown	25343/udp	0.000654
unknown	25348/udp	0.000654
unknown	25353/udp	0.000654
unknown	25364/udp	0.000654
unknown	25366/udp	0.001307
unknown	25369/udp	0.000654
unknown	25374/udp	0.000654
unknown	25375/udp	0.002614
unknown	25378/udp	0.000654
unknown	25385/udp	0.001307
unknown	25390/udp	0.000654
unknown	25394/udp	0.000654
unknown	25395/udp	0.000654
unknown	25396/udp	0.000654
unknown	25397/udp	0.000654
unknown	25398/udp	0.000654
unknown	25399/udp	0.000654
unknown	25402/udp	0.001307
unknown	25416/udp	0.000654
unknown	25418/udp	0.000654
unknown	25421/udp	0.000654
unknown	25428/udp	0.000654
unknown	25432/udp	0.000654
unknown	25439/udp	0.000654
unknown	25442/udp	0.000654
unknown	25443/udp	0.000654
unknown	25445/tcp	0.000076
unknown	25446/udp	0.000654
unknown	25451/udp	0.000654
unknown	25453/udp	0.000654
unknown	25455/udp	0.000654
unknown	25460/udp	0.000654
unknown	25462/udp	0.001961
unknown	25466/udp	0.001307
unknown	25473/tcp	0.000076
unknown	25474/udp	0.000654
unknown	25480/udp	0.000654
unknown	25483/udp	0.000654
unknown	25486/tcp	0.000076
unknown	25488/udp	0.001307
unknown	25492/udp	0.000654
unknown	25493/udp	0.000654
unknown	25498/udp	0.001307
unknown	25499/udp	0.000654
unknown	25502/udp	0.000654
unknown	25509/udp	0.000654
unknown	25514/udp	0.001307
unknown	25515/udp	0.000654
unknown	25521/udp	0.001307
unknown	25522/udp	0.000654
unknown	25523/udp	0.000654
unknown	25524/udp	0.000654
unknown	25533/udp	0.000654
unknown	25534/udp	0.000654
unknown	25537/udp	0.000654
unknown	25538/udp	0.001307
unknown	25540/udp	0.000654
unknown	25541/udp	0.001961
unknown	25542/udp	0.000654
unknown	25544/udp	0.001307
unknown	25546/udp	0.001961
unknown	25560/udp	0.001307
unknown	25564/udp	0.000654
minecraft	25565/tcp	0.000076	# A video game - http://en.wikipedia.org/wiki/Minecraft
unknown	25567/udp	0.000654
unknown	25568/udp	0.000654
unknown	25569/udp	0.000654
unknown	25572/udp	0.000654
unknown	25573/udp	0.000654
unknown	25574/udp	0.000654
unknown	25579/udp	0.001307
unknown	25586/udp	0.001307
unknown	25588/udp	0.000654
unknown	25590/udp	0.000654
unknown	25591/udp	0.000654
unknown	25592/udp	0.000654
unknown	25594/udp	0.000654
unknown	25600/udp	0.001307
unknown	25603/udp	0.000654
unknown	25611/udp	0.000654
unknown	25617/udp	0.000654
unknown	25618/udp	0.000654
unknown	25624/udp	0.001307
unknown	25627/udp	0.001307
unknown	25628/udp	0.001307
unknown	25630/udp	0.000654
unknown	25636/udp	0.000654
unknown	25641/udp	0.000654
unknown	25642/udp	0.000654
unknown	25643/udp	0.000654
unknown	25644/udp	0.000654
unknown	25652/udp	0.001307
unknown	25658/udp	0.000654
unknown	25659/udp	0.000654
unknown	25666/udp	0.000654
unknown	25667/udp	0.000654
unknown	25670/udp	0.001307
unknown	25677/udp	0.000654
unknown	25687/udp	0.000654
unknown	25703/tcp	0.000076
unknown	25706/udp	0.000654
unknown	25709/udp	0.001961
unknown	25710/udp	0.000654
unknown	25712/udp	0.000654
unknown	25715/udp	0.001307
unknown	25716/udp	0.000654
unknown	25717/tcp	0.000076
unknown	25723/udp	0.000654
unknown	25724/udp	0.000654
unknown	25730/udp	0.000654
unknown	25731/udp	0.000654
unknown	25733/udp	0.001307
unknown	25734/tcp	0.000380
unknown	25735/tcp	0.000228
unknown	25735/udp	0.000654
unknown	25744/udp	0.000654
unknown	25751/udp	0.000654
unknown	25756/udp	0.001307
unknown	25763/udp	0.000654
unknown	25767/udp	0.000654
unknown	25768/udp	0.000654
unknown	25778/udp	0.001307
unknown	25790/udp	0.000654
vocaltec-hos	25793/udp	0.000654	# Vocaltec Address Server
unknown	25794/udp	0.000654
unknown	25798/udp	0.000654
unknown	25799/udp	0.000654
unknown	25815/udp	0.000654
unknown	25823/udp	0.000654
unknown	25826/udp	0.001307
unknown	25827/udp	0.000654
unknown	25832/udp	0.000654
unknown	25833/udp	0.000654
unknown	25841/udp	0.000654
unknown	25847/tcp	0.000076
unknown	25849/udp	0.000654
unknown	25851/udp	0.001307
unknown	25853/udp	0.000654
unknown	25857/udp	0.000654
unknown	25868/udp	0.001307
unknown	25875/udp	0.001307
unknown	25879/udp	0.000654
unknown	25881/udp	0.000654
unknown	25887/udp	0.000654
unknown	25894/udp	0.000654
unknown	25896/udp	0.000654
niobserver	25901/udp	0.000654	# NIObserver
unknown	25909/udp	0.001307
unknown	25910/udp	0.000654
unknown	25913/udp	0.001307
unknown	25921/udp	0.000654
unknown	25925/udp	0.001307
unknown	25928/udp	0.000654
unknown	25929/udp	0.000654
unknown	25931/udp	0.001961
unknown	25940/udp	0.000654
unknown	25944/udp	0.000654
unknown	25949/udp	0.000654
unknown	25950/udp	0.000654
unknown	25951/udp	0.000654
unknown	25956/udp	0.001307
unknown	25958/udp	0.000654
unknown	25968/udp	0.000654
unknown	25969/udp	0.000654
unknown	25975/udp	0.000654
unknown	25980/udp	0.000654
unknown	25985/udp	0.000654
unknown	25987/udp	0.000654
unknown	25988/udp	0.000654
unknown	25989/udp	0.000654
unknown	25992/udp	0.001307
unknown	25993/udp	0.000654
quake	26000/tcp	0.000152
quake	26000/udp	0.000490	# Quake game server
unknown	26001/tcp	0.000076
unknown	26002/udp	0.000654
unknown	26005/udp	0.000654
unknown	26007/tcp	0.000076
unknown	26013/udp	0.000654
unknown	26020/udp	0.000654
unknown	26021/udp	0.000654
unknown	26026/udp	0.001307
unknown	26030/udp	0.000654
unknown	26031/udp	0.001307
unknown	26033/udp	0.000654
unknown	26035/udp	0.000654
unknown	26036/udp	0.000654
unknown	26039/udp	0.000654
unknown	26040/udp	0.000654
unknown	26048/udp	0.000654
unknown	26050/udp	0.000654
unknown	26052/udp	0.001307
unknown	26055/udp	0.000654
unknown	26057/udp	0.000654
unknown	26058/udp	0.000654
unknown	26062/udp	0.000654
unknown	26066/udp	0.000654
unknown	26067/udp	0.000654
unknown	26073/udp	0.000654
unknown	26078/udp	0.000654
unknown	26079/udp	0.001307
unknown	26080/udp	0.000654
unknown	26089/udp	0.000654
unknown	26090/udp	0.000654
unknown	26095/udp	0.000654
unknown	26100/udp	0.000654
unknown	26103/udp	0.001307
unknown	26107/udp	0.000654
unknown	26110/udp	0.000654
unknown	26116/udp	0.000654
unknown	26119/udp	0.000654
unknown	26121/udp	0.000654
unknown	26123/udp	0.001307
unknown	26127/udp	0.000654
unknown	26130/udp	0.000654
unknown	26131/udp	0.000654
unknown	26134/udp	0.000654
unknown	26137/udp	0.000654
unknown	26141/udp	0.000654
unknown	26147/udp	0.000654
unknown	26157/udp	0.000654
unknown	26158/udp	0.000654
unknown	26163/udp	0.000654
unknown	26164/udp	0.000654
unknown	26171/udp	0.001307
unknown	26172/udp	0.000654
unknown	26175/udp	0.000654
unknown	26179/udp	0.000654
unknown	26181/udp	0.000654
unknown	26183/udp	0.000654
unknown	26187/udp	0.000654
unknown	26189/udp	0.000654
unknown	26191/udp	0.001307
unknown	26196/udp	0.001307
unknown	26198/udp	0.000654
unknown	26201/udp	0.000654
unknown	26203/udp	0.000654
unknown	26204/udp	0.001307
unknown	26205/udp	0.000654
unknown	26207/udp	0.000654
wnn6_DS	26208/tcp	0.000025	# Wnn6 (Dserver)
unknown	26211/udp	0.000654
unknown	26214/tcp	0.000228
unknown	26219/udp	0.001307
unknown	26225/udp	0.000654
unknown	26239/udp	0.001307
unknown	26243/udp	0.001307
unknown	26254/udp	0.001307
unknown	26270/udp	0.000654
unknown	26273/udp	0.000654
unknown	26275/udp	0.000654
unknown	26279/udp	0.000654
unknown	26283/udp	0.000654
unknown	26284/udp	0.001307
unknown	26286/udp	0.001307
unknown	26289/udp	0.001307
unknown	26291/udp	0.000654
unknown	26296/udp	0.000654
unknown	26299/udp	0.000654
unknown	26304/udp	0.000654
unknown	26311/udp	0.000654
unknown	26318/udp	0.000654
unknown	26325/udp	0.000654
unknown	26337/udp	0.001307
unknown	26338/udp	0.000654
unknown	26339/udp	0.000654
unknown	26340/tcp	0.000076
unknown	26340/udp	0.001307
unknown	26356/udp	0.000654
unknown	26362/udp	0.000654
unknown	26364/udp	0.000654
unknown	26367/udp	0.000654
unknown	26369/udp	0.000654
unknown	26372/udp	0.000654
unknown	26376/udp	0.000654
unknown	26381/udp	0.001307
unknown	26384/udp	0.000654
unknown	26388/udp	0.001307
unknown	26395/udp	0.000654
unknown	26397/udp	0.000654
unknown	26401/udp	0.001307
unknown	26407/udp	0.001961
unknown	26409/udp	0.000654
unknown	26411/udp	0.000654
unknown	26413/udp	0.000654
unknown	26415/udp	0.001961
unknown	26416/udp	0.000654
unknown	26417/tcp	0.000076
unknown	26417/udp	0.000654
unknown	26418/udp	0.000654
unknown	26420/udp	0.001307
unknown	26423/udp	0.001307
unknown	26431/udp	0.001307
unknown	26432/udp	0.000654
unknown	26434/udp	0.001307
unknown	26436/udp	0.000654
unknown	26439/udp	0.000654
unknown	26442/udp	0.000654
unknown	26448/udp	0.000654
unknown	26451/udp	0.000654
unknown	26452/udp	0.001307
unknown	26466/udp	0.000654
unknown	26470/tcp	0.000152
unknown	26473/udp	0.000654
unknown	26477/udp	0.000654
unknown	26481/udp	0.000654
unknown	26482/udp	0.000654
unknown	26484/udp	0.000654
unknown	26491/udp	0.000654
unknown	26493/udp	0.001307
unknown	26497/udp	0.000654
unknown	26507/udp	0.001307
unknown	26508/udp	0.000654
unknown	26509/udp	0.000654
unknown	26512/udp	0.001307
unknown	26522/udp	0.000654
unknown	26523/udp	0.000654
unknown	26529/udp	0.000654
unknown	26531/udp	0.001307
unknown	26532/udp	0.000654
unknown	26536/udp	0.000654
unknown	26538/udp	0.000654
unknown	26541/udp	0.000654
unknown	26549/udp	0.001307
unknown	26556/udp	0.000654
unknown	26563/udp	0.000654
unknown	26573/udp	0.000654
unknown	26575/udp	0.000654
unknown	26578/udp	0.000654
unknown	26579/udp	0.000654
unknown	26585/udp	0.000654
unknown	26587/udp	0.000654
unknown	26594/udp	0.000654
unknown	26596/udp	0.000654
unknown	26618/udp	0.000654
unknown	26621/udp	0.000654
unknown	26622/udp	0.000654
unknown	26628/udp	0.000654
unknown	26631/udp	0.000654
unknown	26639/udp	0.000654
unknown	26641/udp	0.000654
unknown	26645/udp	0.001307
unknown	26649/udp	0.000654
unknown	26651/udp	0.000654
unknown	26654/udp	0.000654
unknown	26655/udp	0.000654
unknown	26664/udp	0.000654
unknown	26665/udp	0.000654
unknown	26666/udp	0.000654
unknown	26668/udp	0.000654
unknown	26669/tcp	0.000076
unknown	26673/udp	0.000654
unknown	26674/udp	0.000654
unknown	26678/udp	0.000654
unknown	26679/udp	0.000654
unknown	26681/udp	0.000654
unknown	26683/udp	0.000654
unknown	26685/udp	0.000654
unknown	26689/udp	0.000654
unknown	26690/udp	0.000654
unknown	26691/udp	0.000654
unknown	26692/udp	0.000654
unknown	26695/udp	0.000654
unknown	26698/udp	0.001307
unknown	26699/udp	0.000654
unknown	26702/udp	0.000654
unknown	26705/udp	0.001307
unknown	26706/udp	0.000654
unknown	26708/udp	0.000654
unknown	26714/udp	0.000654
unknown	26718/udp	0.000654
unknown	26720/udp	0.001961
unknown	26724/udp	0.000654
unknown	26725/udp	0.000654
unknown	26742/udp	0.001307
unknown	26746/udp	0.000654
unknown	26747/udp	0.000654
unknown	26753/udp	0.000654
unknown	26754/udp	0.000654
unknown	26760/udp	0.000654
unknown	26761/udp	0.000654
unknown	26765/udp	0.001307
unknown	26771/udp	0.001307
unknown	26775/udp	0.000654
unknown	26776/udp	0.000654
unknown	26786/udp	0.000654
unknown	26792/udp	0.000654
unknown	26794/udp	0.000654
unknown	26795/udp	0.001307
unknown	26796/udp	0.001307
unknown	26801/udp	0.000654
unknown	26803/udp	0.000654
unknown	26805/udp	0.000654
unknown	26806/udp	0.000654
unknown	26810/udp	0.000654
unknown	26814/udp	0.000654
unknown	26819/udp	0.001307
unknown	26823/udp	0.001307
unknown	26829/udp	0.000654
unknown	26830/udp	0.000654
unknown	26839/udp	0.000654
unknown	26841/udp	0.000654
unknown	26842/udp	0.000654
unknown	26843/udp	0.001307
unknown	26845/udp	0.001307
unknown	26847/udp	0.000654
unknown	26857/udp	0.000654
unknown	26859/udp	0.000654
unknown	26860/udp	0.000654
unknown	26861/udp	0.000654
unknown	26866/udp	0.001307
unknown	26868/udp	0.001307
unknown	26872/udp	0.001961
unknown	26875/udp	0.000654
unknown	26876/udp	0.000654
unknown	26878/udp	0.001307
unknown	26881/udp	0.000654
unknown	26882/udp	0.000654
unknown	26884/udp	0.000654
unknown	26888/udp	0.001307
unknown	26891/udp	0.000654
unknown	26896/udp	0.000654
unknown	26899/udp	0.000654
hexen2	26900/udp	0.001166	# Hexen 2 game server
unknown	26903/udp	0.000654
unknown	26906/udp	0.000654
unknown	26914/udp	0.000654
unknown	26916/udp	0.000654
unknown	26919/udp	0.000654
unknown	26926/udp	0.000654
unknown	26932/udp	0.000654
unknown	26934/udp	0.000654
unknown	26937/udp	0.000654
unknown	26941/udp	0.000654
unknown	26944/udp	0.000654
unknown	26949/udp	0.001307
unknown	26951/udp	0.000654
unknown	26953/udp	0.000654
unknown	26955/udp	0.000654
unknown	26958/udp	0.000654
unknown	26960/udp	0.000654
unknown	26963/udp	0.000654
unknown	26966/udp	0.001961
unknown	26970/udp	0.000654
unknown	26972/tcp	0.000076
unknown	26973/udp	0.001307
unknown	26977/udp	0.000654
unknown	26979/udp	0.000654
unknown	26982/udp	0.001307
unknown	26983/udp	0.000654
unknown	26988/udp	0.000654
unknown	26994/udp	0.001307
unknown	26996/udp	0.001307
unknown	26998/udp	0.001307
flexlm0	27000/tcp	0.000640	# FlexLM license manager additional ports
flexlm1	27001/tcp	0.000075	# FlexLM license manager additional ports
flexlm2	27002/tcp	0.000013	# FlexLM license manager additional ports
flex-lm	27002/udp	0.001307	# FLEX LM (1-10)
flexlm3	27003/tcp	0.000013	# FlexLM license manager additional ports
flex-lm	27003/udp	0.000654	# FLEX LM (1-10)
flexlm5	27005/tcp	0.000013	# FlexLM license manager additional ports
flexlm7	27007/tcp	0.000013	# FlexLM license manager additional ports
flex-lm	27007/udp	0.001307	# FLEX LM (1-10)
flexlm9	27009/tcp	0.000013	# FlexLM license manager additional ports
flexlm10	27010/tcp	0.000063	# FlexLM license manager additional ports
unknown	27010/udp	0.001307
unknown	27014/udp	0.000654
unknown	27015/tcp	0.000076
halflife	27015/udp	0.002432	# Half-life game server
unknown	27016/tcp	0.000076
mongod	27017/tcp	0.000076	# http://docs.mongodb.org/manual/reference/default-mongodb-port/
unknown	27017/udp	0.001307
mongod	27018/tcp	0.000076	# http://docs.mongodb.org/manual/reference/default-mongodb-port/
unknown	27018/udp	0.000654
mongod	27019/tcp	0.000076	# http://docs.mongodb.org/manual/reference/default-mongodb-port/
unknown	27020/udp	0.000654
unknown	27025/udp	0.001307
unknown	27027/udp	0.001307
unknown	27029/udp	0.000654
unknown	27032/udp	0.000654
unknown	27036/udp	0.000654
unknown	27038/udp	0.000654
unknown	27042/udp	0.000654
unknown	27046/udp	0.000654
unknown	27048/udp	0.000654
unknown	27049/udp	0.000654
unknown	27055/tcp	0.000076
unknown	27057/udp	0.000654
unknown	27058/udp	0.001307
unknown	27061/udp	0.000654
unknown	27062/udp	0.000654
unknown	27064/udp	0.001307
unknown	27072/udp	0.001307
unknown	27074/tcp	0.000076
unknown	27075/tcp	0.000076
unknown	27075/udp	0.000654
unknown	27076/udp	0.000654
unknown	27078/udp	0.001307
unknown	27079/udp	0.001307
unknown	27085/udp	0.001307
unknown	27087/tcp	0.000076
unknown	27087/udp	0.000654
unknown	27088/udp	0.000654
unknown	27089/udp	0.000654
unknown	27094/udp	0.000654
unknown	27095/udp	0.001307
unknown	27098/udp	0.000654
unknown	27100/udp	0.000654
unknown	27101/udp	0.000654
unknown	27104/udp	0.000654
unknown	27110/udp	0.001307
unknown	27118/udp	0.000654
unknown	27133/udp	0.001307
unknown	27139/udp	0.000654
unknown	27144/udp	0.000654
unknown	27147/udp	0.000654
unknown	27148/udp	0.000654
unknown	27150/udp	0.001307
unknown	27157/udp	0.000654
unknown	27169/udp	0.000654
unknown	27172/udp	0.000654
unknown	27174/udp	0.000654
unknown	27175/udp	0.000654
unknown	27179/udp	0.001307
unknown	27180/udp	0.001307
unknown	27182/udp	0.001307
unknown	27192/udp	0.000654
unknown	27195/udp	0.002614
unknown	27196/udp	0.000654
unknown	27200/udp	0.001307
unknown	27202/udp	0.000654
unknown	27204/tcp	0.000076
unknown	27209/udp	0.001307
unknown	27212/udp	0.000654
unknown	27221/udp	0.000654
unknown	27223/udp	0.000654
unknown	27227/udp	0.000654
unknown	27228/udp	0.000654
unknown	27230/udp	0.000654
unknown	27232/udp	0.000654
unknown	27237/udp	0.000654
unknown	27249/udp	0.000654
unknown	27258/udp	0.000654
unknown	27259/udp	0.000654
unknown	27263/udp	0.001307
unknown	27268/udp	0.000654
unknown	27270/udp	0.000654
unknown	27271/udp	0.001307
unknown	27272/udp	0.001307
unknown	27274/udp	0.000654
unknown	27280/udp	0.000654
unknown	27285/udp	0.000654
unknown	27286/udp	0.000654
unknown	27287/udp	0.001307
unknown	27289/udp	0.000654
unknown	27290/udp	0.000654
unknown	27291/udp	0.000654
unknown	27298/udp	0.000654
unknown	27300/udp	0.000654
unknown	27310/udp	0.000654
unknown	27313/udp	0.000654
unknown	27316/tcp	0.000076
unknown	27323/udp	0.000654
unknown	27330/udp	0.000654
unknown	27331/udp	0.000654
unknown	27340/udp	0.000654
unknown	27350/tcp	0.000076
unknown	27351/tcp	0.000076
unknown	27352/tcp	0.000304
unknown	27353/tcp	0.000304
unknown	27355/tcp	0.000304
unknown	27355/udp	0.000654
unknown	27356/tcp	0.000228
unknown	27357/tcp	0.000152
unknown	27358/udp	0.000654
unknown	27364/udp	0.000654
unknown	27366/udp	0.000654
unknown	27368/udp	0.000654
unknown	27372/tcp	0.000076
unknown	27373/udp	0.000654
subseven	27374/tcp	0.000050	# Subseven Windows trojan
unknown	27381/udp	0.000654
unknown	27391/udp	0.000654
unknown	27395/udp	0.000654
unknown	27397/udp	0.000654
unknown	27398/udp	0.000654
unknown	27408/udp	0.000654
unknown	27410/udp	0.000654
unknown	27414/udp	0.001307
unknown	27416/udp	0.001307
unknown	27424/udp	0.000654
unknown	27433/udp	0.000654
unknown	27436/udp	0.000654
unknown	27437/udp	0.001307
unknown	27438/udp	0.000654
Trinoo_Bcast	27444/udp	0.001554	# Trinoo distributed attack tool Master
unknown	27445/udp	0.000654
unknown	27449/udp	0.000654
unknown	27454/udp	0.000654
unknown	27455/udp	0.000654
unknown	27464/udp	0.000654
unknown	27465/udp	0.000654
unknown	27466/udp	0.001307
unknown	27470/udp	0.000654
unknown	27471/udp	0.000654
unknown	27473/udp	0.001961
unknown	27475/udp	0.000654
unknown	27476/udp	0.000654
unknown	27482/udp	0.001961
unknown	27487/udp	0.001307
unknown	27493/udp	0.000654
quakeworld	27500/udp	0.000980	# Quake world
unknown	27501/udp	0.000654
unknown	27507/udp	0.000654
unknown	27510/udp	0.000654
unknown	27512/udp	0.000654
unknown	27521/tcp	0.000076
unknown	27525/udp	0.000654
unknown	27532/udp	0.000654
unknown	27533/udp	0.000654
unknown	27537/tcp	0.000076
unknown	27537/udp	0.000654
unknown	27538/udp	0.001307
unknown	27547/udp	0.001307
unknown	27548/udp	0.000654
unknown	27556/udp	0.000654
unknown	27561/udp	0.001307
unknown	27563/udp	0.000654
unknown	27564/udp	0.000654
unknown	27566/udp	0.000654
unknown	27573/udp	0.001307
unknown	27575/udp	0.000654
unknown	27579/udp	0.001307
unknown	27581/udp	0.000654
unknown	27584/udp	0.000654
unknown	27586/udp	0.000654
unknown	27587/udp	0.000654
unknown	27588/udp	0.000654
unknown	27593/udp	0.000654
unknown	27597/udp	0.000654
unknown	27599/udp	0.000654
unknown	27600/udp	0.001307
unknown	27602/udp	0.000654
unknown	27606/udp	0.001307
unknown	27608/udp	0.000654
unknown	27617/udp	0.000654
unknown	27621/udp	0.000654
unknown	27622/udp	0.000654
unknown	27624/udp	0.000654
unknown	27626/udp	0.000654
unknown	27630/udp	0.000654
unknown	27631/udp	0.000654
unknown	27636/udp	0.000654
unknown	27637/udp	0.000654
unknown	27662/udp	0.000654
unknown	27663/udp	0.000654
Trinoo_Master	27665/tcp	0.000038	# Trinoo distributed attack tool Master server control port
unknown	27666/udp	0.001307
unknown	27669/udp	0.000654
unknown	27672/udp	0.000654
unknown	27673/udp	0.001307
unknown	27677/udp	0.000654
unknown	27678/udp	0.001307
unknown	27680/udp	0.000654
unknown	27682/udp	0.001307
unknown	27687/udp	0.000654
unknown	27688/udp	0.000654
unknown	27689/udp	0.000654
unknown	27690/udp	0.000654
unknown	27693/udp	0.000654
unknown	27694/udp	0.000654
unknown	27696/udp	0.001307
unknown	27698/udp	0.000654
unknown	27700/udp	0.000654
unknown	27702/udp	0.000654
unknown	27703/udp	0.000654
unknown	27705/udp	0.000654
unknown	27707/udp	0.001961
unknown	27708/udp	0.001307
unknown	27711/udp	0.001307
unknown	27712/udp	0.000654
unknown	27713/udp	0.000654
unknown	27714/udp	0.000654
unknown	27715/tcp	0.000380
unknown	27715/udp	0.000654
unknown	27718/udp	0.001307
unknown	27720/udp	0.000654
unknown	27721/udp	0.000654
unknown	27722/udp	0.001307
unknown	27729/udp	0.000654
unknown	27733/udp	0.000654
unknown	27735/udp	0.000654
unknown	27741/udp	0.000654
unknown	27742/udp	0.000654
unknown	27745/udp	0.000654
unknown	27750/udp	0.001307
unknown	27755/udp	0.000654
unknown	27756/udp	0.000654
unknown	27760/udp	0.000654
unknown	27767/udp	0.000654
unknown	27769/udp	0.000654
unknown	27770/tcp	0.000076
unknown	27775/udp	0.000654
unknown	27781/udp	0.000654
unknown	27783/udp	0.000654
unknown	27785/udp	0.000654
unknown	27786/udp	0.000654
unknown	27788/udp	0.000654
unknown	27792/udp	0.000654
unknown	27801/udp	0.000654
unknown	27803/udp	0.000654
unknown	27815/udp	0.000654
unknown	27817/udp	0.000654
unknown	27818/udp	0.000654
unknown	27822/udp	0.000654
unknown	27826/udp	0.000654
unknown	27828/udp	0.000654
unknown	27829/udp	0.000654
unknown	27830/udp	0.000654
unknown	27832/udp	0.000654
unknown	27833/udp	0.000654
unknown	27836/udp	0.000654
unknown	27838/udp	0.000654
unknown	27849/udp	0.000654
unknown	27850/udp	0.000654
unknown	27853/udp	0.001307
unknown	27856/udp	0.000654
unknown	27859/udp	0.000654
unknown	27860/udp	0.000654
unknown	27861/udp	0.001307
unknown	27863/udp	0.000654
unknown	27867/udp	0.000654
unknown	27869/udp	0.000654
unknown	27872/udp	0.000654
unknown	27876/udp	0.000654
unknown	27884/udp	0.000654
unknown	27887/udp	0.000654
unknown	27892/udp	0.003268
unknown	27895/udp	0.001307
unknown	27899/udp	0.001961
unknown	27900/udp	0.000654
unknown	27902/udp	0.000654
unknown	27905/udp	0.000654
quake2	27910/udp	0.000760	# Quake 2 game server
unknown	27912/udp	0.000654
unknown	27916/udp	0.000654
unknown	27918/udp	0.000654
unknown	27919/udp	0.001307
unknown	27931/udp	0.000654
unknown	27939/udp	0.000654
unknown	27940/udp	0.000654
unknown	27944/udp	0.000654
unknown	27949/udp	0.001307
unknown	27951/udp	0.000654
unknown	27952/udp	0.000654
unknown	27954/udp	0.000654
unknown	27958/udp	0.000654
unknown	27959/udp	0.000654
quake3	27960/udp	0.000726	# Quake 3 Arena Server
unknown	27967/udp	0.000654
unknown	27969/udp	0.001307
unknown	27970/udp	0.000654
unknown	27972/udp	0.000654
unknown	27973/udp	0.001307
unknown	27974/udp	0.000654
unknown	27979/udp	0.000654
unknown	27983/udp	0.000654
unknown	27984/udp	0.000654
unknown	27992/udp	0.000654
unknown	27994/udp	0.000654
unknown	27996/udp	0.000654
unknown	28005/udp	0.000654
unknown	28011/udp	0.001307
mongod	28017/tcp	0.000076	# http://docs.mongodb.org/manual/reference/default-mongodb-port/
unknown	28019/udp	0.000654
unknown	28020/udp	0.000654
unknown	28021/udp	0.000654
unknown	28028/udp	0.000654
unknown	28029/udp	0.000654
unknown	28034/udp	0.001307
unknown	28036/udp	0.000654
unknown	28043/udp	0.000654
unknown	28045/udp	0.000654
unknown	28051/udp	0.000654
unknown	28054/udp	0.000654
unknown	28058/udp	0.000654
unknown	28059/udp	0.000654
unknown	28064/udp	0.000654
unknown	28070/udp	0.001307
unknown	28071/udp	0.001307
unknown	28072/udp	0.000654
unknown	28074/udp	0.000654
unknown	28077/udp	0.000654
unknown	28078/udp	0.000654
unknown	28080/udp	0.001307
unknown	28089/udp	0.000654
unknown	28091/udp	0.001307
unknown	28094/udp	0.000654
unknown	28096/udp	0.000654
unknown	28097/udp	0.000654
unknown	28098/udp	0.001307
unknown	28105/udp	0.001307
unknown	28107/udp	0.001307
unknown	28108/udp	0.000654
unknown	28109/udp	0.000654
unknown	28112/udp	0.000654
unknown	28114/tcp	0.000076
unknown	28116/udp	0.000654
unknown	28120/udp	0.000654
unknown	28121/udp	0.000654
unknown	28122/udp	0.001961
unknown	28124/udp	0.000654
unknown	28129/udp	0.001307
unknown	28141/udp	0.000654
unknown	28142/tcp	0.000076
unknown	28142/udp	0.000654
unknown	28144/udp	0.000654
unknown	28145/udp	0.000654
unknown	28148/udp	0.000654
unknown	28154/udp	0.000654
unknown	28155/udp	0.000654
unknown	28172/udp	0.001307
unknown	28178/udp	0.000654
unknown	28182/udp	0.000654
unknown	28183/udp	0.000654
unknown	28190/udp	0.001307
unknown	28195/udp	0.000654
unknown	28197/udp	0.000654
unknown	28200/udp	0.000654
unknown	28201/tcp	0.000380
unknown	28203/udp	0.000654
unknown	28211/tcp	0.000152
unknown	28211/udp	0.001307
unknown	28212/udp	0.000654
unknown	28213/udp	0.000654
unknown	28215/udp	0.000654
unknown	28218/udp	0.000654
unknown	28219/udp	0.000654
unknown	28220/udp	0.001307
unknown	28221/udp	0.000654
unknown	28222/udp	0.001307
unknown	28230/udp	0.000654
unknown	28237/udp	0.000654
unknown	28239/udp	0.000654
unknown	28242/udp	0.000654
unknown	28243/udp	0.000654
unknown	28246/udp	0.000654
unknown	28247/udp	0.001307
unknown	28248/udp	0.000654
unknown	28251/udp	0.000654
unknown	28257/udp	0.000654
unknown	28263/udp	0.001307
unknown	28265/udp	0.000654
unknown	28271/udp	0.000654
unknown	28283/udp	0.000654
unknown	28292/udp	0.000654
unknown	28295/udp	0.001307
unknown	28298/udp	0.000654
unknown	28301/udp	0.000654
unknown	28303/udp	0.000654
unknown	28307/udp	0.000654
unknown	28309/udp	0.000654
unknown	28311/udp	0.000654
unknown	28315/udp	0.000654
unknown	28317/udp	0.000654
unknown	28322/udp	0.000654
unknown	28327/udp	0.000654
unknown	28334/udp	0.000654
unknown	28335/udp	0.000654
unknown	28344/udp	0.001307
unknown	28345/udp	0.000654
unknown	28348/udp	0.000654
unknown	28349/udp	0.001307
unknown	28353/udp	0.000654
unknown	28356/udp	0.000654
unknown	28366/udp	0.000654
unknown	28367/udp	0.000654
unknown	28369/udp	0.001961
unknown	28374/tcp	0.000076
unknown	28377/udp	0.000654
unknown	28378/udp	0.000654
unknown	28380/udp	0.000654
unknown	28386/udp	0.000654
unknown	28387/udp	0.001307
unknown	28391/udp	0.000654
unknown	28392/udp	0.000654
unknown	28393/udp	0.000654
unknown	28396/udp	0.000654
unknown	28401/udp	0.000654
unknown	28411/udp	0.000654
unknown	28417/udp	0.000654
unknown	28419/udp	0.000654
unknown	28421/udp	0.000654
unknown	28422/udp	0.000654
unknown	28425/udp	0.000654
unknown	28427/udp	0.000654
unknown	28428/udp	0.000654
unknown	28433/udp	0.000654
unknown	28434/udp	0.000654
unknown	28437/udp	0.000654
unknown	28438/udp	0.001307
unknown	28440/udp	0.001307
unknown	28441/udp	0.000654
unknown	28445/udp	0.001307
unknown	28455/udp	0.000654
unknown	28464/udp	0.000654
unknown	28465/udp	0.001961
unknown	28466/udp	0.000654
unknown	28469/udp	0.000654
unknown	28471/udp	0.000654
unknown	28472/udp	0.000654
unknown	28476/udp	0.001307
unknown	28477/udp	0.000654
unknown	28483/udp	0.000654
unknown	28484/udp	0.000654
unknown	28485/udp	0.001307
unknown	28488/udp	0.000654
unknown	28493/udp	0.001961
unknown	28506/udp	0.000654
unknown	28513/udp	0.000654
unknown	28521/udp	0.000654
unknown	28525/udp	0.001307
unknown	28529/udp	0.000654
unknown	28530/udp	0.000654
unknown	28534/udp	0.000654
unknown	28537/udp	0.000654
unknown	28543/udp	0.001961
unknown	28544/udp	0.000654
unknown	28545/udp	0.000654
unknown	28547/udp	0.002614
unknown	28556/udp	0.000654
unknown	28561/udp	0.000654
unknown	28567/tcp	0.000076
unknown	28575/udp	0.000654
unknown	28584/udp	0.001307
unknown	28586/udp	0.000654
unknown	28587/udp	0.000654
unknown	28597/udp	0.000654
unknown	28607/udp	0.000654
unknown	28609/udp	0.001307
unknown	28610/udp	0.000654
unknown	28617/udp	0.000654
unknown	28618/udp	0.000654
unknown	28620/udp	0.000654
unknown	28625/udp	0.000654
unknown	28630/udp	0.001307
unknown	28633/udp	0.000654
unknown	28638/udp	0.000654
unknown	28640/udp	0.001307
unknown	28641/udp	0.001961
unknown	28642/udp	0.000654
unknown	28643/udp	0.000654
unknown	28644/udp	0.000654
unknown	28645/udp	0.001307
unknown	28649/udp	0.000654
unknown	28654/udp	0.000654
unknown	28660/udp	0.000654
unknown	28661/udp	0.000654
unknown	28663/udp	0.001307
unknown	28664/udp	0.001307
unknown	28673/udp	0.000654
unknown	28674/udp	0.001307
unknown	28675/udp	0.000654
unknown	28682/udp	0.000654
unknown	28685/udp	0.000654
unknown	28689/udp	0.000654
unknown	28692/udp	0.001307
unknown	28696/udp	0.000654
unknown	28697/udp	0.000654
unknown	28700/udp	0.000654
unknown	28705/udp	0.000654
unknown	28706/udp	0.001307
unknown	28707/udp	0.001307
unknown	28708/udp	0.000654
unknown	28717/tcp	0.000076
unknown	28719/udp	0.001307
unknown	28723/udp	0.000654
unknown	28725/udp	0.001307
unknown	28728/udp	0.000654
unknown	28729/udp	0.000654
unknown	28730/udp	0.000654
unknown	28734/udp	0.000654
unknown	28736/udp	0.000654
unknown	28737/udp	0.000654
unknown	28741/udp	0.000654
unknown	28744/udp	0.000654
unknown	28745/udp	0.001307
unknown	28746/udp	0.001307
unknown	28748/udp	0.000654
unknown	28750/udp	0.000654
unknown	28752/udp	0.000654
unknown	28754/udp	0.000654
unknown	28755/udp	0.000654
unknown	28765/udp	0.000654
unknown	28769/udp	0.000654
unknown	28772/udp	0.000654
unknown	28775/udp	0.000654
unknown	28776/udp	0.000654
unknown	28778/udp	0.000654
unknown	28779/udp	0.000654
unknown	28780/udp	0.000654
unknown	28785/udp	0.000654
unknown	28797/udp	0.000654
unknown	28800/udp	0.000654
unknown	28803/udp	0.001307
unknown	28808/udp	0.001307
unknown	28810/udp	0.000654
unknown	28811/udp	0.000654
unknown	28813/udp	0.000654
unknown	28815/udp	0.001307
unknown	28816/udp	0.000654
unknown	28822/udp	0.000654
unknown	28826/udp	0.000654
unknown	28827/udp	0.000654
unknown	28830/udp	0.000654
unknown	28836/udp	0.000654
unknown	28837/udp	0.000654
unknown	28839/udp	0.000654
unknown	28840/udp	0.001961
unknown	28845/udp	0.000654
unknown	28847/udp	0.000654
unknown	28850/tcp	0.000076
unknown	28851/tcp	0.000076
unknown	28851/udp	0.000654
unknown	28854/udp	0.000654
unknown	28855/udp	0.000654
unknown	28856/udp	0.000654
unknown	28858/udp	0.000654
unknown	28865/udp	0.000654
unknown	28875/udp	0.000654
unknown	28876/udp	0.000654
unknown	28877/udp	0.000654
unknown	28879/udp	0.000654
unknown	28880/udp	0.000654
unknown	28883/udp	0.000654
unknown	28885/udp	0.000654
unknown	28887/udp	0.000654
unknown	28888/udp	0.000654
unknown	28892/udp	0.001307
unknown	28893/udp	0.000654
unknown	28895/udp	0.000654
unknown	28896/udp	0.000654
unknown	28898/udp	0.000654
unknown	28900/udp	0.000654
unknown	28902/udp	0.000654
unknown	28905/udp	0.000654
unknown	28906/udp	0.000654
heretic2	28910/udp	0.000524	# Heretic 2 game server
unknown	28917/udp	0.000654
unknown	28919/udp	0.000654
unknown	28920/udp	0.000654
unknown	28924/tcp	0.000076
unknown	28924/udp	0.000654
unknown	28927/udp	0.000654
unknown	28931/udp	0.001307
unknown	28932/udp	0.000654
unknown	28933/udp	0.001307
unknown	28934/udp	0.000654
unknown	28938/udp	0.000654
unknown	28940/udp	0.000654
unknown	28943/udp	0.000654
unknown	28944/udp	0.001307
unknown	28945/udp	0.000654
unknown	28946/udp	0.000654
unknown	28952/udp	0.000654
unknown	28953/udp	0.000654
unknown	28954/udp	0.000654
unknown	28958/udp	0.000654
unknown	28965/udp	0.001307
unknown	28966/udp	0.000654
unknown	28967/tcp	0.000076
unknown	28967/udp	0.000654
unknown	28969/udp	0.000654
unknown	28973/udp	0.001961
unknown	28976/udp	0.000654
unknown	28979/udp	0.000654
unknown	28992/udp	0.000654
unknown	28995/udp	0.001307
unknown	28997/udp	0.000654
unknown	29000/udp	0.000654
unknown	29007/udp	0.000654
unknown	29008/udp	0.000654
unknown	29010/udp	0.000654
unknown	29013/udp	0.000654
unknown	29014/udp	0.000654
unknown	29022/udp	0.000654
unknown	29026/udp	0.000654
unknown	29030/udp	0.001307
unknown	29032/udp	0.000654
unknown	29036/udp	0.000654
unknown	29039/udp	0.000654
unknown	29045/tcp	0.000076
unknown	29045/udp	0.000654
unknown	29046/udp	0.000654
unknown	29048/udp	0.001307
unknown	29052/udp	0.000654
unknown	29053/udp	0.000654
unknown	29054/udp	0.001307
unknown	29056/udp	0.000654
unknown	29058/udp	0.000654
unknown	29061/udp	0.000654
unknown	29069/udp	0.000654
unknown	29070/udp	0.000654
unknown	29078/udp	0.001961
unknown	29082/udp	0.001307
unknown	29084/udp	0.000654
unknown	29087/udp	0.000654
unknown	29095/udp	0.000654
unknown	29105/udp	0.000654
unknown	29112/udp	0.000654
unknown	29114/udp	0.000654
unknown	29115/udp	0.000654
sgsap	29118/sctp	0.000000	# SGsAP in 3GPP
unknown	29121/udp	0.000654
unknown	29126/udp	0.000654
unknown	29129/udp	0.001307
unknown	29134/udp	0.000654
unknown	29135/udp	0.001307
unknown	29137/udp	0.000654
unknown	29142/udp	0.001307
unknown	29149/udp	0.000654
unknown	29150/udp	0.001307
unknown	29152/tcp	0.000076
unknown	29153/udp	0.001307
unknown	29162/udp	0.001307
unknown	29163/udp	0.000654
sbcap	29168/sctp	0.000000	# SBcAP in 3GPP
unknown	29168/udp	0.001307
iuhsctpassoc	29169/sctp	0.000000	# HNBAP and RUA Common Association
unknown	29172/udp	0.000654
unknown	29177/udp	0.000654
unknown	29180/udp	0.001307
unknown	29183/udp	0.000654
unknown	29185/udp	0.000654
unknown	29186/udp	0.000654
unknown	29195/udp	0.000654
unknown	29196/udp	0.000654
unknown	29199/udp	0.000654
unknown	29200/udp	0.001307
unknown	29201/udp	0.000654
unknown	29203/udp	0.000654
unknown	29207/udp	0.000654
unknown	29211/udp	0.000654
unknown	29218/udp	0.000654
unknown	29220/udp	0.000654
unknown	29224/udp	0.000654
unknown	29230/udp	0.001307
unknown	29238/udp	0.000654
unknown	29239/udp	0.000654
unknown	29243/tcp	0.000076
unknown	29243/udp	0.001961
unknown	29248/udp	0.000654
unknown	29249/udp	0.000654
unknown	29256/udp	0.001961
unknown	29257/udp	0.000654
unknown	29259/udp	0.000654
unknown	29268/udp	0.000654
unknown	29272/udp	0.000654
unknown	29273/udp	0.000654
unknown	29276/udp	0.001307
unknown	29277/udp	0.000654
unknown	29278/udp	0.000654
unknown	29280/udp	0.000654
unknown	29281/udp	0.000654
unknown	29283/udp	0.000654
unknown	29284/udp	0.000654
unknown	29286/udp	0.000654
unknown	29298/udp	0.000654
unknown	29305/udp	0.000654
unknown	29308/udp	0.000654
unknown	29312/udp	0.000654
unknown	29315/udp	0.000654
unknown	29317/udp	0.000654
unknown	29319/udp	0.001307
unknown	29323/udp	0.000654
unknown	29324/udp	0.000654
unknown	29327/udp	0.000654
unknown	29329/udp	0.000654
unknown	29331/udp	0.000654
unknown	29333/udp	0.001307
unknown	29335/udp	0.000654
unknown	29342/udp	0.000654
unknown	29352/udp	0.000654
unknown	29355/udp	0.000654
unknown	29357/udp	0.001307
unknown	29364/udp	0.000654
unknown	29366/udp	0.000654
unknown	29368/udp	0.000654
unknown	29375/udp	0.000654
unknown	29376/udp	0.000654
unknown	29380/udp	0.000654
unknown	29390/udp	0.000654
unknown	29393/udp	0.000654
unknown	29396/udp	0.000654
unknown	29397/udp	0.000654
unknown	29398/udp	0.000654
unknown	29400/udp	0.001307
unknown	29401/udp	0.001307
unknown	29403/udp	0.000654
unknown	29406/udp	0.000654
unknown	29407/udp	0.000654
unknown	29408/udp	0.000654
unknown	29410/udp	0.001307
unknown	29414/udp	0.000654
unknown	29415/udp	0.000654
unknown	29420/udp	0.000654
unknown	29426/udp	0.001307
unknown	29427/udp	0.000654
unknown	29432/udp	0.000654
unknown	29435/udp	0.000654
unknown	29442/udp	0.000654
unknown	29444/udp	0.001307
unknown	29447/udp	0.000654
unknown	29448/udp	0.000654
unknown	29449/udp	0.001307
unknown	29453/udp	0.001307
unknown	29457/udp	0.000654
unknown	29461/udp	0.001307
unknown	29465/udp	0.000654
unknown	29467/udp	0.000654
unknown	29471/udp	0.000654
unknown	29474/udp	0.000654
unknown	29476/udp	0.000654
unknown	29480/udp	0.000654
unknown	29486/udp	0.000654
unknown	29488/udp	0.000654
unknown	29494/udp	0.000654
unknown	29499/udp	0.000654
unknown	29503/udp	0.001307
unknown	29506/udp	0.000654
unknown	29507/tcp	0.000076
unknown	29508/udp	0.000654
unknown	29512/udp	0.000654
unknown	29514/udp	0.000654
unknown	29518/udp	0.000654
unknown	29520/udp	0.000654
unknown	29522/udp	0.001307
unknown	29523/udp	0.000654
unknown	29525/udp	0.000654
unknown	29533/udp	0.000654
unknown	29534/udp	0.001307
unknown	29541/udp	0.001307
unknown	29554/udp	0.001307
unknown	29559/udp	0.000654
unknown	29562/udp	0.000654
unknown	29564/udp	0.001307
unknown	29570/udp	0.000654
unknown	29572/udp	0.000654
unknown	29577/udp	0.000654
unknown	29581/udp	0.001307
unknown	29582/udp	0.000654
unknown	29583/udp	0.000654
unknown	29585/udp	0.000654
unknown	29587/udp	0.000654
unknown	29588/udp	0.000654
unknown	29589/udp	0.000654
unknown	29595/udp	0.001307
unknown	29600/udp	0.000654
unknown	29604/udp	0.000654
unknown	29607/udp	0.000654
unknown	29613/udp	0.001307
unknown	29615/udp	0.000654
unknown	29616/udp	0.000654
unknown	29618/udp	0.000654
unknown	29630/udp	0.000654
unknown	29632/udp	0.000654
unknown	29639/udp	0.000654
unknown	29642/udp	0.000654
unknown	29647/udp	0.000654
unknown	29652/udp	0.000654
unknown	29659/udp	0.000654
unknown	29665/udp	0.000654
unknown	29667/udp	0.000654
unknown	29672/tcp	0.000152
unknown	29673/udp	0.000654
unknown	29677/udp	0.000654
unknown	29680/udp	0.000654
unknown	29681/udp	0.000654
unknown	29682/udp	0.000654
unknown	29694/udp	0.000654
unknown	29700/udp	0.000654
unknown	29701/udp	0.000654
unknown	29709/udp	0.001307
unknown	29712/udp	0.000654
unknown	29715/udp	0.000654
unknown	29729/udp	0.000654
unknown	29731/udp	0.000654
unknown	29733/udp	0.000654
unknown	29737/udp	0.000654
unknown	29742/udp	0.000654
unknown	29747/udp	0.000654
unknown	29749/udp	0.000654
unknown	29752/udp	0.000654
unknown	29753/udp	0.000654
unknown	29754/udp	0.000654
unknown	29756/udp	0.000654
unknown	29759/udp	0.000654
unknown	29761/udp	0.000654
unknown	29771/udp	0.000654
unknown	29773/udp	0.000654
unknown	29780/udp	0.000654
unknown	29782/udp	0.000654
unknown	29785/udp	0.000654
unknown	29787/udp	0.000654
unknown	29788/udp	0.000654
unknown	29794/udp	0.001307
unknown	29796/udp	0.000654
unknown	29802/udp	0.000654
unknown	29809/udp	0.000654
unknown	29810/tcp	0.000076
unknown	29810/udp	0.001961
unknown	29811/udp	0.000654
unknown	29812/udp	0.000654
unknown	29816/udp	0.000654
unknown	29823/udp	0.002614
unknown	29829/udp	0.000654
unknown	29831/tcp	0.000152
unknown	29833/udp	0.000654
unknown	29834/udp	0.001307
unknown	29840/udp	0.000654
unknown	29842/udp	0.000654
unknown	29843/udp	0.001307
unknown	29846/udp	0.000654
unknown	29852/udp	0.000654
unknown	29854/udp	0.000654
unknown	29858/udp	0.000654
unknown	29860/udp	0.000654
unknown	29863/udp	0.000654
unknown	29864/udp	0.000654
unknown	29867/udp	0.000654
unknown	29869/udp	0.000654
unknown	29876/udp	0.000654
unknown	29878/udp	0.000654
unknown	29883/udp	0.000654
unknown	29886/udp	0.001307
unknown	29894/udp	0.001307
unknown	29901/udp	0.000654
unknown	29903/udp	0.000654
unknown	29905/udp	0.000654
unknown	29907/udp	0.000654
unknown	29911/udp	0.000654
unknown	29914/udp	0.000654
unknown	29915/udp	0.000654
unknown	29926/udp	0.000654
unknown	29927/udp	0.000654
unknown	29930/udp	0.000654
unknown	29932/udp	0.000654
unknown	29949/udp	0.000654
unknown	29956/udp	0.000654
unknown	29961/udp	0.001307
unknown	29964/udp	0.001307
unknown	29967/udp	0.000654
unknown	29970/udp	0.000654
unknown	29977/udp	0.001961
unknown	29978/udp	0.000654
unknown	29980/udp	0.000654
unknown	29981/udp	0.001307
unknown	29987/udp	0.000654
unknown	29988/udp	0.000654
unknown	30000/tcp	0.000380
unknown	30000/udp	0.000654
pago-services1	30001/tcp	0.000076	# Pago Services 1
unknown	30005/tcp	0.000152
unknown	30006/udp	0.000654
unknown	30008/udp	0.000654
unknown	30015/udp	0.000654
unknown	30018/udp	0.000654
unknown	30020/udp	0.000654
unknown	30027/udp	0.000654
unknown	30031/udp	0.000654
unknown	30034/udp	0.001307
unknown	30036/udp	0.000654
unknown	30041/udp	0.000654
unknown	30046/udp	0.000654
unknown	30048/udp	0.000654
unknown	30055/udp	0.001307
unknown	30059/udp	0.000654
unknown	30063/udp	0.000654
unknown	30066/udp	0.000654
unknown	30067/udp	0.001307
unknown	30085/udp	0.001307
unknown	30086/udp	0.000654
unknown	30087/tcp	0.000076
unknown	30093/udp	0.001307
unknown	30108/udp	0.000654
unknown	30113/udp	0.000654
unknown	30123/udp	0.000654
unknown	30126/udp	0.000654
unknown	30130/udp	0.000654
unknown	30131/udp	0.000654
unknown	30132/udp	0.000654
unknown	30134/udp	0.001307
unknown	30135/udp	0.000654
unknown	30139/udp	0.000654
unknown	30144/udp	0.000654
unknown	30148/udp	0.000654
unknown	30150/udp	0.000654
unknown	30154/udp	0.001307
unknown	30168/udp	0.000654
unknown	30170/udp	0.000654
unknown	30172/udp	0.000654
unknown	30175/udp	0.000654
unknown	30179/udp	0.000654
unknown	30181/udp	0.000654
unknown	30182/udp	0.000654
unknown	30184/udp	0.000654
unknown	30188/udp	0.000654
unknown	30193/udp	0.000654
unknown	30194/udp	0.000654
unknown	30195/tcp	0.000076
unknown	30209/udp	0.001307
unknown	30211/udp	0.000654
unknown	30212/udp	0.000654
unknown	30214/udp	0.001307
unknown	30230/udp	0.000654
unknown	30234/udp	0.000654
unknown	30235/udp	0.000654
unknown	30236/udp	0.000654
unknown	30239/udp	0.000654
unknown	30241/udp	0.000654
unknown	30244/udp	0.000654
unknown	30245/udp	0.000654
unknown	30246/udp	0.000654
unknown	30252/udp	0.000654
unknown	30254/udp	0.000654
unknown	30256/udp	0.001307
unknown	30258/udp	0.000654
kingdomsonline	30260/udp	0.001307	# Kingdoms Online (CraigAvenue)
unknown	30263/udp	0.001961
unknown	30267/udp	0.000654
unknown	30286/udp	0.000654
unknown	30293/udp	0.000654
unknown	30295/udp	0.000654
unknown	30298/udp	0.000654
unknown	30299/tcp	0.000076
unknown	30299/udp	0.001307
unknown	30300/udp	0.000654
unknown	30303/udp	0.002614
unknown	30305/udp	0.000654
unknown	30306/udp	0.000654
unknown	30309/udp	0.000654
unknown	30310/udp	0.000654
unknown	30318/udp	0.000654
unknown	30330/udp	0.000654
unknown	30331/udp	0.000654
unknown	30335/udp	0.000654
unknown	30338/udp	0.000654
unknown	30341/udp	0.000654
unknown	30348/udp	0.001307
unknown	30350/udp	0.000654
unknown	30359/udp	0.000654
unknown	30365/udp	0.002614
unknown	30378/udp	0.000654
unknown	30381/udp	0.000654
unknown	30383/udp	0.000654
unknown	30394/udp	0.000654
unknown	30398/udp	0.000654
unknown	30400/udp	0.000654
unknown	30411/udp	0.000654
unknown	30416/udp	0.000654
unknown	30418/udp	0.000654
unknown	30419/udp	0.000654
unknown	30420/udp	0.000654
unknown	30423/udp	0.000654
unknown	30424/udp	0.000654
unknown	30428/udp	0.000654
unknown	30430/udp	0.000654
unknown	30433/udp	0.000654
unknown	30434/udp	0.000654
unknown	30453/udp	0.000654
unknown	30454/udp	0.000654
unknown	30457/udp	0.000654
unknown	30461/udp	0.001307
unknown	30462/udp	0.000654
unknown	30463/udp	0.000654
unknown	30464/udp	0.000654
unknown	30465/udp	0.001307
unknown	30467/udp	0.000654
unknown	30468/udp	0.000654
unknown	30470/udp	0.000654
unknown	30472/udp	0.000654
unknown	30473/udp	0.001307
unknown	30474/udp	0.001307
unknown	30475/udp	0.000654
unknown	30477/udp	0.001307
unknown	30478/udp	0.000654
unknown	30481/udp	0.000654
unknown	30483/udp	0.000654
unknown	30491/udp	0.000654
unknown	30492/udp	0.000654
unknown	30493/udp	0.000654
unknown	30495/udp	0.000654
unknown	30496/udp	0.000654
unknown	30500/udp	0.000654
unknown	30501/udp	0.000654
unknown	30511/udp	0.000654
unknown	30512/udp	0.001307
unknown	30514/udp	0.000654
unknown	30516/udp	0.000654
unknown	30518/udp	0.000654
unknown	30519/tcp	0.000076
unknown	30521/udp	0.000654
unknown	30522/udp	0.000654
unknown	30526/udp	0.001307
unknown	30529/udp	0.000654
unknown	30533/udp	0.001307
unknown	30536/udp	0.000654
unknown	30539/udp	0.000654
unknown	30544/udp	0.001961
unknown	30550/udp	0.000654
unknown	30555/udp	0.000654
unknown	30564/udp	0.000654
unknown	30566/udp	0.000654
unknown	30568/udp	0.000654
unknown	30575/udp	0.000654
unknown	30578/udp	0.001307
unknown	30583/udp	0.001307
unknown	30587/udp	0.000654
unknown	30588/udp	0.000654
unknown	30592/udp	0.000654
unknown	30599/tcp	0.000076
unknown	30601/udp	0.000654
unknown	30609/udp	0.000654
unknown	30612/udp	0.001307
unknown	30619/udp	0.000654
unknown	30622/udp	0.001307
unknown	30623/udp	0.000654
unknown	30624/udp	0.000654
unknown	30627/udp	0.000654
unknown	30637/udp	0.000654
unknown	30644/tcp	0.000076
unknown	30644/udp	0.000654
unknown	30646/udp	0.000654
unknown	30648/udp	0.000654
unknown	30650/udp	0.000654
unknown	30651/udp	0.000654
unknown	30656/udp	0.001961
unknown	30657/udp	0.000654
unknown	30658/udp	0.000654
unknown	30659/tcp	0.000076
unknown	30660/udp	0.000654
unknown	30661/udp	0.001307
unknown	30662/udp	0.000654
unknown	30664/udp	0.000654
unknown	30665/udp	0.000654
unknown	30669/udp	0.001307
unknown	30670/udp	0.000654
unknown	30672/udp	0.000654
unknown	30682/udp	0.000654
unknown	30687/udp	0.000654
unknown	30688/udp	0.000654
unknown	30689/udp	0.000654
unknown	30697/udp	0.001961
unknown	30698/udp	0.001307
unknown	30701/udp	0.000654
unknown	30702/udp	0.000654
unknown	30704/tcp	0.000152
unknown	30704/udp	0.001961
unknown	30705/tcp	0.000076
unknown	30710/udp	0.000654
unknown	30712/udp	0.000654
unknown	30713/udp	0.000654
unknown	30718/tcp	0.000380
unknown	30718/udp	0.007190
unknown	30719/udp	0.000654
unknown	30723/udp	0.000654
unknown	30725/udp	0.000654
unknown	30729/udp	0.000654
unknown	30734/udp	0.000654
unknown	30737/udp	0.000654
unknown	30738/udp	0.000654
unknown	30741/udp	0.000654
unknown	30746/udp	0.000654
unknown	30754/udp	0.000654
unknown	30755/udp	0.000654
unknown	30757/udp	0.001307
unknown	30762/udp	0.000654
unknown	30765/udp	0.000654
unknown	30772/udp	0.000654
unknown	30780/udp	0.000654
unknown	30782/udp	0.000654
unknown	30783/udp	0.000654
unknown	30784/udp	0.000654
unknown	30785/udp	0.001307
unknown	30789/udp	0.001307
unknown	30795/udp	0.000654
unknown	30796/udp	0.000654
unknown	30803/udp	0.001307
unknown	30805/udp	0.000654
unknown	30808/udp	0.000654
unknown	30819/udp	0.000654
unknown	30820/udp	0.000654
unknown	30823/udp	0.000654
unknown	30824/udp	0.001307
unknown	30825/udp	0.000654
unknown	30826/udp	0.000654
unknown	30827/udp	0.000654
unknown	30828/udp	0.000654
unknown	30833/udp	0.000654
unknown	30837/udp	0.000654
unknown	30838/udp	0.000654
unknown	30841/udp	0.000654
unknown	30849/udp	0.000654
unknown	30851/udp	0.000654
unknown	30856/udp	0.001307
unknown	30867/udp	0.000654
unknown	30869/udp	0.001307
unknown	30875/udp	0.001307
unknown	30876/udp	0.000654
unknown	30880/udp	0.001307
unknown	30881/udp	0.000654
unknown	30886/udp	0.000654
unknown	30892/udp	0.000654
unknown	30893/udp	0.000654
unknown	30894/udp	0.000654
unknown	30896/tcp	0.000076
unknown	30897/udp	0.000654
unknown	30906/udp	0.000654
unknown	30908/udp	0.000654
unknown	30909/udp	0.001307
unknown	30910/udp	0.000654
unknown	30912/udp	0.000654
unknown	30918/udp	0.000654
unknown	30919/udp	0.000654
unknown	30924/udp	0.000654
unknown	30926/udp	0.000654
unknown	30930/udp	0.001307
unknown	30931/udp	0.000654
unknown	30932/udp	0.001307
unknown	30942/udp	0.000654
unknown	30943/udp	0.001307
unknown	30945/udp	0.000654
unknown	30951/tcp	0.000228
unknown	30951/udp	0.000654
unknown	30955/udp	0.000654
unknown	30958/udp	0.000654
unknown	30959/udp	0.000654
unknown	30965/udp	0.000654
unknown	30967/udp	0.000654
unknown	30972/udp	0.000654
unknown	30975/udp	0.001961
unknown	30982/udp	0.000654
unknown	30984/udp	0.000654
unknown	30986/udp	0.000654
unknown	30990/udp	0.000654
unknown	30996/udp	0.001307
unknown	31001/udp	0.000654
unknown	31005/udp	0.000654
unknown	31015/udp	0.000654
unknown	31020/udp	0.000654
unknown	31022/udp	0.000654
unknown	31028/udp	0.000654
unknown	31030/udp	0.000654
unknown	31033/tcp	0.000076
unknown	31034/udp	0.001307
unknown	31036/udp	0.001307
unknown	31038/tcp	0.000380
unknown	31048/udp	0.000654
unknown	31049/udp	0.001307
unknown	31051/udp	0.001307
unknown	31052/udp	0.000654
unknown	31054/udp	0.000654
unknown	31058/tcp	0.000076
unknown	31058/udp	0.000654
unknown	31059/udp	0.001961
unknown	31068/udp	0.000654
unknown	31069/udp	0.000654
unknown	31072/tcp	0.000076
unknown	31072/udp	0.000654
unknown	31073/udp	0.002614
unknown	31076/udp	0.000654
unknown	31078/udp	0.000654
unknown	31080/udp	0.000654
unknown	31082/udp	0.001307
unknown	31083/udp	0.000654
unknown	31084/udp	0.001307
unknown	31085/udp	0.000654
unknown	31088/udp	0.000654
unknown	31089/udp	0.000654
unknown	31100/udp	0.000654
unknown	31105/udp	0.000654
unknown	31109/udp	0.001961
unknown	31112/udp	0.001307
unknown	31115/udp	0.001307
unknown	31119/udp	0.000654
unknown	31127/udp	0.000654
unknown	31129/udp	0.000654
unknown	31133/udp	0.001307
unknown	31134/udp	0.001307
unknown	31137/udp	0.001307
unknown	31141/udp	0.000654
unknown	31146/udp	0.000654
unknown	31150/udp	0.000654
unknown	31155/udp	0.001307
unknown	31162/udp	0.001307
unknown	31176/udp	0.000654
unknown	31180/udp	0.001307
unknown	31187/udp	0.000654
unknown	31189/udp	0.001961
unknown	31192/udp	0.000654
unknown	31195/udp	0.001961
unknown	31198/udp	0.000654
unknown	31199/udp	0.001307
unknown	31202/udp	0.001307
unknown	31204/udp	0.000654
unknown	31209/udp	0.000654
unknown	31211/udp	0.000654
unknown	31212/udp	0.000654
unknown	31215/udp	0.000654
unknown	31217/udp	0.000654
unknown	31218/udp	0.000654
unknown	31230/udp	0.000654
unknown	31234/udp	0.000654
unknown	31237/udp	0.000654
unknown	31238/udp	0.000654
unknown	31240/udp	0.000654
unknown	31242/udp	0.000654
unknown	31247/udp	0.000654
unknown	31248/udp	0.000654
unknown	31249/udp	0.000654
unknown	31252/udp	0.000654
unknown	31254/udp	0.000654
unknown	31257/udp	0.000654
unknown	31258/udp	0.000654
unknown	31261/udp	0.001307
unknown	31266/udp	0.001307
unknown	31267/udp	0.001307
unknown	31268/udp	0.000654
unknown	31271/udp	0.000654
unknown	31273/udp	0.000654
unknown	31275/udp	0.000654
unknown	31279/udp	0.000654
unknown	31284/udp	0.001307
unknown	31288/udp	0.000654
unknown	31292/udp	0.000654
unknown	31293/udp	0.000654
unknown	31299/udp	0.000654
unknown	31301/udp	0.000654
unknown	31309/udp	0.000654
unknown	31314/udp	0.000654
unknown	31318/udp	0.000654
unknown	31324/udp	0.000654
unknown	31325/udp	0.000654
unknown	31326/udp	0.000654
unknown	31333/udp	0.000654
unknown	31334/udp	0.001307
Trinoo_Register	31335/udp	0.001706	# Trinoo distributed attack tool Bcast Daemon registration port
unknown	31336/udp	0.000654
Elite	31337/tcp	0.000163	# Sometimes interesting stuff can be found here
BackOrifice	31337/udp	0.011469	# cDc Back Orifice remote admin tool
unknown	31339/tcp	0.000076
unknown	31340/udp	0.000654
unknown	31343/udp	0.001307
unknown	31347/udp	0.000654
unknown	31350/udp	0.001307
unknown	31352/udp	0.001307
unknown	31354/udp	0.000654
unknown	31358/udp	0.000654
unknown	31361/udp	0.001307
unknown	31362/udp	0.000654
unknown	31365/udp	0.001961
unknown	31366/udp	0.000654
unknown	31371/udp	0.000654
unknown	31386/tcp	0.000076
unknown	31386/udp	0.000654
unknown	31391/udp	0.000654
unknown	31392/udp	0.000654
unknown	31398/udp	0.000654
unknown	31404/udp	0.001307
unknown	31412/udp	0.001307
unknown	31414/udp	0.000654
unknown	31415/udp	0.000654
boinc	31416/tcp	0.000075	# BOINC Client Control
unknown	31421/udp	0.000654
unknown	31422/udp	0.000654
unknown	31423/udp	0.000654
unknown	31424/udp	0.000654
unknown	31428/udp	0.001307
unknown	31429/udp	0.000654
unknown	31432/udp	0.000654
unknown	31438/tcp	0.000076
unknown	31439/udp	0.000654
unknown	31451/udp	0.000654
unknown	31453/udp	0.000654
unknown	31454/udp	0.000654
unknown	31459/udp	0.000654
unknown	31460/udp	0.000654
unknown	31470/udp	0.000654
unknown	31481/udp	0.001307
unknown	31487/udp	0.000654
unknown	31493/udp	0.000654
unknown	31495/udp	0.000654
unknown	31506/udp	0.000654
unknown	31509/udp	0.000654
unknown	31510/udp	0.000654
unknown	31518/udp	0.000654
unknown	31520/udp	0.001307
unknown	31521/udp	0.001307
unknown	31522/tcp	0.000076
unknown	31527/udp	0.000654
unknown	31532/udp	0.000654
unknown	31543/udp	0.000654
unknown	31544/udp	0.000654
unknown	31545/udp	0.000654
unknown	31548/udp	0.000654
unknown	31557/udp	0.000654
unknown	31558/udp	0.000654
unknown	31560/udp	0.001307
unknown	31563/udp	0.000654
unknown	31564/udp	0.000654
unknown	31565/udp	0.000654
unknown	31566/udp	0.000654
unknown	31569/udp	0.001307
unknown	31577/udp	0.000654
unknown	31579/udp	0.000654
unknown	31584/udp	0.001307
unknown	31593/udp	0.000654
unknown	31594/udp	0.000654
unknown	31595/udp	0.000654
unknown	31596/udp	0.000654
unknown	31597/udp	0.000654
unknown	31598/udp	0.000654
unknown	31599/udp	0.001307
unknown	31600/udp	0.000654
unknown	31601/udp	0.000654
unknown	31602/udp	0.001307
unknown	31606/udp	0.000654
unknown	31609/udp	0.001307
unknown	31615/udp	0.000654
unknown	31617/udp	0.000654
unknown	31624/udp	0.000654
unknown	31625/udp	0.001961
unknown	31626/udp	0.000654
unknown	31643/udp	0.000654
unknown	31648/udp	0.000654
unknown	31651/udp	0.000654
unknown	31653/udp	0.000654
unknown	31655/udp	0.000654
unknown	31657/tcp	0.000076
unknown	31657/udp	0.000654
unknown	31660/udp	0.000654
unknown	31663/udp	0.000654
unknown	31668/udp	0.000654
unknown	31669/udp	0.000654
unknown	31670/udp	0.000654
unknown	31671/udp	0.000654
unknown	31673/udp	0.001307
unknown	31678/udp	0.000654
unknown	31679/udp	0.000654
unknown	31681/udp	0.002614
unknown	31683/udp	0.000654
unknown	31692/udp	0.001307
unknown	31703/udp	0.000654
unknown	31705/udp	0.000654
unknown	31709/udp	0.000654
unknown	31712/udp	0.000654
unknown	31720/udp	0.001307
unknown	31723/udp	0.000654
diagd	31727/tcp	0.000152
unknown	31727/udp	0.000654
unknown	31728/tcp	0.000076
unknown	31729/udp	0.000654
unknown	31731/udp	0.001961
unknown	31732/udp	0.001307
unknown	31733/udp	0.000654
unknown	31735/udp	0.001307
unknown	31736/udp	0.000654
unknown	31737/udp	0.000654
unknown	31739/udp	0.000654
unknown	31743/udp	0.001307
unknown	31749/udp	0.000654
unknown	31750/udp	0.001307
unknown	31752/udp	0.000654
unknown	31757/udp	0.000654
unknown	31759/udp	0.000654
unknown	31763/udp	0.000654
unknown	31776/udp	0.000654
unknown	31778/udp	0.000654
unknown	31779/udp	0.000654
unknown	31782/udp	0.000654
unknown	31783/udp	0.001307
unknown	31792/udp	0.001307
unknown	31794/udp	0.001307
unknown	31798/udp	0.000654
unknown	31803/udp	0.001307
unknown	31813/udp	0.000654
unknown	31817/udp	0.000654
unknown	31818/udp	0.000654
unknown	31819/udp	0.000654
unknown	31821/udp	0.000654
unknown	31822/udp	0.000654
unknown	31825/udp	0.000654
unknown	31827/udp	0.000654
unknown	31833/udp	0.000654
unknown	31834/udp	0.000654
unknown	31842/udp	0.000654
unknown	31844/udp	0.000654
unknown	31847/udp	0.000654
unknown	31852/udp	0.001307
unknown	31853/udp	0.000654
unknown	31854/udp	0.000654
unknown	31861/udp	0.000654
unknown	31869/udp	0.000654
unknown	31870/udp	0.000654
unknown	31872/udp	0.000654
unknown	31877/udp	0.000654
unknown	31878/udp	0.000654
unknown	31882/udp	0.001307
unknown	31887/udp	0.001307
unknown	31891/udp	0.002614
unknown	31892/udp	0.000654
unknown	31894/udp	0.000654
unknown	31898/udp	0.000654
unknown	31899/udp	0.000654
unknown	31901/udp	0.000654
unknown	31906/udp	0.000654
unknown	31918/udp	0.001307
unknown	31920/udp	0.000654
unknown	31921/udp	0.000654
unknown	31922/udp	0.000654
unknown	31928/udp	0.000654
unknown	31929/udp	0.000654
unknown	31934/udp	0.000654
unknown	31939/udp	0.000654
unknown	31940/udp	0.000654
unknown	31950/udp	0.000654
unknown	31963/udp	0.001307
unknown	31966/udp	0.000654
unknown	31967/udp	0.000654
unknown	31968/udp	0.000654
unknown	31972/udp	0.000654
unknown	31974/udp	0.000654
unknown	31979/udp	0.000654
unknown	31981/udp	0.000654
unknown	31992/udp	0.000654
unknown	31997/udp	0.000654
unknown	31999/udp	0.001307
unknown	32005/udp	0.000654
unknown	32006/tcp	0.000076
unknown	32006/udp	0.000654
unknown	32007/udp	0.000654
unknown	32010/udp	0.000654
unknown	32011/udp	0.000654
unknown	32018/udp	0.000654
unknown	32022/tcp	0.000076
unknown	32024/udp	0.000654
unknown	32025/udp	0.000654
unknown	32031/tcp	0.000076
unknown	32033/udp	0.000654
unknown	32035/udp	0.000654
unknown	32039/udp	0.000654
unknown	32040/udp	0.000654
unknown	32044/udp	0.001307
unknown	32046/udp	0.000654
unknown	32048/udp	0.000654
unknown	32053/udp	0.001307
unknown	32059/udp	0.000654
unknown	32064/udp	0.000654
unknown	32065/udp	0.000654
unknown	32066/udp	0.001307
unknown	32068/udp	0.000654
unknown	32072/udp	0.000654
unknown	32079/udp	0.000654
unknown	32081/udp	0.000654
unknown	32084/udp	0.000654
unknown	32088/tcp	0.000076
unknown	32090/udp	0.000654
unknown	32091/udp	0.000654
unknown	32092/udp	0.000654
unknown	32094/udp	0.000654
unknown	32102/tcp	0.000076
unknown	32105/udp	0.000654
unknown	32106/udp	0.000654
unknown	32107/udp	0.000654
unknown	32109/udp	0.000654
unknown	32117/udp	0.000654
unknown	32124/udp	0.001307
unknown	32127/udp	0.000654
unknown	32129/udp	0.001307
unknown	32132/udp	0.001307
unknown	32161/udp	0.000654
unknown	32162/udp	0.000654
unknown	32163/udp	0.000654
unknown	32167/udp	0.000654
unknown	32172/udp	0.000654
unknown	32174/udp	0.000654
unknown	32176/udp	0.000654
unknown	32178/udp	0.000654
unknown	32180/udp	0.000654
unknown	32185/udp	0.001307
unknown	32186/udp	0.000654
unknown	32187/udp	0.000654
unknown	32188/udp	0.000654
unknown	32190/udp	0.000654
unknown	32195/udp	0.000654
unknown	32198/udp	0.000654
unknown	32200/tcp	0.000076
unknown	32201/udp	0.000654
unknown	32202/udp	0.000654
unknown	32204/udp	0.000654
unknown	32210/udp	0.000654
unknown	32216/udp	0.001307
unknown	32217/udp	0.000654
unknown	32219/tcp	0.000076
unknown	32219/udp	0.001307
unknown	32221/udp	0.000654
unknown	32222/udp	0.000654
unknown	32223/udp	0.000654
unknown	32225/udp	0.000654
unknown	32228/udp	0.000654
unknown	32231/udp	0.000654
unknown	32245/udp	0.000654
unknown	32248/udp	0.000654
unknown	32251/udp	0.000654
unknown	32259/udp	0.000654
unknown	32260/tcp	0.000076
unknown	32261/tcp	0.000076
unknown	32262/udp	0.001307
unknown	32264/udp	0.000654
unknown	32268/udp	0.000654
unknown	32270/udp	0.000654
unknown	32272/udp	0.000654
unknown	32273/udp	0.001307
unknown	32274/udp	0.000654
unknown	32276/udp	0.000654
unknown	32277/udp	0.000654
unknown	32281/udp	0.000654
unknown	32282/udp	0.000654
unknown	32289/udp	0.000654
unknown	32291/udp	0.000654
unknown	32295/udp	0.000654
unknown	32297/udp	0.000654
unknown	32305/udp	0.000654
unknown	32306/udp	0.000654
unknown	32309/udp	0.000654
unknown	32313/udp	0.000654
unknown	32316/udp	0.000654
unknown	32317/udp	0.000654
unknown	32319/udp	0.000654
unknown	32323/udp	0.000654
unknown	32326/udp	0.001307
unknown	32329/udp	0.000654
unknown	32338/udp	0.000654
unknown	32339/udp	0.000654
unknown	32342/udp	0.000654
unknown	32345/udp	0.001961
unknown	32349/udp	0.000654
unknown	32352/udp	0.001307
unknown	32355/udp	0.000654
unknown	32359/udp	0.001307
unknown	32360/udp	0.000654
unknown	32364/udp	0.000654
unknown	32368/udp	0.001307
unknown	32369/udp	0.000654
unknown	32377/udp	0.000654
unknown	32378/udp	0.000654
unknown	32379/udp	0.000654
unknown	32382/udp	0.001307
unknown	32385/udp	0.001961
unknown	32389/udp	0.000654
unknown	32391/udp	0.000654
unknown	32398/udp	0.000654
unknown	32404/udp	0.001307
unknown	32406/udp	0.000654
unknown	32409/udp	0.000654
unknown	32412/udp	0.000654
unknown	32415/udp	0.001307
unknown	32422/udp	0.001307
unknown	32423/udp	0.000654
unknown	32425/udp	0.001307
unknown	32426/udp	0.000654
unknown	32428/udp	0.000654
unknown	32429/udp	0.000654
unknown	32430/udp	0.001307
unknown	32433/udp	0.000654
unknown	32435/udp	0.000654
unknown	32436/udp	0.000654
unknown	32439/udp	0.000654
unknown	32440/udp	0.000654
unknown	32444/udp	0.000654
unknown	32446/udp	0.001307
unknown	32447/udp	0.000654
unknown	32449/udp	0.000654
unknown	32454/udp	0.000654
unknown	32465/udp	0.000654
unknown	32466/udp	0.000654
unknown	32468/udp	0.000654
unknown	32469/udp	0.001307
unknown	32473/udp	0.000654
unknown	32474/udp	0.000654
unknown	32478/udp	0.000654
unknown	32479/udp	0.001307
unknown	32482/udp	0.000654
apm-link	32483/udp	0.000654	# Access Point Manager Link
unknown	32484/udp	0.000654
unknown	32487/udp	0.000654
unknown	32488/udp	0.000654
unknown	32495/udp	0.001307
unknown	32496/udp	0.000654
unknown	32499/udp	0.001307
unknown	32503/udp	0.000654
unknown	32506/udp	0.001307
unknown	32508/udp	0.000654
unknown	32511/udp	0.000654
unknown	32512/udp	0.000654
unknown	32518/udp	0.000654
unknown	32523/udp	0.000654
unknown	32524/udp	0.000654
unknown	32528/udp	0.001961
unknown	32532/udp	0.000654
unknown	32546/udp	0.001307
unknown	32550/udp	0.000654
unknown	32553/udp	0.000654
unknown	32558/udp	0.000654
unknown	32560/udp	0.000654
unknown	32564/udp	0.000654
unknown	32566/udp	0.000654
unknown	32571/udp	0.000654
unknown	32574/udp	0.000654
unknown	32575/udp	0.000654
unknown	32576/udp	0.000654
unknown	32577/udp	0.000654
unknown	32578/udp	0.000654
unknown	32583/udp	0.000654
unknown	32592/udp	0.000654
unknown	32595/udp	0.000654
unknown	32597/udp	0.000654
unknown	32598/udp	0.000654
unknown	32607/udp	0.001307
unknown	32611/udp	0.001307
unknown	32612/udp	0.000654
unknown	32617/udp	0.000654
unknown	32618/udp	0.000654
unknown	32629/udp	0.000654
unknown	32631/udp	0.000654
unknown	32632/udp	0.000654
unknown	32634/udp	0.000654
unknown	32637/udp	0.000654
unknown	32639/udp	0.000654
unknown	32641/udp	0.000654
unknown	32642/udp	0.000654
unknown	32644/udp	0.000654
unknown	32652/udp	0.000654
unknown	32656/udp	0.000654
unknown	32664/udp	0.000654
unknown	32669/udp	0.000654
unknown	32674/udp	0.000654
unknown	32675/udp	0.000654
unknown	32676/udp	0.000654
unknown	32682/udp	0.000654
unknown	32685/udp	0.000654
unknown	32687/udp	0.000654
unknown	32693/udp	0.000654
unknown	32706/udp	0.000654
unknown	32714/udp	0.000654
unknown	32723/udp	0.000654
unknown	32727/udp	0.001307
unknown	32731/udp	0.000654
unknown	32734/udp	0.000654
unknown	32736/udp	0.000654
unknown	32742/udp	0.000654
unknown	32743/udp	0.000654
unknown	32744/udp	0.000654
unknown	32748/udp	0.000654
unknown	32750/udp	0.001307
unknown	32760/udp	0.001307
unknown	32764/tcp	0.000076
unknown	32765/tcp	0.000076
filenet-powsrm	32767/tcp	0.000076	# FileNet BPM WS-ReliableMessaging Client
filenet-tms	32768/tcp	0.009199	# Filenet TMS
omad	32768/udp	0.044407	# OpenMosix Autodiscovery Daemon
filenet-rpc	32769/tcp	0.000760	# Filenet RPC
filenet-rpc	32769/udp	0.007768	# Filenet RPC
sometimes-rpc3	32770/tcp	0.000903	# Sometimes an RPC port on my Solaris box
sometimes-rpc4	32770/udp	0.006745	# Sometimes an RPC port on my Solaris box
sometimes-rpc5	32771/tcp	0.001367	# Sometimes an RPC port on my Solaris box (rusersd)
sometimes-rpc6	32771/udp	0.008490	# Sometimes an RPC port on my Solaris box (rusersd)
sometimes-rpc7	32772/tcp	0.000891	# Sometimes an RPC port on my Solaris box (status)
sometimes-rpc8	32772/udp	0.005352	# Sometimes an RPC port on my Solaris box (status)
sometimes-rpc9	32773/tcp	0.000602	# Sometimes an RPC port on my Solaris box (rquotad)
sometimes-rpc10	32773/udp	0.003238	# Sometimes an RPC port on my Solaris box (rquotad)
sometimes-rpc11	32774/tcp	0.000602	# Sometimes an RPC port on my Solaris box (rusersd)
sometimes-rpc12	32774/udp	0.002819	# Sometimes an RPC port on my Solaris box (rusersd)
sometimes-rpc13	32775/tcp	0.000427	# Sometimes an RPC port on my Solaris box (status)
sometimes-rpc14	32775/udp	0.002668	# Sometimes an RPC port on my Solaris box (status)
sometimes-rpc15	32776/tcp	0.000364	# Sometimes an RPC port on my Solaris box (sprayd)
sometimes-rpc16	32776/udp	0.002013	# Sometimes an RPC port on my Solaris box (sprayd)
sometimes-rpc17	32777/tcp	0.000301	# Sometimes an RPC port on my Solaris box (walld)
sometimes-rpc18	32777/udp	0.002282	# Sometimes an RPC port on my Solaris box (walld)
sometimes-rpc19	32778/tcp	0.000289	# Sometimes an RPC port on my Solaris box (rstatd)
sometimes-rpc20	32778/udp	0.001577	# Sometimes an RPC port on my Solaris box (rstatd)
sometimes-rpc21	32779/tcp	0.000301	# Sometimes an RPC port on my Solaris box
sometimes-rpc22	32779/udp	0.002584	# Sometimes an RPC port on my Solaris box
sometimes-rpc23	32780/tcp	0.000263	# Sometimes an RPC port on my Solaris box
sometimes-rpc24	32780/udp	0.001812	# Sometimes an RPC port on my Solaris box
unknown	32781/tcp	0.000380
unknown	32782/tcp	0.000380
unknown	32783/tcp	0.000228
unknown	32784/tcp	0.000304
unknown	32785/tcp	0.000228
sometimes-rpc25	32786/tcp	0.000075	# Sometimes an RPC port (mountd)
sometimes-rpc26	32786/udp	0.001191	# Sometimes an RPC port
sometimes-rpc27	32787/tcp	0.000075	# Sometimes an RPC port dmispd (DMI Service Provider)
sometimes-rpc28	32787/udp	0.000956	# Sometimes an RPC port
unknown	32788/tcp	0.000076
unknown	32789/tcp	0.000076
unknown	32789/udp	0.000518
unknown	32790/tcp	0.000076
unknown	32790/udp	0.000518
unknown	32791/tcp	0.000152
unknown	32792/tcp	0.000152
unknown	32792/udp	0.000518
unknown	32793/udp	0.000518
unknown	32796/udp	0.000518
unknown	32797/tcp	0.000076
unknown	32798/tcp	0.000076
unknown	32798/udp	0.001554
unknown	32799/tcp	0.000076
unknown	32800/udp	0.000518
unknown	32803/tcp	0.000152
unknown	32803/udp	0.000518
unknown	32804/udp	0.000518
unknown	32807/tcp	0.000076
unknown	32808/udp	0.000518
unknown	32809/udp	0.000518
unknown	32811/udp	0.000518
unknown	32812/udp	0.001036
unknown	32813/udp	0.000518
unknown	32814/tcp	0.000076
unknown	32814/udp	0.000518
unknown	32815/tcp	0.000076
unknown	32815/udp	0.009322
unknown	32816/tcp	0.000152
unknown	32817/udp	0.000518
unknown	32818/udp	0.002071
unknown	32820/tcp	0.000076
unknown	32820/udp	0.001036
unknown	32821/udp	0.000518
unknown	32822/tcp	0.000152
unknown	32824/udp	0.000518
unknown	32835/tcp	0.000152
unknown	32837/tcp	0.000076
unknown	32841/udp	0.000518
unknown	32842/tcp	0.000076
unknown	32843/udp	0.001036
unknown	32847/udp	0.001036
unknown	32850/udp	0.000518
unknown	32854/udp	0.000518
unknown	32858/tcp	0.000076
unknown	32863/udp	0.000518
unknown	32868/tcp	0.000076
unknown	32869/tcp	0.000076
unknown	32871/tcp	0.000076
unknown	32871/udp	0.000518
unknown	32875/udp	0.000518
unknown	32878/udp	0.000518
unknown	32880/udp	0.000518
unknown	32886/udp	0.000518
unknown	32888/tcp	0.000076
unknown	32890/udp	0.000518
idmgratm	32896/udp	0.000518	# Attachmate ID Manager
unknown	32897/tcp	0.000076
unknown	32897/udp	0.001036
unknown	32898/tcp	0.000076
unknown	32899/udp	0.000518
unknown	32904/tcp	0.000076
unknown	32905/tcp	0.000076
unknown	32905/udp	0.000518
unknown	32908/tcp	0.000076
unknown	32908/udp	0.000518
unknown	32910/tcp	0.000076
unknown	32910/udp	0.000518
unknown	32911/tcp	0.000076
unknown	32915/udp	0.000518
unknown	32923/udp	0.000518
unknown	32931/udp	0.002071
unknown	32932/tcp	0.000076
unknown	32942/udp	0.000518
unknown	32944/tcp	0.000076
unknown	32951/udp	0.000518
unknown	32955/udp	0.001036
unknown	32956/udp	0.000518
unknown	32958/udp	0.000518
unknown	32960/tcp	0.000076
unknown	32961/tcp	0.000076
unknown	32964/udp	0.000518
unknown	32975/udp	0.000518
unknown	32976/tcp	0.000076
unknown	32976/udp	0.000518
unknown	32978/udp	0.000518
unknown	32993/udp	0.000518
unknown	32996/udp	0.000518
unknown	33000/tcp	0.000076
unknown	33008/udp	0.000518
unknown	33009/udp	0.000518
unknown	33011/tcp	0.000076
unknown	33011/udp	0.000518
unknown	33017/tcp	0.000076
unknown	33023/udp	0.000518
unknown	33024/udp	0.000518
unknown	33025/udp	0.000518
unknown	33027/udp	0.000518
unknown	33028/udp	0.001036
unknown	33029/udp	0.000518
unknown	33030/udp	0.001554
unknown	33035/udp	0.000518
unknown	33043/udp	0.001036
unknown	33046/udp	0.000518
unknown	33051/udp	0.000518
unknown	33065/udp	0.000518
unknown	33070/tcp	0.000076
unknown	33070/udp	0.000518
unknown	33073/udp	0.000518
unknown	33076/udp	0.000518
unknown	33080/udp	0.001036
unknown	33087/tcp	0.000076
unknown	33090/udp	0.000518
unknown	33104/udp	0.000518
unknown	33107/udp	0.000518
unknown	33116/udp	0.000518
unknown	33122/udp	0.000518
unknown	33124/tcp	0.000076
unknown	33126/udp	0.000518
unknown	33144/udp	0.001036
unknown	33145/udp	0.000518
unknown	33147/udp	0.000518
unknown	33149/udp	0.001036
unknown	33156/udp	0.001036
unknown	33162/udp	0.001036
unknown	33175/tcp	0.000076
unknown	33183/udp	0.000518
unknown	33187/udp	0.000518
unknown	33188/udp	0.000518
unknown	33192/tcp	0.000076
unknown	33192/udp	0.000518
unknown	33200/tcp	0.000076
unknown	33201/udp	0.000518
unknown	33203/tcp	0.000076
unknown	33203/udp	0.000518
unknown	33206/udp	0.000518
unknown	33207/udp	0.001036
unknown	33208/udp	0.001036
unknown	33214/udp	0.000518
unknown	33216/udp	0.000518
unknown	33217/udp	0.000518
unknown	33221/udp	0.000518
unknown	33223/udp	0.000518
unknown	33228/udp	0.000518
unknown	33230/udp	0.000518
unknown	33231/udp	0.000518
unknown	33238/udp	0.000518
unknown	33240/udp	0.000518
unknown	33241/udp	0.000518
unknown	33248/udp	0.000518
unknown	33249/udp	0.001554
unknown	33264/udp	0.001036
unknown	33270/udp	0.000518
unknown	33272/udp	0.000518
unknown	33274/udp	0.000518
unknown	33277/tcp	0.000076
unknown	33279/udp	0.000518
unknown	33281/udp	0.008286
unknown	33283/udp	0.000518
unknown	33285/udp	0.001036
unknown	33287/udp	0.000518
unknown	33290/udp	0.001036
unknown	33298/udp	0.000518
unknown	33299/udp	0.000518
unknown	33302/udp	0.001036
unknown	33308/udp	0.000518
unknown	33311/udp	0.000518
unknown	33319/udp	0.000518
unknown	33320/udp	0.000518
unknown	33327/tcp	0.000076
unknown	33329/udp	0.000518
unknown	33333/udp	0.000518
unknown	33334/udp	0.000518
unknown	33335/tcp	0.000076
unknown	33336/udp	0.000518
unknown	33337/tcp	0.000076
unknown	33345/udp	0.000518
unknown	33348/udp	0.000518
unknown	33353/udp	0.000518
unknown	33354/tcp	0.000760
unknown	33354/udp	0.005179
unknown	33355/udp	0.002589
unknown	33356/udp	0.000518
unknown	33357/udp	0.000518
unknown	33364/udp	0.000518
unknown	33367/tcp	0.000076
unknown	33377/udp	0.001036
unknown	33379/udp	0.000518
unknown	33381/udp	0.000518
unknown	33386/udp	0.000518
unknown	33389/udp	0.000518
unknown	33394/udp	0.001036
unknown	33395/tcp	0.000076
unknown	33395/udp	0.000518
unknown	33397/udp	0.000518
unknown	33402/udp	0.000518
unknown	33407/udp	0.000518
unknown	33414/udp	0.001036
unknown	33418/udp	0.000518
unknown	33419/udp	0.000518
unknown	33422/udp	0.001036
unknown	33427/udp	0.000518
unknown	33429/udp	0.000518
unknown	33430/udp	0.000518
unknown	33435/udp	0.000518
unknown	33443/udp	0.000518
unknown	33444/tcp	0.000076
unknown	33448/udp	0.001036
unknown	33453/tcp	0.000152
unknown	33456/udp	0.000518
unknown	33459/udp	0.001554
unknown	33460/udp	0.000518
unknown	33464/udp	0.000518
unknown	33465/udp	0.001036
unknown	33468/udp	0.000518
unknown	33472/udp	0.000518
unknown	33481/udp	0.000518
unknown	33483/udp	0.000518
unknown	33485/udp	0.000518
unknown	33497/udp	0.000518
unknown	33510/udp	0.000518
unknown	33513/udp	0.000518
unknown	33514/udp	0.000518
unknown	33517/udp	0.000518
unknown	33521/udp	0.000518
unknown	33522/tcp	0.000076
unknown	33523/tcp	0.000076
unknown	33528/udp	0.000518
unknown	33532/udp	0.000518
unknown	33534/udp	0.000518
unknown	33535/udp	0.000518
unknown	33540/udp	0.000518
unknown	33546/udp	0.000518
unknown	33550/tcp	0.000076
unknown	33550/udp	0.000518
unknown	33554/tcp	0.000152
unknown	33556/udp	0.001036
unknown	33558/udp	0.000518
unknown	33559/udp	0.000518
unknown	33562/udp	0.000518
unknown	33564/udp	0.000518
unknown	33575/udp	0.001036
unknown	33578/udp	0.000518
unknown	33581/udp	0.000518
unknown	33584/udp	0.001036
unknown	33586/udp	0.000518
unknown	33591/udp	0.001036
unknown	33593/udp	0.000518
unknown	33598/udp	0.000518
unknown	33599/udp	0.000518
unknown	33604/tcp	0.000076
unknown	33605/tcp	0.000076
unknown	33606/udp	0.000518
unknown	33635/udp	0.000518
unknown	33636/udp	0.000518
unknown	33641/udp	0.000518
unknown	33651/udp	0.000518
unknown	33652/udp	0.001036
unknown	33653/udp	0.000518
unknown	33671/udp	0.000518
unknown	33687/udp	0.001036
unknown	33691/udp	0.000518
unknown	33693/udp	0.001036
unknown	33699/udp	0.000518
unknown	33700/udp	0.001036
unknown	33702/udp	0.000518
unknown	33709/udp	0.000518
unknown	33710/udp	0.001036
unknown	33717/udp	0.001554
unknown	33722/udp	0.000518
unknown	33724/udp	0.001036
unknown	33726/udp	0.000518
unknown	33734/udp	0.000518
unknown	33744/udp	0.002071
unknown	33745/udp	0.000518
unknown	33753/udp	0.000518
unknown	33755/udp	0.000518
unknown	33761/udp	0.000518
unknown	33773/udp	0.000518
unknown	33774/udp	0.000518
unknown	33775/udp	0.000518
unknown	33776/udp	0.000518
unknown	33781/udp	0.000518
unknown	33782/udp	0.000518
unknown	33790/udp	0.000518
unknown	33795/udp	0.001036
unknown	33804/udp	0.000518
unknown	33813/udp	0.000518
unknown	33814/udp	0.000518
unknown	33821/udp	0.000518
unknown	33826/udp	0.001036
unknown	33832/udp	0.000518
unknown	33836/udp	0.000518
unknown	33837/udp	0.000518
unknown	33838/udp	0.000518
unknown	33841/tcp	0.000076
unknown	33843/udp	0.000518
unknown	33844/udp	0.000518
unknown	33845/udp	0.000518
unknown	33848/udp	0.000518
unknown	33849/udp	0.001036
unknown	33852/udp	0.000518
unknown	33858/udp	0.001036
unknown	33866/udp	0.001554
unknown	33871/udp	0.000518
unknown	33872/udp	0.001554
unknown	33873/udp	0.001036
unknown	33878/udp	0.001036
unknown	33879/tcp	0.000076
unknown	33879/udp	0.000518
unknown	33882/tcp	0.000076
unknown	33882/udp	0.001036
unknown	33889/tcp	0.000076
unknown	33891/udp	0.000518
unknown	33892/udp	0.000518
unknown	33895/tcp	0.000076
unknown	33897/udp	0.000518
unknown	33898/udp	0.000518
unknown	33899/tcp	0.000380
unknown	33900/udp	0.000518
unknown	33902/udp	0.000518
unknown	33905/udp	0.000518
unknown	33906/udp	0.000518
unknown	33907/udp	0.000518
unknown	33908/udp	0.000518
unknown	33915/udp	0.000518
unknown	33916/udp	0.000518
unknown	33924/udp	0.000518
unknown	33933/udp	0.000518
unknown	33935/udp	0.000518
unknown	33962/udp	0.000518
unknown	33967/udp	0.000518
unknown	33968/udp	0.000518
unknown	33972/udp	0.000518
unknown	33973/udp	0.000518
unknown	33975/udp	0.001036
unknown	33979/udp	0.000518
unknown	33986/udp	0.001036
unknown	33987/udp	0.000518
unknown	33991/udp	0.000518
unknown	34012/udp	0.000518
unknown	34016/udp	0.000518
unknown	34021/tcp	0.000076
unknown	34021/udp	0.000518
unknown	34025/udp	0.000518
unknown	34031/udp	0.000518
unknown	34035/udp	0.000518
unknown	34036/tcp	0.000076
unknown	34038/udp	0.001554
unknown	34041/udp	0.000518
unknown	34044/udp	0.000518
unknown	34045/udp	0.000518
unknown	34047/udp	0.000518
unknown	34050/udp	0.000518
unknown	34052/udp	0.000518
unknown	34053/udp	0.000518
unknown	34060/udp	0.000518
unknown	34066/udp	0.000518
unknown	34069/udp	0.000518
unknown	34075/udp	0.001036
unknown	34079/udp	0.001554
unknown	34082/udp	0.001036
unknown	34084/udp	0.000518
unknown	34085/udp	0.000518
unknown	34090/udp	0.000518
unknown	34096/tcp	0.000076
unknown	34108/udp	0.000518
unknown	34111/udp	0.000518
unknown	34119/udp	0.001036
unknown	34125/udp	0.002071
unknown	34133/udp	0.001036
unknown	34136/udp	0.000518
unknown	34140/udp	0.000518
unknown	34153/udp	0.001036
unknown	34154/udp	0.000518
unknown	34156/udp	0.000518
unknown	34157/udp	0.001036
unknown	34167/udp	0.000518
unknown	34168/udp	0.000518
unknown	34172/udp	0.000518
unknown	34174/udp	0.000518
unknown	34178/udp	0.000518
unknown	34181/udp	0.000518
unknown	34182/udp	0.000518
unknown	34189/tcp	0.000076
unknown	34189/udp	0.000518
unknown	34197/udp	0.000518
unknown	34198/udp	0.000518
unknown	34204/udp	0.000518
unknown	34206/udp	0.000518
unknown	34209/udp	0.000518
unknown	34210/udp	0.000518
unknown	34214/udp	0.001036
unknown	34225/udp	0.000518
unknown	34227/udp	0.001036
unknown	34231/udp	0.001036
unknown	34235/udp	0.000518
unknown	34236/udp	0.000518
unknown	34242/udp	0.000518
unknown	34243/udp	0.001036
unknown	34245/udp	0.000518
unknown	34250/udp	0.001036
unknown	34251/udp	0.000518
unknown	34253/udp	0.001036
unknown	34266/udp	0.000518
unknown	34268/udp	0.000518
unknown	34278/udp	0.000518
unknown	34279/udp	0.000518
unknown	34280/udp	0.000518
unknown	34282/udp	0.000518
unknown	34283/udp	0.000518
unknown	34284/udp	0.000518
unknown	34290/udp	0.000518
unknown	34295/udp	0.000518
unknown	34299/udp	0.000518
unknown	34306/udp	0.000518
unknown	34311/udp	0.000518
unknown	34315/udp	0.000518
unknown	34317/tcp	0.000076
unknown	34318/udp	0.000518
unknown	34319/udp	0.000518
unknown	34325/udp	0.000518
unknown	34326/udp	0.000518
unknown	34327/udp	0.000518
unknown	34335/udp	0.000518
unknown	34337/udp	0.000518
unknown	34338/udp	0.000518
unknown	34341/tcp	0.000076
unknown	34345/udp	0.000518
unknown	34349/udp	0.000518
unknown	34353/udp	0.000518
unknown	34358/udp	0.001554
unknown	34363/udp	0.000518
unknown	34366/udp	0.000518
unknown	34374/udp	0.001036
unknown	34375/udp	0.000518
unknown	34377/udp	0.000518
unknown	34381/tcp	0.000076
unknown	34381/udp	0.000518
unknown	34384/udp	0.000518
unknown	34394/udp	0.000518
unknown	34397/udp	0.000518
unknown	34400/udp	0.000518
unknown	34401/tcp	0.000076
unknown	34417/udp	0.001036
unknown	34419/udp	0.000518
unknown	34421/udp	0.001036
unknown	34422/udp	0.001554
unknown	34423/udp	0.000518
unknown	34425/udp	0.001036
unknown	34427/udp	0.000518
unknown	34433/udp	0.001554
unknown	34444/udp	0.000518
unknown	34449/udp	0.000518
unknown	34454/udp	0.000518
unknown	34455/udp	0.000518
unknown	34456/udp	0.000518
unknown	34460/udp	0.000518
unknown	34462/udp	0.000518
unknown	34464/udp	0.000518
unknown	34471/udp	0.000518
unknown	34472/udp	0.000518
unknown	34479/udp	0.000518
unknown	34484/udp	0.000518
unknown	34485/udp	0.000518
unknown	34487/udp	0.000518
unknown	34492/udp	0.000518
unknown	34496/udp	0.000518
unknown	34499/udp	0.000518
unknown	34503/udp	0.000518
unknown	34507/tcp	0.000076
unknown	34509/udp	0.000518
unknown	34510/tcp	0.000076
unknown	34511/udp	0.000518
unknown	34515/udp	0.000518
unknown	34516/udp	0.000518
unknown	34520/udp	0.000518
unknown	34522/udp	0.000518
unknown	34530/udp	0.000518
unknown	34539/udp	0.000518
unknown	34542/udp	0.000518
unknown	34547/udp	0.000518
unknown	34553/udp	0.000518
unknown	34555/udp	0.006732
unknown	34557/udp	0.000518
unknown	34560/udp	0.000518
unknown	34561/udp	0.000518
unknown	34570/udp	0.001554
unknown	34571/tcp	0.000380
unknown	34571/udp	0.000518
unknown	34572/tcp	0.000380
unknown	34572/udp	0.000518
unknown	34573/tcp	0.000380
unknown	34574/udp	0.000518
unknown	34577/udp	0.001554
unknown	34578/udp	0.001554
unknown	34579/udp	0.001554
unknown	34580/udp	0.001554
unknown	34584/udp	0.000518
unknown	34586/udp	0.001036
unknown	34592/udp	0.000518
unknown	34611/udp	0.000518
unknown	34616/udp	0.000518
unknown	34623/udp	0.000518
unknown	34631/udp	0.000518
unknown	34632/udp	0.000518
unknown	34641/udp	0.000518
unknown	34642/udp	0.000518
unknown	34645/udp	0.000518
unknown	34652/udp	0.000518
unknown	34653/udp	0.001036
unknown	34657/udp	0.000518
unknown	34683/tcp	0.000076
unknown	34686/udp	0.000518
unknown	34688/udp	0.000518
unknown	34692/udp	0.001036
unknown	34701/udp	0.000518
unknown	34705/udp	0.001036
unknown	34717/udp	0.000518
unknown	34720/udp	0.000518
unknown	34722/udp	0.000518
unknown	34728/tcp	0.000076
unknown	34730/udp	0.000518
unknown	34732/udp	0.000518
unknown	34735/udp	0.000518
unknown	34747/udp	0.000518
unknown	34752/udp	0.000518
unknown	34757/udp	0.001036
unknown	34758/udp	0.001554
unknown	34763/udp	0.000518
unknown	34765/tcp	0.000076
unknown	34770/udp	0.001036
unknown	34771/udp	0.001036
unknown	34779/udp	0.000518
unknown	34780/udp	0.001036
unknown	34781/udp	0.000518
unknown	34782/udp	0.000518
unknown	34783/tcp	0.000076
unknown	34786/udp	0.000518
unknown	34788/udp	0.000518
unknown	34796/udp	0.001554
unknown	34797/udp	0.000518
unknown	34805/udp	0.000518
unknown	34811/udp	0.000518
unknown	34817/udp	0.000518
unknown	34821/udp	0.000518
unknown	34822/udp	0.001036
unknown	34826/udp	0.000518
unknown	34833/tcp	0.000076
unknown	34838/udp	0.000518
unknown	34841/udp	0.000518
unknown	34844/udp	0.000518
unknown	34847/udp	0.001036
unknown	34855/udp	0.001554
unknown	34856/udp	0.000518
unknown	34857/udp	0.000518
unknown	34861/udp	0.006732
unknown	34862/udp	0.006214
unknown	34867/udp	0.000518
unknown	34870/udp	0.000518
unknown	34872/udp	0.000518
unknown	34875/tcp	0.000076
unknown	34882/udp	0.000518
unknown	34886/udp	0.000518
unknown	34887/udp	0.000518
unknown	34892/udp	0.002071
unknown	34893/udp	0.001036
unknown	34896/udp	0.000518
unknown	34905/udp	0.000518
unknown	34913/udp	0.000518
unknown	34915/udp	0.000518
unknown	34931/udp	0.000518
unknown	34945/udp	0.000518
unknown	34946/udp	0.000518
unknown	34948/udp	0.000518
unknown	34950/udp	0.000518
unknown	34976/udp	0.000518
unknown	34979/udp	0.001036
unknown	34984/udp	0.000518
unknown	34993/udp	0.000518
unknown	34994/udp	0.000518
unknown	34997/udp	0.000518
unknown	34999/udp	0.000518
unknown	35015/udp	0.000518
unknown	35026/udp	0.001036
unknown	35027/udp	0.000518
unknown	35030/udp	0.000518
unknown	35033/tcp	0.000076
unknown	35038/udp	0.000518
unknown	35040/udp	0.000518
unknown	35044/udp	0.001036
unknown	35050/tcp	0.000076
unknown	35051/udp	0.001036
unknown	35060/udp	0.000518
unknown	35063/udp	0.000518
unknown	35067/udp	0.000518
unknown	35088/udp	0.000518
unknown	35099/udp	0.000518
unknown	35108/udp	0.001036
unknown	35116/tcp	0.000076
unknown	35120/udp	0.000518
unknown	35126/udp	0.000518
unknown	35130/udp	0.000518
unknown	35131/tcp	0.000076
unknown	35135/udp	0.000518
unknown	35136/udp	0.000518
unknown	35140/udp	0.000518
unknown	35147/udp	0.000518
unknown	35150/udp	0.000518
unknown	35159/udp	0.000518
unknown	35169/udp	0.000518
unknown	35171/udp	0.000518
unknown	35176/udp	0.001036
unknown	35178/udp	0.000518
unknown	35179/udp	0.000518
unknown	35180/udp	0.000518
unknown	35182/udp	0.000518
unknown	35183/udp	0.000518
unknown	35187/udp	0.000518
unknown	35188/udp	0.001036
unknown	35189/udp	0.000518
unknown	35193/udp	0.000518
unknown	35198/udp	0.000518
unknown	35209/udp	0.000518
unknown	35217/tcp	0.000076
unknown	35217/udp	0.000518
unknown	35218/udp	0.000518
unknown	35222/udp	0.001036
unknown	35228/udp	0.000518
unknown	35230/udp	0.000518
unknown	35233/udp	0.000518
unknown	35235/udp	0.000518
unknown	35236/udp	0.000518
unknown	35238/udp	0.000518
unknown	35240/udp	0.001036
unknown	35245/udp	0.000518
unknown	35247/udp	0.000518
unknown	35251/udp	0.000518
unknown	35272/tcp	0.000076
unknown	35274/udp	0.000518
unknown	35280/udp	0.001036
unknown	35281/udp	0.000518
unknown	35282/udp	0.000518
unknown	35283/udp	0.001036
unknown	35288/udp	0.000518
unknown	35294/udp	0.000518
unknown	35301/udp	0.000518
unknown	35303/udp	0.000518
unknown	35312/udp	0.000518
unknown	35323/udp	0.000518
unknown	35325/udp	0.000518
unknown	35341/udp	0.000518
unknown	35344/udp	0.000518
unknown	35349/tcp	0.000076
unknown	35350/udp	0.000518
unknown	35363/udp	0.000518
unknown	35373/udp	0.000518
unknown	35388/udp	0.000518
unknown	35389/udp	0.000518
unknown	35390/udp	0.001036
unknown	35392/tcp	0.000076
unknown	35393/tcp	0.000076
unknown	35394/udp	0.000518
unknown	35401/tcp	0.000076
unknown	35406/udp	0.000518
unknown	35411/udp	0.000518
unknown	35419/udp	0.000518
unknown	35425/udp	0.000518
unknown	35426/udp	0.000518
unknown	35432/udp	0.000518
unknown	35433/udp	0.000518
unknown	35437/udp	0.000518
unknown	35438/udp	0.002071
unknown	35442/udp	0.000518
unknown	35448/udp	0.000518
unknown	35456/udp	0.000518
unknown	35474/udp	0.001036
unknown	35482/udp	0.000518
unknown	35490/udp	0.001036
unknown	35493/udp	0.001036
unknown	35500/tcp	0.000760
unknown	35502/udp	0.000518
unknown	35506/tcp	0.000076
unknown	35507/udp	0.000518
unknown	35511/udp	0.000518
unknown	35513/tcp	0.000152
unknown	35515/udp	0.000518
unknown	35516/udp	0.001036
unknown	35522/udp	0.000518
unknown	35529/udp	0.000518
unknown	35530/udp	0.000518
unknown	35533/udp	0.000518
unknown	35534/udp	0.000518
unknown	35536/udp	0.000518
unknown	35541/udp	0.000518
unknown	35551/udp	0.000518
unknown	35553/tcp	0.000076
unknown	35555/udp	0.000518
unknown	35557/udp	0.000518
unknown	35558/udp	0.000518
unknown	35561/udp	0.000518
unknown	35571/udp	0.000518
unknown	35574/udp	0.000518
unknown	35575/udp	0.000518
unknown	35579/udp	0.000518
unknown	35585/udp	0.000518
unknown	35587/udp	0.000518
unknown	35593/tcp	0.000076
unknown	35596/udp	0.000518
unknown	35598/udp	0.000518
unknown	35604/udp	0.000518
unknown	35607/udp	0.000518
unknown	35618/udp	0.000518
unknown	35621/udp	0.000518
unknown	35624/udp	0.000518
unknown	35636/udp	0.001036
unknown	35638/udp	0.000518
unknown	35643/udp	0.000518
unknown	35650/udp	0.000518
unknown	35651/udp	0.000518
unknown	35656/udp	0.001036
unknown	35658/udp	0.000518
unknown	35673/udp	0.000518
unknown	35685/udp	0.000518
unknown	35686/udp	0.000518
unknown	35688/udp	0.000518
unknown	35691/udp	0.000518
unknown	35695/udp	0.000518
unknown	35699/udp	0.000518
unknown	35702/udp	0.001554
unknown	35711/udp	0.000518
unknown	35715/udp	0.000518
unknown	35717/udp	0.000518
unknown	35720/udp	0.000518
unknown	35721/udp	0.000518
unknown	35727/udp	0.000518
unknown	35731/tcp	0.000076
unknown	35736/udp	0.000518
unknown	35746/udp	0.001036
unknown	35760/udp	0.000518
unknown	35767/udp	0.000518
unknown	35772/udp	0.000518
unknown	35773/udp	0.001036
unknown	35774/udp	0.000518
unknown	35775/udp	0.001036
unknown	35776/udp	0.001036
unknown	35777/udp	0.003107
unknown	35787/udp	0.000518
unknown	35792/udp	0.000518
unknown	35794/udp	0.001554
unknown	35800/udp	0.000518
unknown	35807/udp	0.000518
unknown	35810/udp	0.001036
unknown	35811/udp	0.000518
unknown	35812/udp	0.000518
unknown	35826/udp	0.000518
unknown	35835/udp	0.000518
unknown	35836/udp	0.000518
unknown	35837/udp	0.000518
unknown	35855/udp	0.000518
unknown	35863/udp	0.000518
unknown	35866/udp	0.000518
unknown	35870/udp	0.000518
unknown	35875/udp	0.000518
unknown	35876/udp	0.000518
unknown	35877/udp	0.000518
unknown	35879/tcp	0.000076
unknown	35882/udp	0.000518
unknown	35887/udp	0.000518
unknown	35896/udp	0.001036
unknown	35900/tcp	0.000076
unknown	35901/tcp	0.000076
unknown	35904/udp	0.001036
unknown	35906/tcp	0.000076
unknown	35906/udp	0.000518
unknown	35918/udp	0.000518
unknown	35925/udp	0.000518
unknown	35928/udp	0.000518
unknown	35929/tcp	0.000076
unknown	35929/udp	0.000518
unknown	35935/udp	0.000518
unknown	35940/udp	0.001036
unknown	35945/udp	0.000518
unknown	35948/udp	0.001036
unknown	35962/udp	0.000518
unknown	35965/udp	0.000518
unknown	35973/udp	0.000518
unknown	35980/udp	0.000518
unknown	35983/udp	0.000518
unknown	35985/udp	0.001036
unknown	35986/tcp	0.000076
unknown	35989/udp	0.000518
unknown	35991/udp	0.001036
unknown	35992/udp	0.000518
unknown	35994/udp	0.000518
unknown	36005/udp	0.000518
unknown	36012/udp	0.000518
unknown	36014/udp	0.000518
unknown	36019/udp	0.001036
unknown	36025/udp	0.000518
unknown	36027/udp	0.000518
unknown	36035/udp	0.000518
unknown	36039/udp	0.000518
unknown	36041/udp	0.001036
unknown	36042/udp	0.000518
unknown	36046/tcp	0.000076
unknown	36046/udp	0.000518
unknown	36052/udp	0.000518
unknown	36065/udp	0.001036
unknown	36069/udp	0.000518
unknown	36072/udp	0.000518
unknown	36073/udp	0.000518
unknown	36080/udp	0.000518
unknown	36083/udp	0.000518
unknown	36093/udp	0.000518
unknown	36096/udp	0.001036
unknown	36099/udp	0.001036
unknown	36102/udp	0.000518
unknown	36104/tcp	0.000076
unknown	36105/tcp	0.000076
unknown	36108/udp	0.001554
unknown	36112/udp	0.000518
unknown	36114/udp	0.000518
unknown	36115/udp	0.000518
unknown	36126/udp	0.001036
unknown	36128/udp	0.000518
unknown	36136/udp	0.001036
unknown	36140/udp	0.000518
unknown	36149/udp	0.000518
unknown	36161/udp	0.000518
unknown	36175/udp	0.000518
unknown	36177/udp	0.000518
unknown	36178/udp	0.001036
unknown	36190/udp	0.000518
unknown	36193/udp	0.000518
unknown	36196/udp	0.000518
unknown	36197/udp	0.000518
unknown	36199/udp	0.000518
unknown	36201/udp	0.000518
unknown	36206/udp	0.002071
unknown	36207/udp	0.000518
unknown	36209/udp	0.000518
unknown	36212/udp	0.000518
unknown	36213/udp	0.000518
unknown	36214/udp	0.001036
unknown	36216/udp	0.000518
unknown	36223/udp	0.000518
unknown	36227/udp	0.000518
unknown	36228/udp	0.000518
unknown	36230/udp	0.000518
unknown	36237/udp	0.001036
unknown	36239/udp	0.000518
unknown	36244/udp	0.000518
unknown	36249/udp	0.000518
unknown	36252/udp	0.000518
unknown	36256/tcp	0.000076
unknown	36267/udp	0.000518
unknown	36269/udp	0.000518
unknown	36270/udp	0.000518
unknown	36275/tcp	0.000076
unknown	36276/udp	0.000518
unknown	36277/udp	0.000518
unknown	36279/udp	0.000518
unknown	36291/udp	0.000518
unknown	36293/udp	0.001036
unknown	36297/udp	0.000518
unknown	36303/udp	0.000518
unknown	36306/udp	0.000518
unknown	36307/udp	0.000518
unknown	36309/udp	0.000518
unknown	36312/udp	0.000518
unknown	36321/udp	0.000518
unknown	36336/udp	0.000518
unknown	36338/udp	0.000518
unknown	36342/udp	0.000518
unknown	36344/udp	0.000518
unknown	36350/udp	0.000518
unknown	36368/tcp	0.000076
unknown	36373/udp	0.000518
unknown	36376/udp	0.000518
unknown	36380/udp	0.001036
unknown	36381/udp	0.000518
unknown	36382/udp	0.000518
unknown	36384/udp	0.001554
unknown	36391/udp	0.000518
unknown	36404/udp	0.000518
unknown	36405/udp	0.000518
s1-control	36412/sctp	0.000000	# S1-Control Plane (3GPP)
unknown	36412/udp	0.000518
x2-control	36422/sctp	0.000000	# X2-Control Plane (3GPP)
unknown	36423/udp	0.000518
unknown	36431/udp	0.000518
unknown	36434/udp	0.000518
unknown	36436/tcp	0.000076
unknown	36445/udp	0.000518
unknown	36455/udp	0.000518
unknown	36456/udp	0.000518
unknown	36458/udp	0.001554
unknown	36460/udp	0.000518
unknown	36462/udp	0.001036
unknown	36464/udp	0.000518
unknown	36465/udp	0.000518
unknown	36469/udp	0.000518
unknown	36471/udp	0.001036
unknown	36474/udp	0.000518
unknown	36475/udp	0.000518
unknown	36480/udp	0.000518
unknown	36482/udp	0.000518
unknown	36483/udp	0.000518
unknown	36485/udp	0.000518
unknown	36486/udp	0.000518
unknown	36489/udp	0.001554
unknown	36491/udp	0.000518
unknown	36500/udp	0.001036
unknown	36508/tcp	0.000076
unknown	36508/udp	0.000518
unknown	36513/udp	0.000518
unknown	36517/udp	0.000518
unknown	36519/udp	0.001036
unknown	36522/udp	0.001036
unknown	36525/udp	0.000518
unknown	36526/udp	0.000518
unknown	36529/udp	0.000518
unknown	36530/tcp	0.000076
unknown	36532/udp	0.000518
unknown	36535/udp	0.000518
unknown	36540/udp	0.000518
unknown	36543/udp	0.000518
unknown	36545/udp	0.000518
unknown	36546/udp	0.000518
unknown	36550/udp	0.000518
unknown	36552/tcp	0.000076
unknown	36556/udp	0.000518
unknown	36561/udp	0.000518
unknown	36562/udp	0.000518
unknown	36571/udp	0.000518
unknown	36576/udp	0.001036
unknown	36578/udp	0.000518
unknown	36590/udp	0.000518
unknown	36596/udp	0.000518
unknown	36600/udp	0.000518
unknown	36601/udp	0.000518
unknown	36612/udp	0.000518
unknown	36616/udp	0.000518
unknown	36618/udp	0.000518
unknown	36622/udp	0.000518
unknown	36624/udp	0.000518
unknown	36633/udp	0.000518
unknown	36640/udp	0.000518
unknown	36641/udp	0.001036
unknown	36645/udp	0.000518
unknown	36647/udp	0.000518
unknown	36655/udp	0.000518
unknown	36659/tcp	0.000076
unknown	36664/udp	0.000518
unknown	36666/udp	0.001036
unknown	36669/udp	0.001554
unknown	36671/udp	0.000518
unknown	36675/udp	0.000518
unknown	36677/tcp	0.000076
unknown	36677/udp	0.000518
unknown	36681/udp	0.000518
unknown	36682/udp	0.000518
unknown	36689/udp	0.000518
unknown	36694/tcp	0.000076
unknown	36694/udp	0.001036
unknown	36695/udp	0.001036
unknown	36696/udp	0.000518
unknown	36699/udp	0.000518
unknown	36702/udp	0.000518
unknown	36705/udp	0.000518
unknown	36710/tcp	0.000076
unknown	36719/udp	0.001036
unknown	36721/udp	0.000518
unknown	36725/udp	0.000518
unknown	36728/udp	0.000518
unknown	36741/udp	0.000518
unknown	36743/udp	0.000518
unknown	36748/tcp	0.000076
unknown	36748/udp	0.000518
unknown	36754/udp	0.000518
unknown	36756/udp	0.000518
unknown	36757/udp	0.000518
unknown	36760/udp	0.000518
unknown	36776/udp	0.000518
unknown	36778/udp	0.001554
unknown	36788/udp	0.000518
unknown	36793/udp	0.000518
unknown	36802/udp	0.000518
unknown	36807/udp	0.000518
unknown	36810/udp	0.000518
unknown	36813/udp	0.000518
unknown	36816/udp	0.000518
unknown	36817/udp	0.001036
unknown	36823/tcp	0.000076
unknown	36824/tcp	0.000076
unknown	36832/udp	0.000518
unknown	36835/udp	0.000518
unknown	36837/udp	0.000518
unknown	36843/udp	0.000518
unknown	36845/udp	0.000518
unknown	36848/udp	0.000518
unknown	36849/udp	0.000518
unknown	36851/udp	0.000518
unknown	36854/udp	0.001036
unknown	36855/udp	0.000518
unknown	36861/udp	0.000518
unknown	36862/udp	0.001036
unknown	36871/udp	0.000518
unknown	36882/udp	0.000518
unknown	36883/udp	0.000518
unknown	36887/udp	0.001036
unknown	36893/udp	0.001554
unknown	36905/udp	0.000518
unknown	36907/udp	0.000518
unknown	36909/udp	0.000518
unknown	36910/udp	0.001036
unknown	36911/udp	0.000518
unknown	36912/udp	0.000518
unknown	36914/tcp	0.000076
unknown	36923/udp	0.000518
unknown	36925/udp	0.000518
unknown	36930/udp	0.000518
unknown	36931/udp	0.001036
unknown	36934/udp	0.000518
unknown	36941/udp	0.000518
unknown	36945/udp	0.001554
unknown	36950/tcp	0.000076
unknown	36955/udp	0.000518
unknown	36962/tcp	0.000076
unknown	36970/udp	0.000518
unknown	36979/udp	0.000518
unknown	36980/udp	0.000518
unknown	36981/udp	0.000518
unknown	36983/tcp	0.000076
unknown	36986/udp	0.000518
unknown	36987/udp	0.000518
unknown	36990/udp	0.001036
unknown	36997/udp	0.000518
unknown	37004/udp	0.000518
unknown	37010/udp	0.000518
unknown	37012/udp	0.000518
unknown	37018/udp	0.001036
unknown	37019/udp	0.000518
unknown	37021/udp	0.000518
unknown	37024/udp	0.000518
unknown	37025/udp	0.001036
unknown	37034/udp	0.000518
unknown	37046/udp	0.001036
unknown	37053/udp	0.000518
unknown	37067/udp	0.000518
unknown	37085/udp	0.000518
unknown	37087/udp	0.000518
unknown	37093/udp	0.001036
unknown	37095/udp	0.000518
unknown	37097/udp	0.000518
unknown	37100/udp	0.000518
unknown	37103/udp	0.000518
unknown	37105/udp	0.000518
unknown	37106/udp	0.000518
unknown	37119/udp	0.000518
unknown	37120/udp	0.000518
unknown	37121/tcp	0.000076
unknown	37122/udp	0.000518
unknown	37126/udp	0.000518
unknown	37130/udp	0.000518
unknown	37136/udp	0.001036
unknown	37138/udp	0.000518
unknown	37139/udp	0.001036
unknown	37144/udp	0.001554
unknown	37148/udp	0.000518
unknown	37149/udp	0.000518
unknown	37151/tcp	0.000076
unknown	37151/udp	0.000518
unknown	37152/udp	0.001036
unknown	37154/udp	0.000518
unknown	37156/udp	0.001036
unknown	37158/udp	0.000518
unknown	37163/udp	0.001036
unknown	37168/udp	0.000518
unknown	37174/tcp	0.000076
unknown	37176/udp	0.000518
unknown	37179/udp	0.000518
unknown	37182/udp	0.001036
unknown	37184/udp	0.000518
unknown	37185/tcp	0.000076
unknown	37198/udp	0.001036
unknown	37203/udp	0.000518
unknown	37208/udp	0.000518
unknown	37210/udp	0.000518
unknown	37212/udp	0.001554
unknown	37214/udp	0.000518
unknown	37215/udp	0.000518
unknown	37216/udp	0.001036
unknown	37218/tcp	0.000076
unknown	37219/udp	0.000518
unknown	37221/udp	0.001036
unknown	37225/udp	0.000518
unknown	37228/udp	0.000518
unknown	37230/udp	0.000518
unknown	37253/udp	0.000518
unknown	37255/udp	0.001036
unknown	37256/udp	0.000518
unknown	37268/udp	0.000518
unknown	37279/udp	0.000518
unknown	37288/udp	0.000518
unknown	37292/udp	0.000518
unknown	37298/udp	0.000518
unknown	37299/udp	0.000518
unknown	37310/udp	0.000518
unknown	37313/udp	0.000518
unknown	37316/udp	0.001036
unknown	37318/udp	0.000518
unknown	37324/udp	0.000518
unknown	37327/udp	0.001036
unknown	37332/udp	0.000518
unknown	37338/udp	0.000518
unknown	37342/udp	0.000518
unknown	37343/udp	0.001036
unknown	37348/udp	0.001036
unknown	37351/udp	0.000518
unknown	37356/udp	0.000518
unknown	37357/udp	0.000518
unknown	37358/udp	0.000518
unknown	37376/udp	0.000518
unknown	37377/udp	0.001036
unknown	37385/udp	0.001036
unknown	37393/tcp	0.000076
unknown	37393/udp	0.001554
unknown	37396/udp	0.000518
unknown	37400/udp	0.001036
unknown	37401/udp	0.001036
unknown	37407/udp	0.000518
unknown	37411/udp	0.000518
unknown	37415/udp	0.000518
unknown	37420/udp	0.000518
unknown	37423/udp	0.001036
unknown	37425/udp	0.000518
unknown	37431/udp	0.000518
unknown	37438/udp	0.000518
unknown	37441/udp	0.001036
unknown	37443/udp	0.000518
unknown	37444/udp	0.006732
unknown	37450/udp	0.000518
unknown	37454/udp	0.000518
unknown	37456/udp	0.001036
unknown	37458/udp	0.000518
unknown	37463/udp	0.000518
unknown	37464/udp	0.001036
unknown	37467/udp	0.000518
unknown	37474/udp	0.000518
unknown	37477/udp	0.000518
unknown	37478/udp	0.001036
unknown	37487/udp	0.000518
unknown	37488/udp	0.000518
unknown	37493/udp	0.000518
unknown	37494/udp	0.000518
unknown	37501/udp	0.000518
unknown	37506/udp	0.000518
unknown	37518/udp	0.000518
unknown	37522/tcp	0.000076
unknown	37522/udp	0.000518
unknown	37524/udp	0.000518
unknown	37525/udp	0.000518
unknown	37531/udp	0.000518
unknown	37541/udp	0.000518
unknown	37543/udp	0.000518
unknown	37546/udp	0.000518
unknown	37560/udp	0.000518
unknown	37561/udp	0.001036
unknown	37563/udp	0.001036
unknown	37567/udp	0.000518
unknown	37568/udp	0.000518
unknown	37572/udp	0.000518
unknown	37574/udp	0.001036
unknown	37587/udp	0.000518
unknown	37588/udp	0.000518
unknown	37589/udp	0.001036
unknown	37592/udp	0.001036
unknown	37602/udp	0.001554
unknown	37607/tcp	0.000076
unknown	37611/udp	0.000518
unknown	37614/tcp	0.000076
unknown	37614/udp	0.000518
unknown	37617/udp	0.000518
unknown	37621/udp	0.000518
unknown	37624/udp	0.000518
unknown	37635/udp	0.000518
unknown	37636/udp	0.000518
unknown	37638/udp	0.000518
unknown	37641/udp	0.000518
unknown	37647/tcp	0.000076
unisys-eportal	37654/udp	0.001036	# Unisys ClearPath ePortal
unknown	37657/udp	0.000518
unknown	37663/udp	0.001036
unknown	37664/udp	0.001036
unknown	37668/udp	0.000518
unknown	37670/udp	0.001036
unknown	37674/tcp	0.000076
unknown	37682/udp	0.001036
unknown	37686/udp	0.001036
unknown	37688/udp	0.000518
unknown	37690/udp	0.000518
unknown	37695/udp	0.000518
unknown	37698/udp	0.000518
unknown	37701/udp	0.000518
unknown	37710/udp	0.000518
unknown	37719/udp	0.000518
unknown	37720/udp	0.000518
unknown	37721/udp	0.000518
unknown	37728/udp	0.000518
unknown	37730/udp	0.000518
unknown	37731/udp	0.000518
unknown	37738/udp	0.000518
unknown	37749/udp	0.000518
unknown	37761/udp	0.001554
unknown	37764/udp	0.000518
unknown	37766/udp	0.000518
unknown	37767/udp	0.000518
unknown	37769/udp	0.000518
unknown	37770/udp	0.000518
unknown	37771/udp	0.000518
unknown	37777/tcp	0.000076
unknown	37778/udp	0.000518
unknown	37781/udp	0.000518
unknown	37783/udp	0.001554
unknown	37789/tcp	0.000076
unknown	37792/udp	0.000518
unknown	37795/udp	0.000518
unknown	37808/udp	0.000518
unknown	37813/udp	0.001554
unknown	37816/udp	0.000518
unknown	37817/udp	0.000518
unknown	37819/udp	0.000518
unknown	37820/udp	0.000518
unknown	37823/udp	0.001036
unknown	37829/udp	0.000518
unknown	37834/udp	0.000518
unknown	37839/tcp	0.000152
unknown	37839/udp	0.000518
unknown	37843/udp	0.001554
unknown	37844/udp	0.000518
unknown	37847/udp	0.000518
unknown	37853/udp	0.000518
unknown	37855/tcp	0.000076
unknown	37862/udp	0.000518
unknown	37863/udp	0.000518
unknown	37864/udp	0.000518
unknown	37866/udp	0.000518
unknown	37873/udp	0.000518
unknown	37874/udp	0.000518
unknown	37886/udp	0.000518
unknown	37888/udp	0.000518
unknown	37891/udp	0.000518
unknown	37893/udp	0.000518
unknown	37898/udp	0.000518
unknown	37900/udp	0.000518
unknown	37906/udp	0.000518
unknown	37907/udp	0.000518
unknown	37917/udp	0.000518
unknown	37920/udp	0.000518
unknown	37922/udp	0.001036
unknown	37923/udp	0.000518
unknown	37933/udp	0.001036
unknown	37942/udp	0.000518
unknown	37949/udp	0.000518
unknown	37952/udp	0.000518
unknown	37959/udp	0.000518
unknown	37964/udp	0.001036
unknown	37967/udp	0.000518
unknown	37968/udp	0.000518
unknown	37969/udp	0.000518
unknown	37974/udp	0.000518
unknown	37978/udp	0.000518
unknown	37985/udp	0.000518
unknown	37995/udp	0.000518
unknown	37997/udp	0.000518
unknown	38007/udp	0.000518
unknown	38008/udp	0.000518
unknown	38013/udp	0.000518
unknown	38014/udp	0.001036
unknown	38016/udp	0.000518
unknown	38021/udp	0.000518
unknown	38025/udp	0.000518
unknown	38029/tcp	0.000076
unknown	38036/udp	0.000518
landesk-cba	38037/tcp	0.000088
landesk-cba	38037/udp	0.002869
unknown	38040/udp	0.000518
unknown	38041/udp	0.001036
unknown	38042/udp	0.000518
unknown	38050/udp	0.000518
unknown	38053/udp	0.001036
unknown	38058/udp	0.000518
unknown	38063/udp	0.001554
unknown	38064/udp	0.001036
unknown	38065/udp	0.000518
unknown	38069/udp	0.000518
unknown	38070/udp	0.000518
unknown	38073/udp	0.000518
unknown	38074/udp	0.000518
unknown	38082/udp	0.000518
unknown	38088/udp	0.000518
unknown	38089/udp	0.000518
unknown	38103/udp	0.000518
unknown	38104/udp	0.000518
unknown	38106/udp	0.000518
unknown	38111/udp	0.000518
unknown	38113/udp	0.000518
unknown	38125/udp	0.001036
unknown	38130/udp	0.000518
unknown	38136/udp	0.000518
unknown	38137/udp	0.000518
unknown	38138/udp	0.000518
unknown	38139/udp	0.000518
unknown	38142/udp	0.001036
unknown	38147/udp	0.000518
unknown	38152/udp	0.000518
unknown	38153/udp	0.001036
unknown	38155/udp	0.000518
unknown	38157/udp	0.000518
unknown	38159/udp	0.000518
unknown	38166/udp	0.000518
unknown	38168/udp	0.000518
unknown	38172/udp	0.001036
unknown	38175/udp	0.000518
unknown	38179/udp	0.000518
unknown	38181/udp	0.000518
unknown	38182/udp	0.000518
unknown	38183/udp	0.001036
unknown	38185/tcp	0.000152
unknown	38188/tcp	0.000152
unknown	38189/udp	0.000518
unknown	38190/udp	0.001036
unknown	38194/tcp	0.000076
unknown	38197/udp	0.000518
fairview	38202/udp	0.000518	# Fairview Message Service
unknown	38205/tcp	0.000076
unknown	38215/udp	0.000518
unknown	38218/udp	0.001036
unknown	38224/tcp	0.000076
unknown	38225/udp	0.000518
unknown	38233/udp	0.000518
unknown	38258/udp	0.000518
unknown	38259/udp	0.000518
unknown	38262/udp	0.000518
unknown	38266/udp	0.000518
unknown	38270/tcp	0.000076
unknown	38274/udp	0.001036
unknown	38280/udp	0.000518
unknown	38283/udp	0.000518
unknown	38288/udp	0.000518
unknown	38290/udp	0.000518
unknown	38291/udp	0.000518
landesk-cba	38292/tcp	0.000276
landesk-cba	38293/udp	0.002970
unknown	38294/udp	0.001036
unknown	38297/udp	0.000518
unknown	38300/udp	0.000518
unknown	38304/udp	0.001036
unknown	38312/udp	0.001036
unknown	38313/tcp	0.000076
unknown	38321/udp	0.000518
unknown	38325/udp	0.001036
unknown	38331/tcp	0.000076
unknown	38334/udp	0.000518
unknown	38341/udp	0.000518
unknown	38343/udp	0.000518
unknown	38345/udp	0.000518
unknown	38350/udp	0.000518
unknown	38354/udp	0.000518
unknown	38355/udp	0.000518
unknown	38356/udp	0.000518
unknown	38358/tcp	0.000076
unknown	38360/udp	0.000518
unknown	38370/udp	0.001036
unknown	38372/udp	0.000518
unknown	38379/udp	0.000518
unknown	38389/udp	0.000518
unknown	38391/udp	0.000518
unknown	38395/udp	0.000518
unknown	38396/udp	0.000518
unknown	38397/udp	0.000518
unknown	38402/udp	0.000518
unknown	38403/udp	0.000518
unknown	38412/udp	0.001554
unknown	38428/udp	0.000518
unknown	38431/udp	0.000518
unknown	38432/udp	0.000518
unknown	38434/udp	0.000518
unknown	38435/udp	0.000518
unknown	38437/udp	0.000518
unknown	38438/udp	0.000518
unknown	38442/udp	0.000518
unknown	38446/tcp	0.000076
unknown	38450/udp	0.000518
unknown	38452/udp	0.000518
unknown	38465/udp	0.000518
unknown	38466/udp	0.000518
unknown	38472/udp	0.000518
unknown	38475/udp	0.000518
unknown	38478/udp	0.000518
unknown	38480/udp	0.000518
unknown	38481/tcp	0.000076
unknown	38490/udp	0.000518
unknown	38494/udp	0.000518
unknown	38497/udp	0.000518
unknown	38498/udp	0.001554
unknown	38499/udp	0.001036
unknown	38500/udp	0.000518
unknown	38505/udp	0.000518
unknown	38510/udp	0.001036
unknown	38512/udp	0.000518
unknown	38519/udp	0.000518
unknown	38520/udp	0.000518
unknown	38526/udp	0.001036
unknown	38530/udp	0.000518
unknown	38544/udp	0.000518
unknown	38545/udp	0.000518
unknown	38546/tcp	0.000076
unknown	38547/udp	0.000518
unknown	38548/udp	0.000518
unknown	38555/udp	0.000518
unknown	38557/udp	0.000518
unknown	38561/tcp	0.000076
unknown	38567/udp	0.000518
unknown	38570/tcp	0.000076
unknown	38571/udp	0.001036
unknown	38579/udp	0.000518
unknown	38581/udp	0.000518
unknown	38582/udp	0.000518
unknown	38598/udp	0.000518
unknown	38599/udp	0.000518
unknown	38608/udp	0.001036
unknown	38609/udp	0.001036
unknown	38610/udp	0.000518
unknown	38615/udp	0.001554
unknown	38618/udp	0.000518
unknown	38620/udp	0.000518
unknown	38627/udp	0.000518
unknown	38630/udp	0.000518
unknown	38631/udp	0.000518
unknown	38634/udp	0.000518
unknown	38638/udp	0.000518
unknown	38639/udp	0.000518
unknown	38644/udp	0.001036
unknown	38647/udp	0.000518
unknown	38648/udp	0.001036
unknown	38662/udp	0.000518
unknown	38666/udp	0.000518
unknown	38667/udp	0.000518
unknown	38671/udp	0.000518
unknown	38672/udp	0.000518
unknown	38675/udp	0.000518
unknown	38677/udp	0.000518
unknown	38680/udp	0.000518
unknown	38681/udp	0.000518
unknown	38684/udp	0.000518
unknown	38686/udp	0.000518
unknown	38694/udp	0.000518
unknown	38697/udp	0.000518
unknown	38707/udp	0.000518
unknown	38710/udp	0.000518
unknown	38712/udp	0.000518
unknown	38714/udp	0.001036
unknown	38716/udp	0.000518
unknown	38720/udp	0.000518
unknown	38721/udp	0.000518
unknown	38723/udp	0.000518
unknown	38724/udp	0.000518
unknown	38727/udp	0.001036
unknown	38729/udp	0.000518
unknown	38732/udp	0.001036
unknown	38734/udp	0.001036
unknown	38739/udp	0.000518
unknown	38742/udp	0.001036
unknown	38744/udp	0.000518
unknown	38745/udp	0.000518
unknown	38750/udp	0.000518
unknown	38759/udp	0.000518
unknown	38761/tcp	0.000076
unknown	38764/tcp	0.000076
unknown	38777/udp	0.000518
unknown	38780/tcp	0.000076
unknown	38780/udp	0.000518
unknown	38784/udp	0.000518
unknown	38788/udp	0.000518
unknown	38794/udp	0.000518
unknown	38799/udp	0.000518
unknown	38805/tcp	0.000076
unknown	38812/udp	0.001036
unknown	38817/udp	0.000518
unknown	38826/udp	0.000518
unknown	38836/udp	0.000518
unknown	38837/udp	0.000518
unknown	38840/udp	0.000518
unknown	38842/udp	0.000518
unknown	38844/udp	0.000518
unknown	38845/udp	0.000518
unknown	38850/udp	0.000518
unknown	38851/udp	0.000518
unknown	38857/udp	0.000518
unknown	38862/udp	0.000518
unknown	38864/udp	0.001036
unknown	38869/udp	0.000518
unknown	38875/udp	0.000518
unknown	38889/udp	0.000518
unknown	38898/udp	0.000518
unknown	38901/udp	0.000518
unknown	38902/udp	0.000518
unknown	38907/udp	0.000518
unknown	38909/udp	0.000518
unknown	38911/udp	0.000518
unknown	38912/udp	0.000518
unknown	38922/udp	0.000518
unknown	38927/udp	0.000518
unknown	38936/tcp	0.000076
unknown	38938/udp	0.000518
unknown	38946/udp	0.000518
unknown	38949/udp	0.000518
unknown	38956/udp	0.000518
unknown	38964/udp	0.000518
unknown	38966/udp	0.000518
unknown	38972/udp	0.001036
unknown	38973/udp	0.000518
unknown	38974/udp	0.000518
unknown	38978/udp	0.000518
unknown	38989/udp	0.000518
unknown	39006/udp	0.000518
unknown	39009/udp	0.000518
unknown	39013/udp	0.000518
unknown	39018/udp	0.000518
unknown	39022/udp	0.000518
unknown	39023/udp	0.000518
unknown	39024/udp	0.000518
unknown	39027/udp	0.000518
unknown	39028/udp	0.001036
unknown	39030/udp	0.000518
unknown	39033/udp	0.000518
unknown	39035/udp	0.001036
unknown	39037/udp	0.000518
unknown	39041/udp	0.000518
unknown	39042/udp	0.001036
unknown	39045/udp	0.000518
unknown	39054/udp	0.000518
unknown	39056/udp	0.001036
unknown	39057/udp	0.000518
unknown	39067/tcp	0.000076
unknown	39068/udp	0.000518
unknown	39074/udp	0.000518
unknown	39076/udp	0.000518
unknown	39083/udp	0.000518
unknown	39084/udp	0.000518
unknown	39085/udp	0.000518
unknown	39086/udp	0.001036
unknown	39087/udp	0.000518
unknown	39091/udp	0.000518
unknown	39095/udp	0.000518
unknown	39104/udp	0.000518
unknown	39107/udp	0.000518
unknown	39109/udp	0.000518
unknown	39114/udp	0.000518
unknown	39115/udp	0.000518
unknown	39116/udp	0.001036
unknown	39117/tcp	0.000076
unknown	39118/udp	0.000518
unknown	39120/udp	0.000518
unknown	39124/udp	0.000518
unknown	39126/udp	0.000518
unknown	39132/udp	0.000518
unknown	39133/udp	0.000518
unknown	39135/udp	0.001036
unknown	39136/tcp	0.000152
unknown	39137/udp	0.000518
unknown	39143/udp	0.000518
unknown	39146/udp	0.001036
unknown	39156/udp	0.000518
unknown	39157/udp	0.000518
unknown	39163/udp	0.001036
unknown	39167/udp	0.000518
unknown	39170/udp	0.000518
unknown	39179/udp	0.000518
unknown	39184/udp	0.000518
unknown	39185/udp	0.000518
unknown	39187/udp	0.000518
unknown	39190/udp	0.000518
unknown	39199/udp	0.000518
unknown	39201/udp	0.000518
sygatefw	39213/udp	0.004446	# Sygate Firewall management port version 3.0 build 521 and above
unknown	39214/udp	0.000518
unknown	39217/udp	0.001554
unknown	39218/udp	0.000518
unknown	39220/udp	0.001036
unknown	39227/udp	0.000518
unknown	39231/udp	0.000518
unknown	39232/udp	0.000518
unknown	39235/udp	0.000518
unknown	39239/udp	0.000518
unknown	39243/udp	0.001036
unknown	39259/udp	0.000518
unknown	39261/udp	0.000518
unknown	39265/tcp	0.000076
unknown	39265/udp	0.000518
unknown	39269/udp	0.000518
unknown	39275/udp	0.000518
unknown	39289/udp	0.000518
unknown	39290/udp	0.000518
unknown	39293/tcp	0.000076
unknown	39294/udp	0.000518
unknown	39297/udp	0.001036
unknown	39301/udp	0.000518
unknown	39303/udp	0.000518
unknown	39307/udp	0.000518
unknown	39313/udp	0.001036
unknown	39315/udp	0.000518
unknown	39318/udp	0.000518
unknown	39324/udp	0.000518
unknown	39330/udp	0.000518
unknown	39332/udp	0.001036
unknown	39344/udp	0.000518
unknown	39350/udp	0.000518
unknown	39375/udp	0.000518
unknown	39376/tcp	0.000152
unknown	39377/udp	0.001036
unknown	39380/tcp	0.000076
unknown	39383/udp	0.001036
unknown	39386/udp	0.000518
unknown	39388/udp	0.000518
unknown	39392/udp	0.000518
unknown	39397/udp	0.000518
unknown	39398/udp	0.000518
unknown	39401/udp	0.001036
unknown	39404/udp	0.000518
unknown	39407/udp	0.000518
unknown	39415/udp	0.000518
unknown	39417/udp	0.000518
unknown	39424/udp	0.000518
unknown	39426/udp	0.000518
unknown	39430/udp	0.001036
unknown	39433/tcp	0.000076
unknown	39439/udp	0.000518
unknown	39440/udp	0.001036
unknown	39444/udp	0.000518
unknown	39445/udp	0.000518
unknown	39452/udp	0.000518
unknown	39453/udp	0.001036
unknown	39457/udp	0.001036
unknown	39463/udp	0.000518
unknown	39466/udp	0.000518
unknown	39472/udp	0.000518
unknown	39477/udp	0.000518
unknown	39480/udp	0.000518
unknown	39482/tcp	0.000076
unknown	39483/udp	0.000518
unknown	39487/udp	0.000518
unknown	39489/tcp	0.000076
unknown	39492/udp	0.000518
unknown	39499/udp	0.000518
unknown	39505/udp	0.000518
unknown	39507/udp	0.001036
unknown	39518/udp	0.000518
unknown	39524/udp	0.000518
unknown	39526/udp	0.000518
unknown	39528/udp	0.000518
unknown	39529/udp	0.000518
unknown	39541/udp	0.000518
unknown	39542/udp	0.000518
unknown	39544/udp	0.000518
unknown	39548/udp	0.001036
unknown	39552/udp	0.000518
unknown	39560/udp	0.000518
unknown	39565/udp	0.000518
unknown	39566/udp	0.000518
unknown	39570/udp	0.000518
unknown	39574/udp	0.000518
unknown	39586/udp	0.000518
unknown	39590/udp	0.001036
unknown	39591/udp	0.000518
unknown	39596/udp	0.001036
unknown	39600/udp	0.001036
unknown	39605/udp	0.000518
unknown	39610/udp	0.000518
unknown	39611/udp	0.000518
unknown	39616/udp	0.000518
unknown	39617/udp	0.000518
unknown	39630/tcp	0.000076
unknown	39630/udp	0.001036
unknown	39632/udp	0.001554
unknown	39638/udp	0.000518
unknown	39641/udp	0.001036
unknown	39649/udp	0.001036
unknown	39659/tcp	0.000152
unknown	39659/udp	0.001036
unknown	39664/udp	0.000518
unknown	39666/udp	0.000518
unknown	39668/udp	0.000518
unknown	39674/udp	0.000518
unknown	39679/udp	0.000518
unknown	39683/udp	0.001554
unknown	39685/udp	0.000518
unknown	39687/udp	0.000518
unknown	39697/udp	0.001036
unknown	39701/udp	0.000518
unknown	39702/udp	0.000518
unknown	39703/udp	0.000518
unknown	39707/udp	0.000518
unknown	39709/udp	0.001036
unknown	39713/udp	0.000518
unknown	39714/udp	0.001554
unknown	39715/udp	0.000518
unknown	39716/udp	0.000518
unknown	39720/udp	0.000518
unknown	39723/udp	0.001554
unknown	39726/udp	0.000518
unknown	39727/udp	0.000518
unknown	39731/udp	0.000518
unknown	39732/tcp	0.000076
unknown	39733/udp	0.001036
unknown	39739/udp	0.000518
unknown	39740/udp	0.000518
unknown	39743/udp	0.001036
unknown	39745/udp	0.001036
unknown	39750/udp	0.000518
unknown	39753/udp	0.001036
unknown	39754/udp	0.000518
unknown	39763/tcp	0.000076
unknown	39763/udp	0.000518
unknown	39765/udp	0.000518
unknown	39773/udp	0.000518
unknown	39774/tcp	0.000076
unknown	39783/udp	0.000518
unknown	39786/udp	0.000518
unknown	39791/udp	0.000518
unknown	39792/udp	0.000518
unknown	39795/tcp	0.000076
unknown	39795/udp	0.000518
unknown	39796/udp	0.000518
unknown	39799/udp	0.000518
unknown	39800/udp	0.000518
unknown	39801/udp	0.000518
unknown	39802/udp	0.000518
unknown	39805/udp	0.000518
unknown	39811/udp	0.001036
unknown	39812/udp	0.001036
unknown	39816/udp	0.000518
unknown	39827/udp	0.000518
unknown	39829/udp	0.000518
unknown	39832/udp	0.000518
unknown	39835/udp	0.000518
unknown	39839/udp	0.000518
unknown	39845/udp	0.000518
unknown	39846/udp	0.000518
unknown	39848/udp	0.000518
unknown	39849/udp	0.000518
unknown	39856/udp	0.000518
unknown	39858/udp	0.000518
unknown	39863/udp	0.001036
unknown	39867/udp	0.000518
unknown	39869/tcp	0.000076
unknown	39871/udp	0.000518
unknown	39873/udp	0.000518
unknown	39878/udp	0.000518
unknown	39883/tcp	0.000076
unknown	39883/udp	0.000518
unknown	39888/udp	0.002071
unknown	39895/tcp	0.000076
unknown	39897/udp	0.000518
unknown	39898/udp	0.000518
unknown	39911/udp	0.000518
unknown	39917/tcp	0.000076
unknown	39919/udp	0.001036
unknown	39930/udp	0.000518
unknown	39938/udp	0.000518
unknown	39940/udp	0.000518
unknown	39948/udp	0.000518
unknown	39951/udp	0.000518
unknown	39959/udp	0.000518
unknown	39967/udp	0.000518
unknown	39973/udp	0.000518
unknown	39978/udp	0.000518
unknown	39980/udp	0.000518
unknown	39982/udp	0.001036
unknown	39990/udp	0.000518
unknown	39991/udp	0.000518
unknown	39997/udp	0.000518
safetynetp	40000/tcp	0.000152	# SafetyNET p
unknown	40001/tcp	0.000076
unknown	40002/tcp	0.000076
unknown	40003/tcp	0.000076
unknown	40005/tcp	0.000076
unknown	40008/udp	0.000518
unknown	40009/udp	0.000518
unknown	40010/udp	0.000518
unknown	40011/tcp	0.000076
unknown	40019/udp	0.001554
unknown	40022/udp	0.000518
unknown	40028/udp	0.000518
unknown	40031/udp	0.000518
unknown	40036/udp	0.000518
unknown	40041/udp	0.000518
unknown	40043/udp	0.001036
unknown	40045/udp	0.000518
unknown	40049/udp	0.000518
unknown	40054/udp	0.000518
unknown	40055/udp	0.000518
unknown	40060/udp	0.000518
unknown	40061/udp	0.000518
unknown	40063/udp	0.000518
unknown	40071/udp	0.001036
unknown	40074/udp	0.001036
unknown	40076/udp	0.000518
unknown	40089/udp	0.000518
unknown	40090/udp	0.000518
unknown	40093/udp	0.000518
unknown	40101/udp	0.001036
unknown	40102/udp	0.001036
unknown	40111/udp	0.001036
unknown	40113/udp	0.000518
unknown	40116/udp	0.002071
unknown	40123/udp	0.000518
unknown	40127/udp	0.000518
unknown	40136/udp	0.000518
unknown	40138/udp	0.000518
unknown	40141/udp	0.000518
unknown	40142/udp	0.000518
unknown	40143/udp	0.000518
unknown	40144/udp	0.000518
unknown	40147/udp	0.000518
unknown	40148/udp	0.000518
unknown	40159/udp	0.000518
unknown	40176/udp	0.000518
unknown	40181/udp	0.000518
unknown	40183/udp	0.000518
unknown	40186/udp	0.000518
unknown	40187/udp	0.000518
unknown	40188/udp	0.000518
unknown	40191/udp	0.000518
unknown	40192/udp	0.000518
unknown	40193/tcp	0.000380
unknown	40198/udp	0.000518
unknown	40207/udp	0.000518
unknown	40211/udp	0.000518
unknown	40216/udp	0.000518
unknown	40218/udp	0.000518
unknown	40224/udp	0.000518
unknown	40249/udp	0.000518
unknown	40250/udp	0.000518
unknown	40251/udp	0.000518
unknown	40266/udp	0.001036
unknown	40268/udp	0.000518
unknown	40270/udp	0.000518
unknown	40287/udp	0.000518
unknown	40291/udp	0.000518
unknown	40293/udp	0.000518
unknown	40299/udp	0.000518
unknown	40301/udp	0.000518
unknown	40303/udp	0.001036
unknown	40306/tcp	0.000076
unknown	40308/udp	0.000518
unknown	40310/udp	0.000518
unknown	40315/udp	0.000518
unknown	40319/udp	0.000518
unknown	40320/udp	0.000518
unknown	40322/udp	0.001036
unknown	40328/udp	0.000518
unknown	40329/udp	0.000518
unknown	40335/udp	0.000518
unknown	40337/udp	0.000518
unknown	40346/udp	0.000518
unknown	40348/udp	0.000518
unknown	40349/udp	0.000518
unknown	40351/udp	0.001036
unknown	40355/udp	0.000518
unknown	40360/udp	0.000518
unknown	40361/udp	0.000518
unknown	40364/udp	0.000518
unknown	40369/udp	0.000518
unknown	40377/udp	0.000518
unknown	40387/udp	0.000518
unknown	40393/tcp	0.000076
unknown	40396/udp	0.000518
unknown	40398/udp	0.000518
unknown	40399/udp	0.001036
unknown	40400/tcp	0.000076
unknown	40400/udp	0.000518
unknown	40402/udp	0.000518
unknown	40411/udp	0.000518
unknown	40415/udp	0.000518
unknown	40418/udp	0.000518
unknown	40423/udp	0.001036
unknown	40433/udp	0.000518
unknown	40436/udp	0.001036
unknown	40441/udp	0.002071
unknown	40448/udp	0.000518
unknown	40450/udp	0.000518
unknown	40451/udp	0.000518
unknown	40452/udp	0.000518
unknown	40453/udp	0.001036
unknown	40456/udp	0.000518
unknown	40457/tcp	0.000076
unknown	40460/udp	0.000518
unknown	40462/udp	0.000518
unknown	40464/udp	0.000518
unknown	40480/udp	0.001036
unknown	40486/udp	0.000518
unknown	40487/udp	0.001036
unknown	40489/tcp	0.000076
unknown	40489/udp	0.000518
unknown	40491/udp	0.001036
unknown	40492/udp	0.000518
unknown	40499/udp	0.000518
unknown	40512/udp	0.001036
unknown	40513/tcp	0.000076
unknown	40515/udp	0.000518
unknown	40517/udp	0.000518
unknown	40522/udp	0.000518
unknown	40530/udp	0.000518
unknown	40538/udp	0.000518
unknown	40539/udp	0.001554
unknown	40542/udp	0.000518
unknown	40543/udp	0.000518
unknown	40551/udp	0.001036
unknown	40554/udp	0.000518
unknown	40564/udp	0.000518
unknown	40566/udp	0.000518
unknown	40571/udp	0.000518
unknown	40574/udp	0.000518
unknown	40580/udp	0.001036
unknown	40581/udp	0.000518
unknown	40584/udp	0.000518
unknown	40586/udp	0.000518
unknown	40591/udp	0.001036
unknown	40594/udp	0.000518
unknown	40606/udp	0.000518
unknown	40607/udp	0.000518
unknown	40611/udp	0.000518
unknown	40613/udp	0.000518
unknown	40614/tcp	0.000076
unknown	40622/udp	0.001554
unknown	40625/udp	0.001036
unknown	40628/tcp	0.000076
unknown	40639/udp	0.000518
unknown	40642/udp	0.001036
unknown	40643/udp	0.000518
unknown	40649/udp	0.000518
unknown	40653/udp	0.001036
unknown	40656/udp	0.000518
unknown	40657/udp	0.000518
unknown	40667/udp	0.001036
unknown	40669/udp	0.000518
unknown	40670/udp	0.000518
unknown	40672/udp	0.000518
unknown	40674/udp	0.000518
unknown	40676/udp	0.000518
unknown	40683/udp	0.000518
unknown	40687/udp	0.000518
unknown	40693/udp	0.000518
unknown	40694/udp	0.000518
unknown	40696/udp	0.000518
unknown	40697/udp	0.000518
unknown	40698/udp	0.000518
unknown	40700/udp	0.000518
unknown	40706/udp	0.000518
unknown	40707/udp	0.000518
unknown	40708/udp	0.002071
unknown	40711/udp	0.001554
unknown	40712/tcp	0.000076
unknown	40713/udp	0.000518
unknown	40719/udp	0.000518
unknown	40721/udp	0.000518
unknown	40722/udp	0.001036
unknown	40724/udp	0.001554
unknown	40726/udp	0.000518
unknown	40732/tcp	0.000076
unknown	40732/udp	0.002071
unknown	40734/udp	0.000518
unknown	40735/udp	0.000518
unknown	40736/udp	0.001036
unknown	40750/udp	0.000518
unknown	40751/udp	0.000518
unknown	40754/tcp	0.000076
unknown	40755/udp	0.000518
unknown	40757/udp	0.000518
unknown	40758/udp	0.000518
unknown	40764/udp	0.000518
unknown	40766/udp	0.000518
unknown	40773/udp	0.000518
unknown	40774/udp	0.000518
unknown	40787/udp	0.000518
unknown	40792/udp	0.000518
unknown	40793/udp	0.000518
unknown	40794/udp	0.000518
unknown	40803/udp	0.000518
unknown	40805/udp	0.001554
unknown	40811/tcp	0.000152
unknown	40812/tcp	0.000076
unknown	40817/udp	0.000518
unknown	40826/udp	0.000518
unknown	40830/udp	0.001036
unknown	40834/tcp	0.000076
cscp	40841/udp	0.000518	# CSCP
unknown	40844/udp	0.000518
unknown	40847/udp	0.001554
unknown	40849/udp	0.000518
unknown	40851/udp	0.000518
unknown	40864/udp	0.000518
unknown	40866/udp	0.001554
unknown	40871/udp	0.000518
unknown	40877/udp	0.001036
unknown	40881/udp	0.000518
unknown	40882/udp	0.001036
unknown	40888/udp	0.000518
unknown	40893/udp	0.001036
unknown	40894/udp	0.000518
unknown	40897/udp	0.000518
unknown	40898/udp	0.000518
unknown	40904/udp	0.001036
unknown	40905/udp	0.000518
unknown	40909/udp	0.000518
unknown	40911/tcp	0.000228
unknown	40914/udp	0.001036
unknown	40915/udp	0.002071
unknown	40923/udp	0.000518
unknown	40938/udp	0.000518
unknown	40940/udp	0.001036
unknown	40946/udp	0.000518
unknown	40951/tcp	0.000076
unknown	40954/udp	0.000518
unknown	40958/udp	0.001036
unknown	40962/udp	0.000518
unknown	40963/udp	0.000518
unknown	40970/udp	0.000518
unknown	40972/udp	0.001036
unknown	40982/udp	0.001036
unknown	40991/udp	0.000518
unknown	40993/udp	0.001036
unknown	41011/udp	0.001036
unknown	41014/udp	0.001036
unknown	41015/udp	0.000518
unknown	41018/udp	0.000518
unknown	41020/udp	0.000518
unknown	41033/udp	0.000518
unknown	41036/udp	0.000518
unknown	41039/udp	0.000518
unknown	41042/udp	0.000518
unknown	41049/udp	0.000518
unknown	41053/udp	0.000518
unknown	41057/udp	0.000518
unknown	41058/udp	0.003107
unknown	41064/tcp	0.000152
unknown	41065/udp	0.000518
unknown	41070/udp	0.000518
unknown	41073/udp	0.001036
unknown	41075/udp	0.000518
unknown	41078/udp	0.000518
unknown	41081/udp	0.002071
unknown	41082/udp	0.000518
unknown	41086/udp	0.000518
unknown	41113/udp	0.000518
unknown	41121/udp	0.000518
unknown	41123/tcp	0.000076
unknown	41123/udp	0.000518
unknown	41130/udp	0.000518
unknown	41135/udp	0.000518
unknown	41139/udp	0.001036
unknown	41141/udp	0.000518
unknown	41142/tcp	0.000076
unknown	41148/udp	0.001036
unknown	41149/udp	0.001036
unknown	41150/udp	0.000518
unknown	41151/udp	0.000518
unknown	41154/udp	0.000518
unknown	41156/udp	0.001036
unknown	41161/udp	0.001036
unknown	41169/udp	0.000518
unknown	41170/udp	0.000518
unknown	41171/udp	0.000518
unknown	41172/udp	0.000518
unknown	41203/udp	0.000518
unknown	41207/udp	0.000518
unknown	41226/udp	0.000518
unknown	41232/udp	0.000518
unknown	41233/udp	0.000518
unknown	41237/udp	0.000518
unknown	41245/udp	0.000518
unknown	41250/tcp	0.000076
unknown	41251/udp	0.000518
unknown	41252/udp	0.000518
unknown	41254/udp	0.000518
unknown	41262/udp	0.000518
unknown	41264/udp	0.000518
unknown	41265/udp	0.001036
unknown	41274/udp	0.000518
unknown	41278/udp	0.000518
unknown	41281/tcp	0.000076
unknown	41283/udp	0.000518
unknown	41289/udp	0.000518
unknown	41295/udp	0.000518
unknown	41308/udp	0.001554
unknown	41309/udp	0.000518
unknown	41318/tcp	0.000076
unknown	41319/udp	0.000518
unknown	41320/udp	0.000518
unknown	41327/udp	0.001036
unknown	41330/udp	0.000518
unknown	41332/udp	0.000518
unknown	41334/udp	0.001036
unknown	41335/udp	0.001036
unknown	41337/udp	0.000518
unknown	41342/tcp	0.000076
unknown	41343/udp	0.001036
unknown	41345/tcp	0.000076
unknown	41348/tcp	0.000076
unknown	41348/udp	0.001036
unknown	41351/udp	0.000518
unknown	41353/udp	0.000518
unknown	41356/udp	0.000518
unknown	41359/udp	0.000518
unknown	41360/udp	0.001036
unknown	41369/udp	0.000518
unknown	41370/udp	0.002071
unknown	41376/udp	0.000518
unknown	41379/udp	0.000518
unknown	41380/udp	0.001036
unknown	41381/udp	0.000518
unknown	41384/udp	0.000518
unknown	41387/udp	0.000518
unknown	41393/udp	0.000518
unknown	41398/tcp	0.000076
unknown	41401/udp	0.000518
unknown	41406/udp	0.001036
unknown	41407/udp	0.000518
unknown	41408/udp	0.000518
unknown	41410/udp	0.000518
unknown	41414/udp	0.000518
unknown	41415/udp	0.000518
unknown	41416/udp	0.000518
unknown	41425/udp	0.000518
unknown	41430/udp	0.000518
unknown	41435/udp	0.000518
unknown	41436/udp	0.000518
unknown	41439/udp	0.000518
unknown	41441/udp	0.000518
unknown	41442/tcp	0.000076
unknown	41446/udp	0.001554
unknown	41448/udp	0.000518
unknown	41450/udp	0.000518
unknown	41458/udp	0.000518
unknown	41463/udp	0.000518
unknown	41464/udp	0.000518
unknown	41470/udp	0.000518
unknown	41474/udp	0.000518
unknown	41475/udp	0.000518
unknown	41479/udp	0.000518
unknown	41484/udp	0.000518
unknown	41485/udp	0.000518
unknown	41494/udp	0.000518
unknown	41496/udp	0.001036
unknown	41497/udp	0.000518
unknown	41498/udp	0.000518
unknown	41499/udp	0.001036
unknown	41504/udp	0.000518
unknown	41507/udp	0.000518
unknown	41511/tcp	0.000228
unknown	41514/udp	0.000518
unknown	41515/udp	0.000518
unknown	41518/udp	0.000518
unknown	41523/tcp	0.000152
unknown	41524/udp	0.005697
unknown	41543/udp	0.000518
unknown	41544/udp	0.000518
unknown	41545/udp	0.000518
unknown	41546/udp	0.000518
unknown	41549/udp	0.000518
unknown	41551/tcp	0.000076
unknown	41551/udp	0.000518
unknown	41554/udp	0.000518
unknown	41562/udp	0.000518
unknown	41564/udp	0.000518
unknown	41565/udp	0.000518
unknown	41568/udp	0.000518
unknown	41570/udp	0.000518
unknown	41571/udp	0.000518
unknown	41574/udp	0.000518
unknown	41584/udp	0.000518
unknown	41589/udp	0.000518
unknown	41596/udp	0.000518
unknown	41602/udp	0.000518
unknown	41606/udp	0.000518
unknown	41610/udp	0.000518
unknown	41616/udp	0.000518
unknown	41617/udp	0.000518
unknown	41619/udp	0.001036
unknown	41620/udp	0.000518
unknown	41631/udp	0.000518
unknown	41632/tcp	0.000076
unknown	41632/udp	0.000518
unknown	41633/udp	0.000518
unknown	41635/udp	0.000518
unknown	41636/udp	0.000518
unknown	41637/udp	0.000518
unknown	41638/udp	0.001554
unknown	41641/udp	0.000518
unknown	41645/udp	0.000518
unknown	41656/udp	0.000518
unknown	41659/udp	0.000518
unknown	41667/udp	0.000518
unknown	41672/udp	0.000518
unknown	41674/udp	0.000518
unknown	41675/udp	0.000518
unknown	41676/udp	0.000518
unknown	41680/udp	0.000518
unknown	41684/udp	0.000518
unknown	41702/udp	0.001554
unknown	41709/udp	0.000518
unknown	41710/udp	0.000518
unknown	41711/udp	0.000518
unknown	41717/udp	0.001036
unknown	41718/udp	0.000518
unknown	41721/udp	0.000518
unknown	41730/udp	0.000518
unknown	41731/udp	0.001036
unknown	41742/udp	0.000518
unknown	41761/udp	0.000518
unknown	41763/udp	0.000518
unknown	41771/udp	0.001036
unknown	41773/tcp	0.000076
unknown	41773/udp	0.000518
unknown	41774/udp	0.001554
unknown	41778/udp	0.000518
unknown	41779/udp	0.001036
unknown	41780/udp	0.000518
unknown	41781/udp	0.000518
unknown	41785/udp	0.000518
crestron-cip	41794/tcp	0.000076	# Crestron Control Port
crestron-ctp	41795/tcp	0.000076	# Crestron Terminal Port
unknown	41799/udp	0.000518
unknown	41800/udp	0.000518
unknown	41801/udp	0.000518
unknown	41806/udp	0.000518
unknown	41807/udp	0.000518
unknown	41808/tcp	0.000076
unknown	41810/udp	0.000518
unknown	41815/udp	0.000518
unknown	41816/udp	0.001036
unknown	41829/udp	0.000518
unknown	41837/udp	0.001036
unknown	41846/udp	0.000518
unknown	41849/udp	0.000518
unknown	41850/udp	0.000518
unknown	41851/udp	0.001036
unknown	41860/udp	0.000518
unknown	41865/udp	0.000518
unknown	41867/udp	0.000518
unknown	41868/udp	0.000518
unknown	41875/udp	0.001036
unknown	41876/udp	0.000518
unknown	41886/udp	0.000518
unknown	41896/udp	0.001554
unknown	41901/udp	0.000518
unknown	41914/udp	0.000518
unknown	41916/udp	0.000518
unknown	41927/udp	0.000518
unknown	41930/udp	0.000518
unknown	41933/udp	0.000518
unknown	41937/udp	0.000518
unknown	41947/udp	0.000518
unknown	41950/udp	0.000518
unknown	41954/udp	0.000518
unknown	41955/udp	0.000518
unknown	41964/udp	0.000518
unknown	41967/udp	0.001554
unknown	41968/udp	0.000518
unknown	41971/udp	0.001554
unknown	41972/udp	0.000518
unknown	41975/udp	0.000518
unknown	41978/udp	0.000518
unknown	41982/udp	0.000518
unknown	41987/udp	0.000518
unknown	41990/udp	0.000518
unknown	41999/udp	0.000518
unknown	42001/tcp	0.000076
unknown	42005/udp	0.001036
unknown	42006/udp	0.000518
unknown	42021/udp	0.000518
unknown	42022/udp	0.000518
unknown	42029/udp	0.000518
unknown	42031/udp	0.000518
unknown	42032/udp	0.000518
unknown	42034/udp	0.000518
unknown	42035/tcp	0.000076
unknown	42046/udp	0.000518
unknown	42048/udp	0.000518
unknown	42051/udp	0.001036
unknown	42054/udp	0.000518
unknown	42056/udp	0.001554
unknown	42067/udp	0.000518
unknown	42072/udp	0.000518
unknown	42081/udp	0.000518
unknown	42085/udp	0.000518
unknown	42088/udp	0.000518
unknown	42093/udp	0.000518
unknown	42096/udp	0.000518
unknown	42100/udp	0.000518
unknown	42101/udp	0.000518
unknown	42112/udp	0.000518
unknown	42123/udp	0.000518
unknown	42126/udp	0.000518
unknown	42127/tcp	0.000076
unknown	42133/udp	0.000518
unknown	42135/udp	0.000518
unknown	42139/udp	0.001036
unknown	42141/udp	0.000518
unknown	42148/udp	0.001036
unknown	42155/udp	0.000518
unknown	42158/tcp	0.000076
unknown	42158/udp	0.000518
unknown	42159/udp	0.000518
unknown	42162/udp	0.000518
unknown	42163/udp	0.000518
unknown	42168/udp	0.000518
unknown	42172/udp	0.002589
unknown	42173/udp	0.000518
unknown	42179/udp	0.000518
unknown	42190/udp	0.000518
unknown	42197/udp	0.000518
unknown	42198/udp	0.000518
unknown	42199/udp	0.000518
unknown	42215/udp	0.001036
unknown	42220/udp	0.001036
unknown	42224/udp	0.000518
unknown	42235/udp	0.000518
unknown	42251/tcp	0.000076
unknown	42251/udp	0.001036
unknown	42262/udp	0.000518
unknown	42276/tcp	0.000076
unknown	42279/udp	0.001036
unknown	42280/udp	0.000518
unknown	42281/udp	0.000518
unknown	42283/udp	0.000518
unknown	42284/udp	0.001036
unknown	42285/udp	0.001036
unknown	42294/udp	0.001036
unknown	42298/udp	0.000518
unknown	42302/udp	0.000518
unknown	42312/udp	0.000518
unknown	42313/udp	0.001554
unknown	42318/udp	0.000518
unknown	42322/tcp	0.000076
unknown	42325/udp	0.000518
unknown	42328/udp	0.000518
unknown	42332/udp	0.000518
unknown	42338/udp	0.000518
unknown	42340/udp	0.001036
unknown	42341/udp	0.001036
unknown	42343/udp	0.000518
unknown	42350/udp	0.000518
unknown	42368/udp	0.000518
unknown	42373/udp	0.001036
unknown	42379/udp	0.000518
unknown	42380/udp	0.000518
unknown	42383/udp	0.000518
unknown	42393/udp	0.000518
unknown	42394/udp	0.000518
unknown	42409/udp	0.000518
unknown	42411/udp	0.000518
unknown	42417/udp	0.000518
unknown	42422/udp	0.000518
unknown	42423/udp	0.000518
unknown	42425/udp	0.000518
unknown	42426/udp	0.000518
unknown	42428/udp	0.000518
unknown	42429/udp	0.000518
unknown	42431/udp	0.001554
unknown	42434/udp	0.001554
unknown	42445/udp	0.000518
unknown	42449/tcp	0.000076
unknown	42452/tcp	0.000076
unknown	42456/udp	0.000518
unknown	42459/udp	0.000518
unknown	42463/udp	0.000518
unknown	42465/udp	0.000518
unknown	42471/udp	0.000518
unknown	42478/udp	0.000518
unknown	42482/udp	0.000518
unknown	42484/udp	0.000518
unknown	42498/udp	0.001036
unknown	42504/udp	0.000518
unknown	42506/udp	0.000518
candp	42508/udp	0.002071	# Computer Associates network discovery protocol
caerpc	42510/tcp	0.000988	# CA eTrust RPC
unknown	42512/udp	0.000518
unknown	42522/udp	0.000518
unknown	42533/udp	0.001036
unknown	42534/udp	0.000518
unknown	42535/udp	0.000518
unknown	42545/udp	0.000518
unknown	42546/udp	0.000518
unknown	42551/udp	0.000518
unknown	42557/udp	0.001554
unknown	42558/udp	0.001036
unknown	42559/tcp	0.000076
unknown	42560/tcp	0.000076
unknown	42562/udp	0.000518
unknown	42571/udp	0.000518
unknown	42575/tcp	0.000076
unknown	42577/udp	0.001554
unknown	42584/udp	0.000518
unknown	42585/udp	0.001036
unknown	42590/tcp	0.000076
unknown	42591/udp	0.000518
unknown	42606/udp	0.000518
unknown	42608/udp	0.000518
unknown	42610/udp	0.000518
unknown	42612/udp	0.001036
unknown	42618/udp	0.000518
unknown	42621/udp	0.000518
unknown	42622/udp	0.000518
unknown	42624/udp	0.000518
unknown	42625/udp	0.000518
unknown	42627/udp	0.001554
unknown	42632/tcp	0.000076
unknown	42632/udp	0.000518
unknown	42633/udp	0.000518
unknown	42634/udp	0.000518
unknown	42638/udp	0.001036
unknown	42639/udp	0.001554
unknown	42644/udp	0.000518
unknown	42648/udp	0.001036
unknown	42651/udp	0.000518
unknown	42652/udp	0.000518
unknown	42664/udp	0.000518
unknown	42666/udp	0.000518
unknown	42668/udp	0.000518
unknown	42671/udp	0.000518
unknown	42672/udp	0.000518
unknown	42674/udp	0.000518
unknown	42675/tcp	0.000076
unknown	42677/udp	0.000518
unknown	42679/tcp	0.000076
unknown	42681/udp	0.000518
unknown	42684/udp	0.000518
unknown	42685/tcp	0.000076
unknown	42687/udp	0.000518
unknown	42695/udp	0.000518
unknown	42699/udp	0.000518
unknown	42702/udp	0.001036
unknown	42706/udp	0.000518
unknown	42708/udp	0.001036
unknown	42716/udp	0.001036
unknown	42717/udp	0.000518
unknown	42721/udp	0.000518
unknown	42734/udp	0.000518
unknown	42735/tcp	0.000076
unknown	42741/udp	0.000518
unknown	42747/udp	0.000518
unknown	42762/udp	0.000518
unknown	42763/udp	0.000518
unknown	42773/udp	0.001036
unknown	42776/udp	0.000518
unknown	42784/udp	0.000518
unknown	42791/udp	0.000518
unknown	42796/udp	0.000518
unknown	42799/udp	0.000518
unknown	42800/udp	0.000518
unknown	42803/udp	0.001036
unknown	42804/udp	0.000518
unknown	42807/udp	0.001036
unknown	42811/udp	0.000518
unknown	42812/udp	0.001036
unknown	42815/udp	0.000518
unknown	42816/udp	0.000518
unknown	42819/udp	0.000518
unknown	42822/udp	0.000518
unknown	42823/udp	0.000518
unknown	42825/udp	0.001036
unknown	42827/udp	0.001036
unknown	42828/udp	0.000518
unknown	42831/udp	0.000518
unknown	42832/udp	0.000518
unknown	42837/udp	0.000518
unknown	42843/udp	0.000518
unknown	42849/udp	0.000518
unknown	42857/udp	0.001036
unknown	42859/udp	0.000518
unknown	42863/udp	0.000518
unknown	42864/udp	0.000518
unknown	42868/udp	0.001036
unknown	42869/udp	0.000518
unknown	42870/udp	0.000518
unknown	42874/udp	0.000518
unknown	42875/udp	0.000518
unknown	42877/udp	0.000518
unknown	42880/udp	0.000518
unknown	42882/udp	0.001036
unknown	42886/udp	0.000518
unknown	42887/udp	0.000518
unknown	42893/udp	0.000518
unknown	42902/udp	0.000518
unknown	42903/udp	0.000518
unknown	42904/udp	0.000518
unknown	42906/tcp	0.000076
unknown	42906/udp	0.000518
unknown	42910/udp	0.000518
unknown	42916/udp	0.001036
unknown	42923/udp	0.000518
unknown	42940/udp	0.000518
unknown	42941/udp	0.001036
unknown	42945/udp	0.000518
unknown	42946/udp	0.000518
unknown	42947/udp	0.000518
unknown	42949/udp	0.000518
unknown	42950/udp	0.000518
unknown	42951/udp	0.000518
unknown	42955/udp	0.000518
unknown	42960/udp	0.000518
unknown	42961/udp	0.000518
unknown	42965/udp	0.000518
unknown	42974/udp	0.000518
unknown	42975/udp	0.000518
unknown	42986/udp	0.000518
unknown	42990/tcp	0.000076
unknown	43000/tcp	0.000076
unknown	43002/tcp	0.000076
unknown	43002/udp	0.000518
unknown	43005/udp	0.000518
unknown	43009/udp	0.000518
unknown	43011/udp	0.000518
unknown	43014/udp	0.000518
unknown	43018/tcp	0.000076
unknown	43024/udp	0.000518
unknown	43027/tcp	0.000076
unknown	43032/udp	0.000518
unknown	43036/udp	0.000518
unknown	43039/udp	0.001036
unknown	43054/udp	0.000518
unknown	43057/udp	0.000518
unknown	43064/udp	0.000518
unknown	43069/udp	0.000518
unknown	43070/udp	0.000518
unknown	43072/udp	0.001036
unknown	43074/udp	0.000518
unknown	43080/udp	0.001036
unknown	43085/udp	0.000518
unknown	43086/udp	0.000518
unknown	43091/udp	0.000518
unknown	43092/udp	0.001036
unknown	43094/udp	0.001554
unknown	43103/tcp	0.000076
unknown	43106/udp	0.000518
unknown	43108/udp	0.000518
unknown	43121/udp	0.000518
unknown	43122/udp	0.000518
unknown	43126/udp	0.000518
unknown	43128/udp	0.000518
unknown	43129/udp	0.000518
unknown	43131/udp	0.000518
unknown	43139/tcp	0.000076
unknown	43139/udp	0.000518
unknown	43141/udp	0.000518
unknown	43143/tcp	0.000076
unknown	43145/udp	0.000518
unknown	43146/udp	0.000518
unknown	43147/udp	0.000518
unknown	43150/udp	0.000518
unknown	43157/udp	0.000518
unknown	43170/udp	0.001036
unknown	43171/udp	0.000518
unknown	43173/udp	0.001036
unknown	43175/udp	0.001036
unknown	43185/udp	0.000518
reachout	43188/tcp	0.000013
unknown	43195/udp	0.001554
unknown	43212/tcp	0.000076
unknown	43216/udp	0.000518
unknown	43225/udp	0.000518
unknown	43231/tcp	0.000076
unknown	43237/udp	0.000518
unknown	43242/tcp	0.000076
unknown	43248/udp	0.001036
unknown	43249/udp	0.000518
unknown	43254/udp	0.000518
unknown	43256/udp	0.000518
unknown	43257/udp	0.000518
unknown	43260/udp	0.001036
unknown	43268/udp	0.001036
unknown	43279/udp	0.000518
unknown	43280/udp	0.000518
unknown	43283/udp	0.000518
unknown	43284/udp	0.001036
unknown	43285/udp	0.000518
unknown	43288/udp	0.001036
unknown	43289/udp	0.000518
unknown	43295/udp	0.000518
unknown	43304/udp	0.000518
unknown	43306/udp	0.000518
unknown	43316/udp	0.000518
unknown	43317/udp	0.000518
unknown	43320/udp	0.000518
unknown	43322/udp	0.000518
unknown	43323/udp	0.000518
unknown	43326/udp	0.000518
unknown	43327/udp	0.000518
unknown	43334/udp	0.001036
unknown	43336/udp	0.001036
unknown	43355/udp	0.000518
unknown	43359/udp	0.000518
unknown	43360/udp	0.000518
unknown	43361/udp	0.001036
unknown	43370/udp	0.001554
unknown	43372/udp	0.000518
unknown	43376/udp	0.000518
unknown	43382/udp	0.000518
unknown	43403/udp	0.000518
unknown	43414/udp	0.000518
unknown	43418/udp	0.000518
unknown	43420/udp	0.000518
unknown	43422/udp	0.000518
unknown	43423/udp	0.001036
unknown	43425/tcp	0.000076
unknown	43432/udp	0.000518
unknown	43446/udp	0.000518
unknown	43455/udp	0.001036
unknown	43464/udp	0.000518
unknown	43472/udp	0.000518
unknown	43474/udp	0.000518
unknown	43477/udp	0.000518
unknown	43485/udp	0.000518
unknown	43491/udp	0.000518
unknown	43503/udp	0.000518
unknown	43505/udp	0.000518
unknown	43506/udp	0.000518
unknown	43510/udp	0.001036
unknown	43511/udp	0.000518
unknown	43514/udp	0.001554
unknown	43523/udp	0.000518
unknown	43525/udp	0.001036
unknown	43527/udp	0.000518
unknown	43544/udp	0.000518
unknown	43547/udp	0.000518
unknown	43550/udp	0.000518
unknown	43552/udp	0.000518
unknown	43553/udp	0.000518
unknown	43558/udp	0.000518
unknown	43589/udp	0.000518
unknown	43590/udp	0.000518
unknown	43594/udp	0.000518
unknown	43600/udp	0.000518
unknown	43601/udp	0.000518
unknown	43608/udp	0.000518
unknown	43610/udp	0.000518
unknown	43613/udp	0.000518
unknown	43617/udp	0.000518
unknown	43632/udp	0.000518
unknown	43640/udp	0.001036
unknown	43653/udp	0.000518
unknown	43654/tcp	0.000076
unknown	43670/udp	0.000518
unknown	43679/udp	0.000518
unknown	43684/udp	0.000518
unknown	43686/udp	0.001554
unknown	43690/tcp	0.000076
unknown	43697/udp	0.000518
unknown	43707/udp	0.000518
unknown	43709/udp	0.000518
unknown	43710/udp	0.000518
unknown	43713/udp	0.000518
unknown	43715/udp	0.001036
unknown	43719/udp	0.000518
unknown	43723/udp	0.000518
unknown	43724/udp	0.000518
unknown	43725/udp	0.000518
unknown	43734/tcp	0.000076
unknown	43735/udp	0.000518
unknown	43739/udp	0.000518
unknown	43740/udp	0.001036
unknown	43756/udp	0.000518
unknown	43774/udp	0.000518
unknown	43781/udp	0.000518
unknown	43785/udp	0.000518
unknown	43786/udp	0.000518
unknown	43788/udp	0.000518
unknown	43791/udp	0.000518
unknown	43794/udp	0.000518
unknown	43798/udp	0.000518
unknown	43799/udp	0.000518
unknown	43802/udp	0.001036
unknown	43803/udp	0.000518
unknown	43805/udp	0.000518
unknown	43811/udp	0.000518
unknown	43812/udp	0.000518
unknown	43814/udp	0.000518
unknown	43816/udp	0.000518
unknown	43823/tcp	0.000076
unknown	43823/udp	0.000518
unknown	43824/udp	0.001554
unknown	43835/udp	0.000518
unknown	43836/udp	0.000518
unknown	43837/udp	0.000518
unknown	43841/udp	0.000518
unknown	43842/udp	0.001036
unknown	43843/udp	0.000518
unknown	43844/udp	0.000518
unknown	43845/udp	0.000518
unknown	43847/udp	0.000518
unknown	43850/udp	0.000518
unknown	43854/udp	0.000518
unknown	43859/udp	0.000518
unknown	43861/udp	0.000518
unknown	43868/tcp	0.000076
unknown	43870/udp	0.000518
unknown	43881/udp	0.000518
unknown	43891/udp	0.000518
unknown	43901/udp	0.000518
unknown	43905/udp	0.000518
unknown	43910/udp	0.000518
unknown	43913/udp	0.000518
unknown	43923/udp	0.000518
unknown	43928/udp	0.000518
unknown	43941/udp	0.001036
unknown	43942/udp	0.001036
unknown	43954/udp	0.000518
unknown	43956/udp	0.000518
unknown	43961/udp	0.000518
unknown	43967/udp	0.001554
unknown	43973/udp	0.000518
unknown	43977/udp	0.000518
unknown	43983/udp	0.001036
unknown	43986/udp	0.000518
unknown	43991/udp	0.000518
unknown	43994/udp	0.000518
unknown	44004/tcp	0.000076
unknown	44009/udp	0.001036
unknown	44010/udp	0.000518
unknown	44013/udp	0.000518
unknown	44021/udp	0.000518
unknown	44024/udp	0.000518
unknown	44026/udp	0.001036
unknown	44032/udp	0.000518
unknown	44034/udp	0.001036
unknown	44035/udp	0.000518
unknown	44037/udp	0.001036
unknown	44040/udp	0.000518
unknown	44042/udp	0.000518
unknown	44048/udp	0.000518
unknown	44054/udp	0.001036
unknown	44056/udp	0.000518
unknown	44058/udp	0.000518
unknown	44059/udp	0.000518
unknown	44061/udp	0.000518
unknown	44075/udp	0.000518
unknown	44076/udp	0.000518
unknown	44079/udp	0.001036
unknown	44080/udp	0.000518
unknown	44087/udp	0.000518
unknown	44090/udp	0.000518
unknown	44093/udp	0.001036
unknown	44094/udp	0.000518
unknown	44098/udp	0.000518
unknown	44099/udp	0.001036
unknown	44100/udp	0.001036
unknown	44101/tcp	0.000076
unknown	44101/udp	0.001554
unknown	44107/udp	0.000518
unknown	44109/udp	0.000518
unknown	44115/udp	0.000518
unknown	44116/udp	0.001036
unknown	44117/udp	0.001036
unknown	44119/tcp	0.000076
unknown	44119/udp	0.000518
unknown	44126/udp	0.000518
unknown	44129/udp	0.000518
unknown	44135/udp	0.001036
unknown	44139/udp	0.000518
unknown	44160/udp	0.001554
unknown	44164/udp	0.000518
unknown	44166/udp	0.000518
unknown	44176/tcp	0.000228
unknown	44176/udp	0.000518
unknown	44177/udp	0.000518
unknown	44179/udp	0.001554
unknown	44180/udp	0.000518
unknown	44185/udp	0.001554
unknown	44190/udp	0.001554
unknown	44194/udp	0.000518
unknown	44195/udp	0.000518
unknown	44200/tcp	0.000076
unknown	44200/udp	0.000518
unknown	44215/udp	0.000518
unknown	44226/udp	0.000518
unknown	44227/udp	0.000518
unknown	44234/udp	0.000518
unknown	44236/udp	0.000518
unknown	44242/udp	0.000518
unknown	44245/udp	0.000518
unknown	44253/udp	0.001554
unknown	44257/udp	0.000518
unknown	44260/udp	0.000518
unknown	44266/udp	0.000518
unknown	44268/udp	0.000518
unknown	44275/udp	0.001036
unknown	44277/udp	0.000518
unknown	44282/udp	0.000518
unknown	44293/udp	0.000518
unknown	44299/udp	0.000518
unknown	44310/udp	0.001036
unknown	44312/udp	0.001036
unknown	44313/udp	0.000518
unknown	44324/udp	0.000518
unknown	44327/udp	0.000518
unknown	44328/udp	0.000518
unknown	44332/udp	0.000518
tinyfw	44334/tcp	0.000088	# tiny personal firewall admin port
unknown	44334/udp	0.001554
unknown	44336/udp	0.000518
unknown	44339/udp	0.000518
unknown	44342/udp	0.000518
unknown	44349/udp	0.000518
unknown	44357/udp	0.000518
unknown	44364/udp	0.001036
unknown	44367/udp	0.000518
unknown	44371/udp	0.001036
unknown	44373/udp	0.000518
unknown	44376/udp	0.000518
unknown	44380/tcp	0.000076
unknown	44390/udp	0.000518
unknown	44395/udp	0.000518
unknown	44396/udp	0.000518
unknown	44402/udp	0.000518
unknown	44403/udp	0.000518
unknown	44408/udp	0.001036
unknown	44409/udp	0.000518
unknown	44410/tcp	0.000076
unknown	44411/udp	0.000518
unknown	44415/udp	0.000518
unknown	44420/udp	0.001036
unknown	44423/udp	0.000518
unknown	44431/tcp	0.000076
unknown	44434/udp	0.000518
unknown	44439/udp	0.000518
coldfusion-auth	44442/tcp	0.000163	# ColdFusion Advanced Security/Siteminder Authentication Port (by Allaire/Netegrity)
coldfusion-auth	44443/tcp	0.000201	# ColdFusion Advanced Security/Siteminder Authentication Port (by Allaire/Netegrity)
unknown	44443/udp	0.000518
unknown	44444/udp	0.000518
unknown	44445/udp	0.000518
unknown	44448/udp	0.000518
unknown	44450/udp	0.000518
unknown	44452/udp	0.000518
unknown	44453/udp	0.000518
unknown	44454/udp	0.001036
unknown	44460/udp	0.000518
unknown	44466/udp	0.000518
unknown	44469/udp	0.000518
unknown	44476/udp	0.000518
unknown	44479/tcp	0.000076
unknown	44479/udp	0.000518
unknown	44483/udp	0.000518
unknown	44501/tcp	0.000228
unknown	44503/udp	0.001036
unknown	44504/udp	0.000518
unknown	44505/tcp	0.000076
unknown	44508/udp	0.001554
unknown	44509/udp	0.000518
unknown	44518/udp	0.001036
unknown	44522/udp	0.000518
unknown	44533/udp	0.000518
unknown	44534/udp	0.000518
unknown	44539/udp	0.001036
unknown	44541/tcp	0.000076
unknown	44541/udp	0.000518
unknown	44542/udp	0.000518
unknown	44557/udp	0.000518
unknown	44558/udp	0.000518
unknown	44559/udp	0.000518
unknown	44561/udp	0.000518
unknown	44577/udp	0.001036
unknown	44586/udp	0.000518
unknown	44595/udp	0.000518
unknown	44597/udp	0.000518
unknown	44598/udp	0.001036
unknown	44609/udp	0.000518
unknown	44611/udp	0.001036
unknown	44612/udp	0.000518
unknown	44614/udp	0.000518
unknown	44616/tcp	0.000076
unknown	44622/udp	0.000518
unknown	44624/udp	0.000518
unknown	44628/tcp	0.000076
unknown	44630/udp	0.000518
unknown	44632/udp	0.000518
unknown	44637/udp	0.000518
unknown	44640/udp	0.000518
unknown	44652/udp	0.000518
unknown	44654/udp	0.000518
unknown	44660/udp	0.000518
unknown	44661/udp	0.001036
unknown	44667/udp	0.000518
unknown	44671/udp	0.000518
unknown	44673/udp	0.000518
unknown	44684/udp	0.000518
unknown	44693/udp	0.000518
unknown	44702/udp	0.000518
unknown	44704/tcp	0.000076
unknown	44709/tcp	0.000152
unknown	44710/udp	0.000518
unknown	44711/tcp	0.000076
unknown	44711/udp	0.000518
unknown	44713/udp	0.000518
unknown	44714/udp	0.000518
unknown	44721/udp	0.000518
unknown	44726/udp	0.000518
unknown	44727/udp	0.000518
unknown	44730/udp	0.000518
unknown	44732/udp	0.000518
unknown	44733/udp	0.001036
unknown	44736/udp	0.000518
unknown	44738/udp	0.000518
unknown	44745/udp	0.000518
unknown	44746/udp	0.000518
unknown	44748/udp	0.001036
unknown	44752/udp	0.000518
unknown	44757/udp	0.000518
unknown	44767/udp	0.000518
unknown	44774/udp	0.000518
unknown	44775/udp	0.000518
unknown	44780/udp	0.000518
unknown	44794/udp	0.000518
unknown	44800/udp	0.000518
unknown	44815/udp	0.000518
unknown	44817/udp	0.000518
EtherNetIP-2	44818/udp	0.000518	# EtherNet/IP messaging
unknown	44819/udp	0.001036
unknown	44823/udp	0.000518
unknown	44831/udp	0.000518
unknown	44837/udp	0.000518
unknown	44845/udp	0.000518
unknown	44850/udp	0.000518
unknown	44851/udp	0.000518
unknown	44856/udp	0.001036
unknown	44866/udp	0.000518
unknown	44869/udp	0.000518
unknown	44871/udp	0.000518
unknown	44873/udp	0.000518
unknown	44876/udp	0.000518
unknown	44880/udp	0.000518
unknown	44885/udp	0.000518
unknown	44901/udp	0.000518
unknown	44912/udp	0.000518
unknown	44915/udp	0.000518
unknown	44917/udp	0.001036
unknown	44919/udp	0.000518
unknown	44923/udp	0.001554
unknown	44924/udp	0.000518
unknown	44927/udp	0.000518
unknown	44935/udp	0.000518
unknown	44937/udp	0.000518
unknown	44941/udp	0.000518
unknown	44943/udp	0.001036
unknown	44946/udp	0.001554
unknown	44955/udp	0.000518
unknown	44956/udp	0.000518
unknown	44958/udp	0.000518
unknown	44965/tcp	0.000076
unknown	44968/udp	0.004143
unknown	44969/udp	0.000518
unknown	44972/udp	0.000518
unknown	44973/udp	0.000518
unknown	44977/udp	0.000518
unknown	44981/tcp	0.000076
unknown	44983/udp	0.000518
unknown	44994/udp	0.000518
unknown	44999/udp	0.000518
ciscopop	45000/udp	0.000839	# Cisco Postoffice Protocol for Cisco Secure IDS
unknown	45001/udp	0.000518
unknown	45006/udp	0.001036
unknown	45014/udp	0.000518
unknown	45020/udp	0.000518
unknown	45021/udp	0.000518
unknown	45032/udp	0.000518
unknown	45037/udp	0.001036
unknown	45038/tcp	0.000076
unknown	45046/udp	0.000518
unknown	45050/tcp	0.000076
unknown	45061/udp	0.001036
unknown	45063/udp	0.000518
unknown	45079/udp	0.000518
unknown	45082/udp	0.000518
unknown	45087/udp	0.000518
unknown	45092/udp	0.000518
unknown	45093/udp	0.000518
unknown	45095/udp	0.000518
unknown	45099/udp	0.000518
unknown	45100/tcp	0.000684
unknown	45103/udp	0.000518
unknown	45106/udp	0.000518
unknown	45114/udp	0.000518
unknown	45118/udp	0.000518
unknown	45120/udp	0.000518
unknown	45121/udp	0.000518
unknown	45124/udp	0.000518
unknown	45125/udp	0.000518
unknown	45133/udp	0.000518
unknown	45135/udp	0.000518
unknown	45136/tcp	0.000076
unknown	45148/udp	0.001036
unknown	45149/udp	0.000518
unknown	45154/udp	0.000518
unknown	45156/udp	0.000518
unknown	45162/udp	0.000518
unknown	45164/tcp	0.000076
unknown	45175/udp	0.000518
unknown	45179/udp	0.000518
unknown	45185/udp	0.000518
unknown	45189/udp	0.000518
unknown	45190/udp	0.000518
unknown	45193/udp	0.001036
unknown	45198/udp	0.000518
unknown	45208/udp	0.000518
unknown	45210/udp	0.000518
unknown	45215/udp	0.000518
unknown	45220/tcp	0.000076
unknown	45220/udp	0.000518
unknown	45223/udp	0.000518
unknown	45225/udp	0.000518
unknown	45226/tcp	0.000076
unknown	45231/udp	0.000518
unknown	45235/udp	0.000518
unknown	45240/udp	0.000518
unknown	45247/udp	0.001554
unknown	45251/udp	0.000518
unknown	45259/udp	0.000518
unknown	45261/udp	0.000518
unknown	45262/udp	0.000518
unknown	45271/udp	0.000518
unknown	45275/udp	0.000518
unknown	45279/udp	0.000518
unknown	45281/udp	0.000518
unknown	45284/udp	0.000518
unknown	45290/udp	0.000518
unknown	45291/udp	0.000518
unknown	45298/udp	0.000518
unknown	45304/udp	0.000518
unknown	45305/udp	0.000518
unknown	45308/udp	0.000518
unknown	45309/udp	0.000518
unknown	45327/udp	0.000518
unknown	45337/udp	0.000518
unknown	45338/udp	0.001036
unknown	45339/udp	0.000518
unknown	45345/udp	0.001036
unknown	45353/udp	0.000518
unknown	45370/udp	0.000518
unknown	45371/udp	0.000518
unknown	45374/udp	0.000518
unknown	45380/udp	0.001554
unknown	45390/udp	0.000518
unknown	45392/udp	0.000518
unknown	45394/udp	0.000518
unknown	45400/udp	0.000518
unknown	45413/tcp	0.000076
unknown	45415/udp	0.000518
unknown	45418/udp	0.000518
unknown	45419/udp	0.000518
unknown	45425/udp	0.000518
unknown	45431/udp	0.000518
unknown	45438/tcp	0.000076
unknown	45441/udp	0.002071
unknown	45442/udp	0.000518
unknown	45449/udp	0.001036
unknown	45452/udp	0.000518
unknown	45454/udp	0.000518
unknown	45463/tcp	0.000076
unknown	45467/udp	0.000518
unknown	45472/udp	0.000518
unknown	45475/udp	0.000518
unknown	45488/udp	0.000518
unknown	45491/udp	0.000518
unknown	45495/udp	0.000518
unknown	45497/udp	0.000518
unknown	45503/udp	0.001036
unknown	45515/udp	0.000518
unknown	45516/udp	0.000518
unknown	45517/udp	0.000518
unknown	45519/udp	0.000518
unknown	45524/udp	0.000518
unknown	45525/udp	0.000518
unknown	45533/udp	0.000518
unknown	45537/udp	0.000518
unknown	45538/udp	0.001036
unknown	45541/udp	0.000518
unknown	45542/udp	0.000518
unknown	45548/udp	0.000518
unknown	45554/udp	0.000518
unknown	45556/udp	0.000518
unknown	45563/udp	0.000518
unknown	45568/udp	0.000518
unknown	45573/udp	0.000518
unknown	45577/udp	0.000518
unknown	45579/udp	0.000518
unknown	45588/udp	0.000518
unknown	45596/udp	0.001036
unknown	45602/tcp	0.000076
unknown	45602/udp	0.000518
unknown	45615/udp	0.000518
unknown	45616/udp	0.000518
unknown	45622/udp	0.000518
unknown	45624/tcp	0.000076
unknown	45624/udp	0.000518
unknown	45628/udp	0.000518
unknown	45645/udp	0.000518
unknown	45651/udp	0.000518
unknown	45657/udp	0.000518
unknown	45658/udp	0.000518
unknown	45665/udp	0.000518
unknown	45672/udp	0.000518
unknown	45673/udp	0.000518
unknown	45675/udp	0.000518
unknown	45676/udp	0.000518
unknown	45679/udp	0.000518
unknown	45683/udp	0.000518
unknown	45685/udp	0.001554
unknown	45686/udp	0.000518
unknown	45689/udp	0.000518
unknown	45691/udp	0.000518
unknown	45697/tcp	0.000076
unknown	45703/udp	0.000518
unknown	45710/udp	0.000518
unknown	45717/udp	0.000518
unknown	45719/udp	0.001036
unknown	45722/udp	0.001554
unknown	45723/udp	0.000518
unknown	45725/udp	0.000518
unknown	45730/udp	0.000518
unknown	45742/udp	0.000518
unknown	45749/udp	0.000518
unknown	45751/udp	0.000518
unknown	45754/udp	0.000518
unknown	45758/udp	0.000518
unknown	45759/udp	0.000518
unknown	45765/udp	0.000518
unknown	45769/udp	0.001036
unknown	45773/udp	0.000518
unknown	45776/udp	0.000518
unknown	45777/tcp	0.000076
unknown	45781/udp	0.000518
unknown	45786/udp	0.000518
unknown	45788/udp	0.000518
unknown	45792/udp	0.000518
unknown	45801/udp	0.000518
unknown	45804/udp	0.000518
unknown	45810/udp	0.000518
unknown	45814/udp	0.000518
unknown	45815/udp	0.000518
unknown	45816/udp	0.000518
unknown	45818/udp	0.001554
unknown	45830/udp	0.000518
unknown	45832/udp	0.000518
unknown	45834/udp	0.000518
unknown	45837/udp	0.000518
unknown	45845/udp	0.000518
unknown	45849/udp	0.000518
unknown	45856/udp	0.000518
unknown	45859/udp	0.000518
unknown	45864/tcp	0.000076
unknown	45865/udp	0.000518
unknown	45871/udp	0.000518
unknown	45875/udp	0.000518
unknown	45877/udp	0.000518
unknown	45883/udp	0.001036
unknown	45889/udp	0.000518
unknown	45891/udp	0.001036
unknown	45895/udp	0.000518
unknown	45900/udp	0.000518
unknown	45906/udp	0.001036
unknown	45910/udp	0.000518
unknown	45913/udp	0.000518
unknown	45917/udp	0.000518
unknown	45920/udp	0.000518
unknown	45925/udp	0.000518
unknown	45928/udp	0.001554
unknown	45943/udp	0.000518
unknown	45947/udp	0.000518
unknown	45948/udp	0.000518
unknown	45954/udp	0.000518
unknown	45960/tcp	0.000076
unknown	45963/udp	0.000518
unknown	45971/udp	0.001036
unknown	45986/udp	0.000518
unknown	45991/udp	0.000518
unknown	46005/udp	0.000518
unknown	46015/udp	0.000518
unknown	46016/udp	0.000518
unknown	46020/udp	0.000518
unknown	46025/udp	0.000518
unknown	46032/udp	0.000518
unknown	46034/tcp	0.000076
unknown	46034/udp	0.000518
unknown	46040/udp	0.001036
unknown	46051/udp	0.000518
unknown	46055/udp	0.001036
unknown	46062/udp	0.000518
unknown	46065/udp	0.000518
unknown	46066/udp	0.001036
unknown	46069/tcp	0.000076
unknown	46069/udp	0.000518
unknown	46070/udp	0.000518
unknown	46071/udp	0.000518
unknown	46072/udp	0.000518
unknown	46081/udp	0.000518
unknown	46082/udp	0.000518
unknown	46087/udp	0.000518
unknown	46093/udp	0.001554
unknown	46108/udp	0.000518
unknown	46109/udp	0.000518
unknown	46110/udp	0.000518
unknown	46112/udp	0.000518
unknown	46114/udp	0.001036
unknown	46115/tcp	0.000076
unknown	46126/udp	0.000518
unknown	46128/udp	0.000518
unknown	46137/udp	0.000518
unknown	46140/udp	0.000518
unknown	46148/udp	0.000518
unknown	46156/udp	0.000518
unknown	46158/udp	0.000518
unknown	46171/tcp	0.000076
unknown	46174/udp	0.000518
unknown	46176/udp	0.000518
unknown	46182/tcp	0.000076
unknown	46187/udp	0.000518
unknown	46195/udp	0.001036
unknown	46200/tcp	0.000152
unknown	46200/udp	0.000518
unknown	46201/udp	0.001036
unknown	46207/udp	0.001036
unknown	46214/udp	0.000518
unknown	46217/udp	0.000518
unknown	46223/udp	0.000518
unknown	46228/udp	0.000518
unknown	46230/udp	0.000518
unknown	46231/udp	0.000518
unknown	46234/udp	0.000518
unknown	46235/udp	0.000518
unknown	46249/udp	0.001036
unknown	46257/udp	0.000518
unknown	46265/udp	0.001036
unknown	46267/udp	0.000518
unknown	46269/udp	0.000518
unknown	46270/udp	0.001036
unknown	46283/udp	0.000518
unknown	46284/udp	0.000518
unknown	46287/udp	0.000518
unknown	46294/udp	0.001036
unknown	46297/udp	0.000518
unknown	46306/udp	0.000518
unknown	46310/tcp	0.000076
unknown	46311/udp	0.000518
unknown	46319/udp	0.000518
unknown	46321/udp	0.000518
unknown	46334/udp	0.000518
unknown	46341/udp	0.000518
unknown	46342/udp	0.000518
unknown	46350/udp	0.000518
unknown	46352/udp	0.000518
unknown	46363/udp	0.000518
unknown	46369/udp	0.000518
unknown	46370/udp	0.000518
unknown	46372/tcp	0.000076
unknown	46373/udp	0.000518
unknown	46374/udp	0.000518
unknown	46383/udp	0.000518
unknown	46387/udp	0.001036
unknown	46391/udp	0.000518
unknown	46395/udp	0.000518
unknown	46414/udp	0.000518
unknown	46418/tcp	0.000076
unknown	46419/udp	0.000518
unknown	46420/udp	0.000518
unknown	46421/udp	0.000518
unknown	46432/udp	0.000518
unknown	46434/udp	0.000518
unknown	46436/tcp	0.000076
unknown	46440/udp	0.001036
unknown	46442/udp	0.000518
unknown	46453/udp	0.000518
unknown	46455/udp	0.000518
unknown	46457/udp	0.001036
unknown	46459/udp	0.000518
unknown	46462/udp	0.001036
unknown	46464/udp	0.001036
unknown	46472/udp	0.000518
unknown	46474/udp	0.000518
unknown	46478/udp	0.000518
unknown	46483/udp	0.001036
unknown	46486/udp	0.000518
unknown	46491/udp	0.000518
unknown	46502/udp	0.000518
unknown	46504/udp	0.000518
unknown	46514/udp	0.000518
unknown	46515/udp	0.000518
unknown	46517/udp	0.000518
unknown	46529/udp	0.000518
unknown	46532/udp	0.001554
unknown	46534/udp	0.000518
unknown	46535/udp	0.000518
unknown	46537/udp	0.000518
unknown	46542/udp	0.000518
unknown	46546/udp	0.000518
unknown	46548/udp	0.000518
unknown	46555/udp	0.000518
unknown	46556/udp	0.000518
unknown	46557/udp	0.000518
unknown	46559/udp	0.000518
unknown	46574/udp	0.000518
unknown	46576/udp	0.000518
unknown	46580/udp	0.000518
unknown	46581/udp	0.000518
unknown	46582/udp	0.000518
unknown	46584/udp	0.001036
unknown	46587/udp	0.000518
unknown	46593/tcp	0.000076
unknown	46594/udp	0.001036
unknown	46599/udp	0.000518
unknown	46602/udp	0.000518
unknown	46603/udp	0.001036
unknown	46606/udp	0.000518
unknown	46625/udp	0.000518
unknown	46630/udp	0.001036
unknown	46640/udp	0.000518
unknown	46641/udp	0.001036
unknown	46643/udp	0.001036
unknown	46644/udp	0.000518
unknown	46652/udp	0.001036
unknown	46653/udp	0.000518
unknown	46654/udp	0.000518
unknown	46656/udp	0.000518
unknown	46657/udp	0.000518
unknown	46658/udp	0.000518
unknown	46662/udp	0.000518
unknown	46666/udp	0.000518
unknown	46668/udp	0.000518
unknown	46688/udp	0.000518
unknown	46689/udp	0.000518
unknown	46692/udp	0.000518
unknown	46693/udp	0.000518
unknown	46694/udp	0.000518
unknown	46698/udp	0.001036
unknown	46699/udp	0.000518
unknown	46717/udp	0.000518
unknown	46741/udp	0.000518
unknown	46745/udp	0.000518
unknown	46746/udp	0.000518
unknown	46749/udp	0.000518
unknown	46757/udp	0.000518
unknown	46758/udp	0.001036
unknown	46764/udp	0.000518
unknown	46765/udp	0.000518
unknown	46779/udp	0.000518
unknown	46780/udp	0.000518
unknown	46785/udp	0.000518
unknown	46788/udp	0.000518
unknown	46793/udp	0.001036
unknown	46799/udp	0.000518
unknown	46803/udp	0.000518
unknown	46804/udp	0.000518
unknown	46805/udp	0.000518
unknown	46808/udp	0.001036
unknown	46813/tcp	0.000076
unknown	46813/udp	0.000518
unknown	46823/udp	0.000518
unknown	46825/udp	0.000518
unknown	46830/udp	0.000518
unknown	46831/udp	0.000518
unknown	46836/udp	0.001554
unknown	46837/udp	0.001036
unknown	46850/udp	0.000518
unknown	46851/udp	0.000518
unknown	46865/udp	0.000518
unknown	46869/udp	0.000518
unknown	46871/udp	0.000518
unknown	46872/udp	0.000518
unknown	46882/udp	0.000518
unknown	46887/udp	0.000518
unknown	46893/udp	0.000518
unknown	46894/udp	0.000518
unknown	46895/udp	0.000518
unknown	46899/udp	0.000518
unknown	46909/udp	0.000518
unknown	46911/udp	0.000518
unknown	46919/udp	0.000518
unknown	46930/udp	0.000518
unknown	46932/udp	0.000518
unknown	46934/udp	0.000518
unknown	46942/udp	0.000518
unknown	46944/udp	0.000518
unknown	46946/udp	0.000518
unknown	46949/udp	0.000518
unknown	46955/udp	0.000518
unknown	46959/udp	0.000518
unknown	46968/udp	0.000518
unknown	46972/udp	0.000518
unknown	46975/udp	0.000518
unknown	46981/udp	0.000518
unknown	46989/udp	0.000518
unknown	46990/udp	0.000518
unknown	46992/tcp	0.000076
unknown	46996/tcp	0.000152
mediabox	46999/udp	0.000518	# MediaBox Server
unknown	47005/udp	0.000518
unknown	47009/udp	0.000518
unknown	47012/tcp	0.000076
unknown	47012/udp	0.000518
unknown	47014/udp	0.000518
unknown	47021/udp	0.000518
unknown	47026/udp	0.000518
unknown	47029/tcp	0.000076
unknown	47030/udp	0.001036
unknown	47037/udp	0.000518
unknown	47042/udp	0.000518
unknown	47043/udp	0.000518
unknown	47045/udp	0.000518
unknown	47057/udp	0.000518
unknown	47058/udp	0.000518
unknown	47060/udp	0.000518
unknown	47065/udp	0.000518
unknown	47069/udp	0.000518
unknown	47073/udp	0.000518
unknown	47074/udp	0.000518
unknown	47079/udp	0.000518
unknown	47080/udp	0.000518
unknown	47083/udp	0.001036
unknown	47086/udp	0.000518
unknown	47087/udp	0.000518
unknown	47090/udp	0.000518
unknown	47091/udp	0.000518
unknown	47100/udp	0.000518
unknown	47102/udp	0.000518
unknown	47103/udp	0.000518
unknown	47119/tcp	0.000076
unknown	47120/udp	0.000518
unknown	47128/udp	0.000518
unknown	47130/udp	0.000518
unknown	47131/udp	0.000518
unknown	47132/udp	0.001036
unknown	47134/udp	0.001036
unknown	47139/udp	0.000518
unknown	47142/udp	0.000518
unknown	47143/udp	0.000518
unknown	47144/udp	0.000518
unknown	47154/udp	0.000518
unknown	47155/udp	0.000518
unknown	47157/udp	0.000518
unknown	47159/udp	0.000518
unknown	47160/udp	0.001036
unknown	47161/udp	0.000518
unknown	47162/udp	0.000518
unknown	47169/udp	0.001036
unknown	47176/udp	0.000518
unknown	47183/udp	0.000518
unknown	47184/udp	0.000518
unknown	47185/udp	0.001036
unknown	47190/udp	0.000518
unknown	47197/tcp	0.000076
unknown	47197/udp	0.000518
unknown	47198/udp	0.001036
unknown	47213/udp	0.000518
unknown	47217/udp	0.000518
unknown	47220/udp	0.000518
unknown	47224/udp	0.000518
unknown	47229/udp	0.000518
unknown	47231/udp	0.000518
unknown	47234/udp	0.000518
unknown	47242/udp	0.000518
unknown	47247/udp	0.000518
unknown	47259/udp	0.000518
unknown	47260/udp	0.000518
unknown	47262/udp	0.000518
unknown	47265/udp	0.000518
unknown	47267/tcp	0.000076
unknown	47267/udp	0.000518
unknown	47270/udp	0.001036
unknown	47279/udp	0.001036
unknown	47281/udp	0.000518
unknown	47289/udp	0.000518
unknown	47290/udp	0.000518
unknown	47291/udp	0.000518
unknown	47298/udp	0.000518
unknown	47300/udp	0.000518
unknown	47306/udp	0.000518
unknown	47307/udp	0.000518
unknown	47310/udp	0.000518
unknown	47315/udp	0.000518
unknown	47335/udp	0.000518
unknown	47336/udp	0.000518
unknown	47337/udp	0.001036
unknown	47346/udp	0.000518
unknown	47348/tcp	0.000076
unknown	47352/udp	0.000518
unknown	47357/udp	0.000518
unknown	47359/udp	0.000518
unknown	47364/udp	0.000518
unknown	47370/udp	0.000518
unknown	47371/udp	0.001036
unknown	47372/tcp	0.000076
unknown	47386/udp	0.000518
unknown	47391/udp	0.000518
unknown	47400/udp	0.000518
unknown	47405/udp	0.000518
unknown	47406/udp	0.001036
unknown	47409/udp	0.000518
unknown	47413/udp	0.000518
unknown	47415/udp	0.000518
unknown	47421/udp	0.000518
unknown	47432/udp	0.001036
unknown	47437/udp	0.000518
unknown	47442/udp	0.000518
unknown	47445/udp	0.000518
unknown	47446/udp	0.000518
unknown	47448/tcp	0.000076
unknown	47456/udp	0.000518
unknown	47457/udp	0.001036
unknown	47470/udp	0.000518
unknown	47474/udp	0.000518
unknown	47475/udp	0.000518
unknown	47477/udp	0.000518
unknown	47481/udp	0.000518
unknown	47490/udp	0.000518
unknown	47494/udp	0.000518
unknown	47496/udp	0.000518
unknown	47513/udp	0.000518
unknown	47526/udp	0.000518
unknown	47531/udp	0.000518
unknown	47535/udp	0.000518
unknown	47544/tcp	0.000152
unknown	47544/udp	0.000518
unknown	47552/udp	0.000518
unknown	47554/udp	0.000518
unknown	47555/udp	0.000518
dbbrowse	47557/tcp	0.000038	# Databeam Corporation
dbbrowse	47557/udp	0.001158	# Databeam Corporation
unknown	47560/udp	0.000518
unknown	47567/tcp	0.000076
unknown	47572/udp	0.001036
unknown	47575/udp	0.000518
unknown	47577/udp	0.001036
unknown	47581/tcp	0.000076
unknown	47582/udp	0.000518
unknown	47584/udp	0.000518
unknown	47586/udp	0.001036
unknown	47594/udp	0.000518
unknown	47595/tcp	0.000076
unknown	47595/udp	0.000518
unknown	47598/udp	0.000518
unknown	47600/udp	0.000518
unknown	47609/udp	0.000518
unknown	47610/udp	0.000518
unknown	47616/udp	0.000518
unknown	47618/udp	0.000518
directplaysrvr	47624/tcp	0.000076	# Direct Play Server
directplaysrvr	47624/udp	0.002071	# Direct Play Server
unknown	47626/udp	0.000518
unknown	47628/udp	0.000518
unknown	47631/udp	0.000518
unknown	47632/udp	0.000518
unknown	47634/tcp	0.000076
unknown	47634/udp	0.000518
unknown	47636/udp	0.000518
unknown	47637/udp	0.000518
unknown	47640/udp	0.000518
unknown	47648/udp	0.000518
unknown	47652/udp	0.000518
unknown	47653/udp	0.000518
unknown	47656/udp	0.001036
unknown	47658/udp	0.000518
unknown	47663/udp	0.000518
unknown	47667/udp	0.000518
unknown	47669/udp	0.000518
unknown	47671/udp	0.000518
unknown	47672/udp	0.000518
unknown	47674/udp	0.000518
unknown	47678/udp	0.000518
unknown	47695/udp	0.000518
unknown	47697/udp	0.000518
unknown	47700/tcp	0.000076
unknown	47701/udp	0.000518
unknown	47702/udp	0.000518
unknown	47706/udp	0.001036
unknown	47708/udp	0.000518
unknown	47717/udp	0.000518
unknown	47718/udp	0.000518
unknown	47751/udp	0.001036
unknown	47756/udp	0.000518
unknown	47762/udp	0.000518
unknown	47765/udp	0.001554
unknown	47768/udp	0.000518
unknown	47771/udp	0.000518
unknown	47772/udp	0.001554
unknown	47775/udp	0.000518
unknown	47777/tcp	0.000076
unknown	47780/udp	0.000518
unknown	47783/udp	0.000518
unknown	47785/udp	0.000518
unknown	47788/udp	0.000518
unknown	47790/udp	0.000518
unknown	47792/udp	0.000518
unknown	47798/udp	0.000518
unknown	47802/udp	0.001036
unknown	47805/udp	0.000518
ap	47806/tcp	0.000076	# ALC Protocol
ap	47806/udp	0.000518	# ALC Protocol
bacnet	47808/udp	0.001554	# Building Automation and Control Networks
unknown	47817/udp	0.001036
unknown	47821/udp	0.001036
unknown	47839/udp	0.000518
unknown	47841/udp	0.000518
unknown	47842/udp	0.001036
unknown	47845/udp	0.000518
unknown	47847/udp	0.001036
unknown	47850/tcp	0.000076
unknown	47851/udp	0.001036
unknown	47852/udp	0.000518
unknown	47858/tcp	0.000076
unknown	47858/udp	0.000518
unknown	47860/tcp	0.000076
unknown	47869/udp	0.000518
unknown	47875/udp	0.000518
unknown	47876/udp	0.000518
unknown	47877/udp	0.000518
unknown	47882/udp	0.000518
unknown	47884/udp	0.000518
unknown	47885/udp	0.000518
unknown	47889/udp	0.000518
unknown	47892/udp	0.000518
unknown	47896/udp	0.000518
unknown	47902/udp	0.000518
unknown	47908/udp	0.000518
unknown	47915/udp	0.001554
unknown	47917/udp	0.001036
unknown	47926/udp	0.001036
unknown	47931/udp	0.000518
unknown	47936/udp	0.001036
unknown	47946/udp	0.000518
unknown	47952/udp	0.000518
unknown	47955/udp	0.000518
unknown	47966/tcp	0.000076
unknown	47968/udp	0.000518
unknown	47969/tcp	0.000076
unknown	47971/udp	0.001036
unknown	47973/udp	0.000518
unknown	47981/udp	0.001554
unknown	47985/udp	0.000518
unknown	47989/udp	0.000518
unknown	47993/udp	0.000518
nimhub	48002/udp	0.000518	# Nimbus Hub
unknown	48004/udp	0.000518
unknown	48005/udp	0.000518
unknown	48009/tcp	0.000076
unknown	48024/udp	0.000518
unknown	48029/udp	0.000518
unknown	48031/udp	0.000518
unknown	48036/udp	0.000518
unknown	48041/udp	0.000518
unknown	48045/udp	0.000518
unknown	48049/udp	0.000518
unknown	48051/udp	0.000518
unknown	48053/udp	0.000518
unknown	48057/udp	0.000518
unknown	48067/tcp	0.000076
unknown	48068/udp	0.000518
unknown	48078/udp	0.001554
unknown	48080/tcp	0.000380
unknown	48080/udp	0.000518
unknown	48083/tcp	0.000076
unknown	48086/udp	0.000518
unknown	48091/udp	0.000518
unknown	48097/udp	0.000518
unknown	48103/udp	0.000518
unknown	48105/udp	0.001036
unknown	48113/udp	0.000518
unknown	48116/udp	0.000518
unknown	48117/udp	0.000518
unknown	48126/udp	0.001036
unknown	48127/tcp	0.000076
isnetserv	48128/udp	0.000518	# Image Systems Network Services
unknown	48130/udp	0.000518
unknown	48132/udp	0.000518
unknown	48133/udp	0.000518
unknown	48137/udp	0.000518
unknown	48152/udp	0.000518
unknown	48153/tcp	0.000076
unknown	48153/udp	0.000518
unknown	48155/udp	0.000518
unknown	48156/udp	0.001036
unknown	48161/udp	0.000518
unknown	48167/tcp	0.000076
unknown	48174/udp	0.000518
unknown	48175/udp	0.000518
unknown	48184/udp	0.000518
unknown	48185/udp	0.000518
unknown	48189/udp	0.001554
unknown	48194/udp	0.000518
unknown	48195/udp	0.000518
unknown	48205/udp	0.000518
unknown	48215/udp	0.000518
unknown	48221/udp	0.000518
unknown	48222/udp	0.001036
unknown	48226/udp	0.000518
unknown	48229/udp	0.000518
unknown	48232/udp	0.000518
unknown	48234/udp	0.000518
unknown	48244/udp	0.000518
unknown	48250/udp	0.000518
unknown	48251/udp	0.000518
unknown	48255/udp	0.001554
unknown	48256/udp	0.000518
unknown	48263/udp	0.001036
unknown	48270/udp	0.000518
unknown	48280/udp	0.000518
unknown	48282/udp	0.001036
unknown	48288/udp	0.000518
unknown	48291/udp	0.000518
unknown	48309/udp	0.000518
unknown	48314/udp	0.001036
unknown	48315/udp	0.001036
unknown	48319/udp	0.000518
unknown	48321/udp	0.001036
unknown	48324/udp	0.001036
unknown	48326/udp	0.000518
unknown	48329/udp	0.001036
unknown	48337/udp	0.000518
unknown	48342/udp	0.001036
unknown	48348/udp	0.000518
unknown	48356/tcp	0.000076
unknown	48357/udp	0.000518
unknown	48365/udp	0.000518
unknown	48366/udp	0.000518
unknown	48369/udp	0.000518
unknown	48370/udp	0.000518
unknown	48372/udp	0.000518
unknown	48374/udp	0.000518
unknown	48376/udp	0.000518
unknown	48378/udp	0.000518
unknown	48386/udp	0.000518
unknown	48387/udp	0.000518
unknown	48390/udp	0.000518
unknown	48395/udp	0.000518
unknown	48406/udp	0.000518
unknown	48409/udp	0.000518
unknown	48411/udp	0.001036
unknown	48424/udp	0.000518
unknown	48427/udp	0.000518
unknown	48434/tcp	0.000076
unknown	48454/udp	0.000518
unknown	48455/udp	0.001554
unknown	48459/udp	0.000518
unknown	48464/udp	0.000518
unknown	48474/udp	0.000518
unknown	48476/udp	0.000518
unknown	48478/udp	0.000518
unknown	48481/udp	0.000518
unknown	48487/udp	0.000518
unknown	48489/udp	0.001554
unknown	48490/udp	0.000518
unknown	48491/udp	0.000518
unknown	48494/udp	0.000518
unknown	48496/udp	0.001036
unknown	48497/udp	0.000518
unknown	48501/udp	0.000518
unknown	48512/udp	0.000518
unknown	48514/udp	0.000518
unknown	48523/udp	0.000518
unknown	48540/udp	0.000518
unknown	48546/udp	0.000518
unknown	48548/udp	0.001036
unknown	48551/udp	0.000518
unknown	48554/udp	0.000518
unknown	48555/udp	0.001036
com-bardac-dw	48556/udp	0.001036
unknown	48558/udp	0.001036
unknown	48564/udp	0.000518
unknown	48566/udp	0.000518
unknown	48571/udp	0.000518
unknown	48572/udp	0.000518
unknown	48573/udp	0.000518
unknown	48574/udp	0.000518
unknown	48577/udp	0.000518
unknown	48588/udp	0.000518
unknown	48598/udp	0.000518
unknown	48601/udp	0.000518
unknown	48602/udp	0.000518
unknown	48605/udp	0.001036
unknown	48606/udp	0.000518
unknown	48611/udp	0.000518
unknown	48613/udp	0.000518
iqobject	48619/tcp	0.000076
unknown	48620/udp	0.000518
unknown	48626/udp	0.001036
unknown	48629/udp	0.000518
unknown	48631/tcp	0.000076
unknown	48631/udp	0.001036
unknown	48648/tcp	0.000076
unknown	48648/udp	0.000518
unknown	48663/udp	0.000518
unknown	48672/udp	0.000518
unknown	48674/udp	0.000518
unknown	48682/tcp	0.000076
unknown	48686/udp	0.000518
unknown	48698/udp	0.000518
unknown	48701/udp	0.000518
unknown	48705/udp	0.000518
unknown	48706/udp	0.000518
unknown	48707/udp	0.000518
unknown	48712/udp	0.001036
unknown	48717/udp	0.000518
unknown	48721/udp	0.000518
unknown	48725/udp	0.000518
unknown	48726/udp	0.000518
unknown	48729/udp	0.000518
unknown	48733/udp	0.001036
unknown	48740/udp	0.000518
unknown	48741/udp	0.000518
unknown	48753/udp	0.000518
unknown	48755/udp	0.000518
unknown	48757/udp	0.000518
unknown	48758/udp	0.000518
unknown	48761/udp	0.001554
unknown	48762/udp	0.000518
unknown	48764/udp	0.000518
unknown	48780/udp	0.001036
unknown	48783/tcp	0.000076
unknown	48786/udp	0.000518
unknown	48790/udp	0.001036
unknown	48793/udp	0.000518
unknown	48794/udp	0.000518
unknown	48800/udp	0.000518
unknown	48803/udp	0.000518
unknown	48813/tcp	0.000076
unknown	48824/udp	0.000518
unknown	48825/udp	0.000518
unknown	48829/udp	0.000518
unknown	48830/udp	0.000518
unknown	48847/udp	0.000518
unknown	48853/udp	0.000518
unknown	48854/udp	0.001036
unknown	48860/udp	0.001036
unknown	48862/udp	0.000518
unknown	48864/udp	0.000518
unknown	48869/udp	0.000518
unknown	48883/udp	0.000518
unknown	48887/udp	0.001036
unknown	48890/udp	0.000518
unknown	48898/udp	0.001036
unknown	48899/udp	0.000518
unknown	48901/udp	0.001036
unknown	48903/udp	0.000518
unknown	48906/udp	0.001036
unknown	48913/udp	0.000518
unknown	48918/udp	0.000518
unknown	48921/udp	0.000518
unknown	48923/udp	0.000518
unknown	48925/tcp	0.000076
unknown	48925/udp	0.000518
unknown	48933/udp	0.000518
unknown	48935/udp	0.000518
unknown	48954/udp	0.001036
unknown	48956/udp	0.000518
unknown	48966/tcp	0.000076
unknown	48967/tcp	0.000076
unknown	48972/udp	0.000518
unknown	48973/tcp	0.000076
unknown	48980/udp	0.000518
unknown	48986/udp	0.000518
unknown	48991/udp	0.000518
unknown	48998/udp	0.000518
unknown	49001/udp	0.000518
unknown	49002/tcp	0.000076
unknown	49005/udp	0.000518
unknown	49011/udp	0.000518
unknown	49015/udp	0.000518
unknown	49017/udp	0.000518
unknown	49020/udp	0.000518
unknown	49022/udp	0.000518
unknown	49028/udp	0.000518
unknown	49032/udp	0.000518
unknown	49034/udp	0.000518
unknown	49036/udp	0.000518
unknown	49040/udp	0.000518
unknown	49042/udp	0.001036
unknown	49048/tcp	0.000076
unknown	49048/udp	0.000518
unknown	49052/udp	0.001036
unknown	49057/udp	0.000518
unknown	49062/udp	0.000518
unknown	49066/udp	0.000518
unknown	49076/udp	0.000518
unknown	49080/udp	0.000518
unknown	49082/udp	0.000518
unknown	49085/udp	0.000518
unknown	49087/udp	0.000518
unknown	49100/udp	0.000518
unknown	49104/udp	0.000518
unknown	49108/udp	0.000518
unknown	49114/udp	0.001036
unknown	49122/udp	0.000518
unknown	49123/udp	0.000518
unknown	49127/udp	0.001036
unknown	49128/udp	0.000518
unknown	49131/udp	0.000518
unknown	49132/tcp	0.000076
unknown	49133/udp	0.000518
unknown	49134/udp	0.000518
unknown	49136/udp	0.001036
unknown	49138/udp	0.000518
unknown	49142/udp	0.000518
unknown	49146/udp	0.000518
unknown	49152/tcp	0.007907
unknown	49152/udp	0.116002
unknown	49153/tcp	0.006158
unknown	49153/udp	0.060743
unknown	49154/tcp	0.006767
unknown	49154/udp	0.092369
unknown	49155/tcp	0.005702
unknown	49155/udp	0.001506
unknown	49156/tcp	0.005322
unknown	49156/udp	0.007530
unknown	49157/tcp	0.003573
unknown	49157/udp	0.002008
unknown	49158/tcp	0.000380
unknown	49158/udp	0.006526
unknown	49159/tcp	0.000380
unknown	49159/udp	0.004016
unknown	49160/tcp	0.000380
unknown	49160/udp	0.003012
unknown	49161/tcp	0.000228
unknown	49161/udp	0.002008
unknown	49162/udp	0.006024
unknown	49163/tcp	0.000304
unknown	49163/udp	0.003514
unknown	49164/tcp	0.000152
unknown	49164/udp	0.001004
unknown	49165/tcp	0.000304
unknown	49165/udp	0.003514
unknown	49166/tcp	0.000076
unknown	49166/udp	0.004016
unknown	49167/tcp	0.000228
unknown	49167/udp	0.002510
unknown	49168/tcp	0.000152
unknown	49168/udp	0.003514
unknown	49169/tcp	0.000076
unknown	49169/udp	0.003012
unknown	49170/tcp	0.000076
unknown	49170/udp	0.002008
unknown	49171/tcp	0.000152
unknown	49171/udp	0.004518
unknown	49172/tcp	0.000076
unknown	49172/udp	0.003514
unknown	49173/tcp	0.000076
unknown	49173/udp	0.002008
unknown	49174/udp	0.003012
unknown	49175/tcp	0.000304
unknown	49175/udp	0.002510
unknown	49176/tcp	0.000228
unknown	49176/udp	0.002008
unknown	49177/udp	0.001506
unknown	49178/udp	0.001506
unknown	49179/tcp	0.000076
unknown	49179/udp	0.004518
unknown	49180/udp	0.005020
unknown	49181/udp	0.010542
unknown	49182/udp	0.007530
unknown	49183/udp	0.001004
unknown	49184/udp	0.004518
unknown	49185/udp	0.007028
unknown	49186/tcp	0.000152
unknown	49186/udp	0.012550
unknown	49187/udp	0.006024
unknown	49188/udp	0.007028
unknown	49189/tcp	0.000076
unknown	49189/udp	0.006024
unknown	49190/tcp	0.000076
unknown	49190/udp	0.007028
unknown	49191/tcp	0.000076
unknown	49191/udp	0.007530
unknown	49192/udp	0.011044
unknown	49193/udp	0.015562
unknown	49194/udp	0.007530
unknown	49195/tcp	0.000152
unknown	49195/udp	0.006024
unknown	49196/tcp	0.000076
unknown	49196/udp	0.006526
unknown	49197/tcp	0.000076
unknown	49197/udp	0.002008
unknown	49198/udp	0.002510
unknown	49199/udp	0.005020
unknown	49200/udp	0.010040
unknown	49201/tcp	0.000076
unknown	49201/udp	0.011044
unknown	49202/tcp	0.000076
unknown	49202/udp	0.004518
unknown	49203/tcp	0.000076
unknown	49203/udp	0.001004
unknown	49204/tcp	0.000076
unknown	49204/udp	0.002510
unknown	49205/udp	0.004518
unknown	49206/udp	0.001004
unknown	49207/udp	0.002008
unknown	49208/udp	0.004518
unknown	49209/udp	0.004518
unknown	49210/udp	0.004518
unknown	49211/tcp	0.000076
unknown	49211/udp	0.007028
unknown	49212/udp	0.002510
unknown	49213/tcp	0.000076
unknown	49213/udp	0.002510
unknown	49214/udp	0.001506
unknown	49215/udp	0.002510
unknown	49216/tcp	0.000076
unknown	49216/udp	0.001506
unknown	49217/udp	0.001004
unknown	49218/udp	0.001004
unknown	49219/udp	0.001004
unknown	49220/udp	0.001506
unknown	49221/udp	0.000502
unknown	49222/udp	0.001506
unknown	49223/udp	0.001004
unknown	49225/udp	0.000502
unknown	49226/udp	0.001506
unknown	49227/udp	0.001004
unknown	49228/tcp	0.000076
unknown	49228/udp	0.000502
unknown	49230/udp	0.000502
unknown	49231/udp	0.001004
unknown	49232/tcp	0.000076
unknown	49233/udp	0.000502
unknown	49235/tcp	0.000076
unknown	49235/udp	0.000502
unknown	49236/tcp	0.000152
unknown	49236/udp	0.001004
unknown	49237/udp	0.001004
unknown	49238/udp	0.000502
unknown	49241/tcp	0.000076
unknown	49241/udp	0.000502
unknown	49244/udp	0.000502
unknown	49245/udp	0.000502
unknown	49248/udp	0.000502
unknown	49249/udp	0.001004
unknown	49250/udp	0.000502
unknown	49251/udp	0.000502
unknown	49252/udp	0.001004
unknown	49255/udp	0.001004
unknown	49258/udp	0.000502
unknown	49259/udp	0.001506
unknown	49260/udp	0.000502
unknown	49261/udp	0.000502
unknown	49262/udp	0.001506
unknown	49263/udp	0.000502
unknown	49264/udp	0.001004
unknown	49265/udp	0.000502
unknown	49266/udp	0.001004
unknown	49268/udp	0.001004
unknown	49269/udp	0.000502
unknown	49270/udp	0.000502
unknown	49273/udp	0.001004
unknown	49275/tcp	0.000076
unknown	49277/udp	0.000502
unknown	49279/udp	0.000502
unknown	49288/udp	0.000502
unknown	49290/udp	0.000502
unknown	49295/udp	0.001004
unknown	49297/udp	0.000502
unknown	49299/udp	0.000502
unknown	49302/tcp	0.000076
unknown	49305/udp	0.000502
unknown	49306/udp	0.001506
unknown	49309/udp	0.000502
unknown	49312/udp	0.000502
unknown	49313/udp	0.000502
unknown	49315/udp	0.000502
unknown	49317/udp	0.001004
unknown	49319/udp	0.001004
unknown	49321/udp	0.000502
unknown	49322/udp	0.000502
unknown	49324/udp	0.001004
unknown	49328/udp	0.000502
unknown	49329/udp	0.000502
unknown	49331/udp	0.000502
unknown	49332/udp	0.000502
unknown	49333/udp	0.000502
unknown	49334/udp	0.001004
unknown	49335/udp	0.000502
unknown	49337/udp	0.001004
unknown	49338/udp	0.000502
unknown	49339/udp	0.000502
unknown	49342/udp	0.000502
unknown	49343/udp	0.000502
unknown	49345/udp	0.000502
unknown	49346/udp	0.000502
unknown	49347/udp	0.000502
unknown	49348/udp	0.001004
unknown	49350/udp	0.001506
unknown	49351/udp	0.000502
unknown	49352/tcp	0.000076
unknown	49358/udp	0.000502
unknown	49360/udp	0.001506
unknown	49361/udp	0.000502
unknown	49362/udp	0.000502
unknown	49367/udp	0.000502
unknown	49372/tcp	0.000076
unknown	49374/udp	0.000502
unknown	49375/udp	0.001004
unknown	49379/udp	0.000502
unknown	49384/udp	0.001004
unknown	49389/udp	0.000502
unknown	49393/udp	0.001506
unknown	49395/udp	0.000502
unknown	49396/udp	0.001506
unknown	49398/tcp	0.000076
unknown	49398/udp	0.000502
compaqdiag	49400/tcp	0.000276	# Compaq Web-based management
unknown	49401/tcp	0.000152
unknown	49401/udp	0.000502
unknown	49408/udp	0.000502
unknown	49411/udp	0.000502
unknown	49412/udp	0.000502
unknown	49413/udp	0.000502
unknown	49421/udp	0.000502
unknown	49424/udp	0.000502
unknown	49430/udp	0.000502
unknown	49436/udp	0.000502
unknown	49440/udp	0.001004
unknown	49441/udp	0.000502
unknown	49442/udp	0.000502
unknown	49443/udp	0.001004
unknown	49448/udp	0.000502
unknown	49450/udp	0.000502
unknown	49451/udp	0.000502
unknown	49452/tcp	0.000076
unknown	49452/udp	0.000502
unknown	49453/udp	0.000502
unknown	49454/udp	0.000502
unknown	49459/udp	0.000502
unknown	49460/udp	0.000502
unknown	49464/udp	0.000502
unknown	49465/udp	0.000502
unknown	49467/udp	0.000502
unknown	49468/udp	0.000502
unknown	49470/udp	0.000502
unknown	49473/udp	0.000502
unknown	49474/udp	0.000502
unknown	49478/udp	0.001004
unknown	49479/udp	0.000502
unknown	49480/udp	0.000502
unknown	49481/udp	0.000502
unknown	49484/udp	0.000502
unknown	49488/udp	0.000502
unknown	49489/udp	0.000502
unknown	49490/udp	0.000502
unknown	49494/udp	0.000502
unknown	49498/tcp	0.000076
unknown	49498/udp	0.000502
unknown	49499/udp	0.000502
unknown	49500/tcp	0.000076
unknown	49502/udp	0.000502
unknown	49503/udp	0.002008
unknown	49505/udp	0.000502
unknown	49506/udp	0.001004
unknown	49509/udp	0.000502
unknown	49511/udp	0.000502
unknown	49513/udp	0.001004
unknown	49514/udp	0.000502
unknown	49517/udp	0.000502
unknown	49519/tcp	0.000076
unknown	49519/udp	0.000502
unknown	49520/tcp	0.000076
unknown	49520/udp	0.000502
unknown	49521/tcp	0.000076
unknown	49522/tcp	0.000076
unknown	49525/udp	0.001004
unknown	49530/udp	0.000502
unknown	49535/udp	0.000502
unknown	49544/udp	0.000502
unknown	49546/udp	0.000502
unknown	49550/udp	0.000502
unknown	49557/udp	0.001004
unknown	49560/udp	0.000502
unknown	49562/udp	0.001004
unknown	49567/udp	0.000502
unknown	49569/udp	0.000502
unknown	49579/udp	0.001004
unknown	49582/udp	0.000502
unknown	49586/udp	0.000502
unknown	49589/udp	0.001004
unknown	49590/udp	0.000502
unknown	49596/udp	0.000502
unknown	49597/tcp	0.000076
unknown	49597/udp	0.000502
unknown	49600/udp	0.001004
unknown	49603/tcp	0.000076
unknown	49603/udp	0.000502
unknown	49605/udp	0.000502
unknown	49608/udp	0.000502
unknown	49615/udp	0.000502
unknown	49618/udp	0.000502
unknown	49619/udp	0.000502
unknown	49620/udp	0.001004
unknown	49622/udp	0.000502
unknown	49631/udp	0.000502
unknown	49633/udp	0.000502
unknown	49635/udp	0.000502
unknown	49639/udp	0.001004
unknown	49640/udp	0.001506
unknown	49642/udp	0.000502
unknown	49644/udp	0.000502
unknown	49651/udp	0.000502
unknown	49653/udp	0.000502
unknown	49654/udp	0.000502
unknown	49656/udp	0.000502
unknown	49668/udp	0.000502
unknown	49669/udp	0.001004
unknown	49678/tcp	0.000076
unknown	49685/udp	0.000502
unknown	49692/udp	0.000502
unknown	49698/udp	0.000502
unknown	49705/udp	0.000502
unknown	49708/udp	0.000502
unknown	49709/udp	0.000502
unknown	49717/udp	0.000502
unknown	49718/udp	0.000502
unknown	49720/udp	0.000502
unknown	49721/udp	0.000502
unknown	49735/udp	0.000502
unknown	49737/udp	0.000502
unknown	49741/udp	0.000502
unknown	49746/udp	0.001004
unknown	49748/udp	0.000502
unknown	49750/udp	0.000502
unknown	49751/tcp	0.000076
unknown	49754/udp	0.001004
unknown	49757/udp	0.000502
unknown	49760/udp	0.000502
unknown	49761/udp	0.000502
unknown	49762/tcp	0.000076
unknown	49764/udp	0.000502
unknown	49765/tcp	0.000076
unknown	49772/udp	0.000502
unknown	49773/udp	0.000502
unknown	49775/udp	0.000502
unknown	49776/udp	0.000502
unknown	49780/udp	0.000502
unknown	49781/udp	0.000502
unknown	49783/udp	0.000502
unknown	49785/udp	0.000502
unknown	49793/udp	0.000502
unknown	49801/udp	0.001004
unknown	49802/udp	0.000502
unknown	49803/tcp	0.000076
unknown	49809/udp	0.000502
unknown	49818/udp	0.000502
unknown	49824/udp	0.000502
unknown	49825/udp	0.000502
unknown	49837/udp	0.000502
unknown	49839/udp	0.001004
unknown	49847/udp	0.000502
unknown	49848/udp	0.000502
unknown	49852/udp	0.000502
unknown	49855/udp	0.000502
unknown	49865/udp	0.000502
unknown	49871/udp	0.000502
unknown	49873/udp	0.000502
unknown	49874/udp	0.000502
unknown	49875/udp	0.000502
unknown	49887/udp	0.000502
unknown	49890/udp	0.000502
unknown	49893/udp	0.000502
unknown	49894/udp	0.000502
unknown	49895/udp	0.000502
unknown	49906/udp	0.000502
unknown	49907/udp	0.000502
unknown	49912/udp	0.000502
unknown	49919/udp	0.000502
unknown	49926/udp	0.001004
unknown	49927/tcp	0.000076
unknown	49930/udp	0.000502
unknown	49935/udp	0.000502
unknown	49939/udp	0.001004
unknown	49942/udp	0.000502
unknown	49945/udp	0.001004
unknown	49955/udp	0.000502
unknown	49957/udp	0.000502
unknown	49960/udp	0.000502
unknown	49962/udp	0.000502
unknown	49964/udp	0.000502
unknown	49965/udp	0.000502
unknown	49968/udp	0.001506
unknown	49969/udp	0.000502
unknown	49978/udp	0.000502
unknown	49984/udp	0.001004
unknown	49986/udp	0.001004
unknown	49990/udp	0.001004
unknown	49996/udp	0.000502
unknown	49998/udp	0.001004
unknown	49999/tcp	0.000684
ibm-db2	50000/tcp	0.001317	# (also Internet/Intranet Input Method Server Framework?)
unknown	50001/tcp	0.000836
iiimsf	50002/tcp	0.000351	# Internet/Intranet Input Method Server Framework
unknown	50003/tcp	0.000380
unknown	50006/tcp	0.000380
unknown	50009/udp	0.001004
unknown	50015/udp	0.000502
unknown	50016/tcp	0.000076
unknown	50019/tcp	0.000076
unknown	50020/udp	0.000502
unknown	50024/udp	0.001004
unknown	50029/udp	0.000502
unknown	50033/udp	0.000502
unknown	50040/tcp	0.000076
unknown	50041/udp	0.001004
unknown	50044/udp	0.000502
unknown	50049/udp	0.001004
unknown	50050/tcp	0.000152
unknown	50058/udp	0.000502
unknown	50060/udp	0.000502
unknown	50065/udp	0.000502
unknown	50067/udp	0.000502
unknown	50075/udp	0.000502
unknown	50085/udp	0.001004
unknown	50093/udp	0.000502
unknown	50096/udp	0.000502
unknown	50099/udp	0.001506
unknown	50100/udp	0.000502
unknown	50101/tcp	0.000076
unknown	50103/udp	0.000502
unknown	50105/udp	0.000502
unknown	50106/udp	0.000502
unknown	50114/udp	0.000502
unknown	50119/udp	0.000502
unknown	50121/udp	0.000502
unknown	50122/udp	0.001004
unknown	50127/udp	0.001004
unknown	50131/udp	0.000502
unknown	50133/udp	0.000502
unknown	50134/udp	0.000502
unknown	50136/udp	0.000502
unknown	50143/udp	0.001004
unknown	50146/udp	0.000502
unknown	50149/udp	0.001004
unknown	50154/udp	0.000502
unknown	50155/udp	0.000502
unknown	50157/udp	0.000502
unknown	50162/udp	0.000502
unknown	50163/udp	0.001004
unknown	50164/udp	0.001506
unknown	50173/udp	0.000502
unknown	50175/udp	0.000502
unknown	50177/udp	0.000502
unknown	50183/udp	0.000502
unknown	50187/udp	0.000502
unknown	50189/tcp	0.000076
unknown	50189/udp	0.000502
unknown	50190/udp	0.000502
unknown	50191/udp	0.000502
unknown	50192/udp	0.000502
unknown	50197/udp	0.000502
unknown	50198/tcp	0.000076
unknown	50202/tcp	0.000076
unknown	50205/tcp	0.000076
unknown	50209/udp	0.000502
unknown	50212/udp	0.000502
unknown	50213/udp	0.000502
unknown	50218/udp	0.000502
unknown	50222/udp	0.000502
unknown	50224/tcp	0.000076
unknown	50234/udp	0.000502
unknown	50239/udp	0.001004
unknown	50246/tcp	0.000076
unknown	50246/udp	0.000502
unknown	50249/udp	0.000502
unknown	50251/udp	0.000502
unknown	50255/udp	0.000502
unknown	50258/tcp	0.000076
unknown	50264/udp	0.000502
unknown	50266/udp	0.000502
unknown	50273/udp	0.001004
unknown	50276/udp	0.000502
unknown	50277/tcp	0.000076
unknown	50282/udp	0.000502
unknown	50287/udp	0.000502
unknown	50288/udp	0.000502
unknown	50289/udp	0.000502
unknown	50295/udp	0.000502
unknown	50296/udp	0.001004
unknown	50300/tcp	0.000228
unknown	50300/udp	0.001004
unknown	50304/udp	0.000502
unknown	50305/udp	0.000502
unknown	50308/udp	0.000502
unknown	50315/udp	0.000502
unknown	50326/udp	0.000502
unknown	50328/udp	0.000502
unknown	50329/udp	0.000502
unknown	50338/udp	0.000502
unknown	50345/udp	0.001004
unknown	50349/udp	0.001004
unknown	50351/udp	0.000502
unknown	50352/udp	0.000502
unknown	50356/tcp	0.000076
unknown	50361/udp	0.000502
unknown	50364/udp	0.000502
unknown	50374/udp	0.000502
unknown	50376/udp	0.001004
unknown	50378/udp	0.000502
unknown	50382/udp	0.000502
unknown	50385/udp	0.000502
unknown	50387/udp	0.000502
unknown	50388/udp	0.000502
unknown	50389/tcp	0.000304
unknown	50404/udp	0.000502
unknown	50409/udp	0.001004
unknown	50411/udp	0.000502
unknown	50413/udp	0.000502
unknown	50420/udp	0.001004
unknown	50427/udp	0.001004
unknown	50430/udp	0.000502
unknown	50434/udp	0.000502
unknown	50439/udp	0.000502
unknown	50443/udp	0.000502
unknown	50444/udp	0.000502
unknown	50446/udp	0.000502
unknown	50447/udp	0.001004
unknown	50448/udp	0.000502
unknown	50453/udp	0.000502
unknown	50461/udp	0.000502
unknown	50470/udp	0.000502
unknown	50474/udp	0.001004
unknown	50475/udp	0.000502
unknown	50476/udp	0.000502
unknown	50484/udp	0.000502
unknown	50492/udp	0.000502
unknown	50493/udp	0.000502
unknown	50494/udp	0.000502
unknown	50497/udp	0.001506
unknown	50500/tcp	0.000228
unknown	50503/udp	0.000502
unknown	50506/udp	0.000502
unknown	50507/udp	0.000502
unknown	50511/udp	0.000502
unknown	50513/tcp	0.000076
unknown	50515/udp	0.000502
unknown	50520/udp	0.000502
unknown	50523/udp	0.001004
unknown	50529/tcp	0.000076
unknown	50533/udp	0.000502
unknown	50536/udp	0.000502
unknown	50545/tcp	0.000076
unknown	50546/udp	0.000502
unknown	50551/udp	0.000502
unknown	50556/udp	0.000502
unknown	50559/udp	0.000502
unknown	50573/udp	0.001004
unknown	50574/udp	0.001004
unknown	50575/udp	0.000502
unknown	50576/tcp	0.000076
unknown	50576/udp	0.000502
unknown	50577/tcp	0.000076
unknown	50577/udp	0.000502
unknown	50579/udp	0.001004
unknown	50585/tcp	0.000076
unknown	50587/udp	0.000502
unknown	50595/udp	0.000502
unknown	50598/udp	0.000502
unknown	50604/udp	0.000502
unknown	50610/udp	0.000502
unknown	50612/udp	0.002008
unknown	50614/udp	0.000502
unknown	50615/udp	0.000502
unknown	50618/udp	0.000502
unknown	50620/udp	0.001004
unknown	50622/udp	0.001004
unknown	50624/udp	0.000502
unknown	50626/udp	0.000502
unknown	50627/udp	0.000502
unknown	50629/udp	0.000502
unknown	50635/udp	0.000502
unknown	50636/tcp	0.000304
unknown	50649/udp	0.001004
unknown	50653/udp	0.000502
unknown	50655/udp	0.000502
unknown	50672/udp	0.000502
unknown	50678/udp	0.000502
unknown	50679/udp	0.000502
unknown	50680/udp	0.000502
unknown	50690/udp	0.000502
unknown	50692/tcp	0.000076
unknown	50703/udp	0.000502
unknown	50707/udp	0.000502
unknown	50708/udp	0.001506
unknown	50711/udp	0.000502
unknown	50712/udp	0.000502
unknown	50714/udp	0.000502
unknown	50722/udp	0.001004
unknown	50729/udp	0.000502
unknown	50733/tcp	0.000076
unknown	50734/udp	0.000502
unknown	50735/udp	0.000502
unknown	50749/udp	0.000502
unknown	50750/udp	0.000502
unknown	50756/udp	0.001004
unknown	50766/udp	0.000502
unknown	50768/udp	0.000502
unknown	50777/udp	0.000502
unknown	50786/udp	0.000502
unknown	50787/tcp	0.000076
unknown	50789/udp	0.000502
unknown	50790/udp	0.000502
unknown	50797/udp	0.000502
unknown	50800/tcp	0.000380
unknown	50802/udp	0.000502
unknown	50807/udp	0.000502
unknown	50809/tcp	0.000076
unknown	50811/udp	0.000502
unknown	50814/udp	0.000502
unknown	50815/tcp	0.000076
unknown	50831/tcp	0.000076
unknown	50833/tcp	0.000076
unknown	50834/tcp	0.000076
unknown	50834/udp	0.000502
unknown	50835/tcp	0.000076
unknown	50835/udp	0.000502
unknown	50836/tcp	0.000076
unknown	50848/udp	0.000502
unknown	50849/tcp	0.000076
unknown	50851/udp	0.000502
unknown	50854/tcp	0.000076
unknown	50860/udp	0.000502
unknown	50862/udp	0.000502
unknown	50868/udp	0.000502
unknown	50870/udp	0.000502
unknown	50873/udp	0.000502
unknown	50881/udp	0.000502
unknown	50883/udp	0.000502
unknown	50886/udp	0.000502
unknown	50887/tcp	0.000076
unknown	50891/udp	0.000502
unknown	50895/udp	0.000502
unknown	50896/udp	0.001004
unknown	50900/udp	0.001004
unknown	50903/tcp	0.000076
unknown	50904/udp	0.001004
unknown	50913/udp	0.001004
unknown	50919/udp	0.001506
unknown	50921/udp	0.000502
unknown	50925/udp	0.000502
unknown	50937/udp	0.000502
unknown	50939/udp	0.000502
unknown	50941/udp	0.000502
unknown	50942/udp	0.000502
unknown	50945/tcp	0.000076
unknown	50954/udp	0.000502
unknown	50959/udp	0.000502
unknown	50960/udp	0.000502
unknown	50974/udp	0.000502
unknown	50977/udp	0.000502
unknown	50981/udp	0.000502
unknown	50982/udp	0.000502
unknown	50985/udp	0.000502
unknown	50987/udp	0.000502
unknown	50990/udp	0.001004
unknown	50994/udp	0.000502
unknown	50995/udp	0.000502
unknown	50997/tcp	0.000076
unknown	50998/udp	0.000502
unknown	51000/udp	0.000502
unknown	51004/udp	0.000502
unknown	51011/tcp	0.000076
unknown	51013/udp	0.001004
unknown	51014/udp	0.001004
unknown	51016/udp	0.000502
unknown	51020/tcp	0.000076
unknown	51020/udp	0.001004
unknown	51021/udp	0.000502
unknown	51023/udp	0.000502
unknown	51025/udp	0.000502
unknown	51027/udp	0.000502
unknown	51037/tcp	0.000076
unknown	51042/udp	0.000502
unknown	51045/udp	0.000502
unknown	51047/udp	0.000502
unknown	51067/tcp	0.000076
unknown	51074/udp	0.000502
unknown	51080/udp	0.000502
unknown	51083/udp	0.000502
unknown	51086/udp	0.000502
unknown	51087/udp	0.000502
unknown	51092/udp	0.000502
unknown	51093/udp	0.000502
unknown	51098/udp	0.000502
unknown	51101/udp	0.000502
unknown	51103/tcp	0.000684
unknown	51111/udp	0.000502
unknown	51112/udp	0.000502
unknown	51118/tcp	0.000076
unknown	51118/udp	0.000502
unknown	51120/udp	0.001004
unknown	51124/udp	0.000502
unknown	51127/udp	0.000502
unknown	51137/udp	0.000502
unknown	51138/udp	0.000502
unknown	51139/tcp	0.000076
unknown	51142/udp	0.000502
unknown	51143/udp	0.001004
unknown	51156/udp	0.000502
unknown	51165/udp	0.000502
unknown	51167/udp	0.001004
unknown	51169/udp	0.000502
unknown	51172/udp	0.001004
unknown	51180/udp	0.000502
unknown	51185/udp	0.000502
unknown	51191/tcp	0.000152
unknown	51193/udp	0.001004
unknown	51195/udp	0.000502
unknown	51199/udp	0.000502
unknown	51211/udp	0.001004
unknown	51212/udp	0.000502
unknown	51221/udp	0.000502
unknown	51225/udp	0.001004
unknown	51233/tcp	0.000076
unknown	51233/udp	0.000502
unknown	51234/tcp	0.000076
unknown	51235/tcp	0.000076
unknown	51240/tcp	0.000076
unknown	51244/udp	0.000502
unknown	51250/udp	0.000502
unknown	51251/udp	0.000502
unknown	51255/udp	0.001506
unknown	51264/udp	0.000502
unknown	51265/udp	0.000502
unknown	51267/udp	0.001004
unknown	51273/udp	0.000502
unknown	51274/udp	0.000502
unknown	51275/udp	0.000502
unknown	51279/udp	0.000502
unknown	51280/udp	0.001004
unknown	51281/udp	0.000502
unknown	51286/udp	0.000502
unknown	51294/udp	0.000502
unknown	51295/udp	0.000502
unknown	51300/tcp	0.000076
unknown	51304/udp	0.000502
unknown	51309/udp	0.000502
unknown	51322/udp	0.000502
unknown	51323/udp	0.001004
unknown	51327/udp	0.000502
unknown	51343/tcp	0.000076
unknown	51351/tcp	0.000076
unknown	51351/udp	0.000502
unknown	51364/udp	0.000502
unknown	51365/udp	0.000502
unknown	51366/tcp	0.000076
unknown	51366/udp	0.000502
unknown	51375/udp	0.000502
unknown	51378/udp	0.000502
unknown	51382/udp	0.000502
unknown	51383/udp	0.001004
unknown	51386/udp	0.000502
unknown	51387/udp	0.000502
unknown	51393/udp	0.000502
unknown	51398/udp	0.000502
unknown	51400/udp	0.001004
unknown	51402/udp	0.000502
unknown	51405/udp	0.000502
unknown	51407/udp	0.001004
unknown	51413/tcp	0.000152
unknown	51418/udp	0.000502
unknown	51423/tcp	0.000076
unknown	51426/udp	0.000502
unknown	51427/udp	0.001004
unknown	51429/udp	0.000502
unknown	51432/udp	0.000502
unknown	51438/udp	0.000502
unknown	51450/udp	0.000502
unknown	51456/udp	0.001506
unknown	51460/tcp	0.000076
unknown	51462/udp	0.000502
unknown	51465/udp	0.000502
unknown	51466/udp	0.000502
unknown	51471/udp	0.001004
unknown	51474/udp	0.000502
unknown	51477/udp	0.001004
unknown	51484/tcp	0.000076
unknown	51485/tcp	0.000076
unknown	51485/udp	0.000502
unknown	51486/udp	0.000502
unknown	51487/udp	0.000502
unknown	51488/tcp	0.000076
unknown	51493/tcp	0.000304
unknown	51500/udp	0.000502
unknown	51503/udp	0.000502
unknown	51506/udp	0.000502
unknown	51509/udp	0.000502
unknown	51515/tcp	0.000076
unknown	51515/udp	0.000502
unknown	51516/udp	0.000502
unknown	51517/udp	0.000502
unknown	51520/udp	0.000502
unknown	51524/udp	0.000502
unknown	51534/udp	0.000502
unknown	51535/udp	0.000502
unknown	51544/udp	0.001004
unknown	51551/udp	0.000502
unknown	51554/udp	0.001506
unknown	51556/udp	0.000502
unknown	51559/udp	0.000502
unknown	51562/udp	0.000502
unknown	51580/udp	0.000502
unknown	51581/udp	0.001004
unknown	51582/tcp	0.000076
unknown	51582/udp	0.000502
unknown	51583/udp	0.000502
unknown	51584/udp	0.000502
unknown	51585/udp	0.000502
unknown	51586/udp	0.001506
unknown	51587/udp	0.000502
unknown	51588/udp	0.000502
unknown	51589/udp	0.001004
unknown	51590/udp	0.000502
unknown	51591/udp	0.000502
unknown	51592/udp	0.000502
unknown	51596/udp	0.000502
unknown	51602/udp	0.000502
unknown	51603/udp	0.000502
unknown	51606/udp	0.000502
unknown	51614/udp	0.000502
unknown	51621/udp	0.000502
unknown	51628/udp	0.000502
unknown	51634/udp	0.000502
unknown	51638/udp	0.000502
unknown	51644/udp	0.000502
unknown	51646/udp	0.000502
unknown	51649/udp	0.001004
unknown	51651/udp	0.000502
unknown	51656/udp	0.000502
unknown	51657/udp	0.000502
unknown	51658/tcp	0.000076
unknown	51662/udp	0.000502
unknown	51668/udp	0.000502
unknown	51670/udp	0.000502
unknown	51677/udp	0.000502
unknown	51683/udp	0.000502
unknown	51684/udp	0.000502
unknown	51690/udp	0.001506
unknown	51705/udp	0.000502
unknown	51710/udp	0.001004
unknown	51712/udp	0.000502
unknown	51714/udp	0.000502
unknown	51717/udp	0.002008
unknown	51718/udp	0.000502
unknown	51724/udp	0.000502
unknown	51738/udp	0.000502
unknown	51749/udp	0.000502
unknown	51751/udp	0.000502
unknown	51753/udp	0.000502
unknown	51760/udp	0.000502
unknown	51763/udp	0.000502
unknown	51765/udp	0.000502
unknown	51768/udp	0.000502
unknown	51771/tcp	0.000076
unknown	51772/tcp	0.000076
unknown	51781/udp	0.001004
unknown	51788/udp	0.000502
unknown	51800/tcp	0.000076
unknown	51804/udp	0.000502
unknown	51805/udp	0.000502
unknown	51807/udp	0.000502
unknown	51809/tcp	0.000076
unknown	51809/udp	0.000502
unknown	51820/udp	0.000502
unknown	51823/udp	0.000502
unknown	51825/udp	0.000502
unknown	51828/udp	0.000502
unknown	51837/udp	0.000502
unknown	51843/udp	0.001004
unknown	51845/udp	0.000502
unknown	51846/udp	0.000502
unknown	51847/udp	0.001004
unknown	51848/udp	0.000502
unknown	51855/udp	0.000502
unknown	51857/udp	0.000502
unknown	51859/udp	0.000502
unknown	51860/udp	0.000502
unknown	51861/udp	0.000502
unknown	51864/udp	0.000502
unknown	51865/udp	0.000502
unknown	51869/udp	0.000502
unknown	51871/udp	0.000502
unknown	51882/udp	0.000502
unknown	51894/udp	0.001004
unknown	51903/udp	0.001004
unknown	51905/udp	0.001506
unknown	51906/tcp	0.000076
unknown	51908/udp	0.000502
unknown	51909/tcp	0.000076
unknown	51918/udp	0.000502
unknown	51921/udp	0.000502
unknown	51927/udp	0.000502
unknown	51936/udp	0.000502
unknown	51949/udp	0.000502
unknown	51950/udp	0.000502
unknown	51952/udp	0.000502
unknown	51960/udp	0.000502
unknown	51961/tcp	0.000076
unknown	51961/udp	0.000502
unknown	51965/tcp	0.000076
unknown	51965/udp	0.000502
unknown	51966/udp	0.000502
unknown	51969/udp	0.000502
unknown	51972/udp	0.001506
unknown	51976/udp	0.000502
unknown	51991/udp	0.000502
unknown	52000/tcp	0.000076
unknown	52001/tcp	0.000076
unknown	52002/tcp	0.000076
unknown	52003/tcp	0.000076
unknown	52003/udp	0.000502
unknown	52004/udp	0.000502
unknown	52005/udp	0.000502
unknown	52006/udp	0.001004
unknown	52012/udp	0.000502
unknown	52016/udp	0.000502
unknown	52019/udp	0.000502
unknown	52025/tcp	0.000076
unknown	52025/udp	0.000502
unknown	52027/udp	0.000502
unknown	52038/udp	0.000502
unknown	52046/tcp	0.000076
unknown	52046/udp	0.000502
unknown	52049/udp	0.000502
unknown	52052/udp	0.000502
unknown	52057/udp	0.000502
unknown	52059/udp	0.000502
unknown	52064/udp	0.000502
unknown	52071/tcp	0.000076
unknown	52072/udp	0.000502
unknown	52081/udp	0.000502
unknown	52088/udp	0.000502
unknown	52089/udp	0.001004
unknown	52092/udp	0.000502
unknown	52099/udp	0.000502
unknown	52100/udp	0.000502
unknown	52103/udp	0.000502
unknown	52106/udp	0.000502
unknown	52107/udp	0.000502
unknown	52109/udp	0.000502
unknown	52114/udp	0.000502
unknown	52121/udp	0.000502
unknown	52127/udp	0.000502
unknown	52130/udp	0.001004
unknown	52133/udp	0.000502
unknown	52138/udp	0.001004
unknown	52141/udp	0.000502
unknown	52144/udp	0.001506
unknown	52148/udp	0.000502
unknown	52151/udp	0.000502
unknown	52152/udp	0.000502
unknown	52154/udp	0.000502
unknown	52155/udp	0.001004
unknown	52158/udp	0.000502
unknown	52167/udp	0.000502
unknown	52173/tcp	0.000076
unknown	52178/udp	0.000502
unknown	52182/udp	0.000502
unknown	52194/udp	0.000502
unknown	52195/udp	0.000502
unknown	52197/udp	0.000502
unknown	52201/udp	0.000502
unknown	52203/udp	0.000502
unknown	52211/udp	0.000502
unknown	52212/udp	0.000502
unknown	52220/udp	0.001004
unknown	52222/udp	0.000502
unknown	52224/udp	0.001004
unknown	52225/tcp	0.000076
unknown	52225/udp	0.003012
unknown	52226/tcp	0.000076
unknown	52227/udp	0.001004
unknown	52228/udp	0.000502
unknown	52230/tcp	0.000076
unknown	52237/tcp	0.000076
unknown	52237/udp	0.000502
unknown	52248/udp	0.000502
unknown	52253/udp	0.000502
unknown	52254/udp	0.001004
unknown	52255/udp	0.000502
unknown	52258/udp	0.000502
unknown	52260/udp	0.000502
unknown	52262/tcp	0.000076
unknown	52268/udp	0.000502
unknown	52276/udp	0.000502
unknown	52277/udp	0.000502
unknown	52278/udp	0.000502
unknown	52279/udp	0.000502
unknown	52287/udp	0.000502
unknown	52294/udp	0.000502
unknown	52298/udp	0.000502
unknown	52302/udp	0.000502
unknown	52306/udp	0.000502
unknown	52315/udp	0.000502
unknown	52316/udp	0.000502
unknown	52317/udp	0.000502
unknown	52321/udp	0.000502
unknown	52330/udp	0.000502
unknown	52331/udp	0.000502
unknown	52332/udp	0.000502
unknown	52333/udp	0.001004
unknown	52335/udp	0.000502
unknown	52336/udp	0.000502
unknown	52344/udp	0.000502
unknown	52350/udp	0.000502
unknown	52356/udp	0.000502
unknown	52361/udp	0.000502
unknown	52364/udp	0.001004
unknown	52368/udp	0.000502
unknown	52375/udp	0.000502
unknown	52391/tcp	0.000076
unknown	52394/udp	0.000502
unknown	52395/udp	0.000502
unknown	52402/udp	0.000502
unknown	52408/udp	0.000502
unknown	52412/udp	0.001004
unknown	52419/udp	0.000502
unknown	52420/udp	0.000502
unknown	52424/udp	0.000502
unknown	52425/udp	0.000502
unknown	52428/udp	0.000502
unknown	52443/udp	0.000502
unknown	52451/udp	0.000502
unknown	52460/udp	0.000502
unknown	52467/udp	0.000502
unknown	52477/tcp	0.000076
unknown	52478/udp	0.000502
unknown	52480/udp	0.000502
unknown	52492/udp	0.000502
unknown	52494/udp	0.000502
unknown	52496/udp	0.000502
unknown	52499/udp	0.000502
unknown	52503/udp	0.002510
unknown	52506/tcp	0.000076
unknown	52509/udp	0.000502
unknown	52515/udp	0.000502
unknown	52516/udp	0.001004
unknown	52519/udp	0.000502
unknown	52524/udp	0.000502
unknown	52533/udp	0.000502
unknown	52540/udp	0.000502
unknown	52552/udp	0.000502
unknown	52571/udp	0.001004
unknown	52573/tcp	0.000076
unknown	52580/udp	0.000502
unknown	52582/udp	0.001004
unknown	52585/udp	0.000502
unknown	52592/udp	0.000502
unknown	52596/udp	0.000502
unknown	52610/udp	0.000502
unknown	52616/udp	0.000502
unknown	52620/udp	0.000502
unknown	52623/udp	0.000502
unknown	52628/udp	0.000502
unknown	52649/udp	0.001004
unknown	52651/udp	0.000502
unknown	52660/tcp	0.000152
unknown	52663/udp	0.000502
unknown	52665/tcp	0.000076
unknown	52667/udp	0.000502
unknown	52669/udp	0.000502
unknown	52671/udp	0.000502
unknown	52673/tcp	0.000228
unknown	52674/udp	0.001004
unknown	52675/tcp	0.000076
unknown	52677/udp	0.000502
unknown	52679/udp	0.000502
unknown	52685/udp	0.000502
unknown	52692/udp	0.000502
unknown	52696/udp	0.000502
unknown	52700/udp	0.000502
unknown	52706/udp	0.001004
unknown	52710/tcp	0.000152
unknown	52713/udp	0.001004
unknown	52716/udp	0.000502
unknown	52724/udp	0.000502
unknown	52726/udp	0.000502
unknown	52727/udp	0.000502
unknown	52734/udp	0.000502
unknown	52735/tcp	0.000152
unknown	52740/udp	0.000502
unknown	52755/udp	0.000502
unknown	52761/udp	0.000502
unknown	52762/udp	0.001004
unknown	52766/udp	0.000502
unknown	52772/udp	0.001004
unknown	52775/udp	0.000502
unknown	52780/udp	0.000502
unknown	52781/udp	0.000502
unknown	52791/udp	0.000502
unknown	52792/udp	0.001004
unknown	52806/udp	0.000502
unknown	52807/udp	0.000502
unknown	52813/udp	0.001004
unknown	52815/udp	0.000502
unknown	52817/udp	0.000502
unknown	52820/udp	0.000502
unknown	52821/udp	0.000502
unknown	52822/tcp	0.000456
unknown	52825/udp	0.000502
unknown	52830/udp	0.000502
unknown	52833/udp	0.000502
unknown	52844/udp	0.000502
unknown	52845/udp	0.000502
unknown	52847/tcp	0.000152
unknown	52847/udp	0.000502
unknown	52848/tcp	0.000228
unknown	52848/udp	0.000502
unknown	52849/tcp	0.000152
unknown	52849/udp	0.000502
unknown	52850/tcp	0.000152
unknown	52851/tcp	0.000152
unknown	52853/tcp	0.000152
unknown	52861/udp	0.001004
unknown	52864/udp	0.000502
unknown	52865/udp	0.000502
unknown	52869/tcp	0.000760
unknown	52872/udp	0.000502
unknown	52886/udp	0.000502
unknown	52887/udp	0.000502
unknown	52889/udp	0.000502
unknown	52891/udp	0.000502
unknown	52893/tcp	0.000076
unknown	52894/udp	0.000502
unknown	52899/udp	0.000502
unknown	52908/udp	0.000502
unknown	52909/udp	0.000502
unknown	52915/udp	0.000502
unknown	52916/udp	0.000502
unknown	52920/udp	0.000502
unknown	52931/udp	0.000502
unknown	52934/udp	0.000502
unknown	52938/udp	0.000502
unknown	52944/udp	0.000502
unknown	52945/udp	0.001004
unknown	52946/udp	0.000502
unknown	52947/udp	0.000502
unknown	52948/tcp	0.000076
unknown	52950/udp	0.000502
unknown	52956/udp	0.000502
unknown	52959/udp	0.000502
unknown	52965/udp	0.000502
unknown	52966/udp	0.000502
unknown	52967/udp	0.000502
unknown	52969/udp	0.000502
unknown	52981/udp	0.000502
unknown	52992/udp	0.000502
unknown	52994/udp	0.000502
unknown	53000/udp	0.000502
unknown	53006/udp	0.001506
unknown	53008/udp	0.000502
unknown	53011/udp	0.000502
unknown	53014/udp	0.000502
unknown	53015/udp	0.000502
unknown	53019/udp	0.000502
unknown	53020/udp	0.000502
unknown	53023/udp	0.001004
unknown	53024/udp	0.000502
unknown	53029/udp	0.000502
unknown	53033/udp	0.000502
unknown	53034/udp	0.000502
unknown	53036/udp	0.000502
unknown	53037/udp	0.001506
unknown	53044/udp	0.000502
unknown	53050/udp	0.000502
unknown	53059/udp	0.000502
unknown	53069/udp	0.000502
unknown	53070/udp	0.000502
unknown	53071/udp	0.000502
unknown	53073/udp	0.000502
unknown	53079/udp	0.000502
unknown	53080/udp	0.000502
unknown	53084/udp	0.001004
unknown	53085/tcp	0.000076
unknown	53085/udp	0.000502
unknown	53094/udp	0.000502
unknown	53098/udp	0.000502
unknown	53101/udp	0.000502
unknown	53112/udp	0.000502
unknown	53126/udp	0.001004
unknown	53128/udp	0.000502
unknown	53135/udp	0.000502
unknown	53142/udp	0.000502
unknown	53153/udp	0.000502
unknown	53157/udp	0.000502
unknown	53160/udp	0.000502
unknown	53161/udp	0.001004
unknown	53164/udp	0.000502
unknown	53176/udp	0.000502
unknown	53178/tcp	0.000076
unknown	53179/udp	0.000502
unknown	53182/udp	0.001004
unknown	53189/tcp	0.000076
unknown	53191/udp	0.000502
unknown	53198/udp	0.000502
unknown	53199/udp	0.000502
unknown	53200/udp	0.000502
unknown	53202/udp	0.000502
unknown	53208/udp	0.000502
unknown	53211/tcp	0.000152
unknown	53212/tcp	0.000076
unknown	53212/udp	0.001004
unknown	53218/udp	0.000502
unknown	53222/udp	0.000502
unknown	53228/udp	0.001004
unknown	53240/tcp	0.000076
unknown	53242/udp	0.000502
unknown	53245/udp	0.000502
unknown	53246/udp	0.000502
unknown	53249/udp	0.001004
unknown	53250/udp	0.000502
unknown	53252/udp	0.000502
unknown	53258/udp	0.000502
unknown	53260/udp	0.000502
unknown	53265/udp	0.000502
unknown	53266/udp	0.000502
unknown	53271/udp	0.000502
unknown	53273/udp	0.000502
unknown	53276/udp	0.000502
unknown	53279/udp	0.001004
unknown	53284/udp	0.000502
unknown	53285/udp	0.000502
unknown	53286/udp	0.001004
unknown	53292/udp	0.000502
unknown	53301/udp	0.000502
unknown	53305/udp	0.000502
unknown	53308/udp	0.000502
unknown	53311/udp	0.000502
unknown	53313/tcp	0.000152
unknown	53313/udp	0.000502
unknown	53314/tcp	0.000152
unknown	53318/udp	0.000502
unknown	53319/tcp	0.000076
unknown	53321/udp	0.000502
unknown	53322/udp	0.000502
unknown	53326/udp	0.000502
unknown	53331/udp	0.000502
unknown	53332/udp	0.000502
unknown	53336/udp	0.000502
unknown	53339/udp	0.000502
unknown	53340/udp	0.000502
unknown	53341/udp	0.000502
unknown	53347/udp	0.000502
unknown	53361/tcp	0.000076
unknown	53362/udp	0.000502
unknown	53366/udp	0.000502
unknown	53367/udp	0.001004
unknown	53370/tcp	0.000076
unknown	53373/udp	0.000502
unknown	53375/udp	0.000502
unknown	53385/udp	0.000502
unknown	53389/udp	0.000502
unknown	53390/udp	0.000502
unknown	53392/udp	0.000502
unknown	53393/udp	0.000502
unknown	53396/udp	0.001004
unknown	53399/udp	0.000502
unknown	53401/udp	0.000502
unknown	53403/udp	0.001004
unknown	53410/udp	0.000502
unknown	53412/udp	0.000502
unknown	53420/udp	0.000502
unknown	53421/udp	0.000502
unknown	53433/udp	0.001004
unknown	53434/udp	0.000502
unknown	53442/udp	0.000502
unknown	53455/udp	0.000502
unknown	53458/udp	0.000502
unknown	53460/tcp	0.000076
unknown	53460/udp	0.001004
unknown	53468/udp	0.000502
unknown	53469/tcp	0.000076
unknown	53470/udp	0.000502
unknown	53491/tcp	0.000076
unknown	53491/udp	0.000502
unknown	53500/udp	0.000502
unknown	53503/udp	0.000502
unknown	53505/udp	0.000502
unknown	53507/udp	0.000502
unknown	53513/udp	0.000502
unknown	53514/udp	0.000502
unknown	53516/udp	0.000502
unknown	53517/udp	0.000502
unknown	53520/udp	0.000502
unknown	53526/udp	0.000502
unknown	53528/udp	0.000502
unknown	53535/tcp	0.000152
unknown	53535/udp	0.000502
unknown	53536/udp	0.000502
unknown	53537/udp	0.000502
unknown	53539/udp	0.000502
unknown	53545/udp	0.000502
unknown	53549/udp	0.000502
unknown	53551/udp	0.000502
unknown	53554/udp	0.001004
unknown	53555/udp	0.000502
unknown	53560/udp	0.000502
unknown	53562/udp	0.000502
unknown	53564/udp	0.000502
unknown	53571/udp	0.002510
unknown	53574/udp	0.000502
unknown	53586/udp	0.000502
unknown	53589/udp	0.001506
unknown	53620/udp	0.000502
unknown	53633/tcp	0.000076
unknown	53633/udp	0.000502
unknown	53635/udp	0.000502
unknown	53639/tcp	0.000076
unknown	53643/udp	0.000502
unknown	53645/udp	0.000502
unknown	53647/udp	0.000502
unknown	53649/udp	0.000502
unknown	53651/udp	0.001004
unknown	53656/tcp	0.000076
unknown	53660/udp	0.000502
unknown	53670/udp	0.000502
unknown	53674/udp	0.000502
unknown	53677/udp	0.000502
unknown	53678/udp	0.000502
unknown	53684/udp	0.000502
unknown	53685/udp	0.000502
unknown	53688/udp	0.000502
unknown	53690/tcp	0.000076
unknown	53695/udp	0.000502
unknown	53702/udp	0.000502
unknown	53708/udp	0.000502
unknown	53723/udp	0.000502
unknown	53724/udp	0.000502
unknown	53730/udp	0.000502
unknown	53731/udp	0.000502
unknown	53732/udp	0.000502
unknown	53733/udp	0.000502
unknown	53735/udp	0.000502
unknown	53740/udp	0.000502
unknown	53742/tcp	0.000076
unknown	53750/udp	0.000502
unknown	53751/udp	0.000502
unknown	53753/udp	0.000502
unknown	53758/udp	0.000502
unknown	53761/udp	0.000502
unknown	53766/udp	0.000502
unknown	53768/udp	0.000502
unknown	53769/udp	0.000502
unknown	53780/udp	0.000502
unknown	53782/tcp	0.000076
unknown	53787/udp	0.000502
unknown	53797/udp	0.000502
unknown	53808/udp	0.000502
unknown	53813/udp	0.000502
unknown	53826/udp	0.000502
unknown	53827/tcp	0.000076
unknown	53829/udp	0.000502
unknown	53830/udp	0.001004
unknown	53835/udp	0.000502
unknown	53836/udp	0.000502
unknown	53838/udp	0.001506
unknown	53847/udp	0.000502
unknown	53852/tcp	0.000076
unknown	53857/udp	0.000502
unknown	53860/udp	0.000502
unknown	53867/udp	0.000502
unknown	53880/udp	0.001004
unknown	53882/udp	0.000502
unknown	53887/udp	0.000502
unknown	53888/udp	0.000502
unknown	53894/udp	0.000502
unknown	53901/udp	0.000502
unknown	53904/udp	0.000502
unknown	53910/tcp	0.000076
unknown	53912/udp	0.000502
unknown	53919/udp	0.000502
unknown	53921/udp	0.000502
unknown	53924/udp	0.000502
unknown	53925/udp	0.000502
unknown	53926/udp	0.000502
unknown	53934/udp	0.000502
unknown	53935/udp	0.000502
unknown	53940/udp	0.001004
unknown	53941/udp	0.000502
unknown	53951/udp	0.000502
unknown	53954/udp	0.000502
unknown	53958/tcp	0.000076
unknown	53960/udp	0.000502
unknown	53987/udp	0.001004
unknown	53988/udp	0.000502
unknown	53993/udp	0.000502
unknown	53996/udp	0.001004
unknown	53997/udp	0.000502
unknown	54001/udp	0.000502
unknown	54002/udp	0.000502
unknown	54007/udp	0.000502
unknown	54011/udp	0.000502
unknown	54016/udp	0.000502
unknown	54018/udp	0.000502
unknown	54020/udp	0.000502
unknown	54021/udp	0.000502
unknown	54023/udp	0.001004
unknown	54024/udp	0.000502
unknown	54027/udp	0.001004
unknown	54032/udp	0.000502
unknown	54033/udp	0.000502
unknown	54034/udp	0.000502
unknown	54040/udp	0.001004
unknown	54045/tcp	0.000228
unknown	54045/udp	0.001004
unknown	54048/udp	0.000502
unknown	54049/udp	0.000502
unknown	54054/udp	0.000502
unknown	54055/udp	0.001004
unknown	54068/udp	0.000502
unknown	54075/tcp	0.000076
unknown	54077/udp	0.000502
unknown	54081/udp	0.000502
unknown	54089/udp	0.000502
unknown	54090/udp	0.000502
unknown	54092/udp	0.000502
unknown	54094/udp	0.001506
unknown	54096/udp	0.000502
unknown	54100/udp	0.000502
unknown	54101/tcp	0.000076
unknown	54103/udp	0.000502
unknown	54111/udp	0.000502
unknown	54114/udp	0.001506
unknown	54115/udp	0.000502
unknown	54125/udp	0.000502
unknown	54126/udp	0.001004
unknown	54127/tcp	0.000076
unknown	54131/udp	0.000502
unknown	54152/udp	0.000502
unknown	54159/udp	0.000502
unknown	54165/udp	0.000502
unknown	54171/udp	0.000502
unknown	54178/udp	0.000502
unknown	54183/udp	0.000502
unknown	54190/udp	0.000502
unknown	54193/udp	0.000502
unknown	54198/udp	0.000502
unknown	54203/udp	0.000502
unknown	54212/udp	0.000502
unknown	54219/udp	0.000502
unknown	54233/udp	0.000502
unknown	54235/tcp	0.000076
unknown	54235/udp	0.000502
unknown	54253/udp	0.000502
unknown	54258/udp	0.000502
unknown	54259/udp	0.001004
unknown	54261/udp	0.000502
unknown	54263/tcp	0.000076
unknown	54264/udp	0.001004
unknown	54266/udp	0.000502
unknown	54267/udp	0.001004
unknown	54268/udp	0.000502
unknown	54276/tcp	0.000076
unknown	54277/udp	0.000502
unknown	54279/udp	0.000502
unknown	54280/udp	0.000502
unknown	54281/udp	0.002008
unknown	54282/udp	0.000502
unknown	54284/udp	0.000502
unknown	54289/udp	0.000502
unknown	54296/udp	0.001004
unknown	54298/udp	0.001004
unknown	54301/udp	0.000502
unknown	54302/udp	0.000502
unknown	54311/udp	0.000502
bo2k	54320/tcp	0.000075	# Back Orifice 2K Default Port
unknown	54321/tcp	0.000076
bo2k	54321/udp	0.002246	# Back Orifice 2K Default Port
unknown	54323/tcp	0.000076
unknown	54324/udp	0.001004
unknown	54326/udp	0.000502
unknown	54328/tcp	0.000228
unknown	54331/udp	0.000502
unknown	54335/udp	0.000502
unknown	54341/udp	0.000502
unknown	54348/udp	0.000502
unknown	54349/udp	0.001004
unknown	54356/udp	0.000502
unknown	54370/udp	0.000502
unknown	54375/udp	0.001004
unknown	54377/udp	0.000502
unknown	54382/udp	0.000502
unknown	54383/udp	0.000502
unknown	54389/udp	0.000502
unknown	54398/udp	0.001004
unknown	54412/udp	0.000502
unknown	54414/udp	0.000502
unknown	54417/udp	0.000502
unknown	54418/udp	0.000502
unknown	54425/udp	0.000502
unknown	54434/udp	0.000502
unknown	54435/udp	0.000502
unknown	54436/udp	0.000502
unknown	54446/udp	0.000502
unknown	54448/udp	0.000502
unknown	54451/udp	0.000502
unknown	54475/udp	0.000502
unknown	54480/udp	0.000502
unknown	54482/udp	0.000502
unknown	54490/udp	0.000502
unknown	54495/udp	0.000502
unknown	54496/udp	0.000502
unknown	54499/udp	0.000502
unknown	54513/udp	0.001004
unknown	54514/tcp	0.000076
unknown	54517/udp	0.000502
unknown	54521/udp	0.001004
unknown	54526/udp	0.000502
unknown	54531/udp	0.001004
unknown	54535/udp	0.000502
unknown	54536/udp	0.000502
unknown	54537/udp	0.000502
unknown	54540/udp	0.000502
unknown	54541/udp	0.000502
unknown	54545/udp	0.000502
unknown	54547/udp	0.000502
unknown	54551/tcp	0.000076
unknown	54553/udp	0.000502
unknown	54561/udp	0.000502
unknown	54573/udp	0.000502
unknown	54578/udp	0.000502
unknown	54579/udp	0.000502
unknown	54587/udp	0.000502
unknown	54588/udp	0.000502
unknown	54593/udp	0.000502
unknown	54603/udp	0.000502
unknown	54604/udp	0.000502
unknown	54605/tcp	0.000076
unknown	54606/udp	0.000502
unknown	54607/udp	0.001004
unknown	54608/udp	0.000502
unknown	54612/udp	0.000502
unknown	54615/udp	0.000502
unknown	54627/udp	0.001004
unknown	54628/udp	0.000502
unknown	54629/udp	0.000502
unknown	54631/udp	0.000502
unknown	54632/udp	0.000502
unknown	54633/udp	0.000502
unknown	54638/udp	0.000502
unknown	54639/udp	0.000502
unknown	54642/udp	0.000502
unknown	54644/udp	0.000502
unknown	54653/udp	0.001004
unknown	54658/tcp	0.000076
unknown	54665/udp	0.000502
unknown	54668/udp	0.000502
unknown	54669/udp	0.000502
unknown	54670/udp	0.000502
unknown	54674/udp	0.000502
unknown	54675/udp	0.000502
unknown	54676/udp	0.001004
unknown	54688/tcp	0.000076
unknown	54696/udp	0.000502
unknown	54711/udp	0.001506
unknown	54722/tcp	0.000076
unknown	54722/udp	0.001004
unknown	54741/tcp	0.000076
unknown	54747/udp	0.001004
unknown	54748/udp	0.000502
unknown	54751/udp	0.000502
unknown	54755/udp	0.000502
unknown	54757/udp	0.000502
unknown	54758/udp	0.001004
unknown	54763/udp	0.000502
unknown	54783/udp	0.000502
unknown	54788/udp	0.000502
unknown	54790/udp	0.000502
unknown	54792/udp	0.000502
unknown	54793/udp	0.000502
unknown	54801/udp	0.000502
unknown	54805/udp	0.000502
unknown	54806/udp	0.000502
unknown	54807/udp	0.001506
unknown	54811/udp	0.000502
unknown	54812/udp	0.001004
unknown	54820/udp	0.000502
unknown	54833/udp	0.000502
unknown	54835/udp	0.000502
unknown	54838/udp	0.000502
unknown	54843/udp	0.000502
unknown	54847/udp	0.000502
unknown	54848/udp	0.001004
unknown	54849/udp	0.000502
unknown	54853/udp	0.000502
unknown	54854/udp	0.000502
unknown	54862/udp	0.000502
unknown	54863/udp	0.000502
unknown	54873/tcp	0.000076
unknown	54875/udp	0.000502
unknown	54878/udp	0.000502
unknown	54884/udp	0.000502
unknown	54887/udp	0.000502
unknown	54890/udp	0.000502
unknown	54902/udp	0.000502
unknown	54906/udp	0.000502
unknown	54907/tcp	0.000076
unknown	54907/udp	0.000502
unknown	54911/udp	0.000502
unknown	54920/udp	0.000502
unknown	54922/udp	0.000502
unknown	54923/udp	0.000502
unknown	54924/udp	0.000502
unknown	54925/udp	0.001506
unknown	54927/udp	0.000502
unknown	54933/udp	0.000502
unknown	54937/udp	0.000502
unknown	54938/udp	0.000502
unknown	54939/udp	0.001004
unknown	54942/udp	0.000502
unknown	54946/udp	0.001004
unknown	54948/udp	0.000502
unknown	54952/udp	0.001004
unknown	54957/udp	0.000502
unknown	54959/udp	0.000502
unknown	54965/udp	0.000502
unknown	54970/udp	0.000502
unknown	54971/udp	0.000502
unknown	54978/udp	0.000502
unknown	54981/udp	0.000502
unknown	54982/udp	0.000502
unknown	54987/tcp	0.000076
unknown	54991/tcp	0.000076
unknown	54993/udp	0.001004
unknown	54995/udp	0.000502
unknown	54999/udp	0.000502
unknown	55000/tcp	0.000076
unknown	55020/tcp	0.000152
unknown	55020/udp	0.000502
unknown	55034/udp	0.001004
unknown	55038/udp	0.000502
unknown	55043/udp	0.001506
unknown	55051/udp	0.000502
unknown	55055/tcp	0.000304
unknown	55056/tcp	0.000228
unknown	55095/udp	0.000502
unknown	55100/udp	0.000502
unknown	55101/udp	0.000502
unknown	55102/udp	0.000502
unknown	55105/udp	0.000502
unknown	55108/udp	0.000502
unknown	55109/udp	0.000502
unknown	55120/udp	0.000502
unknown	55121/udp	0.000502
unknown	55124/udp	0.001004
unknown	55125/udp	0.000502
unknown	55129/udp	0.000502
unknown	55133/udp	0.000502
unknown	55142/udp	0.000502
unknown	55145/udp	0.000502
unknown	55147/udp	0.000502
unknown	55155/udp	0.000502
unknown	55156/udp	0.001004
unknown	55157/udp	0.000502
unknown	55165/udp	0.000502
unknown	55168/udp	0.000502
unknown	55174/udp	0.000502
unknown	55176/udp	0.000502
unknown	55179/udp	0.000502
unknown	55183/tcp	0.000076
unknown	55185/udp	0.000502
unknown	55187/tcp	0.000076
unknown	55194/udp	0.000502
unknown	55198/udp	0.000502
unknown	55200/udp	0.000502
unknown	55201/udp	0.000502
unknown	55203/udp	0.000502
unknown	55204/udp	0.000502
unknown	55205/udp	0.001004
unknown	55206/udp	0.000502
unknown	55212/udp	0.000502
unknown	55214/udp	0.000502
unknown	55215/udp	0.000502
unknown	55227/tcp	0.000076
unknown	55228/udp	0.000502
unknown	55229/udp	0.000502
unknown	55230/udp	0.000502
unknown	55233/udp	0.000502
unknown	55234/udp	0.000502
unknown	55243/udp	0.000502
unknown	55247/udp	0.000502
unknown	55249/udp	0.000502
unknown	55250/udp	0.000502
unknown	55251/udp	0.000502
unknown	55264/udp	0.000502
unknown	55266/udp	0.000502
unknown	55267/udp	0.001004
unknown	55271/udp	0.000502
unknown	55272/udp	0.000502
unknown	55292/udp	0.000502
unknown	55296/udp	0.000502
unknown	55303/udp	0.000502
unknown	55311/udp	0.000502
unknown	55312/tcp	0.000076
unknown	55316/udp	0.001004
unknown	55321/udp	0.000502
unknown	55323/udp	0.000502
unknown	55330/udp	0.000502
unknown	55334/udp	0.000502
unknown	55341/udp	0.000502
unknown	55344/udp	0.000502
unknown	55345/udp	0.000502
unknown	55350/tcp	0.000076
unknown	55352/udp	0.001004
unknown	55353/udp	0.000502
unknown	55365/udp	0.000502
unknown	55367/udp	0.000502
unknown	55373/udp	0.000502
unknown	55382/tcp	0.000076
unknown	55384/udp	0.000502
unknown	55395/udp	0.000502
unknown	55400/tcp	0.000076
unknown	55403/udp	0.000502
unknown	55411/udp	0.000502
unknown	55412/udp	0.000502
unknown	55414/udp	0.000502
unknown	55415/udp	0.000502
unknown	55416/udp	0.000502
unknown	55423/udp	0.000502
unknown	55425/udp	0.000502
unknown	55426/tcp	0.000076
unknown	55436/udp	0.000502
unknown	55437/udp	0.000502
unknown	55438/udp	0.000502
unknown	55443/udp	0.000502
unknown	55451/udp	0.000502
unknown	55456/udp	0.000502
unknown	55457/udp	0.000502
unknown	55469/udp	0.000502
unknown	55471/udp	0.000502
unknown	55472/udp	0.000502
unknown	55479/tcp	0.000076
unknown	55485/udp	0.000502
unknown	55488/udp	0.001004
unknown	55504/udp	0.000502
unknown	55527/tcp	0.000076
unknown	55527/udp	0.000502
unknown	55529/udp	0.000502
unknown	55534/udp	0.000502
unknown	55537/udp	0.000502
unknown	55539/udp	0.000502
unknown	55540/udp	0.000502
unknown	55541/udp	0.001004
unknown	55543/udp	0.000502
unknown	55544/udp	0.001506
unknown	55553/udp	0.001004
unknown	55555/tcp	0.000760
unknown	55556/tcp	0.000076
unknown	55566/udp	0.000502
unknown	55568/tcp	0.000076
unknown	55569/tcp	0.000076
unknown	55575/udp	0.000502
unknown	55576/tcp	0.000152
unknown	55576/udp	0.000502
unknown	55577/udp	0.000502
unknown	55578/udp	0.000502
unknown	55579/tcp	0.000076
unknown	55579/udp	0.001004
unknown	55581/udp	0.001004
unknown	55582/udp	0.000502
unknown	55587/udp	0.001506
unknown	55593/udp	0.001004
unknown	55595/udp	0.000502
unknown	55596/udp	0.000502
unknown	55597/udp	0.000502
unknown	55600/tcp	0.000760
unknown	55600/udp	0.000502
unknown	55603/udp	0.000502
unknown	55605/udp	0.000502
unknown	55609/udp	0.000502
unknown	55614/udp	0.000502
unknown	55617/udp	0.000502
unknown	55618/udp	0.001004
unknown	55619/udp	0.000502
unknown	55622/udp	0.000502
unknown	55623/udp	0.000502
unknown	55624/udp	0.000502
unknown	55628/udp	0.000502
unknown	55630/udp	0.000502
unknown	55632/udp	0.000502
unknown	55633/udp	0.000502
unknown	55635/tcp	0.000076
unknown	55642/udp	0.000502
unknown	55643/udp	0.000502
unknown	55650/udp	0.001004
unknown	55652/tcp	0.000076
unknown	55659/udp	0.000502
unknown	55665/udp	0.000502
unknown	55672/udp	0.000502
unknown	55676/udp	0.000502
unknown	55679/udp	0.000502
unknown	55684/tcp	0.000076
unknown	55695/udp	0.000502
unknown	55697/udp	0.000502
unknown	55698/udp	0.000502
unknown	55701/udp	0.000502
unknown	55703/udp	0.000502
unknown	55712/udp	0.000502
unknown	55718/udp	0.000502
unknown	55719/udp	0.000502
unknown	55721/tcp	0.000076
unknown	55728/udp	0.000502
unknown	55729/udp	0.000502
unknown	55736/udp	0.000502
unknown	55745/udp	0.001004
unknown	55746/udp	0.000502
unknown	55752/udp	0.000502
unknown	55758/tcp	0.000076
unknown	55760/udp	0.000502
unknown	55763/udp	0.000502
unknown	55766/udp	0.001004
unknown	55767/udp	0.000502
unknown	55769/udp	0.000502
unknown	55773/tcp	0.000076
unknown	55781/tcp	0.000076
unknown	55784/udp	0.001004
unknown	55789/udp	0.000502
unknown	55795/udp	0.001004
unknown	55797/udp	0.000502
unknown	55803/udp	0.000502
unknown	55805/udp	0.000502
unknown	55808/udp	0.000502
unknown	55818/udp	0.000502
unknown	55828/udp	0.000502
unknown	55830/udp	0.000502
unknown	55832/udp	0.000502
unknown	55843/udp	0.000502
unknown	55846/udp	0.000502
unknown	55847/udp	0.000502
unknown	55864/udp	0.000502
unknown	55870/udp	0.001004
unknown	55876/udp	0.000502
unknown	55877/udp	0.000502
unknown	55880/udp	0.000502
unknown	55888/udp	0.000502
unknown	55899/udp	0.000502
unknown	55901/tcp	0.000076
unknown	55905/udp	0.000502
unknown	55906/udp	0.000502
unknown	55907/tcp	0.000076
unknown	55909/udp	0.000502
unknown	55910/tcp	0.000076
unknown	55918/udp	0.000502
unknown	55921/udp	0.000502
unknown	55922/udp	0.000502
unknown	55924/udp	0.000502
unknown	55929/udp	0.000502
unknown	55937/udp	0.000502
unknown	55939/udp	0.000502
unknown	55941/udp	0.001004
unknown	55944/udp	0.000502
unknown	55948/tcp	0.000076
unknown	55949/udp	0.000502
unknown	55954/udp	0.001004
unknown	55957/udp	0.000502
unknown	55960/udp	0.000502
unknown	55961/udp	0.000502
unknown	55969/udp	0.000502
unknown	55978/udp	0.000502
unknown	55979/udp	0.000502
unknown	55990/udp	0.000502
unknown	55993/udp	0.000502
unknown	55994/udp	0.000502
unknown	55998/udp	0.000502
unknown	56005/udp	0.000502
unknown	56006/udp	0.000502
unknown	56011/udp	0.000502
unknown	56012/udp	0.000502
unknown	56013/udp	0.000502
unknown	56015/udp	0.000502
unknown	56016/tcp	0.000076
unknown	56018/udp	0.000502
unknown	56028/udp	0.000502
unknown	56029/udp	0.000502
unknown	56037/udp	0.000502
unknown	56054/udp	0.000502
unknown	56055/tcp	0.000076
unknown	56057/udp	0.000502
unknown	56059/udp	0.000502
unknown	56068/udp	0.000502
unknown	56073/udp	0.000502
unknown	56074/udp	0.000502
unknown	56092/udp	0.000502
unknown	56096/udp	0.000502
unknown	56099/udp	0.000502
unknown	56103/udp	0.001004
unknown	56105/udp	0.001004
unknown	56107/udp	0.000502
unknown	56109/udp	0.000502
unknown	56110/udp	0.000502
unknown	56111/udp	0.000502
unknown	56116/udp	0.000502
unknown	56119/udp	0.000502
unknown	56120/udp	0.000502
unknown	56122/udp	0.000502
unknown	56127/udp	0.000502
unknown	56129/udp	0.000502
unknown	56130/udp	0.000502
unknown	56137/udp	0.000502
unknown	56141/udp	0.002008
unknown	56147/udp	0.000502
unknown	56152/udp	0.000502
unknown	56153/udp	0.001004
unknown	56163/udp	0.000502
unknown	56168/udp	0.001004
unknown	56171/udp	0.000502
unknown	56192/udp	0.000502
unknown	56202/udp	0.000502
unknown	56203/udp	0.000502
unknown	56209/udp	0.001004
unknown	56213/udp	0.000502
unknown	56214/udp	0.000502
unknown	56221/udp	0.000502
unknown	56225/udp	0.001004
unknown	56228/udp	0.000502
unknown	56235/udp	0.000502
unknown	56241/udp	0.000502
unknown	56246/udp	0.000502
unknown	56259/tcp	0.000076
unknown	56259/udp	0.000502
unknown	56262/udp	0.000502
unknown	56267/udp	0.000502
unknown	56273/udp	0.001004
unknown	56274/udp	0.000502
unknown	56278/udp	0.000502
unknown	56284/udp	0.001004
unknown	56288/udp	0.001004
unknown	56289/udp	0.000502
unknown	56293/tcp	0.000076
unknown	56293/udp	0.000502
unknown	56308/udp	0.000502
unknown	56321/udp	0.000502
unknown	56324/udp	0.000502
unknown	56326/udp	0.001004
unknown	56332/udp	0.000502
unknown	56333/udp	0.000502
unknown	56337/udp	0.001004
unknown	56358/udp	0.000502
unknown	56359/udp	0.001004
unknown	56360/udp	0.000502
unknown	56366/udp	0.001004
unknown	56369/udp	0.000502
unknown	56371/udp	0.000502
unknown	56377/udp	0.000502
unknown	56380/udp	0.000502
unknown	56384/udp	0.000502
unknown	56393/udp	0.000502
unknown	56396/udp	0.000502
unknown	56404/udp	0.000502
unknown	56411/udp	0.000502
unknown	56418/udp	0.000502
unknown	56427/udp	0.000502
unknown	56433/udp	0.000502
unknown	56435/udp	0.000502
unknown	56438/udp	0.000502
unknown	56442/udp	0.000502
unknown	56457/udp	0.000502
unknown	56460/udp	0.000502
unknown	56462/udp	0.000502
unknown	56463/udp	0.000502
unknown	56466/udp	0.000502
unknown	56468/udp	0.001004
unknown	56469/udp	0.000502
unknown	56478/udp	0.000502
unknown	56485/udp	0.000502
unknown	56487/udp	0.000502
unknown	56491/udp	0.001004
unknown	56494/udp	0.000502
unknown	56497/udp	0.000502
unknown	56507/tcp	0.000076
unknown	56515/udp	0.000502
unknown	56525/udp	0.000502
unknown	56531/udp	0.000502
unknown	56533/udp	0.000502
unknown	56535/tcp	0.000076
unknown	56542/udp	0.000502
unknown	56548/udp	0.000502
unknown	56554/udp	0.001004
unknown	56555/udp	0.001004
unknown	56560/udp	0.000502
unknown	56591/tcp	0.000076
unknown	56592/udp	0.000502
unknown	56594/udp	0.000502
unknown	56597/udp	0.000502
unknown	56603/udp	0.000502
unknown	56615/udp	0.000502
unknown	56620/udp	0.000502
unknown	56621/udp	0.000502
unknown	56622/udp	0.001004
unknown	56627/udp	0.000502
unknown	56632/udp	0.000502
unknown	56637/udp	0.001004
unknown	56639/udp	0.000502
unknown	56643/udp	0.000502
unknown	56645/udp	0.000502
unknown	56653/udp	0.000502
unknown	56654/udp	0.000502
unknown	56657/udp	0.000502
unknown	56659/udp	0.000502
unknown	56666/udp	0.000502
unknown	56668/tcp	0.000076
unknown	56668/udp	0.001004
unknown	56679/udp	0.000502
unknown	56681/tcp	0.000076
unknown	56690/udp	0.000502
unknown	56691/udp	0.000502
unknown	56696/udp	0.000502
unknown	56704/udp	0.000502
unknown	56708/udp	0.000502
unknown	56710/udp	0.000502
unknown	56723/tcp	0.000076
unknown	56725/tcp	0.000076
unknown	56728/udp	0.000502
unknown	56732/udp	0.000502
unknown	56733/udp	0.000502
unknown	56736/udp	0.000502
unknown	56737/tcp	0.000228
unknown	56738/tcp	0.000304
unknown	56744/udp	0.000502
unknown	56750/udp	0.000502
unknown	56751/udp	0.000502
unknown	56753/udp	0.000502
unknown	56761/udp	0.000502
unknown	56765/udp	0.001004
unknown	56766/udp	0.000502
unknown	56782/udp	0.000502
unknown	56789/udp	0.000502
unknown	56798/udp	0.000502
unknown	56799/udp	0.000502
unknown	56800/udp	0.000502
unknown	56801/udp	0.000502
unknown	56802/udp	0.000502
unknown	56803/udp	0.000502
unknown	56804/udp	0.000502
unknown	56806/udp	0.000502
unknown	56810/tcp	0.000076
unknown	56816/udp	0.000502
unknown	56822/tcp	0.000076
unknown	56823/udp	0.000502
unknown	56825/udp	0.001004
unknown	56826/udp	0.000502
unknown	56827/tcp	0.000076
unknown	56838/udp	0.000502
unknown	56848/udp	0.001004
unknown	56851/udp	0.000502
unknown	56856/udp	0.000502
unknown	56863/udp	0.000502
unknown	56867/udp	0.000502
unknown	56869/udp	0.001004
unknown	56870/udp	0.000502
unknown	56876/udp	0.001004
unknown	56878/udp	0.000502
unknown	56880/udp	0.000502
unknown	56888/udp	0.000502
unknown	56891/udp	0.000502
unknown	56892/udp	0.001004
unknown	56895/udp	0.001004
unknown	56897/udp	0.001004
unknown	56904/udp	0.000502
unknown	56909/udp	0.000502
unknown	56913/udp	0.000502
unknown	56916/udp	0.000502
unknown	56921/udp	0.000502
unknown	56929/udp	0.001004
unknown	56933/udp	0.000502
unknown	56939/udp	0.000502
unknown	56943/udp	0.000502
unknown	56949/udp	0.000502
unknown	56950/udp	0.000502
unknown	56954/udp	0.001004
unknown	56960/udp	0.000502
unknown	56970/udp	0.000502
unknown	56973/tcp	0.000076
unknown	56975/tcp	0.000076
unknown	56980/udp	0.001004
unknown	56984/udp	0.000502
unknown	57000/udp	0.000502
unknown	57005/udp	0.001004
unknown	57010/udp	0.000502
unknown	57018/udp	0.000502
unknown	57020/tcp	0.000076
unknown	57020/udp	0.000502
unknown	57028/udp	0.000502
unknown	57050/udp	0.000502
unknown	57053/udp	0.000502
unknown	57060/udp	0.000502
unknown	57063/udp	0.001004
unknown	57068/udp	0.000502
unknown	57082/udp	0.000502
unknown	57086/udp	0.000502
unknown	57096/udp	0.000502
unknown	57099/udp	0.000502
unknown	57103/tcp	0.000076
unknown	57104/udp	0.000502
unknown	57110/udp	0.000502
unknown	57114/udp	0.001004
unknown	57121/udp	0.000502
unknown	57122/udp	0.000502
unknown	57123/tcp	0.000076
unknown	57128/udp	0.000502
unknown	57133/udp	0.001004
unknown	57134/udp	0.000502
unknown	57135/udp	0.000502
unknown	57154/udp	0.000502
unknown	57156/udp	0.001004
unknown	57167/udp	0.000502
unknown	57172/udp	0.001506
unknown	57176/udp	0.000502
unknown	57180/udp	0.000502
unknown	57182/udp	0.000502
unknown	57194/udp	0.000502
unknown	57202/udp	0.000502
unknown	57204/udp	0.000502
unknown	57208/udp	0.000502
unknown	57213/udp	0.000502
unknown	57217/udp	0.000502
unknown	57221/udp	0.000502
unknown	57234/udp	0.000502
unknown	57237/udp	0.000502
unknown	57244/udp	0.000502
unknown	57245/udp	0.000502
unknown	57247/udp	0.000502
unknown	57250/udp	0.000502
unknown	57252/udp	0.000502
unknown	57254/udp	0.000502
unknown	57255/udp	0.000502
unknown	57279/udp	0.000502
unknown	57283/udp	0.000502
unknown	57286/udp	0.000502
unknown	57294/tcp	0.000380
unknown	57304/udp	0.000502
unknown	57320/udp	0.000502
unknown	57322/udp	0.000502
unknown	57325/tcp	0.000076
unknown	57328/udp	0.000502
unknown	57335/tcp	0.000076
unknown	57336/udp	0.000502
unknown	57337/udp	0.000502
unknown	57344/udp	0.000502
unknown	57347/tcp	0.000076
unknown	57348/udp	0.000502
unknown	57350/tcp	0.000076
unknown	57352/tcp	0.000076
unknown	57357/udp	0.000502
unknown	57358/udp	0.000502
unknown	57361/udp	0.000502
unknown	57369/udp	0.000502
unknown	57373/udp	0.000502
unknown	57375/udp	0.000502
unknown	57379/udp	0.000502
unknown	57381/udp	0.000502
unknown	57382/udp	0.000502
unknown	57383/udp	0.000502
unknown	57386/udp	0.001004
unknown	57387/tcp	0.000076
unknown	57388/udp	0.000502
unknown	57391/udp	0.000502
unknown	57392/udp	0.000502
unknown	57395/udp	0.000502
unknown	57398/tcp	0.000076
unknown	57399/udp	0.000502
unknown	57402/udp	0.000502
unknown	57407/udp	0.000502
unknown	57409/udp	0.001506
unknown	57410/udp	0.001506
unknown	57416/udp	0.000502
unknown	57421/udp	0.001004
unknown	57425/udp	0.000502
unknown	57426/udp	0.000502
unknown	57456/udp	0.000502
unknown	57461/udp	0.001004
unknown	57471/udp	0.000502
unknown	57473/udp	0.000502
unknown	57474/udp	0.000502
unknown	57479/tcp	0.000076
unknown	57479/udp	0.000502
unknown	57483/udp	0.000502
unknown	57486/udp	0.000502
unknown	57491/udp	0.000502
unknown	57503/udp	0.000502
unknown	57504/udp	0.000502
unknown	57505/udp	0.000502
unknown	57510/udp	0.000502
unknown	57515/udp	0.000502
unknown	57516/udp	0.000502
unknown	57522/udp	0.000502
unknown	57527/udp	0.000502
unknown	57530/udp	0.000502
unknown	57552/udp	0.000502
unknown	57559/udp	0.000502
unknown	57576/tcp	0.000076
unknown	57577/udp	0.000502
unknown	57580/udp	0.000502
unknown	57587/udp	0.000502
unknown	57594/udp	0.000502
unknown	57614/udp	0.000502
unknown	57616/udp	0.000502
unknown	57619/udp	0.000502
unknown	57620/udp	0.000502
unknown	57622/udp	0.000502
unknown	57624/udp	0.000502
unknown	57629/udp	0.001004
unknown	57632/udp	0.000502
unknown	57633/udp	0.000502
unknown	57637/udp	0.000502
unknown	57638/udp	0.000502
unknown	57644/udp	0.000502
unknown	57646/udp	0.000502
unknown	57651/udp	0.000502
unknown	57655/udp	0.000502
unknown	57662/udp	0.001004
unknown	57665/tcp	0.000152
unknown	57671/udp	0.000502
unknown	57675/udp	0.000502
unknown	57676/udp	0.000502
unknown	57677/udp	0.000502
unknown	57678/tcp	0.000076
unknown	57679/udp	0.001004
unknown	57681/tcp	0.000076
unknown	57692/udp	0.000502
unknown	57696/udp	0.000502
unknown	57700/udp	0.000502
unknown	57702/tcp	0.000076
unknown	57711/udp	0.000502
unknown	57714/udp	0.000502
unknown	57719/udp	0.000502
unknown	57720/udp	0.000502
unknown	57728/udp	0.000502
unknown	57729/udp	0.000502
unknown	57730/tcp	0.000076
unknown	57733/tcp	0.000076
unknown	57733/udp	0.000502
unknown	57734/udp	0.000502
unknown	57739/udp	0.000502
unknown	57747/udp	0.000502
unknown	57756/udp	0.001004
unknown	57757/udp	0.000502
unknown	57758/udp	0.000502
unknown	57761/udp	0.000502
unknown	57767/udp	0.000502
unknown	57774/udp	0.000502
unknown	57784/udp	0.000502
unknown	57787/udp	0.000502
unknown	57797/tcp	0.000228
unknown	57800/udp	0.000502
unknown	57802/udp	0.000502
unknown	57812/udp	0.000502
unknown	57813/udp	0.001506
unknown	57814/udp	0.000502
unknown	57816/udp	0.000502
unknown	57821/udp	0.000502
unknown	57827/udp	0.001004
unknown	57836/udp	0.001004
unknown	57839/udp	0.000502
unknown	57843/udp	0.001506
unknown	57848/udp	0.001004
unknown	57850/udp	0.000502
unknown	57852/udp	0.000502
unknown	57858/udp	0.001004
unknown	57862/udp	0.000502
unknown	57864/udp	0.000502
unknown	57868/udp	0.001004
unknown	57871/udp	0.000502
unknown	57884/udp	0.000502
unknown	57891/tcp	0.000076
unknown	57893/udp	0.000502
unknown	57896/tcp	0.000076
unknown	57896/udp	0.000502
unknown	57899/udp	0.000502
unknown	57904/udp	0.000502
unknown	57916/udp	0.000502
unknown	57917/udp	0.000502
unknown	57920/udp	0.000502
unknown	57921/udp	0.000502
unknown	57923/tcp	0.000076
unknown	57928/tcp	0.000076
unknown	57933/udp	0.000502
unknown	57942/udp	0.001004
unknown	57946/udp	0.001004
unknown	57956/udp	0.000502
unknown	57958/udp	0.001506
unknown	57960/udp	0.000502
unknown	57963/udp	0.000502
unknown	57965/udp	0.000502
unknown	57972/udp	0.000502
unknown	57975/udp	0.000502
unknown	57976/udp	0.000502
unknown	57977/udp	0.001506
unknown	57988/tcp	0.000076
unknown	57990/udp	0.000502
unknown	57999/tcp	0.000076
unknown	57999/udp	0.000502
unknown	58000/udp	0.000502
unknown	58001/tcp	0.000152
unknown	58002/tcp	0.000152
unknown	58002/udp	0.003514
unknown	58003/udp	0.000502
unknown	58004/udp	0.000502
unknown	58007/udp	0.000502
unknown	58008/udp	0.000502
unknown	58009/udp	0.000502
unknown	58010/udp	0.000502
unknown	58011/udp	0.000502
unknown	58012/udp	0.000502
unknown	58014/udp	0.000502
unknown	58016/udp	0.000502
unknown	58020/udp	0.000502
unknown	58023/udp	0.000502
unknown	58026/udp	0.001004
unknown	58027/udp	0.000502
unknown	58033/udp	0.000502
unknown	58042/udp	0.000502
unknown	58049/udp	0.000502
unknown	58050/udp	0.000502
unknown	58070/udp	0.000502
unknown	58072/tcp	0.000076
unknown	58075/udp	0.001506
unknown	58076/udp	0.000502
unknown	58077/udp	0.000502
unknown	58080/tcp	0.000380
unknown	58085/udp	0.000502
unknown	58088/udp	0.000502
unknown	58089/udp	0.001004
unknown	58091/udp	0.001004
unknown	58101/udp	0.000502
unknown	58102/udp	0.001004
unknown	58105/udp	0.000502
unknown	58107/tcp	0.000076
unknown	58109/tcp	0.000076
unknown	58111/udp	0.000502
unknown	58114/udp	0.001004
unknown	58117/udp	0.000502
unknown	58123/udp	0.000502
unknown	58127/udp	0.000502
unknown	58141/udp	0.001004
unknown	58154/udp	0.000502
unknown	58162/udp	0.000502
unknown	58164/tcp	0.000076
unknown	58167/udp	0.000502
unknown	58176/udp	0.000502
unknown	58178/udp	0.001506
unknown	58179/udp	0.000502
unknown	58182/udp	0.000502
unknown	58183/udp	0.000502
unknown	58184/udp	0.000502
unknown	58185/udp	0.000502
unknown	58187/udp	0.000502
unknown	58189/udp	0.000502
unknown	58201/udp	0.000502
unknown	58205/udp	0.001004
unknown	58219/udp	0.000502
unknown	58224/udp	0.000502
unknown	58228/udp	0.000502
unknown	58229/udp	0.000502
unknown	58235/udp	0.000502
unknown	58236/udp	0.000502
unknown	58241/udp	0.000502
unknown	58244/udp	0.000502
unknown	58248/udp	0.000502
unknown	58252/tcp	0.000076
unknown	58252/udp	0.000502
unknown	58254/udp	0.000502
unknown	58261/udp	0.000502
unknown	58262/udp	0.000502
unknown	58266/udp	0.000502
unknown	58279/udp	0.000502
unknown	58293/udp	0.000502
unknown	58302/udp	0.000502
unknown	58305/tcp	0.000076
unknown	58306/udp	0.000502
unknown	58308/udp	0.001004
unknown	58310/tcp	0.000076
unknown	58314/udp	0.000502
unknown	58315/udp	0.000502
unknown	58318/udp	0.000502
unknown	58327/udp	0.000502
unknown	58328/udp	0.000502
unknown	58334/udp	0.000502
unknown	58347/udp	0.000502
unknown	58348/udp	0.000502
unknown	58349/udp	0.000502
unknown	58350/udp	0.000502
unknown	58352/udp	0.000502
unknown	58353/udp	0.000502
unknown	58358/udp	0.000502
unknown	58363/udp	0.000502
unknown	58364/udp	0.000502
unknown	58369/udp	0.001004
unknown	58371/udp	0.000502
unknown	58374/tcp	0.000076
unknown	58390/udp	0.000502
unknown	58391/udp	0.000502
unknown	58395/udp	0.000502
unknown	58401/udp	0.000502
unknown	58402/udp	0.000502
unknown	58408/udp	0.000502
unknown	58416/udp	0.000502
unknown	58419/udp	0.001506
unknown	58427/udp	0.000502
unknown	58430/tcp	0.000076
unknown	58432/udp	0.001004
unknown	58441/udp	0.000502
unknown	58442/udp	0.000502
unknown	58446/tcp	0.000076
unknown	58446/udp	0.000502
unknown	58455/udp	0.001004
unknown	58456/tcp	0.000076
unknown	58463/udp	0.000502
unknown	58465/udp	0.000502
unknown	58468/tcp	0.000076
unknown	58478/udp	0.000502
unknown	58479/udp	0.000502
unknown	58486/udp	0.000502
unknown	58498/tcp	0.000076
unknown	58504/udp	0.000502
unknown	58525/udp	0.000502
unknown	58526/udp	0.000502
unknown	58528/udp	0.000502
unknown	58537/udp	0.000502
unknown	58546/udp	0.000502
unknown	58549/udp	0.000502
unknown	58558/udp	0.000502
unknown	58561/udp	0.000502
unknown	58562/tcp	0.000076
unknown	58570/tcp	0.000076
unknown	58571/udp	0.000502
unknown	58572/udp	0.000502
unknown	58576/udp	0.000502
unknown	58577/udp	0.000502
unknown	58580/udp	0.000502
unknown	58584/udp	0.000502
unknown	58589/udp	0.000502
unknown	58590/udp	0.000502
unknown	58596/udp	0.000502
unknown	58606/udp	0.000502
unknown	58609/udp	0.000502
unknown	58610/tcp	0.000076
unknown	58614/udp	0.000502
unknown	58618/udp	0.000502
unknown	58620/udp	0.000502
unknown	58622/tcp	0.000076
unknown	58627/udp	0.000502
unknown	58629/udp	0.000502
unknown	58630/tcp	0.000152
unknown	58630/udp	0.000502
unknown	58631/udp	0.002008
unknown	58632/tcp	0.000152
unknown	58632/udp	0.000502
unknown	58634/tcp	0.000076
unknown	58640/udp	0.002008
unknown	58646/udp	0.001004
unknown	58648/udp	0.000502
unknown	58649/udp	0.000502
unknown	58654/udp	0.000502
unknown	58655/udp	0.000502
unknown	58657/udp	0.000502
unknown	58658/udp	0.000502
unknown	58667/udp	0.000502
unknown	58670/udp	0.000502
unknown	58672/udp	0.000502
unknown	58674/udp	0.001004
unknown	58686/udp	0.000502
unknown	58690/udp	0.000502
unknown	58691/udp	0.000502
unknown	58697/udp	0.000502
unknown	58698/udp	0.000502
unknown	58699/tcp	0.000076
unknown	58700/udp	0.001004
unknown	58703/udp	0.000502
unknown	58705/udp	0.001004
unknown	58710/udp	0.000502
unknown	58713/udp	0.000502
unknown	58715/udp	0.000502
unknown	58721/tcp	0.000076
unknown	58722/udp	0.000502
unknown	58728/udp	0.000502
unknown	58731/udp	0.000502
unknown	58733/udp	0.000502
unknown	58742/udp	0.000502
unknown	58744/udp	0.000502
unknown	58747/udp	0.001004
unknown	58761/udp	0.000502
unknown	58768/udp	0.000502
unknown	58772/udp	0.000502
unknown	58776/udp	0.000502
unknown	58777/udp	0.001004
unknown	58782/udp	0.001004
unknown	58786/udp	0.000502
unknown	58793/udp	0.000502
unknown	58795/udp	0.000502
unknown	58797/udp	0.001506
unknown	58803/udp	0.000502
unknown	58814/udp	0.000502
unknown	58817/udp	0.001004
unknown	58828/udp	0.000502
unknown	58831/udp	0.000502
unknown	58838/tcp	0.000152
unknown	58838/udp	0.000502
unknown	58839/udp	0.000502
unknown	58845/udp	0.000502
unknown	58847/udp	0.000502
unknown	58848/udp	0.000502
unknown	58866/udp	0.000502
unknown	58871/udp	0.000502
unknown	58876/udp	0.000502
unknown	58880/udp	0.000502
unknown	58891/udp	0.000502
unknown	58892/udp	0.000502
unknown	58893/udp	0.001004
unknown	58899/udp	0.000502
unknown	58903/udp	0.000502
unknown	58908/tcp	0.000076
unknown	58911/udp	0.000502
unknown	58914/udp	0.001004
unknown	58925/udp	0.000502
unknown	58926/udp	0.000502
unknown	58929/udp	0.001004
unknown	58931/udp	0.000502
unknown	58933/udp	0.000502
unknown	58937/udp	0.000502
unknown	58938/udp	0.001004
unknown	58943/udp	0.000502
unknown	58944/udp	0.000502
unknown	58952/udp	0.000502
unknown	58954/udp	0.000502
unknown	58960/udp	0.000502
unknown	58964/udp	0.000502
unknown	58966/udp	0.000502
unknown	58970/tcp	0.000076
unknown	58970/udp	0.000502
unknown	58972/udp	0.000502
unknown	58975/udp	0.001004
unknown	58988/udp	0.000502
unknown	58991/tcp	0.000076
unknown	59002/udp	0.001004
unknown	59014/udp	0.000502
unknown	59016/udp	0.000502
unknown	59023/udp	0.000502
unknown	59035/udp	0.001004
unknown	59037/udp	0.001004
unknown	59039/udp	0.000502
unknown	59045/udp	0.000502
unknown	59047/udp	0.000502
unknown	59055/udp	0.000502
unknown	59079/udp	0.000502
unknown	59083/udp	0.000502
unknown	59087/tcp	0.000076
unknown	59090/udp	0.000502
unknown	59093/udp	0.001004
unknown	59097/udp	0.000502
unknown	59101/udp	0.000502
unknown	59107/tcp	0.000076
unknown	59110/tcp	0.000152
unknown	59116/udp	0.000502
unknown	59122/tcp	0.000076
unknown	59128/udp	0.000502
unknown	59130/udp	0.000502
unknown	59131/udp	0.000502
unknown	59132/udp	0.001004
unknown	59134/udp	0.000502
unknown	59138/udp	0.000502
unknown	59140/udp	0.000502
unknown	59141/udp	0.000502
unknown	59149/tcp	0.000076
unknown	59158/udp	0.000502
unknown	59159/udp	0.000502
unknown	59160/tcp	0.000076
unknown	59166/udp	0.000502
unknown	59179/udp	0.000502
unknown	59184/udp	0.000502
unknown	59186/udp	0.001004
unknown	59189/udp	0.001004
unknown	59191/tcp	0.000076
unknown	59193/udp	0.001506
unknown	59196/udp	0.000502
unknown	59200/tcp	0.000152
unknown	59201/tcp	0.000152
unknown	59202/tcp	0.000152
unknown	59205/udp	0.000502
unknown	59207/udp	0.001506
unknown	59209/udp	0.000502
unknown	59212/udp	0.000502
unknown	59214/udp	0.001004
unknown	59215/udp	0.000502
unknown	59216/udp	0.001004
unknown	59223/udp	0.000502
unknown	59231/udp	0.000502
unknown	59239/tcp	0.000076
unknown	59239/udp	0.000502
unknown	59253/udp	0.000502
unknown	59254/udp	0.001004
unknown	59256/udp	0.000502
unknown	59258/udp	0.000502
unknown	59260/udp	0.000502
unknown	59265/udp	0.000502
unknown	59267/udp	0.000502
unknown	59272/udp	0.000502
unknown	59279/udp	0.000502
unknown	59282/udp	0.000502
unknown	59295/udp	0.000502
unknown	59296/udp	0.001004
unknown	59301/udp	0.001004
unknown	59303/udp	0.000502
unknown	59324/udp	0.000502
unknown	59327/udp	0.001004
unknown	59328/udp	0.000502
unknown	59335/udp	0.000502
unknown	59340/tcp	0.000076
unknown	59351/udp	0.000502
unknown	59356/udp	0.000502
unknown	59357/udp	0.000502
unknown	59360/udp	0.000502
unknown	59361/udp	0.000502
unknown	59364/udp	0.000502
unknown	59369/udp	0.000502
unknown	59371/udp	0.000502
unknown	59372/udp	0.000502
unknown	59380/udp	0.000502
unknown	59388/udp	0.001004
unknown	59390/udp	0.000502
unknown	59392/udp	0.000502
unknown	59398/udp	0.000502
unknown	59401/udp	0.000502
unknown	59415/udp	0.001004
unknown	59434/udp	0.001004
unknown	59435/udp	0.000502
unknown	59439/udp	0.000502
unknown	59447/udp	0.000502
unknown	59449/udp	0.000502
unknown	59450/udp	0.000502
unknown	59452/udp	0.000502
unknown	59453/udp	0.000502
unknown	59454/udp	0.000502
unknown	59461/udp	0.000502
unknown	59465/udp	0.000502
unknown	59468/udp	0.000502
unknown	59473/udp	0.000502
unknown	59482/udp	0.000502
unknown	59483/udp	0.001004
unknown	59484/udp	0.000502
unknown	59486/udp	0.000502
unknown	59487/udp	0.000502
unknown	59488/udp	0.000502
unknown	59490/udp	0.000502
unknown	59495/udp	0.000502
unknown	59497/udp	0.000502
unknown	59499/tcp	0.000076
unknown	59500/udp	0.000502
unknown	59504/tcp	0.000076
unknown	59506/udp	0.001004
unknown	59509/tcp	0.000076
unknown	59510/tcp	0.000076
unknown	59516/udp	0.000502
unknown	59525/tcp	0.000076
unknown	59554/udp	0.000502
unknown	59555/udp	0.001004
unknown	59563/udp	0.000502
unknown	59564/udp	0.000502
unknown	59565/tcp	0.000076
unknown	59573/udp	0.000502
unknown	59574/udp	0.000502
unknown	59576/udp	0.000502
unknown	59577/udp	0.001004
unknown	59580/udp	0.000502
unknown	59581/udp	0.001004
unknown	59586/udp	0.000502
unknown	59589/udp	0.000502
unknown	59593/udp	0.001004
unknown	59595/udp	0.000502
unknown	59598/udp	0.000502
unknown	59603/udp	0.001004
unknown	59607/udp	0.000502
unknown	59608/udp	0.000502
unknown	59609/udp	0.000502
unknown	59620/udp	0.000502
unknown	59625/udp	0.000502
unknown	59632/udp	0.001004
unknown	59637/udp	0.000502
unknown	59640/udp	0.000502
unknown	59646/udp	0.000502
unknown	59659/udp	0.000502
unknown	59669/udp	0.001004
unknown	59672/udp	0.000502
unknown	59683/udp	0.000502
unknown	59684/tcp	0.000076
unknown	59684/udp	0.000502
unknown	59688/udp	0.000502
unknown	59689/udp	0.000502
unknown	59691/udp	0.000502
unknown	59701/udp	0.000502
unknown	59709/udp	0.000502
unknown	59710/udp	0.000502
unknown	59715/udp	0.000502
unknown	59727/udp	0.000502
unknown	59734/udp	0.000502
unknown	59743/udp	0.000502
unknown	59747/udp	0.000502
unknown	59757/udp	0.000502
unknown	59758/udp	0.001004
unknown	59762/udp	0.000502
unknown	59763/udp	0.000502
unknown	59764/udp	0.000502
unknown	59765/udp	0.001506
unknown	59766/udp	0.000502
unknown	59767/udp	0.000502
unknown	59768/udp	0.000502
unknown	59769/udp	0.000502
unknown	59778/tcp	0.000076
unknown	59781/udp	0.000502
unknown	59790/udp	0.000502
unknown	59791/udp	0.001004
unknown	59794/udp	0.000502
unknown	59797/udp	0.000502
unknown	59798/udp	0.000502
unknown	59805/udp	0.001004
unknown	59809/udp	0.000502
unknown	59810/tcp	0.000076
unknown	59829/tcp	0.000076
unknown	59834/udp	0.000502
unknown	59835/udp	0.000502
unknown	59836/udp	0.000502
unknown	59841/tcp	0.000076
unknown	59846/udp	0.001506
unknown	59847/udp	0.000502
unknown	59853/udp	0.000502
unknown	59860/udp	0.001004
unknown	59874/udp	0.000502
unknown	59883/udp	0.000502
unknown	59884/udp	0.000502
unknown	59885/udp	0.000502
unknown	59888/udp	0.000502
unknown	59891/udp	0.000502
unknown	59897/udp	0.000502
unknown	59902/udp	0.000502
unknown	59919/udp	0.000502
unknown	59925/udp	0.000502
unknown	59928/udp	0.000502
unknown	59933/udp	0.000502
unknown	59934/udp	0.000502
unknown	59935/udp	0.000502
unknown	59943/udp	0.001004
unknown	59948/udp	0.000502
unknown	59949/udp	0.000502
unknown	59951/udp	0.000502
unknown	59952/udp	0.000502
unknown	59960/udp	0.000502
unknown	59966/udp	0.000502
unknown	59969/udp	0.000502
unknown	59971/udp	0.001004
unknown	59984/udp	0.000502
unknown	59987/tcp	0.000076
unknown	59987/udp	0.000502
unknown	59992/udp	0.000502
unknown	59995/udp	0.000502
unknown	59998/udp	0.001004
unknown	60000/tcp	0.000076
unknown	60001/udp	0.000502
unknown	60002/tcp	0.000076
unknown	60003/tcp	0.000076
unknown	60004/udp	0.000502
unknown	60020/tcp	0.000380
unknown	60025/udp	0.000502
unknown	60028/udp	0.001004
unknown	60032/udp	0.000502
unknown	60035/udp	0.001004
unknown	60037/udp	0.000502
unknown	60041/udp	0.000502
unknown	60043/udp	0.000502
unknown	60048/udp	0.000502
unknown	60052/udp	0.000502
unknown	60055/tcp	0.000076
unknown	60055/udp	0.000502
unknown	60062/udp	0.000502
unknown	60067/udp	0.000502
unknown	60069/udp	0.001004
unknown	60071/udp	0.000502
unknown	60075/udp	0.000502
unknown	60076/udp	0.000502
unknown	60086/tcp	0.000076
unknown	60095/udp	0.000502
unknown	60097/udp	0.001004
unknown	60105/udp	0.000502
unknown	60111/tcp	0.000076
unknown	60119/udp	0.000502
unknown	60123/tcp	0.000152
unknown	60126/udp	0.000502
unknown	60129/udp	0.000502
unknown	60130/udp	0.000502
unknown	60134/udp	0.000502
unknown	60138/udp	0.000502
unknown	60140/udp	0.000502
unknown	60142/udp	0.000502
unknown	60145/udp	0.001004
unknown	60146/tcp	0.000152
unknown	60147/udp	0.000502
unknown	60148/udp	0.000502
unknown	60150/udp	0.000502
unknown	60152/udp	0.000502
unknown	60154/udp	0.000502
unknown	60160/udp	0.000502
unknown	60164/udp	0.000502
unknown	60170/udp	0.000502
unknown	60171/udp	0.000502
unknown	60172/udp	0.001506
unknown	60177/tcp	0.000076
unknown	60191/udp	0.000502
unknown	60203/udp	0.000502
unknown	60214/udp	0.000502
unknown	60216/udp	0.000502
unknown	60227/tcp	0.000076
unknown	60227/udp	0.001004
unknown	60236/udp	0.000502
unknown	60240/udp	0.000502
unknown	60243/tcp	0.000076
unknown	60243/udp	0.000502
unknown	60244/udp	0.000502
unknown	60246/udp	0.000502
unknown	60247/udp	0.000502
unknown	60250/udp	0.000502
unknown	60255/udp	0.001004
unknown	60256/udp	0.000502
unknown	60268/udp	0.000502
unknown	60279/tcp	0.000076
unknown	60288/udp	0.000502
unknown	60291/udp	0.000502
unknown	60292/udp	0.000502
unknown	60299/udp	0.000502
unknown	60316/udp	0.000502
unknown	60322/udp	0.000502
unknown	60326/udp	0.000502
unknown	60331/udp	0.000502
unknown	60341/udp	0.001004
unknown	60347/udp	0.001004
unknown	60354/udp	0.000502
unknown	60356/udp	0.000502
unknown	60360/udp	0.000502
unknown	60363/udp	0.001004
unknown	60365/udp	0.000502
unknown	60369/udp	0.000502
unknown	60370/udp	0.000502
unknown	60376/udp	0.000502
unknown	60377/tcp	0.000076
unknown	60381/udp	0.001506
unknown	60383/udp	0.000502
unknown	60384/udp	0.001004
unknown	60401/tcp	0.000076
unknown	60401/udp	0.000502
unknown	60403/tcp	0.000076
unknown	60404/udp	0.000502
unknown	60406/udp	0.000502
unknown	60423/udp	0.001506
unknown	60430/udp	0.001004
unknown	60431/udp	0.001004
unknown	60433/udp	0.000502
unknown	60435/udp	0.001004
unknown	60436/udp	0.000502
unknown	60438/udp	0.001004
unknown	60443/tcp	0.000228
unknown	60449/udp	0.000502
unknown	60454/udp	0.000502
unknown	60455/udp	0.000502
unknown	60462/udp	0.000502
unknown	60472/udp	0.000502
unknown	60485/tcp	0.000076
unknown	60491/udp	0.000502
unknown	60492/tcp	0.000076
unknown	60493/udp	0.000502
unknown	60504/tcp	0.000076
unknown	60517/udp	0.000502
unknown	60522/udp	0.000502
unknown	60528/udp	0.000502
unknown	60544/tcp	0.000076
unknown	60546/udp	0.000502
unknown	60548/udp	0.000502
unknown	60550/udp	0.000502
unknown	60557/udp	0.000502
unknown	60575/udp	0.000502
unknown	60578/udp	0.000502
unknown	60579/tcp	0.000076
unknown	60579/udp	0.000502
unknown	60587/udp	0.000502
unknown	60594/udp	0.000502
unknown	60598/udp	0.000502
unknown	60606/udp	0.000502
unknown	60612/tcp	0.000076
unknown	60613/udp	0.000502
unknown	60618/udp	0.000502
unknown	60621/tcp	0.000076
unknown	60628/tcp	0.000076
unknown	60629/udp	0.000502
unknown	60630/udp	0.000502
unknown	60631/udp	0.000502
unknown	60640/udp	0.000502
unknown	60642/tcp	0.000152
unknown	60650/udp	0.001004
unknown	60655/udp	0.000502
unknown	60662/udp	0.000502
unknown	60665/udp	0.000502
unknown	60675/udp	0.000502
unknown	60677/udp	0.000502
unknown	60678/udp	0.000502
unknown	60679/udp	0.001004
unknown	60683/udp	0.000502
unknown	60696/udp	0.000502
unknown	60700/udp	0.000502
unknown	60701/udp	0.001004
unknown	60704/udp	0.000502
unknown	60705/udp	0.001004
unknown	60707/udp	0.001004
unknown	60712/udp	0.000502
unknown	60713/tcp	0.000076
unknown	60715/udp	0.000502
unknown	60716/udp	0.000502
unknown	60727/udp	0.000502
unknown	60728/tcp	0.000076
unknown	60731/udp	0.000502
unknown	60735/udp	0.000502
unknown	60743/tcp	0.000076
unknown	60748/udp	0.000502
unknown	60753/tcp	0.000076
unknown	60754/udp	0.000502
unknown	60768/udp	0.000502
unknown	60774/udp	0.000502
unknown	60775/udp	0.000502
unknown	60778/udp	0.000502
unknown	60781/udp	0.000502
unknown	60782/tcp	0.000076
unknown	60783/tcp	0.000076
unknown	60789/tcp	0.000076
unknown	60791/udp	0.000502
unknown	60792/udp	0.000502
unknown	60794/tcp	0.000076
unknown	60799/udp	0.000502
unknown	60803/udp	0.000502
unknown	60822/udp	0.000502
unknown	60824/udp	0.000502
unknown	60831/udp	0.000502
unknown	60833/udp	0.000502
unknown	60842/udp	0.000502
unknown	60846/udp	0.000502
unknown	60848/udp	0.000502
unknown	60856/udp	0.000502
unknown	60861/udp	0.000502
unknown	60863/udp	0.000502
unknown	60872/udp	0.000502
unknown	60873/udp	0.000502
unknown	60878/udp	0.000502
unknown	60880/udp	0.000502
unknown	60883/udp	0.000502
unknown	60885/udp	0.000502
unknown	60889/udp	0.000502
unknown	60890/udp	0.000502
unknown	60899/udp	0.000502
unknown	60912/udp	0.000502
unknown	60922/udp	0.000502
unknown	60925/udp	0.000502
unknown	60936/udp	0.000502
unknown	60937/udp	0.000502
unknown	60941/udp	0.000502
unknown	60948/udp	0.000502
unknown	60950/udp	0.001004
unknown	60963/udp	0.000502
unknown	60966/udp	0.001004
unknown	60973/udp	0.000502
unknown	60988/udp	0.001004
unknown	60989/tcp	0.000076
unknown	60990/udp	0.000502
unknown	60996/udp	0.000502
unknown	60998/udp	0.000502
unknown	61000/udp	0.000502
unknown	61001/udp	0.000502
unknown	61003/udp	0.000502
unknown	61005/udp	0.000502
unknown	61006/udp	0.000502
unknown	61016/udp	0.000502
unknown	61020/udp	0.000502
unknown	61024/udp	0.001506
unknown	61027/udp	0.001004
unknown	61032/udp	0.000502
unknown	61038/udp	0.000502
unknown	61042/udp	0.000502
unknown	61046/udp	0.001004
unknown	61047/udp	0.001004
unknown	61048/udp	0.000502
unknown	61050/udp	0.001004
unknown	61054/udp	0.000502
unknown	61055/udp	0.001004
unknown	61081/udp	0.001004
unknown	61086/udp	0.000502
unknown	61095/udp	0.001004
unknown	61100/udp	0.000502
unknown	61107/udp	0.000502
unknown	61125/udp	0.000502
unknown	61127/udp	0.001004
unknown	61128/udp	0.000502
unknown	61130/udp	0.000502
unknown	61137/udp	0.000502
unknown	61142/udp	0.001506
unknown	61149/udp	0.000502
unknown	61151/udp	0.000502
unknown	61159/tcp	0.000076
unknown	61163/udp	0.000502
unknown	61167/udp	0.001004
unknown	61169/tcp	0.000076
unknown	61170/tcp	0.000076
unknown	61171/udp	0.000502
unknown	61188/udp	0.000502
unknown	61192/udp	0.001004
unknown	61193/udp	0.001004
unknown	61198/udp	0.000502
unknown	61202/udp	0.000502
unknown	61207/udp	0.000502
unknown	61210/udp	0.000502
unknown	61213/udp	0.000502
unknown	61219/udp	0.000502
unknown	61226/udp	0.001004
unknown	61233/udp	0.000502
unknown	61244/udp	0.000502
unknown	61260/udp	0.000502
unknown	61265/udp	0.000502
unknown	61269/udp	0.000502
unknown	61270/udp	0.000502
unknown	61277/udp	0.000502
unknown	61278/udp	0.000502
unknown	61284/udp	0.000502
unknown	61294/udp	0.000502
unknown	61301/udp	0.000502
unknown	61309/udp	0.000502
unknown	61315/udp	0.000502
unknown	61318/udp	0.000502
unknown	61319/udp	0.001506
unknown	61321/udp	0.000502
unknown	61322/udp	0.001506
unknown	61338/udp	0.000502
unknown	61348/udp	0.000502
unknown	61349/udp	0.000502
unknown	61364/udp	0.000502
unknown	61370/udp	0.002008
unknown	61371/udp	0.000502
unknown	61373/udp	0.000502
unknown	61374/udp	0.000502
unknown	61381/udp	0.001004
unknown	61389/udp	0.000502
unknown	61393/udp	0.000502
unknown	61395/udp	0.001004
unknown	61397/udp	0.000502
unknown	61400/udp	0.001004
unknown	61401/udp	0.000502
unknown	61402/tcp	0.000076
unknown	61405/udp	0.000502
unknown	61408/udp	0.000502
unknown	61411/udp	0.000502
unknown	61412/udp	0.001506
unknown	61414/udp	0.000502
unknown	61418/udp	0.000502
unknown	61420/udp	0.000502
unknown	61422/udp	0.001004
unknown	61427/udp	0.000502
unknown	61431/udp	0.001004
unknown	61435/udp	0.000502
unknown	61438/udp	0.001004
unknown	61448/udp	0.000502
unknown	61452/udp	0.000502
unknown	61455/udp	0.000502
unknown	61456/udp	0.000502
unknown	61458/udp	0.000502
unknown	61463/udp	0.000502
unknown	61466/udp	0.000502
unknown	61473/tcp	0.000076
unknown	61480/udp	0.001004
unknown	61481/udp	0.001506
unknown	61483/udp	0.000502
unknown	61484/udp	0.000502
unknown	61485/udp	0.001004
unknown	61492/udp	0.000502
unknown	61493/udp	0.000502
unknown	61494/udp	0.000502
unknown	61497/udp	0.000502
unknown	61500/udp	0.000502
unknown	61501/udp	0.000502
unknown	61508/udp	0.000502
unknown	61512/udp	0.001004
unknown	61516/tcp	0.000076
unknown	61518/udp	0.000502
unknown	61523/udp	0.001004
unknown	61524/udp	0.000502
unknown	61527/udp	0.000502
unknown	61529/udp	0.000502
unknown	61532/tcp	0.000304
unknown	61532/udp	0.001004
unknown	61539/udp	0.001004
unknown	61542/udp	0.000502
unknown	61550/udp	0.001506
unknown	61551/udp	0.000502
unknown	61553/udp	0.000502
unknown	61554/udp	0.000502
unknown	61556/udp	0.000502
unknown	61574/udp	0.000502
unknown	61579/udp	0.000502
unknown	61586/udp	0.000502
unknown	61587/udp	0.001004
unknown	61590/udp	0.000502
unknown	61601/udp	0.000502
unknown	61613/tcp	0.000152
unknown	61616/tcp	0.000076
unknown	61617/tcp	0.000076
unknown	61623/udp	0.000502
unknown	61635/udp	0.000502
unknown	61638/udp	0.000502
unknown	61652/udp	0.000502
unknown	61653/udp	0.001004
unknown	61654/udp	0.000502
unknown	61667/udp	0.000502
unknown	61669/tcp	0.000076
unknown	61678/udp	0.001004
unknown	61681/udp	0.000502
unknown	61685/udp	0.001506
unknown	61687/udp	0.000502
unknown	61688/udp	0.000502
unknown	61695/udp	0.000502
unknown	61703/udp	0.000502
unknown	61707/udp	0.000502
unknown	61709/udp	0.001004
unknown	61716/udp	0.000502
unknown	61722/tcp	0.000076
unknown	61734/tcp	0.000076
unknown	61748/udp	0.000502
unknown	61753/udp	0.000502
unknown	61756/udp	0.000502
unknown	61762/udp	0.000502
unknown	61764/udp	0.000502
unknown	61774/udp	0.000502
unknown	61781/udp	0.001004
unknown	61783/udp	0.000502
unknown	61784/udp	0.000502
unknown	61786/udp	0.000502
unknown	61790/udp	0.000502
unknown	61794/udp	0.000502
unknown	61795/udp	0.000502
unknown	61802/udp	0.000502
unknown	61804/udp	0.000502
unknown	61815/udp	0.000502
unknown	61818/udp	0.000502
unknown	61821/udp	0.000502
unknown	61825/udp	0.000502
unknown	61827/tcp	0.000076
unknown	61828/udp	0.001004
unknown	61834/udp	0.000502
unknown	61838/udp	0.000502
unknown	61848/udp	0.000502
unknown	61851/tcp	0.000076
unknown	61862/udp	0.000502
unknown	61867/udp	0.001004
unknown	61876/udp	0.000502
unknown	61886/udp	0.000502
unknown	61893/udp	0.000502
unknown	61894/udp	0.000502
unknown	61900/tcp	0.000304
unknown	61902/udp	0.001004
unknown	61906/udp	0.000502
unknown	61921/udp	0.001004
unknown	61936/udp	0.000502
unknown	61937/udp	0.001004
unknown	61942/tcp	0.000076
unknown	61943/udp	0.000502
unknown	61951/udp	0.000502
unknown	61956/udp	0.000502
unknown	61957/udp	0.000502
unknown	61960/udp	0.000502
unknown	61961/udp	0.001506
unknown	61965/udp	0.000502
unknown	61967/udp	0.001004
unknown	61973/udp	0.001004
unknown	61980/udp	0.000502
unknown	61983/udp	0.001004
unknown	61987/udp	0.000502
unknown	61989/udp	0.000502
unknown	61995/udp	0.000502
unknown	61997/udp	0.000502
unknown	62000/udp	0.000502
unknown	62005/udp	0.000502
unknown	62006/tcp	0.000076
unknown	62009/udp	0.000502
unknown	62011/udp	0.000502
unknown	62017/udp	0.000502
unknown	62023/udp	0.000502
unknown	62026/udp	0.000502
unknown	62038/udp	0.001004
unknown	62039/udp	0.000502
unknown	62042/tcp	0.000076
unknown	62046/udp	0.000502
unknown	62053/udp	0.000502
unknown	62056/udp	0.000502
unknown	62064/udp	0.000502
unknown	62070/udp	0.000502
unknown	62071/udp	0.000502
unknown	62072/udp	0.000502
unknown	62074/udp	0.000502
iphone-sync	62078/tcp	0.000304	# Apparently used by iPhone while syncing - http://code.google.com/p/iphone-elite/source/browse/wiki/Port_62078.wiki
unknown	62080/tcp	0.000076
unknown	62083/udp	0.000502
unknown	62086/udp	0.000502
unknown	62089/udp	0.000502
unknown	62090/udp	0.000502
unknown	62092/udp	0.000502
unknown	62100/udp	0.001004
unknown	62101/udp	0.001004
unknown	62111/udp	0.000502
unknown	62114/udp	0.001004
unknown	62116/udp	0.000502
unknown	62132/udp	0.000502
unknown	62133/udp	0.001004
unknown	62143/udp	0.000502
unknown	62146/udp	0.000502
unknown	62152/udp	0.000502
unknown	62154/udp	0.001506
unknown	62164/udp	0.001004
unknown	62165/udp	0.000502
unknown	62166/udp	0.000502
unknown	62170/udp	0.000502
unknown	62178/udp	0.000502
unknown	62181/udp	0.000502
unknown	62187/udp	0.000502
unknown	62188/tcp	0.000076
unknown	62188/udp	0.001004
unknown	62200/udp	0.000502
unknown	62201/udp	0.000502
unknown	62203/udp	0.000502
unknown	62211/udp	0.000502
unknown	62214/udp	0.000502
unknown	62215/udp	0.000502
unknown	62216/udp	0.001004
unknown	62218/udp	0.000502
unknown	62232/udp	0.000502
unknown	62233/udp	0.000502
unknown	62243/udp	0.000502
unknown	62245/udp	0.000502
unknown	62246/udp	0.000502
unknown	62250/udp	0.000502
unknown	62251/udp	0.000502
unknown	62256/udp	0.000502
unknown	62267/udp	0.000502
unknown	62270/udp	0.000502
unknown	62274/udp	0.000502
unknown	62281/udp	0.001004
unknown	62285/udp	0.000502
unknown	62287/udp	0.002008
unknown	62295/udp	0.000502
unknown	62302/udp	0.000502
unknown	62305/udp	0.000502
unknown	62312/tcp	0.000076
unknown	62312/udp	0.000502
unknown	62320/udp	0.000502
unknown	62321/udp	0.000502
unknown	62325/udp	0.001004
unknown	62345/udp	0.000502
unknown	62346/udp	0.000502
unknown	62362/udp	0.000502
unknown	62370/udp	0.000502
unknown	62377/udp	0.000502
unknown	62383/udp	0.000502
unknown	62385/udp	0.000502
unknown	62386/udp	0.000502
unknown	62392/udp	0.000502
unknown	62398/udp	0.000502
unknown	62404/udp	0.001004
unknown	62408/udp	0.000502
unknown	62412/udp	0.001004
unknown	62413/udp	0.000502
unknown	62418/udp	0.000502
unknown	62420/udp	0.001004
unknown	62424/udp	0.000502
unknown	62431/udp	0.000502
unknown	62435/udp	0.000502
unknown	62436/udp	0.001004
unknown	62440/udp	0.000502
unknown	62442/udp	0.000502
unknown	62449/udp	0.001004
unknown	62454/udp	0.000502
unknown	62458/udp	0.001004
unknown	62461/udp	0.000502
unknown	62466/udp	0.000502
unknown	62469/udp	0.000502
unknown	62477/udp	0.000502
unknown	62479/udp	0.000502
unknown	62484/udp	0.000502
unknown	62485/udp	0.000502
unknown	62493/udp	0.001004
unknown	62496/udp	0.000502
unknown	62511/udp	0.000502
unknown	62516/udp	0.000502
unknown	62518/udp	0.000502
unknown	62519/tcp	0.000076
unknown	62522/udp	0.001004
unknown	62526/udp	0.000502
unknown	62533/udp	0.000502
unknown	62534/udp	0.000502
unknown	62540/udp	0.000502
unknown	62544/udp	0.000502
unknown	62556/udp	0.000502
unknown	62562/udp	0.001004
unknown	62563/udp	0.000502
unknown	62566/udp	0.000502
unknown	62570/tcp	0.000076
unknown	62574/udp	0.000502
unknown	62575/udp	0.001506
unknown	62578/udp	0.000502
unknown	62581/udp	0.000502
unknown	62590/udp	0.000502
unknown	62599/udp	0.000502
unknown	62600/udp	0.000502
unknown	62604/udp	0.000502
unknown	62606/udp	0.000502
unknown	62612/udp	0.000502
unknown	62617/udp	0.000502
unknown	62621/udp	0.000502
unknown	62629/udp	0.000502
unknown	62630/udp	0.000502
unknown	62631/udp	0.000502
unknown	62635/udp	0.000502
unknown	62637/udp	0.000502
unknown	62647/udp	0.000502
unknown	62652/udp	0.000502
unknown	62658/udp	0.000502
unknown	62662/udp	0.000502
unknown	62671/udp	0.000502
unknown	62674/tcp	0.000076
unknown	62677/udp	0.001506
unknown	62678/udp	0.000502
unknown	62679/udp	0.000502
unknown	62680/udp	0.000502
unknown	62682/udp	0.000502
unknown	62689/udp	0.000502
unknown	62690/udp	0.001004
unknown	62697/udp	0.001004
unknown	62699/udp	0.001506
unknown	62701/udp	0.001004
unknown	62707/udp	0.000502
unknown	62708/udp	0.000502
unknown	62711/udp	0.000502
unknown	62725/udp	0.000502
unknown	62738/udp	0.000502
unknown	62760/udp	0.000502
unknown	62761/udp	0.000502
unknown	62764/udp	0.000502
unknown	62766/udp	0.000502
unknown	62778/udp	0.001004
unknown	62779/udp	0.000502
unknown	62783/udp	0.000502
unknown	62785/udp	0.000502
unknown	62788/udp	0.000502
unknown	62791/udp	0.000502
unknown	62820/udp	0.000502
unknown	62821/udp	0.000502
unknown	62822/udp	0.000502
unknown	62825/udp	0.000502
unknown	62827/udp	0.001004
unknown	62834/udp	0.000502
unknown	62841/udp	0.000502
unknown	62843/udp	0.000502
unknown	62845/udp	0.001004
unknown	62846/udp	0.000502
unknown	62856/udp	0.000502
unknown	62858/udp	0.000502
unknown	62866/tcp	0.000076
unknown	62866/udp	0.001004
unknown	62874/udp	0.000502
unknown	62878/udp	0.000502
unknown	62880/udp	0.001004
unknown	62884/udp	0.000502
unknown	62887/udp	0.000502
unknown	62888/udp	0.000502
unknown	62892/udp	0.000502
unknown	62902/udp	0.000502
unknown	62906/udp	0.000502
unknown	62909/udp	0.000502
unknown	62923/udp	0.000502
unknown	62933/udp	0.000502
unknown	62934/udp	0.000502
unknown	62935/udp	0.000502
unknown	62936/udp	0.000502
unknown	62937/udp	0.000502
unknown	62955/udp	0.001004
unknown	62957/udp	0.000502
unknown	62958/udp	0.001506
unknown	62962/udp	0.000502
unknown	62964/udp	0.000502
unknown	62965/udp	0.000502
unknown	62972/udp	0.000502
unknown	62973/udp	0.000502
unknown	62975/udp	0.001004
unknown	62982/udp	0.000502
unknown	62985/udp	0.000502
unknown	62993/udp	0.000502
unknown	62998/udp	0.000502
unknown	63000/udp	0.000502
unknown	63006/udp	0.001004
unknown	63014/udp	0.000502
unknown	63017/udp	0.000502
unknown	63021/udp	0.000502
unknown	63033/udp	0.000502
unknown	63036/udp	0.000502
unknown	63039/udp	0.000502
unknown	63049/udp	0.000502
unknown	63062/udp	0.000502
unknown	63067/udp	0.000502
unknown	63071/udp	0.000502
unknown	63073/udp	0.000502
unknown	63079/udp	0.001004
unknown	63086/udp	0.000502
unknown	63088/udp	0.000502
unknown	63089/udp	0.000502
unknown	63091/udp	0.000502
unknown	63092/udp	0.000502
unknown	63101/udp	0.001004
unknown	63105/tcp	0.000076
unknown	63106/udp	0.001004
unknown	63109/udp	0.000502
unknown	63112/udp	0.000502
unknown	63120/udp	0.000502
unknown	63129/udp	0.001004
unknown	63135/udp	0.000502
unknown	63136/udp	0.001004
unknown	63139/udp	0.000502
unknown	63143/udp	0.000502
unknown	63145/udp	0.000502
unknown	63146/udp	0.001004
unknown	63147/udp	0.000502
unknown	63149/udp	0.000502
unknown	63151/udp	0.000502
unknown	63156/tcp	0.000076
unknown	63160/udp	0.000502
unknown	63162/udp	0.000502
unknown	63172/udp	0.000502
unknown	63173/udp	0.001004
unknown	63176/udp	0.000502
unknown	63179/udp	0.000502
unknown	63186/udp	0.000502
unknown	63197/udp	0.000502
unknown	63203/udp	0.000502
unknown	63210/udp	0.000502
unknown	63211/udp	0.000502
unknown	63213/udp	0.000502
unknown	63217/udp	0.000502
unknown	63220/udp	0.000502
unknown	63231/udp	0.000502
unknown	63232/udp	0.000502
unknown	63237/udp	0.000502
unknown	63238/udp	0.000502
unknown	63246/udp	0.000502
unknown	63247/udp	0.001004
unknown	63251/udp	0.000502
unknown	63266/udp	0.000502
unknown	63270/udp	0.000502
unknown	63273/udp	0.000502
unknown	63278/udp	0.000502
unknown	63281/udp	0.001004
unknown	63289/udp	0.000502
unknown	63315/udp	0.000502
unknown	63318/udp	0.000502
unknown	63322/udp	0.000502
unknown	63325/udp	0.000502
unknown	63330/udp	0.000502
unknown	63331/tcp	0.000380
unknown	63331/udp	0.001004
unknown	63335/udp	0.000502
unknown	63336/udp	0.000502
unknown	63337/udp	0.001004
unknown	63343/udp	0.000502
unknown	63344/udp	0.001004
unknown	63346/udp	0.001004
unknown	63351/udp	0.000502
unknown	63356/udp	0.000502
unknown	63363/udp	0.000502
unknown	63366/udp	0.000502
unknown	63373/udp	0.000502
unknown	63385/udp	0.000502
unknown	63397/udp	0.000502
unknown	63398/udp	0.000502
unknown	63407/udp	0.000502
unknown	63409/udp	0.000502
unknown	63410/udp	0.000502
unknown	63411/udp	0.000502
unknown	63420/udp	0.001506
unknown	63423/tcp	0.000076
unknown	63423/udp	0.000502
unknown	63427/udp	0.000502
unknown	63446/udp	0.000502
unknown	63447/udp	0.001004
unknown	63449/udp	0.000502
unknown	63451/udp	0.000502
unknown	63461/udp	0.000502
unknown	63464/udp	0.000502
unknown	63466/udp	0.000502
unknown	63477/udp	0.000502
unknown	63481/udp	0.000502
unknown	63495/udp	0.000502
unknown	63499/udp	0.001004
unknown	63508/udp	0.001004
unknown	63514/udp	0.000502
unknown	63515/udp	0.000502
unknown	63517/udp	0.000502
unknown	63524/udp	0.000502
unknown	63532/udp	0.000502
unknown	63533/udp	0.000502
unknown	63534/udp	0.001004
unknown	63535/udp	0.000502
unknown	63543/udp	0.000502
unknown	63546/udp	0.000502
unknown	63555/udp	0.002008
unknown	63564/udp	0.000502
unknown	63566/udp	0.000502
unknown	63567/udp	0.000502
unknown	63574/udp	0.000502
unknown	63587/udp	0.000502
unknown	63595/udp	0.000502
unknown	63613/udp	0.000502
unknown	63614/udp	0.000502
unknown	63619/udp	0.000502
unknown	63625/udp	0.000502
unknown	63626/udp	0.000502
unknown	63632/udp	0.000502
unknown	63636/udp	0.000502
unknown	63638/udp	0.000502
unknown	63640/udp	0.000502
unknown	63644/udp	0.000502
unknown	63647/udp	0.000502
unknown	63656/udp	0.000502
unknown	63657/udp	0.000502
unknown	63661/udp	0.000502
unknown	63663/udp	0.000502
unknown	63664/udp	0.000502
unknown	63671/udp	0.000502
unknown	63673/udp	0.001004
unknown	63675/tcp	0.000076
unknown	63677/udp	0.000502
unknown	63678/udp	0.000502
unknown	63681/udp	0.000502
unknown	63682/udp	0.000502
unknown	63683/udp	0.000502
unknown	63686/udp	0.000502
unknown	63698/udp	0.000502
unknown	63700/udp	0.001004
unknown	63707/udp	0.000502
unknown	63710/udp	0.001004
unknown	63714/udp	0.000502
unknown	63715/udp	0.000502
unknown	63720/udp	0.000502
unknown	63721/udp	0.000502
unknown	63740/udp	0.000502
unknown	63747/udp	0.000502
unknown	63753/udp	0.000502
unknown	63757/udp	0.000502
unknown	63774/udp	0.000502
unknown	63776/udp	0.000502
unknown	63777/udp	0.000502
unknown	63786/udp	0.001004
unknown	63791/udp	0.000502
unknown	63793/udp	0.000502
unknown	63803/tcp	0.000076
unknown	63803/udp	0.000502
unknown	63814/udp	0.000502
unknown	63820/udp	0.001004
unknown	63823/udp	0.000502
unknown	63826/udp	0.000502
unknown	63830/udp	0.000502
unknown	63833/udp	0.000502
unknown	63835/udp	0.000502
unknown	63853/udp	0.000502
unknown	63856/udp	0.000502
unknown	63864/udp	0.000502
unknown	63874/udp	0.000502
unknown	63875/udp	0.000502
unknown	63877/udp	0.000502
unknown	63878/udp	0.000502
unknown	63879/udp	0.000502
unknown	63892/udp	0.000502
unknown	63901/udp	0.000502
unknown	63904/udp	0.000502
unknown	63906/udp	0.000502
unknown	63907/udp	0.000502
unknown	63914/udp	0.000502
unknown	63917/udp	0.001004
unknown	63930/udp	0.000502
unknown	63931/udp	0.000502
unknown	63942/udp	0.000502
unknown	63943/udp	0.000502
unknown	63946/udp	0.000502
unknown	63948/udp	0.000502
unknown	63951/udp	0.000502
unknown	63962/udp	0.001004
unknown	63966/udp	0.000502
unknown	63967/udp	0.000502
unknown	63973/udp	0.000502
unknown	63975/udp	0.000502
unknown	63983/udp	0.000502
unknown	63995/udp	0.000502
unknown	64006/udp	0.000502
unknown	64007/udp	0.000502
unknown	64012/udp	0.000502
unknown	64015/udp	0.000502
unknown	64016/udp	0.000502
unknown	64035/udp	0.000502
unknown	64042/udp	0.000502
unknown	64047/udp	0.000502
unknown	64053/udp	0.000502
unknown	64058/udp	0.000502
unknown	64065/udp	0.000502
unknown	64072/udp	0.000502
unknown	64080/tcp	0.000076
unknown	64080/udp	0.001506
unknown	64081/udp	0.000502
unknown	64083/udp	0.000502
unknown	64090/udp	0.000502
unknown	64113/udp	0.000502
unknown	64114/udp	0.000502
unknown	64118/udp	0.000502
unknown	64120/udp	0.000502
unknown	64123/udp	0.000502
unknown	64127/tcp	0.000076
unknown	64127/udp	0.000502
unknown	64130/udp	0.000502
unknown	64135/udp	0.000502
unknown	64139/udp	0.000502
unknown	64140/udp	0.000502
unknown	64150/udp	0.000502
unknown	64151/udp	0.000502
unknown	64161/udp	0.000502
unknown	64163/udp	0.000502
unknown	64165/udp	0.000502
unknown	64175/udp	0.000502
unknown	64183/udp	0.000502
unknown	64184/udp	0.000502
unknown	64187/udp	0.000502
unknown	64188/udp	0.000502
unknown	64198/udp	0.000502
unknown	64202/udp	0.001004
unknown	64215/udp	0.000502
unknown	64222/udp	0.000502
unknown	64225/udp	0.000502
unknown	64240/udp	0.000502
unknown	64244/udp	0.000502
unknown	64247/udp	0.000502
unknown	64252/udp	0.000502
unknown	64257/udp	0.000502
unknown	64258/udp	0.001004
unknown	64259/udp	0.001004
unknown	64273/udp	0.000502
unknown	64277/udp	0.000502
unknown	64280/udp	0.000502
unknown	64284/udp	0.001004
unknown	64286/udp	0.000502
unknown	64296/udp	0.000502
unknown	64312/udp	0.001004
unknown	64313/udp	0.001004
unknown	64320/tcp	0.000076
unknown	64325/udp	0.000502
unknown	64335/udp	0.000502
unknown	64337/udp	0.000502
unknown	64340/udp	0.001004
unknown	64341/udp	0.000502
unknown	64345/udp	0.001004
unknown	64348/udp	0.000502
unknown	64360/udp	0.000502
unknown	64363/udp	0.000502
unknown	64365/udp	0.001004
unknown	64367/udp	0.000502
unknown	64370/udp	0.000502
unknown	64401/udp	0.000502
unknown	64406/udp	0.001004
unknown	64410/udp	0.000502
unknown	64428/udp	0.000502
unknown	64430/udp	0.000502
unknown	64438/tcp	0.000076
unknown	64441/udp	0.000502
unknown	64442/udp	0.000502
unknown	64446/udp	0.000502
unknown	64447/udp	0.000502
unknown	64450/udp	0.000502
unknown	64456/udp	0.001004
unknown	64460/udp	0.000502
unknown	64461/udp	0.000502
unknown	64466/udp	0.000502
unknown	64469/udp	0.001004
unknown	64474/udp	0.000502
unknown	64481/udp	0.001506
unknown	64492/udp	0.001004
unknown	64493/udp	0.000502
unknown	64494/udp	0.000502
unknown	64507/tcp	0.000076
unknown	64511/udp	0.000502
unknown	64512/udp	0.000502
unknown	64513/udp	0.002008
unknown	64530/udp	0.000502
unknown	64533/udp	0.000502
unknown	64534/udp	0.000502
unknown	64536/udp	0.000502
unknown	64540/udp	0.000502
unknown	64541/udp	0.000502
unknown	64544/udp	0.001004
unknown	64550/udp	0.000502
unknown	64551/tcp	0.000076
unknown	64555/udp	0.000502
unknown	64556/udp	0.000502
unknown	64558/udp	0.000502
unknown	64566/udp	0.001004
unknown	64574/udp	0.000502
unknown	64576/udp	0.000502
unknown	64585/udp	0.000502
unknown	64589/udp	0.001004
unknown	64590/udp	0.001506
unknown	64612/udp	0.000502
unknown	64615/udp	0.001004
unknown	64616/udp	0.001004
unknown	64621/udp	0.000502
unknown	64623/tcp	0.000760
unknown	64625/udp	0.000502
unknown	64630/udp	0.001004
unknown	64636/udp	0.000502
unknown	64640/udp	0.001004
unknown	64644/udp	0.000502
unknown	64646/udp	0.000502
unknown	64647/udp	0.000502
unknown	64649/udp	0.000502
unknown	64652/udp	0.000502
unknown	64654/udp	0.000502
unknown	64657/udp	0.000502
unknown	64658/udp	0.000502
unknown	64660/udp	0.000502
unknown	64676/udp	0.000502
unknown	64680/tcp	0.000760
unknown	64682/udp	0.001004
unknown	64685/udp	0.000502
unknown	64693/udp	0.001004
unknown	64696/udp	0.000502
unknown	64709/udp	0.000502
unknown	64721/udp	0.000502
unknown	64726/tcp	0.000076
unknown	64726/udp	0.000502
unknown	64727/tcp	0.000076
unknown	64727/udp	0.001506
unknown	64729/udp	0.000502
unknown	64731/udp	0.000502
unknown	64735/udp	0.000502
unknown	64737/udp	0.000502
murmur	64738/udp	0.000502	# Murmur is the server-side software for Mumble open source voice chat software
unknown	64740/udp	0.000502
unknown	64743/udp	0.000502
unknown	64746/udp	0.000502
unknown	64750/udp	0.000502
unknown	64751/udp	0.000502
unknown	64755/udp	0.000502
unknown	64767/udp	0.000502
unknown	64772/udp	0.001004
unknown	64774/udp	0.000502
unknown	64778/udp	0.000502
unknown	64779/udp	0.000502
unknown	64795/udp	0.001004
unknown	64798/udp	0.001004
unknown	64800/udp	0.000502
unknown	64802/udp	0.000502
unknown	64811/udp	0.000502
unknown	64813/udp	0.000502
unknown	64815/udp	0.000502
unknown	64816/udp	0.000502
unknown	64817/udp	0.000502
unknown	64820/udp	0.000502
unknown	64829/udp	0.001004
unknown	64836/udp	0.000502
unknown	64840/udp	0.000502
unknown	64843/udp	0.000502
unknown	64846/udp	0.000502
unknown	64874/udp	0.001004
unknown	64875/udp	0.000502
unknown	64876/udp	0.000502
unknown	64878/udp	0.000502
unknown	64884/udp	0.001004
unknown	64889/udp	0.000502
unknown	64890/tcp	0.000076
unknown	64890/udp	0.001004
unknown	64892/udp	0.000502
unknown	64894/udp	0.000502
unknown	64916/udp	0.000502
unknown	64918/udp	0.000502
unknown	64921/udp	0.000502
unknown	64926/udp	0.000502
unknown	64939/udp	0.000502
unknown	64944/udp	0.001004
unknown	64949/udp	0.000502
unknown	64982/udp	0.000502
unknown	64998/udp	0.000502
unknown	65000/tcp	0.000760
unknown	65001/udp	0.000502
unknown	65002/udp	0.000502
unknown	65003/udp	0.000502
unknown	65018/udp	0.000502
unknown	65019/udp	0.000502
unknown	65024/udp	0.016064
unknown	65025/udp	0.000502
unknown	65030/udp	0.000502
unknown	65031/udp	0.000502
unknown	65043/udp	0.000502
unknown	65048/tcp	0.000076
unknown	65052/udp	0.000502
unknown	65053/udp	0.000502
unknown	65062/udp	0.000502
unknown	65066/udp	0.000502
unknown	65068/udp	0.000502
unknown	65073/udp	0.000502
unknown	65077/udp	0.000502
unknown	65080/udp	0.000502
unknown	65082/udp	0.000502
unknown	65087/udp	0.000502
unknown	65098/udp	0.000502
unknown	65101/udp	0.000502
unknown	65105/udp	0.001004
unknown	65113/udp	0.000502
unknown	65116/udp	0.000502
unknown	65122/udp	0.000502
unknown	65123/udp	0.000502
unknown	65124/udp	0.000502
unknown	65129/tcp	0.000380
unknown	65129/udp	0.000502
unknown	65152/udp	0.000502
unknown	65155/udp	0.000502
unknown	65159/udp	0.000502
unknown	65174/udp	0.000502
unknown	65176/udp	0.000502
unknown	65178/udp	0.000502
unknown	65199/udp	0.000502
unknown	65200/udp	0.000502
unknown	65214/udp	0.000502
unknown	65220/udp	0.000502
unknown	65227/udp	0.000502
unknown	65230/udp	0.000502
unknown	65232/udp	0.001004
unknown	65239/udp	0.000502
unknown	65248/udp	0.000502
unknown	65266/udp	0.000502
unknown	65274/udp	0.000502
unknown	65275/udp	0.000502
unknown	65276/udp	0.000502
unknown	65282/udp	0.000502
unknown	65286/udp	0.001004
unknown	65292/udp	0.000502
pcanywhere	65301/tcp	0.000025
unknown	65305/udp	0.000502
unknown	65310/tcp	0.000152
unknown	65310/udp	0.000502
unknown	65311/tcp	0.000076
unknown	65311/udp	0.000502
unknown	65312/udp	0.000502
unknown	65320/udp	0.000502
unknown	65324/udp	0.000502
unknown	65338/udp	0.000502
unknown	65347/udp	0.001004
unknown	65361/udp	0.000502
unknown	65363/udp	0.000502
unknown	65373/udp	0.000502
unknown	65376/udp	0.000502
unknown	65377/udp	0.000502
unknown	65380/udp	0.001004
unknown	65386/udp	0.000502
unknown	65389/tcp	0.000760
unknown	65392/udp	0.000502
unknown	65396/udp	0.001004
unknown	65397/udp	0.000502
unknown	65407/udp	0.000502
unknown	65419/udp	0.000502
unknown	65420/udp	0.001004
unknown	65421/udp	0.000502
unknown	65429/udp	0.000502
unknown	65434/udp	0.000502
unknown	65444/udp	0.000502
unknown	65451/udp	0.000502
unknown	65460/udp	0.001004
unknown	65469/udp	0.000502
unknown	65476/udp	0.000502
unknown	65483/udp	0.000502
unknown	65487/udp	0.000502
unknown	65488/tcp	0.000076
unknown	65492/udp	0.000502
unknown	65493/udp	0.000502
unknown	65498/udp	0.000502
unknown	65499/udp	0.000502
unknown	65501/udp	0.000502
unknown	65506/udp	0.000502
unknown	65512/udp	0.000502
unknown	65514/tcp	0.000076
unknown	65517/udp	0.000502
unknown	65520/udp	0.001004
unknown	65526/udp	0.000502
unknown	65530/udp	0.000502
unknown	65531/udp	0.000502
unknown	65532/udp	0.000502
