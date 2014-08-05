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
joint = args.joint

class Bag_error:
  def __init__(self, bagfile, joint):
    print "Reading %s" % bagfile
    bag = rosbag.Bag(bagfile)
    self.joint = joint
    self.sensors_msgs = map(lambda x: x[1], list(bag.read_messages(topics=['/robot/sensors/robot_state'])))
    self.filters_msgs = map(lambda x: x[1], list(bag.read_messages(topics=['/robot/sensors/robot_state_filtered'])))
    self.controls_msgs = map(lambda x: x[1], list(bag.read_messages(topics=['/robot/controls/joint_states'])))

  def extractInfo(self):
    print "Reading info for %s and adjusting lengths..." % self.joint
    index = self.controls_msgs[0].name.index(self.joint)

    min_len = min([len(self.sensors_msgs), len(self.controls_msgs),\
        len(self.filters_msgs)])

    diff = len(self.sensors_msgs) - min_len
    if diff > 0:
      self.torque_mes = [sensor.joint_effort[index] for sensor in self.sensors_msgs[diff:]]
      self.pos_mes = [sensor.joint_position[index] for sensor in self.sensors_msgs[diff:]]
    else:
      self.torque_mes = [sensor.joint_effort[index] for sensor in self.sensors_msgs]
      self.pos_mes = [sensor.joint_position[index] for sensor in self.sensors_msgs]

    diff = len(self.controls_msgs) - min_len
    if diff > 0:
      self.torque_model = [control.effort[index] for control in self.controls_msgs[diff:]]
      self.pos_model = [control.position[index] for control in self.controls_msgs[diff:]]
    else:
      self.torque_model = [control.effort[index] for control in self.controls_msgs]
      self.pos_model = [control.position[index] for control in self.controls_msgs]

    diff = len(self.filters_msgs) - min_len
    if diff > 0:
      self.torque_filt = [filter.joint_effort[index] for filter in self.filters_msgs[diff:]]
    else:
      self.torque_filt = [filter.joint_effort[index] for filter in self.filters_msgs]

    assert len(self.torque_mes) == len(self.torque_model)

  def computeTorques(self):
    print "Computing torques..."
    dic = json.load(open('/home/herve/.ros/torques.json'))
    gain = dic[self.joint]['gain']
    offset = dic[self.joint]['offset']
    variance = dic[self.joint]['std_dev']

    self.torque_est = map(lambda x: gain*x + offset, self.torque_model)
    self.torque_sup = map(lambda x: 3*variance + x, self.torque_est)
    self.torque_inf = map(lambda x: -3*variance + x, self.torque_est)

  def plotTorques(self):
    print "Plotting torques..."
    pylab.fill_between(range(len(self.torque_est)), self.torque_sup,\
        self.torque_inf, facecolor='blue', alpha=0.3)
    pylab.plot(self.torque_est, 'b')
    pylab.plot(self.torque_mes, 'r', alpha=0.1)
    pylab.plot(self.torque_filt,'r')
    pylab.show()

  def torques(self, joint):
    self.joint = joint
    self.extractInfo()
    self.computeTorques()
    self.plotTorques()

  def plotPos(self):
    print "Plotting positions..."
    self.err = map(lambda x,y: x-y, self.pos_model, self.pos_mes)
    f, axarr = pylab.subplots(2, sharex=True)
    p1, = axarr[0].plot(self.pos_model)
    p2, = axarr[0].plot(self.pos_mes)
    p3, = axarr[1].plot(self.err)
    pylab.legend([p1, p2, p3], ["Desired", "Measure", "Error"])
    pylab.show()

  def positions(self, joint):
    self.joint = joint
    self.extractInfo()
    self.plotPos()

bag_error = Bag_error(bagfile, joint)
bag_error.extractInfo()
bag_error.computeTorques()
bag_error.plotPos()
#filt = syncStamp(sensors_msgs, controls_msgs)
#filt_pos = [f.joint_position for f in filt]

#r_wrist_error = [sens[21] - cont[21] for sens, cont in zip(filt_pos, controls)]

#pylab.plot(r_wrist_error)
                                                                #pylab.show()
