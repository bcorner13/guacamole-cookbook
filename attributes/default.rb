default['guacamole']['version'] = '0.9.7'

default['guacamole']['usermap']['default'] = {
                                              "name" => "student1",
                                              "password" => "chef",
                                              "machines" => {
                                                "workstation" => {
                                                  "ec2" => {
                                                    "public_hostname" => "matt-test-node.clouapp.net"
                                                  },
                                                  "platform_family" => "windows",
                                                  "guacamole_user" => "chef",
                                                  "guacamole_pass" => "CodeCan!"
                                                },
                                                "winnode" => {
                                                  "ec2" => {
                                                    "public_hostname" => "matt-test-node.clouapp.net"
                                                  },
                                                  "platform_family" => "windows",
                                                  "guacamole_user" => "Administrator",
                                                  "guacamole_pass" => "Cod3Can!"
                                                }
                                              }
                                            }
