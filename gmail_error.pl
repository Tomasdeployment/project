#!/usr/bin/perl

use strict;
  use warnings;
  use Email::Send;
  use Email::Send::Gmail;
  use Email::Simple::Creator;


  my $email = Email::Simple->create(
      header => [
          From    => 'tomasmahony@gmail.com',
          To      => 'tomasmahony@gmail.com',
          Subject => 'there are problems with the site',
      ],
      body => 'Errors!',
  );
  
  my $sender = Email::Send->new(
      {   mailer      => 'Gmail',
          mailer_args => [
              username => 'tomasmahony@gmail.com',
              password => 'sheeba8383',
          ]
      }
  );
  eval { $sender->send($email) };

