# ROS on Windows Release Maintainer Handbook

This document is to help the release maintainer to gain the required knowledge and understand the activities for a new release.

## ROS Basic Knowledge

First, let's start from the required ROS knowledge for a release.

In the ROS ecosystem, we can break down the required resources into:

  * **Target Platform:**
    ROS community collectively defines the minimum requirement for building the fundamental composition.
    The requirement is documented by [`REP-2000`](https://www.ros.org/reps/rep-2000.html) and [`REP-0003`](https://www.ros.org/reps/rep-0003.html).
    It covers the topics, such as, toolchain, external libraries, and the supported versions.

  * **ROS Packages:**
    A ROS package is the smallest unit when composing a larger ROS application.
    A source repository can house more than one ROS packages, such as [`ros_comm`](https://github.com/ros/ros_comm).
    The ROS package maintainers often integrate their package releases with the central ROS index database, which is the [`rosdistro`](https://github.com/ros/rosdistro) repository.
    One can find the matching tags and repositories for a package source from the `rosdistro`.

  * **ROS Distribution:**
    A ROS distribution (or distro) is a versioned set of ROS packages.
    The purpose of the ROS distributions is to let developers work against a relatively stable codebase until they are ready to roll everything forward.

  * **ROS Variant (or Metapackage):**
    For development convenience, a set of fundamental ROS packages are described as a larger composition.
    The composition is collectively defined by the community.
    It is documented in [`REP-2001`](https://ros.org/reps/rep-2001.html) for ROS 2 and [`REP-0150`](https://ros.org/reps/rep-0150.html) for ROS 1.

## Supported Matrix for ROS on Windows

Now let's talk about the minimum supported matrix for this project:

  * **ROS2:**
    All active distributions with `desktop` variant are supported.

  * **ROS1:**
    The distributions of `Melodic` and `Noetic` with `desktop_full` variant are supported.

The above is the general guidence, unless stated explicitly otherwise.

## Release Version Scheme

This project is using the following version scheme:

`MAJOR.MINOR.PATCH.BUILD`

The `MAJOR` matches to the Open Robotics Release Sync versioned string.
It will be covered later on what's a Open Robotics Release Sync.

The `MINOR` and `PATCH` is reserved and currently is not in used.

The `BUILD` matches to the timestamp of when the pipelines kicks off the build.

## Working with a New Release

This section is to describe the activities how to create a new release for an existing ROS distro.

### Open Robotics Release Sync

The team in [Open Robotics](https://www.openrobotics.org/team) has a regular cadence to roll out a new release sync for an existing ROS distro.
The calendar and communication can be found in the [ROS discourse](https://discourse.ros.org/c/release).

After a new release sync is out, a [release tag](https://github.com/ros/rosdistro/releases) will be made in the rosdistro to match the snapshot of the release.

The release maintainer monitors the release sync and decides the candidate for the next release.

### Sorting Out Release Sync Candidates

Once a relase sync is out, the release maintainer can try to kick off a build with the release sync.

The steps are as follows: (Use `noetic` as the example.)

  1. Open a command prompt with the Python access. (You can reuse a ROS command prompt.)
  2. Run,

```Batchfile
:: Get the latest rosdistro
pip install -U "rosdistro>=0.8.3"

:: Change directory to the distro folder
cd .\experimental\ros\noetic
```

  3. Edit the `repos.ps1` and look for and change the `Version` to the desired release tag.
  4. Run `powershell .\repos.ps1`.

After the execution, the `noetic.repos`, `noetic-cache.yaml`, and `noetic-cache.yaml.gz` should get updated to the versioned set for the release sync.

The `noetic-cache.yaml` and `noetic-cache.yaml.gz` are the snapshots of the whole ROS index for a distro at the given release sync.
They are currently not in use with the pipelines, but they are useful for debug.

The release maintainer now can commit the changes to a new working branch for new release.

### Building the Pre-release for Validation

Once the working branch is created, the release maintainer can navigate to the [pipelines](https://ros-win.visualstudio.com/ros-win/_build?view=folders) view, and look for `vNext\ms-iot.<distro>.release` pipeline.

Now kick off a new build targeting to the working branch.
Once the build is done, you can find the `<distro>-setup` artifact, where you can download and install the test build on your dev box for more testing.

### Distro-specific Override Repos File

The ROS packages have its own living dyanmics and some release sync might have difficulty to build against Windows platform.

The Distro-specific override repos file serves the purpose to cherry-pick a newer commit which has the proper Windows fix or redirect to a different fork with larger changes.

**It is expected to repeat the process of editing `<distro>_override.repos` and kicking off a new build until a stable build is created.**

### Publish Pre-release Builds

Once the release maintainer is comfortable with the quality of a build, a pre-release can be published for larger audiences for preview.

To publish a pre-release build, the build must be triggered from `master` branch.
Therefore, the working branch is required to be reviewed and merged.

Once the build is done, it waits for approvals.
The release maintainer can approve the pre-release and later the build will be available on `https://aka.ms/ros/public`.

### Publish Release Builds

Once the release maintainer is comfortable with the quality of a build, a release can be published for the public use.

The step to publish a release build is similar to the pre-release build.
The release maintainer can approve the release gate and later the build will be available on `https://aka.ms/ros/public`.

In additions, once a release is out, there are more activities are required:

  * [x] Post a release [anouncement](https://discourse.ros.org/t/ros-on-windows-noetic-release-v20200831-0-0-2009101215/16352) on ROS discourse.
  * [x] ...

### Available Test Automations

<TBD>

## Onboarding a New Distribution

<TBD>

## Refreshing External Dependency

<TBD>

## Examples

## 2020-10-15 Patch Release

This is a case where a bugfix is not yet included in a released package.
The [fix](https://github.com/ros-visualization/rviz/pull/1528) is not yet included in RViz releases (`1.13.13`/Melodic and `1.14.1`/Noetic).

In such case, since we only need to cherry-pick this particular commit, we don't redo the whole release sync flow.
Hereby, the process can be simplified into:

1. Identify the upstream release versions.

    Look it up from [`melodic.repos`](./ros/melodic/melodic.repos) and [`noetic.repos`](./ros/noetic/noetic.repos).
    And at the time of writing, they are `1.13.13` and `1.14.1` respectively.

2. Check if any `ms-iot` forks exists.

    Look it up from [`melodic_override.repos`](./ros/melodic/melodic_override.repos) and [`noetic_override.repos`](./ros/noetic/noetic_override.repos).
    And at the time of writing, they are `https://github.com/ms-iot/rviz/tree/windows/1.13.13` and `https://github.com/ms-iot/rviz/tree/windows/1.14.1`.

3. Cherry-pick the relative commit.

    Create the pull requests for the cherry-pick. For examples, [https://github.com/ms-iot/rviz/pull/4](https://github.com/ms-iot/rviz/pull/4) and [https://github.com/ms-iot/rviz/pull/3](https://github.com/ms-iot/rviz/pull/3).

4. Kick-off new builds.

    Since we reuse the same `ms-iot` forks with the same target branch, we don't need to modify any build recipes in [`ros-windows-build`](https://github.com/ms-iot/ros-windows-build).
    Instead, one can kick off the builds from the respective pipelines.
    For examples, at the time of writing, [here](https://ros-win.visualstudio.com/ros-win/_build/results?buildId=8718) is the Melodic one, and [here](https://ros-win.visualstudio.com/ros-win/_build/results?buildId=8717) is the Noetic one.

5. Validate the builds.

    Once the build finishes, verify the installation from `<distro>-setup` artifacts as the normal process does.

6. Approve the releases.

    Once the build is verified, one can approve the release gate and make it available publicly from https://aka.ms/ros/public.

## Upstream Override Changes

As more releases are exercised, it is common to see a number of cumulative patches in override repos file.
One responsibility of the release maintainer is to keep the list as short as possible.
Here we talk about the principles and guides for the release maintainers.

Depending on the override types, there are different activities.

  * **Cherry-picks for Upstream Commits:**
    In such case, the repository is redirected to a commit which is not in a release tag yet.
    Be polite and respectful to friendly remind the package maintainer and ask for a new release (of the ROS package) if possible.

  * **Override by ms-iot forks:**
    In such case, usually it means there are larger patches to ROS packages.
    Be consistent to carve out time to prepare the pull requests to the upstream repositories.
    And keep that your changes portable to other platforms and platform-specific delta down to the minimum.
