import rosbag
import matplotlib.pyplot as plt
import numpy
import os

joint = 17

directory='/home/herve'
bagfile = '2014-05-23-16-03-50.bag'
bag = rosbag.Bag(os.path.join(directory, bagfile))


error = [m[1].error\
        for m in bag.read_messages(topics='/robot/controls/disable')]

error_dot = [m[1].error_dot\
        for m in bag.read_messages(topics='/robot/controls/disable')]

disable = [m[1].disable\
        for m in bag.read_messages(topics='/robot/controls/disable')]

q = [m[1].joint_position
    for m in bag.read_messages(topics='/robot/sensors/robot_state')]

qd = [m[1].position
    for m in bag.read_messages(topics='/robot/controls/joint_states')]

energy = [e[joint]*ed[joint] for e, ed in zip(error, error_dot)]

jd = [d[joint] for d in disable]
dt = max(jd)
et = min(jd)
disabling = [i for i, j in enumerate(jd) if j == dt]
enabling = [i for i, j in enumerate(jd) if j == et]

plt.figure(1)
ax = plt.subplot(211)
ax.plot([e[joint] for e in q])
ax.plot([e[joint] for e in qd])
for d in disabling:
  ax.axvspan(d, d+dt, facecolor='r', alpha=0.2)
for e in enabling:
  ax.axvspan(e, e-et, facecolor='g', alpha=0.2)

plt.subplot(212, sharex=ax)
plt.plot(energy)

plt.show()
