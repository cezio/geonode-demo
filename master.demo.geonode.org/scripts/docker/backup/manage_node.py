#!/usr/bin/env python
# -*- coding: utf-8 -*-

import os, sys
import docker


DEPLOYMENT_LABEL = 'org.geonode.deployment.name'

def rebuild_containers(client, containers):
    pass

def restart_containers(client, containers):
    pass


def get_containers(client, host):
    current = client.containers.get(host)
    deployment_name = current.labels.get(DEPLOYMENT_LABEL)
    if not deployment_name:
        raise ValueError("Container {} doesn't have "
                         "expected label: {}".format(current.name,
                                                     DEPLOYMENT_LABEL))
    label = '{}={}'.format(DEPLOYMENT_LABEL, deployment_name)
    all_c = client.containers.list(filter={'label': label})
    for container in all_c:
        print container.id, container.name

def cmd_restart(client, host):
    containers = get_containers(client, host)
    rebuild_containers(client, containers)
    restart_containers(client, containers)

    
def cmd_list(client, host):
    containers = get_containers(client, host)
    


def main():
    commands = {'restart': cmd_restart,
                'list': cmd_list}
    try:
        _cmd = sys.argv[1]
        cmd = commands[_cmd]
    except (IndexError, KeyError,):
        print("No command supplied. use one of: {}".format(commands.keys()))
        return 
    hostname = os.getenv('HOSTNAME')
    client = docker.from_env()
    return cmd(client, hostname)

if __name__ == '__main__':
    main()
