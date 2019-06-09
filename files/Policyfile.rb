<<<<<<< HEAD
name 'chef_automate_wrapper'
default_source :supermarket

run_list 'chef_automate_wrapper::default'
named_run_list :chef_automate, 'chef_automate_wrapper::default'

cookbook 'chef_automate_wrapper', github: 'devoptimist/chef_automate_wrapper', tag: 'v0.1.1'
cookbook 'chef-ingredient', github: 'chef-cookbooks/chef-ingredient', tag: 'v3.1.1'
=======
name 'chef_server_wrapper'
default_source :supermarket

run_list 'chef_server_wrapper::default'
named_run_list :chef_server, 'chef_server_wrapper::default'

cookbook 'chef_server_wrapper', github: 'devoptimist/chef_server_wrapper', tag: 'v0.1.5'
cookbook 'chef-ingredient'    , github: 'chef-cookbooks/chef-ingredient', tag: 'v3.1.1'
>>>>>>> dfae90c6ac14db5c970e0bb55a876ea5cb36e852
