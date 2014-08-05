import rosbag
import matplotlib.pyplot as plt
import numpy
import os
import argparse

joint = 'HEAD_JOINT1'

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
dit = [m[1].header.stamp.to_sec() for m in disable_msgs]

error = [m[1].error\
        for m in disable_msgs]

error_dot = [m[1].error_dot\
        for m in disable_msgs]

disable = [m[1].disable\
        for m in disable_msgs]

iq = bag.read_messages(topics='/robot/sensors/robot_state').next()[1].joint_name.index(joint)
print "-Actual (#%s)" % iq
q, qt = zip(*[(m[1].joint_position, m[1].header.stamp.to_time())
    for m in bag.read_messages(topics='/robot/sensors/robot_state')])

iqd = bag.read_messages(topics='/robot/controls/joint_states').next()[1].name.index(joint)
print "-Desired (#%s)" % iqd
qd, qdt = zip(*[(m[1].position, m[1].header.stamp.to_time())
    for m in bag.read_messages(topics='/robot/controls/joint_states')])


print "Post-treatment"
energy = [e[iqd+1]*ed[iqd+1] for e, ed in zip(error, error_dot)]

jd = [d[iqd+1] for d in disable]
dt = max(max(jd), 1)
et = min(min(jd), -1)
disabling = [i for i, j in enumerate(jd) if j == dt]
enabling = [i for i, j in enumerate(jd) if j == et]

print "Plotting"
plt.figure(1)
ax = plt.subplot(211)
print "-Actual"
ax.plot(qt, [e[iq] for e in q], 'b')
print "-Desired"
ax.plot(qdt, [e[iqd] for e in qd], 'r')

print "-Disable (%s+/%s-)" % (str(len(enabling)),str(len(disabling)))
for d in disabling:
  ax.axvspan(dit[d], dit[d+int(dt)], facecolor='r', alpha=0.2)
for e in enabling:
  ax.axvspan(dit[e], dit[e-int(et)], facecolor='g', alpha=0.2)

plt.subplot(212, sharex=ax)
print "-Energy"
plt.plot(dit, energy)

plt.show()
