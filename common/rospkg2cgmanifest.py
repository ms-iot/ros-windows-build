from catkin_pkg.packages import find_packages
from multiprocessing import freeze_support
from rosdistro import get_cached_distribution, get_index, get_index_url
from subprocess import Popen, PIPE
import os
import sys
import json


def get_distro(distro_name):
    index = get_index(get_index_url())
    return get_cached_distribution(index, distro_name)


def get_package_repo(distro, name):
    return distro.repositories[distro.release_packages[name].repository_name].source_repository


if __name__ == '__main__':
    freeze_support()
    if not ('ROS_SHARE_DIR' in os.environ):
        raise ValueError('expect ROS_SHARE_DIR to be defined in os.environ')

    if not ('ROS_DISTRO' in os.environ):
        raise ValueError('expect ROS_DISTRO to be defined in os.environ')

    packages = find_packages(os.environ['ROS_SHARE_DIR'])
    distro = get_distro(os.environ['ROS_DISTRO'])
    data = {}
    data['version'] = 1
    reg = data['registrations'] = []
    for key, value in packages.iteritems():
        try:
            lic = value.licenses[0]
            repo = get_package_repo(distro, value.name)
            url = repo.url
            version = repo.version
            git_query = Popen(['git', 'ls-remote', url, version], stdout=PIPE, stderr=PIPE)
            (git_status, error) = git_query.communicate()
            if git_query.poll() == 0:
                s_list = git_status.splitlines()
            for line in s_list:
                commit = line.split()[0]

            reg.append({
                'component': {
                    'type': 'git',
                    'git': {
                        'name': value.name,
                        'repositoryUrl': url,
                        'commitHash': commit
                    }
                },
                'license': str(lic),
                'version': value.version
            })
        except:
            pass
    print json.dumps(data)
