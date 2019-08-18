#!/usr/bin/env python
#-*- coding: utf-8 -*-

import hdf5storage
from keras.callbacks import ModelCheckpoint
from keras.models import Sequential
from keras.layers.core import Activation,Dense
from keras.optimizers import Nadam
import time
import sys

OuDataPath=sys.argv[1]
InDataPath=sys.argv[2]

MdNamePath=sys.argv[3]

MxEpoch=int(sys.argv[4])
InpDim=int(sys.argv[5])
OutDim=int(sys.argv[6])

indata = hdf5storage.loadmat(InDataPath)
outdata = hdf5storage.loadmat(OuDataPath)

indata = indata["indata"].astype('float32')
outdata = outdata["outdata"].astype('float32')

model = Sequential()
model.add(Dense(2048, input_dim=InpDim, activation='sigmoid'))
model.add(Dense(2048, activation='sigmoid'))
model.add(Dense(2048, activation='sigmoid'))
model.add(Dense(OutDim, activation='linear'))

OptimIz=Nadam(lr=0.0005, beta_1=0.9, beta_2=0.999, epsilon=1e-08, schedule_decay=0.004)
model.compile(
	loss='mean_squared_error',
	optimizer=OptimIz,
	metrics=['accuracy'])
						
checkpointer = ModelCheckpoint(
	filepath=MdNamePath+".hdf5",
	monitor="loss",
	mode="min",
	verbose=1,
	save_best_only=True)

StartTime= time.time()

Hist=model.fit(
	indata, outdata,
	batch_size=2000,
	nb_epoch=MxEpoch,
	verbose=1,
	callbacks=[checkpointer],
	validation_split=0.02,
	shuffle=True)

EndTime = time.time()
print('time is {} sec'.format(EndTime-StartTime))
