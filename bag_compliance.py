import rosbag
import matplotlib.pyplot as plt
import numpy
import os
import argparse

joint = 18

directory='/home/herve'
bagfile = '2014-05-23-16-02-53.bag'
bag = rosbag.Bag(os.path.join(directory, bagfile))

parser = argparse.ArgumentParser(description="Utility to read bags")
parser.add_argument("bagfile", nargs='?', const=1, default=bagfile, help="Bag name, containing robot_state, robot_state_filtered, controls/joint_states and controls/disable")
parser.add_argument("joint", nargs='?', const=1, default=joint, help="Joint number")

args = parser.parse_args()
bagfile = args.bagfile
joint = args.joint

print [c.topic for c in bag._get_connections()]

print "Reading bag"
print "-Disable"
disable_msgs = list(bag.read_messages(topics='/robot/controls/disable'))

error = [m[1].error\
        for m in disable_msgs]

error_dot = [m[1].error_dot\
        for m in disable_msgs]

disable = [m[1].disable\
        for m in disable_msgs]

print "-Actual"
q = [m[1].joint_position
    for m in bag.read_messages(topics='/robot/sensors/robot_state')]

print "-Desired"
qd = [m[1].position
    for m in bag.read_messages(topics='/robot/controls/joint_states')]

print "Post-treatment"
energy = [e[joint]*ed[joint] for e, ed in zip(error, error_dot)]

jd = [d[joint] for d in disable]
dt = max(max(jd), 1)
et = min(min(jd), -1)
disabling = [i for i, j in enumerate(jd) if j == dt]
enabling = [i for i, j in enumerate(jd) if j == et]

print "Plotting"
plt.figure(1)
ax = plt.subplot(211)
print "-Actual"
ax.plot([e[joint-1] for e in q])
print "-Desired"
ax.plot([e[joint-1] for e in qd])

print "-Disable (%s)" % str(len(disabling))
for d in disabling:
  ax.axvspan(d, d+dt, facecolor='r', alpha=0.2)
for e in enabling:
  ax.axvspan(e, e-et, facecolor='g', alpha=0.2)

plt.subplot(212, sharex=ax)
print "-Energy"
plt.plot(energy)

plt.show()
