name 'chef_automate_wrapper'
default_source :supermarket

run_list 'chef_automate_wrapper::default'
named_run_list :chef_automate, 'chef_automate_wrapper::default'

cookbook 'chef_automate_wrapper', github: 'devoptimist/chef_automate_wrapper', tag: 'v0.1.2'
cookbook 'chef-ingredient', github: 'chef-cookbooks/chef-ingredient', tag: 'v3.1.1'
