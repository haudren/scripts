#!/usr/bin/env python
import rosbag
import numpy as np
import sys
import pylab
import itertools
import json
import argparse

def syncStamp(sensors_msgs, controls_msgs):
  if len(sensors_msgs) >= len(controls_msgs):
    filt_sensors = []
    sensors = sensors_msgs
    for control in controls_msgs:
      stamp = control.header.stamp
      sensors = itertools.dropwhile(lambda x: x.header.stamp < stamp, sensors)
      try:
        sensor = sensors.next()
      except StopIteration:
        sensor = sensors_msgs[-1]
      filt_sensors.append(sensor)
  else:
    raise Exception("You have more sensor messages than controls")

  return filt_sensors

parser = argparse.ArgumentParser(description="Utility to read bags")
parser.add_argument("bagfile", help="Bag name, containing robot_state, robot_state_filtered and controls/joint_states")
parser.add_argument("joint", help="Joint name")

args = parser.parse_args()

bagfile = args.bagfile

bag = rosbag.Bag(bagfile)

sensors_msgs = map(lambda x: x[1], list(bag.read_messages(topics=['/robot/sensors/robot_state'])))
filters_msgs = map(lambda x: x[1], list(bag.read_messages(topics=['/robot/sensors/robot_state_filtered'])))
controls_msgs = map(lambda x: x[1], list(bag.read_messages(topics=['/robot/controls/joint_states'])))

index = controls_msgs[0].name.index(args.joint)

min_len = min([len(sensors_msgs), len(controls_msgs), len(filters_msgs)])

diff = len(sensors_msgs) - min_len
if diff > 0:
  torque_mes = [sensor.joint_effort[index] for sensor in sensors_msgs[diff:]]
  pos_mes = [sensor.joint_position[index] for sensor in sensors_msgs[diff:]]
else:
  torque_mes = [sensor.joint_effort[index] for sensor in sensors_msgs]
  pos_mes = [sensor.joint_position[index] for sensor in sensors_msgs]

diff = len(controls_msgs) - min_len
if diff > 0:
  torque_model = [control.effort[index] for control in controls_msgs[diff:]]
  pos_model = [control.position[index] for control in controls_msgs[diff:]]
else:
  torque_model = [control.effort[index] for control in controls_msgs]
  pos_model = [control.position[index] for control in controls_msgs]

diff = len(filters_msgs) - min_len
if diff > 0:
  torque_filt = [filter.joint_effort[index] for filter in filters_msgs[diff:]]
else:
  torque_filt = [filter.joint_effort[index] for filter in filters_msgs]

assert len(torque_mes) == len(torque_model)

dic = json.load(open('/home/herve/.ros/torques.json'))
gain = dic[args.joint]['gain']
offset = dic[args.joint]['offset']
variance = dic[args.joint]['std_dev']

torque_est = map(lambda x: gain*x + offset, torque_model)
torque_sup = map(lambda x: 3*variance + x, torque_est)
torque_inf = map(lambda x: -3*variance + x, torque_est)
#pylab.plot(torque_model, 'b')

def plotTorques():
  pylab.fill_between(range(len(torque_est)), torque_sup, torque_inf,\
      facecolor='blue', alpha=0.3)
  pylab.plot(torque_est, 'b')
  pylab.plot(torque_mes, 'r', alpha=0.1)
  pylab.plot(torque_filt,'r')
  pylab.show()

def plotPos():
  err = map(lambda x,y: x-y, pos_model, pos_mes)
  f, axarr = pylab.subplots(2, sharex=True)
  p1, = axarr[0].plot(pos_model)
  p2, = axarr[0].plot(pos_mes)
  p3, = axarr[1].plot(err)
  pylab.legend([p1, p2, p3], ["Desired", "Measure", "Error"])
  pylab.show()

plotPos()
#filt = syncStamp(sensors_msgs, controls_msgs)
#filt_pos = [f.joint_position for f in filt]

#r_wrist_error = [sens[21] - cont[21] for sens, cont in zip(filt_pos, controls)]

#pylab.plot(r_wrist_error)
#pylab.show()
