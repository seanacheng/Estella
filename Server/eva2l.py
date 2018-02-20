import tensorflow as tf 
import numpy as np 
import cv2
import time
import scipy.io as sio
import os


modelpath = 'model/'
theta = []    #weights and bias are stored here

###########################################################
#define weight and bias initialization
#定义weight和bias的初始化方法

def weight(shape,inp,outp):
	#Xavier initialization. To control the std-div of all layers
	rg = np.sqrt(6.0/(inp+outp))
	res = tf.random_uniform(shape,minval=-rg,maxval=rg,dtype=tf.float32)
	return tf.Variable(res)

def bias(shape):
	res = tf.constant(0.1,shape=shape)
	return tf.Variable(res)

###########################################################
#define basic layers
#定义用到的layer

def conv2D(x,size,inchn,outchn,stride=1,pad='SAME',activation=None):
	W = weight([size,size,inchn,outchn],size*size*inchn,outchn)
	b = bias([outchn])
	z = (tf.nn.conv2d(x,W,strides=[1,stride,stride,1],padding=pad)+b)
	theta.append(W)
	theta.append(b)
	if activation==None:
		return z
	return activation(z)

def maxpooling(x,size):
	return tf.nn.max_pool(x,ksize=[1,size,size,1],strides=[1,size,size,1],padding='SAME')

def Fcnn(x,insize,outsize,activation=None):
	W = weight([insize,outsize],insize,outsize)
	b = bias([outsize])
	theta.append(W)
	theta.append(b)
	if activation==None:
		return tf.matmul(x,W)+b
	return activation(tf.matmul(x,W)+b)

def MFM(x):
	#shape is in format [batchsize, x, y, channel]
	shape = tf.shape(x)
	res = tf.reshape(x,[shape[0],shape[1],shape[2],-1,2])
	res = tf.reduce_max(res,reduction_indices=[4])
	return res

#Network in network
def NIN(x,inchn,outchn1,ksize,outchn2):
	conv1_1 = conv2D(x,1,inchn,outchn1)
	mfm1 = MFM(conv1_1)
	conv2 = conv2D(mfm1,ksize,int(outchn1/2),outchn2)
	return MFM(conv2)



#####################################
#identify model
#model
x2 = tf.placeholder(tf.float32,shape=[None,128,128,1])
conv1_1 = conv2D(x2,5,1,96)
mfm1_1 = MFM(conv1_1)
pool1_1 = maxpooling(mfm1_1,2)
conv2_1 = NIN(pool1_1,48,96,3,192)
pool2_1 = maxpooling(conv2_1,2)
conv3_1 = NIN(pool2_1,96,192,3,384)
pool3_1 = maxpooling(conv3_1,2)
conv4_1 = NIN(pool3_1,192,384,3,256)
conv5_1 = NIN(conv4_1,128,256,3,256)
pool4_1 = maxpooling(conv5_1,2)
flat_1 = tf.reshape(pool4_1,[-1,8*8*128])
fc1_1 = Fcnn(flat_1,8*8*128,512)
mfm_fc1_1 = tf.reduce_max(tf.reshape(fc1_1,[-1,2,256]),reduction_indices=[1])
###########################################################
#define the model
#定义模型

#input (xs) and label (ys)
xs = tf.placeholder(tf.float32,shape=[None,96,96,1])

#model
conv1 = conv2D(xs,5,1,64)
mfm1 = MFM(conv1)
pool1 = maxpooling(mfm1,2)
conv2 = NIN(pool1,32,64,3,128)
pool2 = maxpooling(conv2,2)
conv3 = NIN(pool2,64,128,3,196)
pool3 = maxpooling(conv3,2)
conv4 = NIN(pool3,98,196,3,196)
#conv4 = conv2D(pool3,3,98,196)
pool4 = maxpooling(conv4,2)
flat = tf.reshape(pool4,[-1,6*6*98])
fc1 = Fcnn(flat,6*6*98,128)
mfm_fc1 = tf.reduce_max(tf.reshape(fc1,[-1,2,64]),reduction_indices=[1])
fc2 = Fcnn(mfm_fc1,64,3)


