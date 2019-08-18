#!/usr/bin/env python
#-*- coding: utf-8 -*-

import hdf5storage
import numpy as np
import scipy.io
from keras.models import load_model
import sys

TsDataPath=sys.argv[1]
MdNamePath=sys.argv[2]

testdata=hdf5storage.loadmat(TsDataPath)

testdata = testdata["TstDataMVN"].astype('float32')

ReconSpectrumPatch=[]

Outtest16K = load_model(MdNamePath+'.hdf5')

ReconSpectrumPatch.append(Outtest16K.predict(testdata, batch_size=10000, verbose=1))
	
ReconSpectrumPatch=np.array(ReconSpectrumPatch,dtype='float32')

scipy.io.savemat('ReconSpectrumPatch.mat', {'ReconSpectrumPatch':ReconSpectrumPatch[0,:,:]})


