#!/usr/bin/env python
# -*- coding: utf-8 -*-

import os, sys
import docker


DEPLOYMENT_LABEL = 'org.geonode.deployment.name'


def restart_containers(client, containers, this_host):
    for c in containers:
        print('container', c.name, c.id)
        if this_host == c.name:
            continue
        print('restarting {}:{}'.format(c.id, c.name))
        c.restart()


def get_containers(client, host):
    current = client.containers.get(host)
    deployment_name = current.labels.get(DEPLOYMENT_LABEL)
    if not deployment_name:
        raise ValueError("Container {} doesn't have "
                         "expected label: {}".format(current.name,
                                                     DEPLOYMENT_LABEL))
    label = '{}={}'.format(DEPLOYMENT_LABEL, deployment_name)
    all_c = client.containers.list(filters={'label': label})
    return all_c

def cmd_restart(client, host):
    """
    Restart containers from deployment
    """
    containers = get_containers(client, host)
    restart_containers(client, containers, host)

    
def cmd_list(client, host):
    """
    List containers for given deployment
    """
    containers = get_containers(client, host)
    for container in containers:
        print container.id, container.name
   
def cmd_restore(client, host, dump_dir=None, *args, **kwargs):
    """
    Restore data from given dir
    """
    containers = get_containers(client, host)
    # we expect second arg to be a dir
    if not dump_dir:
        print("Dump requires dump path as a second argument")
        return
    print('duming to {}'.format(dump_dir))
    django_c = None
    for c in containers:
        print(c.name)
        if c.labels.get('org.geonode.component') == 'django':
            django_c = c
            break
    if not django_c:
        print("Cannot find django container")
        return
    cmd = 'python manage.py loaddata {}/auth.json'.format(dump_dir)
    print('executing {}'.format(cmd))
    out = django_c.exec_run(cmd, tty=True)
    print(out.output)
    print('done')

def cmd_dump(client, host, dump_dir=None, *args, **kwargs):
    """
    This will dump data to given dir on django container
    """
    containers = get_containers(client, host)
    # we expect second arg to be a dir
    if not dump_dir:
        print("Dump requires dump path as a second argument")
        return
    print('duming to {}'.format(dump_dir))
    django_c = None
    for c in containers:
        print(c.name)
        if c.labels.get('org.geonode.component') == 'django':
            django_c = c
            break
    if not django_c:
        print("Cannot find django container")
        return
    django_c.exec_run('mkdir -p {}'.format(dump_dir))
    cmd = 'python manage.py dumpdata monitoring -o {}/monitoring.json'.format(dump_dir)
    print('executing {}'.format(cmd))
    out = django_c.exec_run(cmd, tty=True)
    print(out.output)
    cmd = 'python manage.py dumpdata auth people.Profile -o {}/auth.json'.format(dump_dir)
    print('executing {}'.format(cmd))
    out = django_c.exec_run(cmd, tty=True)
    print(out.output)
    django_c.exec_run('touch {}/do.restore.marker'.format(dump_dir), tty=True)

    print('done')



def main():
    commands = {'restart': cmd_restart,
                'list': cmd_list,
                'dump': cmd_dump,
                'restore': cmd_restore}
    try:
        _cmd = sys.argv[1]
        cmd = commands[_cmd]
    except (IndexError, KeyError,):
        print("No command supplied. use one of: {}".format(commands.keys()))
        return 
    hostname = os.getenv('HOSTNAME')
    client = docker.from_env()
    return cmd(client, hostname, *sys.argv[2:])

if __name__ == '__main__':
    main()