def loadModel(sess,paramlist,path,pref):
	#sess.run(tf.global_variables_initializer())
	dic = {}
	for i in paramlist:
		dic[pref+str(i)] = theta[i]
	saver = tf.train.Saver(dic)
	print('restoring model',path)
	saver.restore(sess,path)


def loadSess(sess=None,modpath =None):
	#load session if there exist any models, and initialize the sess if not
	#如果存在model，加载session，否则初始化
	if sess==None:
		sess = tf.Session()
	saver = tf.train.Saver()
	ckpt = tf.train.get_checkpoint_state(modelpath)
	if modpath!=None:
		print('loading from model:',modpath)
		saver.restore(sess,modpath)
	elif ckpt:
		mod = ckpt.model_checkpoint_path
		print('loading from model:',mod)
		saver.restore(sess,mod)
	else:
		sess.run(tf.global_variables_initializer())
	return sess


fcascade = cv2.CascadeClassifier('haarcascade_frontalface_default.xml')
vecfile = sio.loadmat('idvectors.mat')
features = vecfile['feature']
labels = vecfile['label']

def getFace(img):
	faces = fcascade.detectMultiScale(img,1.1,8,minSize=(150,150))
	return faces

def evalID(vec):
	score = []
	for i in range(len(features)):
		cos = np.sum(features[i]*vec[0])/(np.linalg.norm(features[i])*np.linalg.norm(vec))
		score.append(cos)
		print(score)
	score = np.float32(score)
	if np.max(score)>0.55:
		return labels[np.argmax(score)]
	else:
		return 'Unknown'

def getFace2(imgfile):
	img = cv2.imread(imgfile,0)
	faces = fcascade.detectMultiScale(img,1.1,8,minSize=(150,150))
	#print (faces)
	if len(list(faces))==1:
		for (x,y,w,h) in faces:
			f1 = img[y:y+h,x:x+w]
			f1 = cv2.resize(f1,(128,128))
			return f1

def Go(name):
	global features,labels
	lab = ['neg','neu','pos']
	with tf.Session() as sess:
		sess.run(tf.global_variables_initializer())
		loadModel(sess=sess,paramlist=list(range(20)),path='model/recognition_model.ckpt',pref='fi')
		loadModel(sess=sess,paramlist=list(range(20,len(theta))),path='model/expression_model.ckpt',pref='emo')
		cap = cv2.VideoCapture(0)
		while True:
			ret,frame=cap.read()
			gray = cv2.cvtColor(frame,cv2.COLOR_BGR2GRAY)
			faces = getFace(gray)
			for (x,y,w,h) in faces:
				a = time.time()
				face = gray[y:y+h,x:x+w]
				face1 = cv2.resize(face,(128,128))
				face = cv2.resize(face,(96,96))
				face = face.reshape([1,96,96,1])
				#print(face.shape)
				ind = sess.run(fc2,feed_dict={xs:face})
				ind = np.argmax(ind)
				#print (lab[ind])
				font = cv2.FONT_HERSHEY_SIMPLEX
				idvec = sess.run(mfm_fc1_1,feed_dict={x2:face1.reshape([1,128,128,1])})
				idname = evalID(idvec)
				cv2.putText(frame, lab[ind], (x,y), font,2, (0,0,255),4)
				cv2.putText(frame, 'id:'+idname, (x,y+h), font,1, (0,0,255),2)
				cv2.rectangle(frame,(x,y),(x+w,y+h),(0,255,0),2)
				b = time.time()
				print('time',b-a)
			cv2.imshow('frame',frame)
			if name!=None and len(list(faces))==1:
				features = list(features)
				labels = list(labels)
				features.append(idvec[0])
				labels.append(name)
				sio.savemat('idvectors.mat',{'feature':features,'label':labels})
				break
			if cv2.waitKey(1)&0xFF==ord('q'):
				break

import argparse

parser = argparse.ArgumentParser(description='Face Demo.')
parser.add_argument('--name', type=str,help='Store a face as this name. Run normal detection if this argument is not set.')

args = parser.parse_args()
Go(name=args.name)
