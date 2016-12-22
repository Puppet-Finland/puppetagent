#
# == Class: puppetagent
#
# Class for configuring puppet agents. Does not handle puppet agent installation 
# due to a chicken-and-egg problem.
#
# == Parameters
#
# [*manage*]
#  Whether to manage the Puppet Agent with Puppet or not. Valid values are true
#  (default) and false.
# [*env*]
#    Puppet environment this node will use. Defaults to "production".
# [*master*]
#   Puppetmaster's IP address. Defaults to "puppet.$::domain".
# [*manage_puppet_conf*]
#   Whether to manage puppet.conf or not. On Puppet masters you need to say 
#   false here. On client nodes the default value, true, is typically the 
#   correct choice.
# [*onboot*]
#   Run Puppet agent once on boot. Only works on systemd distros. Valid values
#   are true and false (default).
# [*enable*]
#   Whether to enable the puppet agent (daemon) on boot. Valid values true and 
#   false. If you run puppet manually or via cron you want to use false. 
#   Defaults to false.
# [*service_ensure*]
#   Status of the Puppet service. Valid values are 'running' and 'stopped'. 
#   Leave this undefined to not manage service state using Pupppet.
# [*stringify_facts*]
#   Convert all custom facts to strings. This is the default and only possible 
#   behavior on Puppet < 3.8. Valid values are true (default) and false.
#
# == Examples
#
#   class { 'puppetagent': 
#       env => 'testing',
#       master => 'puppet.qantar.net',
#   }
#
# == Authors
#
# Samuli Seppänen <samuli.seppanen@gmail.com>
#
# Samuli Seppänen <samuli@openvpn.net>
#
# == License
#
# BSD-license. See file LICENSE for details.
#
class puppetagent
(
    $manage = true,
    $master = "puppet.${::domain}",
    $manage_puppet_conf = true,
    $env = 'production',
    $onboot = false,
    $enable = false,
    $service_ensure = undef,
    $stringify_facts = true
)
{

if $manage {

    include ::puppetlabs

    class { '::puppetagent::config':
        master             => $master,
        manage_puppet_conf => $manage_puppet_conf,
        env                => $env,
        stringify_facts    => $stringify_facts,
    }

    class { '::puppetagent::service':
        ensure => $service_ensure,
        enable => $enable,
        onboot => $onboot,
    }
}
}
