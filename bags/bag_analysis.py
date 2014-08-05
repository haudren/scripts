import rosbag
import pylab

bagfile1 = '/home/herve/2014-05-15-11-47-00.bag'
bagfile2 = '/home/herve/2014-05-15-14-36-04.bag'

def extract_from_bag(bagfile):
  bag = rosbag.Bag(bagfile)
  msg = list(bag.read_messages(topics='/rosout'))
  msg_sensors = filter(lambda x: x[1].name == '/torque_sensors', msg)
  content = [eval(m[1].msg) for m in msg_sensors]
  return content

def plot_content(content, style):
  qs = [c[1] for c in content]
  er = [c[2] for c in content]
  pylab.plot(qs, er, style)

plot_content(extract_from_bag(bagfile1), 'r')
plot_content(extract_from_bag(bagfile2), 'b')

pylab.show()
