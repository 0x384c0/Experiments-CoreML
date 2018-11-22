import os, shutil
import numpy as np

TEST_DATA_PERCENTAGE = 0.2

def move(from_path,to_path):
	for folder in os.walk(from_path):
		path = folder[0]
		files = folder[2]
		if len(files) == 0:
			continue
		test_files = np.random.choice(files, int(TEST_DATA_PERCENTAGE * len(files)), replace=False)
		for file in test_files:
			src = path + "/" + file
			dst = path.replace(from_path,to_path) + "/"
			if not os.path.exists(dst):
				os.mkdir(dst)
			shutil.move(src,dst)




move("tmp/Training_Data/","tmp/Testing_Data/")