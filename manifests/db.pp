# == Class: mongodb::db
#
# Class for creating mongodb databases and users.
#
# == Parameters
#
#  user - Database username.
#  db_name - Database name. Defaults to $name.
#  password_hash - Hashed password. Hex encoded md5 hash of "$username:mongo:$password".
#  password - Plain text user password. This is UNSAFE, use 'password_hash' instead.
#  roles (default: ['dbAdmin']) - array with user roles.
#  tries (default: 10) - The maximum amount of two second tries to wait MongoDB startup.
#
define mongodb::db (
  String           $user,
  String           $db_name       = $name,
  Optional[String] $password_hash = undef,
  Optional[String] $password      = undef,
  Array[String]    $roles         = ['dbAdmin'],
  Integer[0]       $tries         = 10,
) {

  mongodb_database { $db_name:
    ensure => present,
    tries  => $tries,
  }

  if $password_hash {
  } elsif $password {
  } else {
    fail("Parameter 'password_hash' or 'password' should be provided to mongodb::db.")
  }

  if $db_name == 'admin' {
    mongodb_adminuser { "User ${user} on db ${db_name}":
      ensure        => present,
      password_hash => $password_hash,
      password      => $password,
      username      => $user,
      database      => $db_name,
      roles         => $roles,
    }
  }
  else {
    mongodb_user { "User ${user} on db ${db_name}":
      ensure        => present,
      password_hash => $password_hash,
      password      => $password,
      username      => $user,
      database      => $db_name,
      roles         => $roles,
    }
  }

}
